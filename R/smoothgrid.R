#' @title Smooth a Gridded Data Frame
#' @name smoothgrid
#' @description Smooth the grid using \link{focal} and \link{focalWeight} from \link{raster}.
#'
#' @param x a data.frame, two first column must be longitudes and latitudes of
#' gridded data.
#' @param var name of the variable to smooth
#' @param d numeric. If type=circle, the radius of the circle. If type=rectangle
#' the dimension of the rectangle (one or two numbers). If type=Gauss the size
#' of sigma, and optionally another number to determine the size of the matrix
#' returned (default is 3 times sigma)
#' @param type character indicating the type of filter to be returned
#'
#'
#' @return a smoother gridded data.frame
#' @export
#'
#' @examples
#' library(linemap)
#' data("popOcc")
#' # example on an extract of the gridded data
#' popTou <- popOcc[findInterval(popOcc$X, c(3600234,3659444)) == 1  &
#'                    findInterval(popOcc$Y, c(2290913,2348192)) == 1, ]
#' popTou1 <- smoothgrid(x = popTou, var = "pop", d = 1500, type = "circle")
#' popTou2 <- smoothgrid(x = popTou, var = "pop", d = 3000, type = "circle")
#' popTou3 <- smoothgrid(x = popTou, var = "pop", d = 5000, type = "circle")
#'
#' opar <- par(mar=c(0.2,0.2,0.2,0.2), bg = "ivory1", mfrow = c(1,4))
#'
#' linemap(x = popTou, var = "pop", k = 2.5, threshold = 50,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = FALSE)
#' mtext(text = "No smoothing", side = 3, line = -1, adj = c(0.2))
#'
#' linemap(x = popTou1, var = "pop", k = 3, threshold = 50,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = FALSE)
#' mtext(text = "type = 'circle', d = 1500", side = 3, line = -1,
#'       adj = c(0.2))
#'
#' linemap(x = popTou2, var = "pop", k = 4, threshold = 50,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = FALSE)
#' mtext(text = "type = 'circle', d = 3000", side = 3, line = -1,
#'       adj = c(0.2))
#'
#' linemap(x = popTou3, var = "pop", k = 6, threshold = 50,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = FALSE)
#' mtext(text = "type = 'circle', d = 5000", side = 3, line = -1,
#'       adj = c(0.2))
#'
#' par(opar)
#'
#' \donttest{
#' library(sf)
#' data("occitanie")
#' popOcc1 <- smoothgrid(x = popOcc, var = "pop", d = c(1000,5000), type = "Gauss")
#' opar <- par(mar=c(0,0,0,0), bg = "ivory2")
#' plot(st_geometry(occitanie), col="ivory1", border = NA)
#' linemap(x = popOcc1, var = "pop", k = 5, threshold = 25,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
#' par(opar)
#' }
smoothgrid <- function(x, var, d, type){
  x <- sp::SpatialPointsDataFrame(coords = x[,1:2], data = x[, var, drop = FALSE])
  sp::gridded(x) <- TRUE
  x <- raster::raster(x)
  mat <- raster::focalWeight(x = x, d = d,type = type)
  x <- raster::focal(x = x, w = mat, fun = sum,
                     na.rm = FALSE, pad = TRUE, padValue = 0)
  result <- data.frame(sp::coordinates(x),
                       pop = as.vector(x, mode = "numeric"))
  names(result)[3] <- var
  return(result)
}
