# data <- read.csv("data/afc.csv")

# Spending on Residential Services
library(dplyr)
library(RCurl) # requires install.packages("RCurl")
data <- getURL("https://raw.githubusercontent.com/j-hagedorn/open404/master/data/clean/subMaster",ssl.verifypeer=0L, followlocation=1L)
writeLines(data,'temp.csv')
subMaster <- read.csv('temp.csv')

# ... and create a subset
library(scales)
res <- 
  subMaster %>%
  group_by(FY,Service,Code_Mod,CMHSP) %>%
  summarise(SumOfCost = sum(SumOfCost),
            TotalServed = max(TotalServed),
            ResCases = sum(SumOfCases[Code_Mod %in% c("T1020","T1020TF","T1020TG","S9976")])) %>%
  filter(Service == "Residential Treatment") %>%
  ungroup %>%
  group_by(FY,Service) %>%
  summarise(CostInMillions = round(sum(SumOfCost)/1000000, digits = 1),
            Cost1kSvd = round((sum(SumOfCost)/sum(TotalServed)*1000), digits = 2),
            Residents = sum(ResCases),
            ResidentCost = round(sum(SumOfCost)/sum(ResCases), digits = 1)
  ) %>%
  droplevels

library(rCharts)
reschart <- nPlot(CostInMillions ~ FY, 
                  group = "Service", 
                  data = res, 
                  type = 'lineChart', id = 'chart')
reschart$xAxis(axisLabel = 'Year', width = 62)
reschart$yAxis(axisLabel = 'Cost', width = 62)
#reschart$chart(forceY = c(0, 580))
reschart$addControls("y", 
                     value = "CostInMillions", 
                     values = c("CostInMillions","Cost1kSvd",
                                "Residents","ResidentCost"))
reschart

library(htmlwidgets)
library(sparkline)
sparkline(res$CostInMillions, type = 'line')

# Percentage of MI/DD beds occupied by Medicaid
round(sum(res$Residents[res$FY == 2013])/sum(afc_pop$Beds[afc_pop$DDMI != "Other"])*100, digits = 1)

# Summary per licensee

afc_summary <-
  data %>%
  filter(DDMI %in% c("MI","DD","DD|MI")) %>%
  group_by(Licensee) %>%
  summarise(Homes = n(),
            Beds = sum(Capacity),
            BedsPerHome = round(sum(Capacity)/n(), digits = 1),
            Violations = sum(as.numeric(ViolationsPastYr)),
            Provisionals = sum(as.numeric(Provisionals)),
            PctDD = round(sum(as.numeric(ServeDD))/n()*100, digits = 1),
            PctMI = round(sum(as.numeric(ServeMI))/n()*100, digits = 1)
  ) %>%
  filter(Homes >= 1) %>%
  arrange(desc(Homes)) %>%
  top_n(25,Homes)


afc_summary <-
  plyr::ddply(data, c("Licensee","DDMI"), summarise, 
              Homes = length(LicenseNo),
              Beds = sum(Capacity),
              BedsPerHome = round(sum(Capacity)/length(LicenseNo), digits = 1),
              Violations = sum(as.numeric(ViolationsPastYr)),
              Provisionals = sum(as.numeric(Provisionals)),
              PctDD = round(sum(as.numeric(ServeDD))/n()*100, digits = 1),
              PctMI = round(sum(as.numeric(ServeMI))/n()*100, digits = 1),
              .drop=FALSE)
afc_summary <- afc_summary %>% filter(Homes > 1 & DDMI %in% c("MI","DD","DD|MI"))

c1 <- 
  nPlot(Homes ~ Licensee, 
        #group = "DDMI", 
        data = afc_summary, 
        type = "multiBarChart" ,  #"multiBarChart" 'lineChart' # OR 'lineWithFocusChart' #'stackedAreaChart'
        id = "chart")
c1$xAxis(axisLabel = 'Licensee', width = 82, staggerLabels = T)
c1$yAxis(axisLabel = 'AFCs serving people with MI and/or DD', width = 100)
c1$chart(color = c("#00A08A", "#F2AD00", "#F98400", "#5BBCD6","#ECCBAE", "#046C9A", "#D69C4E", "#ABDDDE", "#000000"),
         showControls = F, reduceXTicks = F) 
c1$show('iframesrc',cdn=TRUE)

# Summary By Disability Type
afc_pop <-
  data %>%
  group_by(DDMI, TypeDesc) %>%
  summarise(Homes = n(),
            Beds = sum(Capacity),
            BedsPerHome = round(sum(Capacity)/n(), digits = 1),
            Violations = sum(as.numeric(ViolationsPastYr)),
            Provisionals = sum(as.numeric(Provisionals)))

afc_pop <-
  plyr::ddply(data, c("DDMI","TypeDesc"), summarise, 
              Homes = length(LicenseNo),
              Beds = sum(Capacity),
              BedsPerHome = round(sum(Capacity)/length(LicenseNo), digits = 1),
              .drop=FALSE)

library(rCharts)
a1 <- 
  nPlot(Homes ~ TypeDesc, 
        group = "DDMI", 
        data = afc_pop, 
        type = "multiBarChart" ,  #"multiBarChart" 'lineChart' # OR 'lineWithFocusChart' #'stackedAreaChart'
        id = "chart")
a1$xAxis(axisLabel = 'Setting Type', width = 62)
a1$yAxis(axisLabel = 'Selected measure', width = 62)
#a1$chart(reduceXTicks = FALSE)
#a1$xAxis(staggerLabels = TRUE)
a1$chart(color = c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"),
         forceY = c(0,100)) 
a1$addControls("y", 
               value = "Homes", 
               values = c("Homes","Beds","BedsPerHome"))
a1$show('iframesrc',cdn=TRUE)
#a1$show('inline', include_assets = TRUE, cdn = TRUE)

data %>%
  group_by(TypeDesc) %>%
  summarise(Beds = sum(Capacity),
            MIbeds = sum(Capacity[ServeMI == T]),
            DDbeds = sum(Capacity[ServeDD == T]),
            TBIbeds = sum(Capacity[ServeTBI == T]),
            Agedbeds = sum(Capacity[ServeAged == T]),
            Physbeds = sum(Capacity[ServePhysHandicap == T]),
            Alzbeds = sum(Capacity[ServeAlzheimers == T])
  ) %>%
  
  
  # Summary By Beds
  afc_beds <- data %>% filter(DDMI %in% c("MI","DD","DD|MI"))
afc_beds <-
  plyr::ddply(afc_beds, c("BedRange","TypeDesc"), summarise, 
              Homes = length(LicenseNo),
              Beds = sum(Capacity), 
              .drop=FALSE)

b1 <- 
  nPlot(Homes ~ BedRange, 
        group = "TypeDesc", 
        data = afc_beds, 
        type = "multiBarChart" ,  #"multiBarChart" 'lineChart' # OR 'lineWithFocusChart' #'stackedAreaChart'
        id = "chart")
b1$xAxis(axisLabel = 'Beds in facility', width = 62)
b1$yAxis(axisLabel = 'AFCs serving people with MI and/or DD', width = 62)
b1$chart(color = c("#FF0000", "#00A08A", "#F2AD00", "#F98400", "#5BBCD6","#ECCBAE", "#046C9A", "#D69C4E", "#ABDDDE", "#000000"),
         stacked = TRUE) 
b1$show('iframesrc',cdn=TRUE)

# Violations by licensee
afc_viol <-
  data %>%
  filter(DDMI %in% c("MI","DD","DD|MI")) %>%
  group_by(Licensee) %>%
  summarise(Homes = n(),
            Beds = sum(Capacity),
            BedsPerHome = round(sum(Capacity)/n(), digits = 1),
            Violations = sum(as.numeric(ViolationsPastYr)),
            Provisionals = sum(as.numeric(Provisionals)),
            PctDD = round(sum(as.numeric(ServeDD))/n()*100, digits = 1),
            PctMI = round(sum(as.numeric(ServeMI))/n()*100, digits = 1)) %>%
  mutate(PctViol = round(Violations/Homes*100, digits = 1),
         PctProv = round(Provisionals/Homes*100, digits = 1)) %>%
  filter(Violations >= 1 | Provisionals >= 1)

afc_viol$HomeRange <- recode(afc_viol$Homes,
                             "1:5 = '01-05 homes'; 
                             6:10 ='06-10 homes';
                             11:15 = '11-15 homes';
                             16:20 = '16-20 homes';
                             21:25 = '21-25 homes';
                             else = '26+ homes'")
afc_viol$HomeRange <- factor(afc_viol$HomeRange)
afc_viol$HomeRange <- ordered(afc_viol$HomeRange,
                              levels = c("01-05 homes", "06-10 homes", 
                                         "11-15 homes", "16-20 homes",
                                         "21-25 homes", "26+ homes"))
afc_viol$jitterProv <- round(jitter(afc_viol$Provisionals), digits = 1)
afc_viol$jitterViol <- round(jitter(afc_viol$Violations), digits = 1)


d1 <- nPlot(jitterProv ~ jitterViol, group = "HomeRange", 
            data = afc_viol, type = 'scatterChart')
d1$xAxis(axisLabel = 'Homes with violations in past year', width = 62)
d1$yAxis(axisLabel = 'Homes with provisional licenses', width = 62)
d1$chart(tooltipContent = "#! function(key, x, y, e){ 
         return '<b>Licensee:</b> ' + e.point.Licensee + '<br/>' +
         '<b>Homes with violations: </b>' + e.point.Violations + '<br/>' +
         '<b>Homes with provisionals: </b>' + e.point.Provisionals + '<br/>' +
         '<b># Homes: </b>' + e.point.Homes + '<br/>' +
         '<b>Beds per home: </b>' + e.point.BedsPerHome + '<br/>' +
         '<b>% homes with violations: </b>' + e.point.PctViol + '<br/>' +
         '<b>% homes with provisional: </b>' + e.point.PctProv 
         } !#",
         color = c("#fcbba1", "#ef3b2c", "#fc9272", "#99000d", "#cb181d","#fb6a4a"))
d1$chart(showDistX = TRUE, showDistY = TRUE)
d1



############################
devtools::install_github("hrbrmstr/metricsgraphics")
library(metricsgraphics)
data %>%
  mjs_plot(x=Capacity, width=500, height=400) %>%
  mjs_histogram(bins = 30)


tmp %>%
  mjs_plot(x=Beds, width=500, height=400) %>%
  mjs_histogram(bins = NULL)

# Make a data table
library(DT)
datatable(afc_summary, options = list(iDisplayLength = 5))

# # Use rCharts leaflet
# library(rCharts)
# map <- Leaflet$new()
# map$setView(c(43.808709, -85.373016), 
#             zoom = 7)
# map$tileLayer(provider = 'Stamen.TonerLite')
# #map$marker(data$lat, data$long, bindPopup = data$FacilityName)
# map$geoJson(toGeoJSON(data_), 
#             onEachFeature = '#! function(feature, layer){
#       layer.bindPopup(feature.properties.popup)
#             } !#',
#             pointToLayer =  "#! function(feature, latlng){
#             return L.circleMarker(latlng, {
#             radius: 4,
#             fillColor: feature.properties.fillColor || 'red',    
#             color: '#000',
#             weight: 1,
#             fillOpacity: 0.8
#             })
#             } !#")
# map$enablePopover(TRUE)
# map$fullScreen(TRUE)