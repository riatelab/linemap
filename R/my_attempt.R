# library(foreign)
# France <- readRDS("France.rds")
# Occitanie <- readRDS("Occitanie.rds")
# reg <- readRDS("OccitanieReg.rds")
#
# df <- read.dbf("/home/tg/Téléchargements/ECP1KM_09_MET/R_rfl09_LAEA1000.dbf")
# df <- df[-1,]
#
#
# grid <- expand.grid(x=unique(df$x_laea), y = unique(df$y_laea))
#
# grid <- merge(grid, df[,c("x_laea","y_laea", "ind")],
#               by.x = c("x","y"),
#               by.y = c("x_laea","y_laea"), all.x = TRUE)
#
# grid[is.na(grid$ind),"ind"] <- 0
# gridx <- grid
#
# devtools::create_description()
#
#
# # grid <- gridx
# grid <- grid[grid$x>3425028 & grid$x <3917763 & grid$y>2159464 & grid$y <2482957,]
#
#
# lat <- unique(grid$y)
# lon <- unique(grid$x)
#
#
# par(mar=c(0,0,0,0))
# plot(1:10, xlim = bbox(France)[1,], ylim = bbox(France)[2,], asp=T)
#
# plot(reg, lwd = 0.7, border = NA, col = "ivory3", add=F)
# for (i in length(lat):1){
#   ly <- grid[grid$y==lat[i],]
#   ly$ind[ly$ind<50] <- 0
#   yVals <- ly$y + ly$ind * 3
#   xVals <- c(ly$x)
#   yVals[is.na(yVals)] <- lat[i]
#   yVals[1] <- lat[i]
#   yVals[length(yVals)] <- yVals[1]
#
#   polygon(xVals, yVals, border = NA, col = "#ffffff")
#   # lines(xVals, yVals, col="#8C8C8C", lwd=0.1)
#
#   j<- 1
#   while (j <= (length(yVals) - 1)) {
#
#     if ((ly$ind[j]) > 50 | (ly$ind[j+1]) > 50) {
#       segments(xVals[j], yVals[j], xVals[j+1], yVals[j+1], col="#000000", lwd=.5)
#     } else { } # Do nothing
#
#     j <- j + 1
#
#   }
# }
#
# # dev.off()
#
#
# # plot(reg, xlim = c(3425028, 3673294), ylim = c(2297453, 2369376))
# # plot(reg, lwd = 0.7, border = NA, col = "ivory3", add=F)
# #
# # for (i in length(lat):1){
# #   ly <- gridO[gridO$y==lat[i],]
# #  # points(ly$x, ly$y + ly$ind * 3, type = "l", lwd = 0.5, col = "black")
# #
# #
# #   xx <- c(ly$x, rev(ly$x))
# #   yy <- c(rep(lat[i], nrow(ly)), rev(ly$y + ly$ind * 3))
# #   yy[length(yy)] <- yy[1]
# #   yy[is.na(yy)] <- lat[i]
# #   pol = st_sfc(st_polygon(list(cbind(xx,yy))))
# #   polb <- st_buffer(st_buffer(pol, dist = -10), 10)
# #   plot(polb, add=T, border = "black", col = "ivory3", lwd = 0.5)
# #
# # }
#
