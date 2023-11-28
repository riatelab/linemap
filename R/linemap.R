#' @title Create Line Map
#' @name linemap
#' @description Plot a line map.
#' @param x a data.frame (x, y, value), a terra SpatRaster.
#' @param k expension factor.
#' @param threshold threshold of the data to plot.
#' @param col color for the lines areas.
#' @param border color for the lines borders.
#' @param lwd thickness of the lines.
#' @param bg background color
#' @param add if TRUE add the lines to the current plot.
#' @importFrom graphics par
#' @export
#' @examples
#' ras <- terra::rast(system.file("tif/elevation.tif", package = "linemap"))
#' linemap(ras, k = 7)
linemap <- function(x,
                    k = 2,
                    threshold = 1,
                    col = "white",
                    border = "black",
                    lwd = 0.5,
                    bg = par("bg"),
                    add = FALSE) {

  x <- input_mat(x)
  mmin <- min(x, na.rm = TRUE)
  x[is.na(x)] <- 0
  x[is.nan(x)] <- 0
  x[is.infinite(x)] <- 0
  x[x < threshold] <- 0
  dx <- dim(x)
  lon <- as.numeric(colnames(x))
  lat <- as.numeric(row.names(x))
  mm <- x * k + lat

  # ausol
  mm <- mm - mmin

  if(!add){
    graphics::plot(1:10, type = "n", axes = F,
                   xlab = "", ylab="", asp = 1,
                   xlim = c(min(lon), max(lon)),
                   ylim = c(min(c(mm, lat)), max(c(mm, lat))))
  }
  long <- c(lon[1], lon, lon[dx[2]])
  ncolm <- dx[2]
  rrowm <- dx[1]
  for (i in seq_along(lat)){
    graphics::polygon(x = long,
                      y = c(lat[i], mm[i,], lat[i]),
                      border = NA,
                      col = col)
    mc <- rep(border, ncolm - 1)
    v1 <- unname(x[i, ] > threshold)
    v <- v1[-ncolm] + v1[-1]
    mc[v == 0] <- NA
    graphics::segments(x0 = lon[-ncolm],
                       y0 = mm[i,][-ncolm],
                       x1 = lon[-1],
                       y1 = mm[i,][-1],
                       col = mc,
                       lwd = lwd
    )
  }
  graphics::polygon(x = long,
          y = c(lat[rrowm], mm[rrowm,], lat[rrowm]),
          border = NA,
          col = bg)
  graphics::segments(x0 = lon[-ncolm],
           y0 = mm[rrowm, ][-ncolm],
           x1 = lon[-1],
           y1 = mm[rrowm, ][-1],
           col = mc,
           lwd = lwd
  )
}



input_mat <- function(x) {
  # test inputs
  if (!inherits(x = x,
                what = c("SpatRaster",
                         "data.frame"))) {
    stop(
      paste0(
        "'x' should be a data.frame ",
        "or a SpatRaster."
      ),
      call. = FALSE
    )
  }

  if (inherits(x = x, what = c("SpatRaster"))) {
    if (terra::nlyr(x) != 1) {
      stop("'x' should be a single layer SpatRaster.",
           call. = FALSE)
    }
    ext <- terra::ext(x)
    nc <- terra::ncol(x)
    nr <- terra::nrow(x)
    xr <- terra::xres(x) / 2
    yr <- terra::yres(x) / 2
    lon <- seq(ext[1] + xr, ext[2] - xr, length.out = nc)
    lat <- seq(ext[4] - yr, ext[3] + yr, length.out = nr)
    m <- matrix(
      data = terra::values(x),
      nrow = nr,
      dimnames = list(lat, lon),
      byrow = TRUE
    )
  }

  if (inherits(x = x, what = "data.frame")) {
    nax <- names(x)
    if (length(nax) != 3) {
      stop("`x` should contains 3 variables : x, y and value.", call. = FALSE)
    }
    if(!all(apply(x, 2, is.numeric))){
      stop("x, y and value should be numeric.", call. = FALSE)
    }

    coords <- nax[1:2]
    var <- nax[3]

    if (length(unique(x[[coords[1]]])) * length(unique(x[[coords[2]]])) !=
        length(x[[var]])) {
      stop("It seems that 'x' is not a regular grid.",
           call. = FALSE)
    }

    # Reorder dataframe by X-Y if needed
    x <- x[order(x[[coords[1]]]), ]
    x <- x[order(x[[coords[2]]], decreasing = TRUE), ]

    m <- t(matrix(
      data = x[[var]],
      nrow = length(unique(x[[coords[1]]])),
      dimnames = list(unique(x[[coords[1]]]),
                      unique(x[[coords[2]]]))
    ))
  }
  return(m)
}
