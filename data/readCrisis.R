## readCrisis.R
library(tidyverse); library(readxl); library(ggmap); library(leaflet)
library(htmltools)

crisis <- read_excel("data/crisis_facilities.xlsx")
crisis <- crisis[,1:5]

crisis_address <-
  crisis %>%
  select(Name,Location,Phone) %>%
  filter(is.na(Location) == F)

crisis_coords <- geocode(crisis_address$Location)

tst <- crisis_address %>% bind_cols(crisis_coords)

crisis_map <-
tst %>%
  filter(is.na(lon) == F) %>%
  leaflet() %>% 
  addProviderTiles(providers$Stamen.Toner) %>%
  setView(
    lng = -94.61057, 
    lat = 39.05998, 
    zoom = 4
  ) %>%
  addCircleMarkers(
    lng = ~lon, 
    lat = ~lat,
    label = ~htmlEscape(Name),
    stroke = FALSE, 
    fillOpacity = 0.5
  )

library(htmlwidgets)
saveWidget(crisis_map, file="crisis_map.html")
