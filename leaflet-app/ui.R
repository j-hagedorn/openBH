
library(shiny)
library(leaflet)



ui <- fluidPage(
  titlePanel(h2("countyXplorer")),
  
  sidebarPanel(
    h3("Make your own Choropleth Map"),
    p("Use this interactive application to explore the highest and lowest concentrations of your selcted variable."),
    br(),
    selectInput("var", 
                label = "Choose a variable to visualize",
                choices = c("Population", 
                            "Poverty", 
                            'Obesity',
                            'Concentration of Whites',
                            'Concentration of Blacks',
                            'Concentration of Asians',
                            'Concentration of Hispanics'
                ),
                selected = "population"),
    
    p("Explore and",span("click",style="color:blue"),"on your desired area for county QuickFacts and the actual percentage of your chosen Choropleth variable relative to the entire county population"),
    br()),

  
  mainPanel(),
  leafletOutput("map",width="66%",height="400"))

