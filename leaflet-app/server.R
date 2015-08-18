###Server

## loading required pre-fromatted data

load("C:\\Users\\Joseph\\Documents\\leaflet-app\\data.rda")

## Making the server 

server <- function(input, output,session) {
  # create the parts of the map that will not change
  output$map <- renderLeaflet({
    leaflet()%>% 
      setView(lng = -98.583, lat = 39.833, zoom = 4) %>%
      addTiles() 
  })
  
  # Create the reaction (I think there might be a way to avoid the "if" statment with groups
  # but I wont have time to dive into that before I send these your way)
  
  observe({
    title<-input$var
    
    if (input$var=="Population") {
      
      heatmap<- colorQuantile("YlOrRd",
                              data$Population, n = 5)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Population</span>',data$pop,"<br>",
                   
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no high school education: ",data$HighSchool)
      
      
      x <- data[[input$var]]
      y <- labelFormat(prefix = "")
      
    } else if(input$var=="Poverty") {
      
      heatmap<-colorQuantile("Greens",
                             data$PovBin)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Portion of the population in poverty</span>',data$Poverty,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no high school education: ",data$HighSchool)
      
      x <- data[["PovBin"]]
      y <- labelFormat(prefix = "")
      
      
    } else if(input$var=="Obesity") {
      
      heatmap<-colorQuantile('Oranges',
                        data$ObBin)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Portion of the population that is Obese</span>',data$Obesity,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no high school education: ",data$HighSchool)
      
      
      x <- data[['ObBin']]
      y <- labelFormat(suffix = "%")
      
    } else if(input$var=="Concentration of Whites") {
      
      heatmap<-colorQuantile('Blues',
                        data$WhBn)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Total white population</span>',data$white,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no high school education: ",data$HighSchool)
      
      
      x <- data[['WhBn']]
      y <- labelFormat(prefix='')
      
    } else if(input$var=="Concentration of Blacks") {
      
      heatmap<-colorQuantile('Purples',
                             data$BlBn)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Total black population</span>',data$black,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no high school education: ",data$HighSchool)
      
      
      x <- data[['BlBn']]
      y <- labelFormat(prefix='')
    } else if(input$var=="Concentration of Asians") {
      
      heatmap<-colorQuantile('Reds',
                             data$AsBn)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Total asian population</span>',data$asian,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no Highschool education: ",data$HighSchool)
      
      
      x <- data[['AsBn']]
      y <- labelFormat(prefix='')
    
    } else if(input$var=="Concentration of Hispanics") {
      
      heatmap<-colorQuantile('Oranges',
                             data$HpBn)
      
      popup<-paste("<h4>",data$location,"</h4>",
                   
                   '<span style="color:green">Total hispanic population</span>',data$hisp,"<br>",
                   '<b>','County QuickFacts',"</b>",'<br>',
                   "Population: ",data$pop,"<br>",
                   "Median Income: ",data$Median_Income,"<br>",
                   "Unemployment: ",data$Unemployment,"<br>",
                   "Murders: ",data$Murders,"<br>",
                   "Adults with no Highschool education: ",data$HighSchool)
      
      
      x <- data[['HpBn']]
      y <- labelFormat(prefix='')
      
    }
    
    
    leafletProxy("map",data=data) %>%
      clearControls()%>%
      clearShapes()%>%
      clearPopups()%>%
      addPolygons(stroke = TRUE,fillOpacity = .5,
                  weight=1,smoothFactor=1,
                  color = ~heatmap(x),
                  popup=~popup,
                  options = popupOptions( keepInView = TRUE))%>%
      addLegend("bottomright", pal = heatmap, values = ~x,
                title = title,
                labFormat = y,
                opacity = .55)})
}

                    
    
  

