## readCrisis.R
library(tidyverse); library(readxl); library(ggmap); library(leaflet)
library(htmltools)


#### Get data from sheets ####

crisis <- read_excel("data/crisis_facilities.xlsx")
crisis <- crisis[,2:8]
crisis$type <- "Crisis Facility"

psych <- read_excel("data/crisis_facilities.xlsx", sheet = 2)
psych <- psych[,2:8]
psych$type <- "Psychiatric Hospital"

lock_csu <- read_excel("data/crisis_facilities.xlsx", sheet = 3)
lock_csu <- lock_csu[,2:8]
lock_csu$type <- "Locked CSU"

crisis_stab <- read_excel("data/crisis_facilities.xlsx", sheet = 4)
crisis_stab <- crisis_stab[,2:8]
crisis_stab$type <- "Crisis Stabilization"

twentythree <- read_excel("data/crisis_facilities.xlsx", sheet = 5)
twentythree <- twentythree[,2:8]
twentythree$type <- "23-Hour Crisis Stabilization"

peer_respite <- read_excel("data/crisis_facilities.xlsx", sheet = 6)
peer_respite <- peer_respite[,2:8]
peer_respite$type <- "Peer Respite"

youth_cru <- read_excel("data/crisis_facilities.xlsx", sheet = 7)
youth_cru <- youth_cru[,2:8]
youth_cru$type <- "Youth CRU"

crisis_network <-
crisis %>%
  bind_rows(psych, lock_csu, crisis_stab, twentythree, peer_respite, youth_cru)

# Remove extra dataframes

rm(youth_cru);rm(peer_respite);rm(twentythree);rm(crisis_stab);rm(lock_csu);
rm(psych);rm(crisis)

#### Get geocodes

crisis_address <-
  crisis_network %>%
  select(
    Name,
    Location,
    Phone,
    Operated = `Operated by`,
    type) %>%
  filter(is.na(Location) == F) 

crisis_coords <- geocode(crisis_address$Location)

tst <- crisis_address %>% bind_cols(crisis_coords)

factpal <- colorFactor("viridis", unique(tst$type))

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
    color = ~factpal(type),
    popup = ~paste0(
        "<b>Name:</b> ",htmlEscape(Name),"<br/>",
        "<b>Address:</b> ",htmlEscape(Location),"<br/>",
        "<b>Operated by:</b> ",htmlEscape(Operated),"<br/>",
        "<b>Program Type:</b> ",htmlEscape(type)
    ),
    stroke = FALSE, 
    fillOpacity = 0.25
  )

library(htmlwidgets)
saveWidget(crisis_map, file="crisis_map.html")
