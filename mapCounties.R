
library(leaflet)
library(rgdal) #for reading/writing geo files

# Download Tiger zip shapefiles
  url <- "http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_20m.zip"
  downloaddir <- paste(getwd(),"/tiger", sep = "")
  destname<-"tiger.zip"
  download.file(url, destname)
  unzip(destname, exdir=downloaddir, junkpaths=TRUE)
  
  filename<-list.files(downloaddir, pattern=".shp", full.names=FALSE)
  filename<-gsub(".shp", "", filename)
  
  counties <- readOGR("tiger/cb_2014_us_county_20m.shp",
                      layer = "cb_2014_us_county_20m", 
                      verbose = FALSE)

leaflet(counties) %>%
  addTiles(urlTemplate = 'http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png',
           attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
  addPolygons(
    stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
    color = ~colorQuantile("YlOrRd", counties$AWATER)(AWATER)
  )

library(maps)
mapCounties = map("county", fill = TRUE, plot = FALSE)
leaflet(data = mapCounties) %>% 
  addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
