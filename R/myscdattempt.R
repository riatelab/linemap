# library(sf)
# iris <- st_read(dsn = "/home/tg/Téléchargements/CONTOURS-IRIS_2-1__SHP_LAMB93_FXX_2016-11-10/CONTOURS-IRIS/1_DONNEES_LIVRAISON_2015/CONTOURS-IRIS_2-1_SHP_LAMB93_FE-2015/",layer = "CONTOURS-IRIS")
# iris75 <- iris[substr(iris$INSEE_COM,1,2) %in% c(75),]
# library(readxl)
# xx <- read_excel(path = "/home/tg/Téléchargements/base-ic-activite-residents-2013.xls", sheet = "IRIS", skip = 5)
# x <- xx[xx$DEP %in%  c(75),]
# iris75 <- merge(iris75,x, by.x="CODE_IRIS",by.y = "IRIS", all.x=T)
# library(cartography)
#
# plot(iris75$geometry)
# propSymbolsLayer(x = iris75, var = "P13_SAL15P_CDI", inches = 0.1)
#
#
# # isimp <- st_simplify(iris75,dTolerance = 25 )
# #
# #
# #
# # plot(st_geometry(isimp), col = NA, border = "grey")
#
#
# x <- iris75
# cellsize = 200*200
# var  = names(x)[19:120]
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
#
#
# x$area <- sf::st_area(x)
#
# # get a grid
# grid <- getGridSquare(x, cellsize)
# plot(grid$geometry, add=F)
#
#
#
# # keep only intersecting cells
# # gover <- sf::st_intersects(grid, x)
# # grid <- grid[unlist(lapply(gover, FUN = function(x) {if(length(x)>0){TRUE}else{FALSE}})), ]
#
# # predicted warning, we don't care...
# options(warn = -1)
# parts <- sf::st_intersection(x = grid[,"id_cell"], y = x)
# options(warn = 0)
#
#
# parts$area_part <- sf::st_area(parts)
#
#
#
# lvar <- vector(mode = "list", length = length(var))
# names(lvar) <- var
# for (i in 1:length(lvar)){
#   print(names(lvar)[i])
#   lvar[[i]] <- as.vector(parts[[names(lvar)[i]]] * parts$area_part / parts$area)
# }
# v <- aggregate(do.call(cbind,lvar), by = list(id = parts[['id_cell']]),
#                FUN = sum, na.rm=TRUE)
#
# grid <- merge(grid, v, by.x  = "id_cell", by.y = "id", all.x = T)
#
#
#
# gr <- cbind(grid, st_coordinates(st_centroid(grid)))
#
#
# gr[is.na(gr$P13_SAL15P_CDI),"P13_SAL15P_CDI"] <- 0
#
# lat <- unique(gr$Y)
# lon <- unique(gr$X)
#
#
# par(mar=c(0,0,0,0))
# plot(iris75$geometry, col = "black", border = NA, bg="black")
#
# threshold = 1
# # plot(reg, lwd = 0.7, border = NA, col = "ivory3", add=T)
# for (i in length(lat):1){
#   ly <- gr[gr$Y==lat[i],]
#   ly$P13_SAL15P_CDI[ly$P13_SAL15P_CDI<threshold] <- 0
#   yVals <- ly$Y - ly$P13_ACT1564 /2
#   xVals <- c(ly$X)
#   yVals[is.na(yVals)] <- lat[i]
#   yVals[1] <- lat[i]
#   yVals[length(yVals)] <- yVals[1]
#
#   polygon(xVals, yVals, border = NA, col = "#00000050")
#  # lines(xVals, yVals, col="#8C8C8C", lwd=0.1)
#
#   j<- 1
#   while (j <= (length(yVals) - 1)) {
#
#     if ((ly$P13_SAL15P_CDI[j]) > threshold | (ly$P13_SAL15P_CDI[j+1]) > threshold) {
#       segments(xVals[j], yVals[j], xVals[j+1], yVals[j+1], col="green", lwd=.5)
#     } else { } # Do nothing
#
#     j <- j + 1
#
#   }
# }
# dev.off()
