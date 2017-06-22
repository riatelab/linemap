#' @title Line Map
#' @name linemap
#' @description Plot a line map.
#' @param x a data.frame, two first column must be longitude and latitude of
#' gridded data
#' @param var the name of the variable to plot
#' @param k expension factor
#' @param threshold threshold of the data to plot
#' @param col color for the lines areas
#' @param border color for the lines borders
#' @param lwd thickness of the lines
#' @param add if TRUE add the lines to the current plot
#' @export
#' @examples
#' data("Occitanie")
#' par(mar=c(0,0,0,0), bg = "ivory2")
#' plot(sf::st_geometry(regOcc), col="ivory1", border = NA, lwd = 1, lty=3)
#' mtext(text = "Occitanie, le nouveau Mordor", side = 3, line = -2,
#'       adj = 0.01, cex = 1.5, col = "ivory4", font = 3)
#' linemap(x = popOcc, var = "pop", k = 2.5, threshold = 50,
#'         col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
linemap <- function(x, var, k = 2, threshold = 1, col = "white",
                    border = "black", lwd = 0.5, add = FALSE){
  lat <- unique(x[,2])
  lon <- unique(x[,1])
  if(!add){
    graphics::plot(1:10, type = "n", axes = F, xlab = "", ylab="", asp = 1,
                   xlim = c(min(x[,1]), max(x[,1])),
                   ylim = c(min(x[,2]), max(x[,2])))
  }
  for (i in length(lat):1){
    ly <- x[x[,2]==lat[i],]
    ly[ly[var]<threshold, var] <- 0
    yVals <- ly[,2] + ly[,var] * k
    xVals <- ly[,1]
    yVals[is.na(yVals)] <- lat[i]
    yVals[1] <- lat[i] + min(ly[,var] * k)
    yVals[length(yVals)] <- yVals[1]
    graphics::polygon(xVals, yVals, border = NA, col = col)
    for(j in 1:(length(yVals) - 1)){
      if ((ly[j,var] > threshold) | (ly[j+1,var] > threshold)){
        graphics::segments(xVals[j], yVals[j], xVals[j+1], yVals[j+1],
                           col=border, lwd=lwd)
      }
    }
  }
}




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
