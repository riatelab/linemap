#
# load("/home/tg/Documents/prz/semin-r_2016/data/BarsParis.RData")
# library(sf)
#
# getGridSquare <- function(x, cellsize){
#   # cellsize transform
#   cellsize = sqrt(cellsize)
#   boundingBox <- st_bbox(x)
#   rounder <- boundingBox[1:2] %% cellsize
#   boundingBox[1] <- boundingBox[1] - rounder[1]
#   boundingBox[2] <- boundingBox[2] - rounder[2]
#   n <- unname(c(ceiling(diff(boundingBox[c(1, 3)]) / cellsize),
#                 ceiling(diff(boundingBox[c(2, 4)]) / cellsize)))
#   grid <- st_make_grid(cellsize = cellsize, offset = boundingBox[1:2], n = n,
#                        crs = st_crs(x))
#   grid <- st_sf(id_cell=1:length(grid), geometry = grid)
#   # grid$id_cell <- 1:nrow(grid)
#   row.names(grid) <- grid$id_cell
#   return(grid)
# }
#
# bars <- st_as_sf(bars)
# plot(bars$geometry)
# grid <- getGridSquare(x = bars, cellsize = 300 * 300 )
# plot(grid$geometry, add=T)
#
# inter <- st_intersects(x = bars, y = grid)
#
#
# bars$id_cell <- unlist(inter)
#
# grid_bar <- aggregate(bars$id_cell, by = list(id_cell=bars$id_cell), length)
# grid <- merge(grid, grid_bar, by = "id_cell", all.x = TRUE)
#
# names(grid)[2] <- "nbars"
# x <- cbind(grid, st_coordinates(st_centroid(grid)))
# x[is.na(x$nbars),"nbars"] <- 0
#
# x <- as.data.frame(x[c("X", "Y", "nbars")])
#
#
# library(linemap)
# par(mar=c(0,0,0,0), bg = "ivory2")
# plot(paris, col="ivory1", border = NA, lwd = 1, lty=3)
# linemap(x = x, var = "nbars", k = 40, threshold = 10,
#         col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
#
#
#
#
#
#
# plot(bars$geometry, add=T, cex = .1)
# plot(iris)
#
# plot(irispt)
#
# plot(paris, add=T)
#
# library(sp)
# library(SpatialPosition)
# library(cartography)
#
# grid <- CreateGrid(w = paris, resolution = 200)
#
# plot(grid, add=F)
#
#
# par(mar = c(0,0,1.2,0))
# plot(grid, col = NA,  add=F)
# plot(paris, col = "grey50", border = NA, add=T)
# plot(grid, pch = 20, col = "black", cex = 0.3, add=T)
# layoutLayer(title = "Grille régulière d'un pas de 200 mètres",
#             frame = FALSE,
#             coltitle = "black",
#             col = NA, scale = NULL, sources="",
#             author = "")
#
