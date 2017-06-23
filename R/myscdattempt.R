# library(sf)
# library(readxl)
# iris <- st_read(dsn = "/home/tg/Téléchargements/CONTOURS-IRIS_2-1__SHP_LAMB93_FXX_2016-11-10/CONTOURS-IRIS/1_DONNEES_LIVRAISON_2015/CONTOURS-IRIS_2-1_SHP_LAMB93_FE-2015/",layer = "CONTOURS-IRIS")
# xx <- read_excel(path = "/home/tg/Téléchargements/base-ic-activite-residents-2013.xls", sheet = "IRIS", skip = 5)
# dep <- c(29,22,56,35)
# iris75 <- iris[substr(iris$INSEE_COM,1,2) %in% dep,]
# x <- xx[xx$DEP %in% dep,]
# iris75 <- merge(iris75,x, by.x="CODE_IRIS",by.y = "IRIS", all.x=T)
#
#
# x <- iris75
# cellsize = 2000*2000
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
# plot(grid$geometry, add=T)
#
#
#
# # keep only intersecting cells
# # gover <- sf::st_intersects(grid, x)
# # grid <- grid[unlist(lapply(gover, FUN = function(x) {if(length(x)>0){TRUE}else{FALSE}})), ]
#
#
# t0 <- Sys.time()
# # predicted warning, we don't care...
# options(warn = -1)
# parts <- sf::st_intersection(x = grid[,"id_cell"], y = x)
# options(warn = 0)
# t1 <- Sys.time()
# t1-t0
#
#
# parts$area_part <- sf::st_area(parts)
#
#
#
# lvar <- vector(mode = "list", length = length(var))
# names(lvar) <- var
# for (i in 1:length(lvar)){
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
#
#
# gr <- as.data.frame(gr[,c("X","Y",var), drop=TRUE])
# head(gr)
# library(linemap)
# plot(iris75$geometry, col = "ivory3", lwd = 0.2, border = NA)
# linemap(x = gr, var = "C13_ACT1564", k = 3, threshold = 100,col = "ivory1", border = "ivory4", lwd = 0.6, add = F)
#





# library(foreign)
# France <- readRDS("/home/tg/Documents/prj/linemap/France.rds")
# Occitanie <- readRDS("/home/tg/Documents/prj/linemap/Occitanie.rds")
# Region <- readRDS("/home/tg/Documents/prj/linemap/OccitanieReg.rds")
# df <- read.dbf("/home/tg/Téléchargements/ECP1KM_09_MET/R_rfl09_LAEA1000.dbf")
# df <- df[-1,]
# df <- df[df$x_laea>3425028 & df$x_laea <3917763 & df$y_laea>2159464 & df$y_laea <2482957,]
# grid <- expand.grid(x=unique(df$x_laea), y = unique(df$y_laea))
# grid <- merge(grid, df[,c("x_laea","y_laea", "ind")],
#               by.x = c("x","y"),
#               by.y = c("x_laea","y_laea"), all.x = TRUE)
#
# grid[is.na(grid$ind),"ind"] <- 0
# library(sf)
# grid = st_as_sf(grid, coords = c("x", "y"), crs = proj4string(Region), agr = "constant")
# xx <- st_intersects(x = grid, y = st_as_sf(Region))
# grid[unlist(lapply(xx, FUN = function(x) {if(length(x)>0){FALSE}else{TRUE}})), "ind"] <- 0
# Region <- st_as_sf(Region)
# x <- data.frame(st_coordinates(st_centroid(grid)), pop = grid$ind)
# str(Region)
# popOcc <- x
# regOcc <- st_simplify(Region, dTolerance = 1000)
# save(list=c("popOcc", "regOcc"), file = "data/Occitanie.RData" )

# dev.off()

