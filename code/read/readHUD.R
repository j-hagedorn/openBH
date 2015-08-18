library(gdata)
library(dplyr)

#Fair market rents by county
#http://www.huduser.org/portal/datasets/fmr.html

# ws = website address to file
# y = year


rent<-function(ws,y){
  
  library(dplyr)
  df<-read.xls(ws)
  
  if(y %in% c(2015,2014,2013)){
    
    df$fips2010<-gsub(99999,"",df$fips2010)
    df<-df[nchar(df$fips2010)<=5,]
    #adding a zero in front of all FIPS obs. with 4 characters 
    df[nchar(df[,2])==4,2] <- paste("0", df[nchar(df[,2])==4,2], sep="")
    df<-mutate(df,Year=y)
    #filtering out puerto rico
    df<-df[-grep("^72",df$fips2010),]
    df$Year_FIPS<-paste(df$Year,df$fips2010,sep="_")
    df<-select(df,Year_FIPS,"3bdr_hud"=fmr3)
    # making date for most recent grouping(master table)
    df$current<-y
    return(df)
    
  } else if (y %in% c(2012,2011,2010,2009)){
    
    df$FIPS<-gsub(99999,"",df$FIPS)
    df<-df[nchar(df$FIPS)<=5,]
    #adding a zero in front of all FIPS obs. with 4 characters 
    df[nchar(df[,1])==4,1] <- paste("0", df[nchar(df[,1])==4,1], sep="")
    df<-mutate(df,Year=y)
    #filtering out puerto rico
    df<-df[-grep("^72",df$FIPS),]
    df$Year_FIPS<-paste(df$Year,df$FIPS,sep="_")
    df<-select(df,Year_FIPS,"3bdr_hud"=fmr3)
    
    # making date for most recent grouping(master table)
    df$current<-y
    
    return(df)
    
  } else if (y %in% c(2008,2007,2006)){
    
    df$fips<-gsub(99999,"",df$fips)
    df<-df[nchar(df$fips)<=5,]
    #adding a zero in front of all FIPS obs. with 4 characters 
    df[nchar(df[,1])==4,1] <- paste("0", df[nchar(df[,1])==4,1], sep="")
    df<-mutate(df,Year=y)
    #filtering out puerto rico
    df<-df[-grep("^72",df$fips),]
    #Creating primary key
    df$Year_FIPS<-paste(df$Year,df$fips,sep="_")
    
    df<-select(df,Year_FIPS,"3bdr_hud"=fmr3)
    
    # making date for most recent grouping(master table)
    df$current<-y
    return(df)
  }
}
  
r15<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2015f/FY2015F_4050_Final.xls",
       y="2015")
r14<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2014f/FY2014_4050_RevFinal.xls",
       y="2014")
r13<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2013f/FY2013_4050_Final.xls",
       y="2013")
r12<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2012f/FY2012_4050_Final.xls",
       y="2012")
r11<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2011f/FY2011_4050_Final.xls",
       y="2011")
r10<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2010f/FY2010_4050_Final_PostRDDs.xls",
       y="2010")
r09<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2009r/FY2009_4050_Rev_Final.xls",
       y="2009")
r08<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2008r/FMR_county_fy2008r_rdds.xls",
       y="2008")
r07<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2007f/FY2007F_County_Town.xls",
       y="2007")
r06<-rent(ws = "http://www.huduser.org/portal/datasets/fmr/fmr2006r/FY2006_County_Town.xls",
       y="2006")

#Combinig and saving 
rent<-rbind(r15,r14,r13,r12,r11,r10,r09,r08,r07,r06)
rm(r15,r14,r13,r12,r11,r10,r09,r08,r07,r06)
