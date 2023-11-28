library(terra)
r <- rast(system.file("tif/elevation.tif", package = "linemap"))

expect_silent(linemap(x = r, k = 2.5, threshold = 50,
                      col = "ivory1", border = "ivory4",
                      lwd = 0.6,
                      add = FALSE))

expect_error(linemap(x = 8))
s <- rast(system.file("ex/logo.tif", package = "terra"))
expect_error(linemap(x = s))

pts <- as.points(r)
mon_df <- data.frame(crds(pts), values(pts))
expect_silent(linemap(x = mon_df))
expect_error(linemap(mon_df[1:130, 1:2]))
expect_error(linemap(mon_df[c(1:1200,3,5), ]))
mon_df$x = "aha"
expect_error(linemap(mon_df))
