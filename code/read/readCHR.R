library(gdata)#requires installing the latest veriosn of perl and restarting computer
library(dplyr)

#County health ranking data
#http://www.countyhealthrankings.org/rankings/data

# ws  = website address to file
# y = year
# d = current year available for groupings

chr<-function(ws,y,d){
  library(dplyr)
  df<-read.xls(ws,sheet=2)
  
  if(y=="2015"){
    df<-df[-c(1:2),]
    df<-mutate(df,Year="2015")
    df<-df[-grep("000$",df$X),]
    
    # Making primary key
    df$Year_FIPS<-paste(df$Year,df$X,sep="_")
    df<-select(df,Year_FIPS,hlfr_chr=X.4)
    
    # Converting from factor to numeric
    df$hlfr_chr<-as.numeric(as.character(df$hlfr_chr))
    
    df$current<-y
    return(df)
  }
  df<-mutate(df,Year=y)
  df<-df[-1,]
  
  # Making primary key
  df$Year_FIPS<-paste(df$Year,df$X,sep="_")
  df<-select(df,Year_FIPS,hlfr_chr=Health.Factors)
  
  # Converting from factor to numeric
  df$hlfr_chr<-as.numeric(as.character(df$hlfr_chr))
  
  df$current<-y
  return(df)
}

c15<-chr(ws="http://www.countyhealthrankings.org/sites/default/files/2015CountyHealthRankingsNationalData.xls",
         y="2015")
c14<-chr(ws = "http://www.countyhealthrankings.org/sites/default/files/2014%20County%20Health%20Rankings%20Data%20-%20v1.xls",
         y="2014")
c13<-chr(ws = "http://www.countyhealthrankings.org/sites/default/files/2013%20County%20Health%20Rankings%20Data%20-%20v1.xls",
         y="2013")
c12<-chr(ws = "http://www.countyhealthrankings.org/sites/default/files/2012%20County%20Health%20Rankings%20National%20Data_v2.xls",
          y="2012")
c11<-chr(ws = "http://www.countyhealthrankings.org/sites/default/files/2011%20County%20Health%20Rankings%20National%20Data_v2.xls",
         y="2011")
c10<-chr(ws = "http://www.countyhealthrankings.org/sites/default/files/2010%20County%20Health%20Rankings%20National%20Data.xls",
         y="2010")

chr<-rbind(c15,c14,c13,c12,c11,c10)
rm(c15,c14,c13,c12,c11,c10)