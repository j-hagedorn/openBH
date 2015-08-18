library(dplyr)
library(gdata)#requires latest version of pearl


#Unemployment data by county
#http://www.bls.gov/lau/#ex14

# ws = website address to file
# y = year
# d = current year available for groupings 


emply<-function(ws,y,d){
  
  library(dplyr)
  
  df<-read.xls(ws,skip=1,method="csv")
  df$Year<-y
  df$FIPS<-paste(df$State,df$County,sep="")
  df<-df[-c(1,2),]
  
# filtering out puerto rico
  df<-df[-grep("^72",df$FIPS),]

# Creating primary key "Year_FIPS"
  df$Year_FIPS<-paste(df$Year,df$FIPS,sep="_")
  df<-select(df,Year_FIPS, lbrf_bls=X.4,unmpl_bls=X.6)

# converting from factor to numeric with obs. integrity 
  df$lbrf_bls<-as.numeric(gsub(",","", df$lbrf_bls))
  df$unmpl_bls<-as.numeric(gsub(",","", df$unmpl_bls))

  df$current<-d

 return(df)
}

e14<-emply(ws = "http://www.bls.gov/lau/laucnty14.xlsx",y="2014",d="2015")
e13<-emply(ws = "http://www.bls.gov/lau/laucnty13.xlsx",y="2013",d="2014")
e12<-emply(ws = "http://www.bls.gov/lau/laucnty12.xlsx",y="2012",d="2013")
e11<-emply(ws = "http://www.bls.gov/lau/laucnty11.xlsx",y="2011",d="2012")
e10<-emply(ws = "http://www.bls.gov/lau/laucnty10.xlsx",y="2010",d="2011")
e09<-emply(ws = "http://www.bls.gov/lau/laucnty09.xlsx",y="2009",d="2010")
e08<-emply(ws = "http://www.bls.gov/lau/laucnty08.xlsx",y="2008",d="2009")
e07<-emply(ws = "http://www.bls.gov/lau/laucnty07.xlsx",y="2007",d="2008")
e06<-emply(ws = "http://www.bls.gov/lau/laucnty06.xlsx",y="2006",d="2007")

emply<-rbind(e14,e13,e12,e11,e10,e09,e08,e07,e06)
rm(e14,e13,e12,e11,e10,e09,e08,e07,e06)

