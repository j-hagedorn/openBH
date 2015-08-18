library(gdata)#Requires latest verion of pearl
library(dplyr)

# Obesity prevalence by county
# http://www.cdc.gov/diabetes/atlas/countydata/County_ListofIndicators.html

# v = column postion of variable
# y = year
# d = curent year available for master table groupings

obse<-function(v,y,d){
  library(dplyr)
  df<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
  
  df<-mutate(df,"Year"=y)
# Filtering out puerto rico
  df<-df[-grep("^72",df$X),]

# Creating primary key "Year_FIPS"
  df$Year_FIPS<-paste(df$Year,df$X,sep="_")
  df<-select(df,Year_FIPS,ospv_cdc=v)
  df<-df[-1,]

# Converting from factor to numeric and rounding 
  df$ospv_cdc<-as.numeric(as.character(df$ospv_cdc))
  df$ospv_cdc<-round(df$ospv_cdc, digits = 0)

  df$current<-d
  return(df)
}


o12<-obse(v = 60,y = "2012",d = "2015")
o11<-obse(v = 53,y = "2011",d = "2014")
o10<-obse(v = 46,y = "2010",d = "2013")
o09<-obse(v = 39,y = "2009",d = "2012")
o08<-obse(v = 32,y = "2008",d = "2011")
o07<-obse(v = 25,y = "2007",d = "2010")
o06<-obse(v = 18,y = "2006",d = "2009")

obse<-rbind(o12,o11,o10,o09,o08,o07,o06)
rm(o12,o11,o10,o09,o08,o07,o06)

