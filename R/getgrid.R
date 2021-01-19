#' @title Transform a Polygon Layer to a Grid
#' @name getgrid
#' @description Transform a polygon layer to a regular grid data.frame.
#' @param x an sf polygon layer.
#' @param cellsize size of the side of a grid cell.
#' @param var name of the variable to transform to the grid. It can be a vector
#' of names.
#' @return A data frame is returned.
#' @export
#' @examples
#' library(linemap)
#' library(sf)
#' Bretagne <- st_read(system.file("gpkg/geofla.gpkg", package = "linemap"),
#'                     layer = "Bretagne")
#' France <- st_read(system.file("gpkg/geofla.gpkg", package = "linemap"),
#'                   layer = "France")
#' # example on an extract of dataset
#' cotedarmor <- Bretagne[Bretagne$CODE_DEPT == 22, ]
#' cota <- getgrid(x = cotedarmor, cellsize = 1750, var = "POPULATION")
#' opar <- par(mar = c(0,0,0,0))
#' plot(st_geometry(France), col="lightblue3", border = NA, bg = "lightblue2",
#'      xlim = c(min(cota$X), max(cota$X)), ylim= c(min(cota$Y), max(cota$Y)))
#' linemap(x = cota, var = "POPULATION", k = 5, threshold = 1,
#'         col = "lightblue3", border = "white", lwd = 0.8,
#'         add = TRUE)
#' par(opar)
#'
#'
#' \donttest{
#' # example on the full dataset
#' Bretagne_grid <- getgrid(x = Bretagne, cellsize = 1750, var = "POPULATION")
#' opar <- par(mar = c(0,0,0,0))
#' plot(st_geometry(France), col="lightblue3", border = NA, bg = "lightblue2",
#'      xlim = range(Bretagne_grid$X), ylim= range(Bretagne_grid$Y))
#' linemap(x = Bretagne_grid, var = "POPULATION", k = 5, threshold = 1,
#'         col = "lightblue3", border = "white", lwd = 0.8,
#'         add = TRUE)
#' par(opar)
#' }
getgrid <- function(x, cellsize, var){
  b <- sf::st_bbox(x)
  mx <- (b[3] - b[1]) %/% cellsize
  my <- (b[4] - b[2]) %/% cellsize
  if((b[3] - b[1]) %% cellsize!=0){
    b[3] <- b[1] + (mx+1) * cellsize
  }
  if((b[4] - b[2]) %% cellsize!=0){
    b[4] <- b[2] + (my+1) * cellsize
  }
  n <- unname(c(ceiling(diff(b[c(1, 3)]) / cellsize),
                ceiling(diff(b[c(2, 4)]) / cellsize)))
  grid <- sf::st_make_grid(cellsize = cellsize, offset = b[1:2],
                       n = n,crs = sf::st_crs(x))
  grid <- sf::st_sf(id_cell=1:length(grid), geometry = grid)
  row.names(grid) <- grid$id_cell

  x$area <- sf::st_area(x)
  # predicted warning, we don't care...
  # options(warn = -1)
  sf::st_agr(x) <- 'constant'
  sf::st_agr(grid) <- 'constant'

  parts <- sf::st_intersection(x = grid[,"id_cell"], y = x)
  # options(warn = 0)

  parts$area_part <- sf::st_area(parts)
  lvar <- vector(mode = "list", length = length(var))
  names(lvar) <- var
  for (i in 1:length(lvar)){
    lvar[[i]] <- as.vector(
      parts[[names(lvar)[i]]] * parts$area_part / parts$area
      )
  }
  v <- stats::aggregate(do.call(cbind,lvar), by = list(id = parts[['id_cell']]),
                 FUN = sum, na.rm=TRUE)
  grid <- merge(grid, v, by.x  = "id_cell", by.y = "id", all.x = T)
  gr <- cbind(grid, sf::st_coordinates(sf::st_centroid(sf::st_geometry(grid))))
  gr <- as.data.frame(gr[,c("X","Y",var), drop=TRUE])
  return(gr)
}




