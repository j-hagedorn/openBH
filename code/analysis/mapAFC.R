
# Download leaflet lib
# https://github.com/rstudio/leaflet/blob/master/vignettes/leaflet.Rmd

#   if (!require('devtools')) install.packages('devtools')
#   devtools::install_github('rstudio/leaflet')
    
  library(leaflet)
  library(dplyr)
  
  data$popup <- paste("<table><tr><td>Facility:", data$FacilityName,
                      "<br>Licensee:",data$Licensee, 
                      "<br>Address:",data$GeoAddress, 
                      "<br>Capacity:",data$Capacity, 
                      "<br>Violations in Past Year?", data$ViolationsPastYr,
                      "</td></tr></table>")
  
  
  leaflet(data) %>% 
    addProviderTiles("Stamen.TonerLite") %>%
    addCircles(fillOpacity = .5, radius = ~Capacity, popup=~popup) %>% #color="red", radius=~PMLevel*1000
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
  
  