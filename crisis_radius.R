# Crisis programs in Michigan with 60-mile radius

crisis_radius <-
  crisis_address %>%
  filter(is.na(lon) == F) %>%
  filter(type == "Crisis Facility") %>%
  leaflet() %>% 
  addProviderTiles(providers$Stamen.Toner) %>%
  setView(
    lng = -84.506836, 
    lat = 44.182205, 
    zoom = 7
  ) %>%
  addCircles(
    lng = ~lon, 
    lat = ~lat,
    color = "#FF9F55", 
    stroke = FALSE,
    # Add radius in meters (= 60 miles)
    radius = 96560.6,
    fillOpacity = 0.2
  ) %>%
  addCircleMarkers(
    lng = ~lon, 
    lat = ~lat,
    color = ~factpal(type),
    popup = ~paste0(
      "<b>Name:</b> ",htmlEscape(Name),"<br/>",
      "<b>Address:</b> ",htmlEscape(Location),"<br/>",
      "<b>Operated by:</b> ",htmlEscape(Operated),"<br/>",
      "<b>Program Type:</b> ",htmlEscape(type)
    ),
    stroke = FALSE,
    radius = 4,
    fillOpacity = 0.6
  ) 

library(htmlwidgets)
saveWidget(crisis_radius, file = "crisis_radius.html")
