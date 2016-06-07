## global.R ##
library(shiny)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(magrittr)
library(tidyr)
library(xts)
library(car)
library(scales)
library(lubridate)
library(plotly)
library(ggplot2)
library(dygraphs)
library(RColorBrewer)


# Get data

drug_death <- read.csv("data/drug_death.csv")

# Extract undup totals per year for calculating grouped rates
totals <-
drug_death %>%
  group_by(PIHPname,CMHSP,county,year) %>%
  summarize(TotalPop = max(TotalPop, na.rm = T)) %>%
  ungroup() 
