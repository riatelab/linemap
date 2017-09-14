[![Build Status](https://travis-ci.org/rCarto/linemap.svg?branch=master)](https://travis-ci.org/rCarto/linemap)

# `linemap`: Create Maps Made of Lines

## Example

The package contains two functions: `linemap` and `getgrid`

### `linemap` 

`linemap` displays a map made of lines from a data frame of gridded data.

```r
library(linemap)
library(sf)
data("popOcc")
data("occitanie")
opar <- par(mar=c(0,0,0,0), bg = "ivory2")
plot(st_geometry(occitanie), col="ivory1", border = NA)
linemap(x = popOcc, var = "pop", k = 2.5, threshold = 50,
        col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
par(opar)
```

![mordor](https://raw.githubusercontent.com/rCarto/linemap/master/img/mordor.png)


### `getgrid` 

`getgrid` transforms a set of polygons (POLYGONS or MULTIPOLYGONS, `sf` objects) into a suitable data frame for `linemap`. 


```r
library(linemap)
library(sf)
data("bretagne")
data("france")
plot(st_geometry(bretagne))
```
![bretagne](https://raw.githubusercontent.com/rCarto/linemap/master/img/bret.png)
```r
bret <- getgrid(x = bretagne, cellsize = 2000, var = "POPULATION")
bret[6010:6014,]
```
|     |        X|       Y| POPULATION|
|:----|--------:|-------:|----------:|
|6010 | 340217.1| 6783195|   670.7509|
|6011 | 342217.1| 6783195|  1050.2651|
|6012 | 344217.1| 6783195|  1410.0992|
|6013 | 346217.1| 6783195|  2304.2012|
|6014 | 348217.1| 6783195|  2875.4047|



```r
opar <- par(mar = c(0,0,0,0))
plot(st_geometry(france), col="lightblue3", border = NA, bg = "lightblue2",
     xlim = c(min(bret$X), max(bret$X)), ylim= c(min(bret$Y), max(bret$Y)))
linemap(x = bret, var = "POPULATION", k = 5, threshold = 1,
        col = "lightblue3", border = "white", lwd = 0.8,
        add = TRUE)
par(opar)
```

![mordor2](https://raw.githubusercontent.com/rCarto/linemap/master/img/mordor2.png)




## Installation

```r
library(devtools)
install_github("rCarto/linemap")
```


## Inspiration 
[Unknown Pleasures](https://en.wikipedia.org/wiki/Unknown_Pleasures) (*Joy Division*)  
[Population Lines: How and Why I Created It](http://spatial.ly/2017/04/population-lines-how-and-why-i-created-it/) (*James Cheshire*)  
[GeospatialLineGraphs](https://github.com/Brideau/GeospatialLineGraphs) (*Ryan Brideau*)  
