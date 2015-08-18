library(dplyr)
library(gdata)#Requires latest version of perl

#Medicare enrollees & spending per county
#http://www.dartmouthatlas.org/tools/downloads.aspx?tab=35

# ws = website address to file
# y = year
# v = column position of variable in file
# d = current year available for groupings 


mdcr<-function(ws,y,v,d){
  library(dplyr)
  df<-read.xls(ws)
  
  df<-mutate(df,Year_FIPS=y)
  df[nchar(df[,1])==4,1] <- paste("0", df[nchar(df[,1])==4,1], sep="")
  
# Creating primary key "Year_FIPS"
  df$Year_FIPS<-paste(df$Year_FIPS,df$County.ID,sep="_")
  df<-select(df,Year_FIPS,tmre_dtm=v)
  df<-df[-1,]

# Removing comma and converting from factor to numeric
  df$tmre_dtm<-as.numeric(gsub(",","",df$tmre_dtm))

  df$current<-d
  return(df)
}


m12<-mdcr(ws = "http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2012.xls",
       y="2012",v=4,d="2015")
m11<-mdcr(ws = "http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2011.xls",
       y="2011",v=4,d="2014")
m10<-mdcr(ws = "http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2010.xls",
       y="2010",v=4,d="2013")

mdcr<-rbind(m12,m11,m10)
rm(m12,m11,m10)