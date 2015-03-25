
# Download leaflet lib
# https://github.com/rstudio/leaflet/blob/master/vignettes/leaflet.Rmd

  if (!require('devtools')) install.packages('devtools')
  devtools::install_github('rstudio/leaflet')
    
  library(leaflet)
  library(dplyr)
  
  leaflet(data) %>% 
    addTiles(urlTemplate = 'http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png',
             attribution = 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% # (urlTemplate = "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png") %>%
    addCircles() %>% 
    setView(-85.373016, 43.808709, zoom = 7)
  #addPopups
  
# http://leaflet-extras.github.io/leaflet-providers/preview/index.html

# if (!require("DT")) devtools::install_github("rstudio/DT")
library(DT)
  data %>%
    select(FacilityName,Status,ViolationsPastYr) %>%
    datatable(options = list(iDisplayLength = 5))
    
  
  datatable(options = list(), 
              class = "display", 
              callback = JS("return table;"), 
              rownames, 
              colnames, 
              container, 
              caption = NULL, 
              filter = c("none", "bottom", "top"), 
              server = FALSE, 
              escape = TRUE, 
              extensions = list()
              )
  
  