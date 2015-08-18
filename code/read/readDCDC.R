library(gdata)
library(dplyr)

# Diagnosed diabetes prevalence per county
# http://www.cdc.gov/diabetes/atlas/countydata/County_ListofIndicators.html

# v = column postion of variable,
# y = year
# d = current year for grouping in master table

dibtes<-function(v,y,d){
  library(dplyr)
  df<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx",
               method="csv")
  
  df<-mutate(df,"Year"=y)
# Filtering out puerto rico
  df<-df[-grep("^72",df$X),]

# Creating primary key "Year_FIPS"
  df$Year_FIPS<-paste(df$Year,df$X,sep="_")
  df<-select(df,Year_FIPS,ddpv_cdc=v)
  df<-df[-1,]

# Converting from factor to numeric
  df$ddpv_cdc<-as.numeric(as.character(df$ddpv_cdc))
  df$ddpv_cdc<-round(df$ddpv_cdc, digits = 0)

  df$current<-d
  return(df)
}

d12<-dibtes(v = 60,y="2012",d = "2015")
d11<-dibtes(v = 53,y="2011",d = "2014")
d10<-dibtes(v = 46,y="2010",d = "2013")
d09<-dibtes(v = 39,y="2009",d = "2012")
d08<-dibtes(v = 32,y="2008",d = "2011")
d07<-dibtes(v = 25,y="2007",d = "2010")
d06<-dibtes(v = 18,y="2006",d = "2009")

diabtes<-rbind(d12,d11,d10,d09,d08,d07,d06)
rm(d12,d11,d10,d09,d08,d07,d06)
