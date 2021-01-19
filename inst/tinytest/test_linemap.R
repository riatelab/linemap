data("popOcc")
popToulouse <- popOcc[findInterval(popOcc$X, c(3600234,3659444)) == 1  &
                        findInterval(popOcc$Y, c(2290913,2348192)) == 1, ]
expect_silent(linemap(x = popToulouse, var = "pop", k = 2.5, threshold = 50,
                      col = "ivory1", border = "ivory4", lwd = 0.6,
                      add = FALSE))
expect_silent(linemap(x = popToulouse, var = "pop", add = TRUE))


library(sf)
Bretagne <- st_read(system.file("gpkg/geofla.gpkg", package = "linemap"),
                    layer = "Bretagne", quiet = TRUE)
# example on an extract of dataset
cotedarmor <- Bretagne[Bretagne$CODE_DEPT == 22, ]
expect_silent(getgrid(x = cotedarmor, cellsize = 1750, var = "POPULATION"))
