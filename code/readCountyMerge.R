library(dplyr)

# Function for creating independent primary key "Year_FIPS"

pmy<-function(y){
    library(acs)
    library(dplyr)
    
    df<-as.vector(fips.county)
  # filtering out Guam,Puerto Rico and virgen islands
    df<-df %>% filter(State == "MI")
    df[nchar(df[,2])==1,2] <- paste("0", df[nchar(df[,2])==1,2], sep="")
    df[nchar(df[,3])==1,3] <- paste("00", df[nchar(df[,3])==1,3], sep="")
    df[nchar(df[,3])==2,3] <- paste("0", df[nchar(df[,3])==2,3], sep="")
    df$FIPS<-paste(df$State.ANSI,df$County.ANSI,sep="")
    df$year<-y        
  # Creating primary key
    df$Year_FIPS<-paste(df$year,df$FIPS,sep="_")
    df<-select(df,Year_FIPS,"st_acs"=State,"cnty_acs"=County.Name)
  
return(df)

}

# Span for desired years and then stacked by year from high to low
  p1<-pmy(y = 2015)
  p2<-pmy(y = 2014)
  p3<-pmy(y = 2013)
  p4<-pmy(y = 2012)
  p5<-pmy(y = 2011)
  p6<-pmy(y = 2010)
  p7<-pmy(y = 2009)
  p8<-pmy(y = 2008)
  p9<-pmy(y = 2007)
  p10<-pmy(y = 2006)
  primary<-rbind(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
           rm(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)


# Calling all other pre-formated county level data 
# Due to the API key, acs data must be pre-leaded manually before continuing 

source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readBLS.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readCHR.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readHUD.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readFBI.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readOCDC.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readDCDC.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readDRT.R")
source("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\code\\readFAL.R")

# Merging data sets 

table<-merge(primary,chr,by="Year_FIPS",all.x=TRUE)
table<-merge(table,acs,by="Year_FIPS",all.x=TRUE)
table<-merge(table,dibtes,by="Year_FIPS",all.x=TRUE)
table<-merge(table,obse,by="Year_FIPS",all.x=TRUE)
table<-merge(table,lowacc,by="Year_FIPS",all.x=TRUE)
table<-merge(table,mdcr,by="Year_FIPS",all.x=TRUE)
table<-merge(table,emply,by="Year_FIPS",all.x=TRUE)
table<-merge(table,rent,by="Year_FIPS",all.x=TRUE)
table<-merge(table,fbi,by="Year_FIPS",all.x=TRUE)


rm(primary,fbi,chr,obse,dibtes,lowacc,mdcr,rent,acs,FIPSe,US,key,tst,emply,pmy,FIPS)

####

# Creating FIPS column from Year_FIPS
table$FIPS<-table$Year_FIPS
table<-table[,c(38,1:37)]
table$FIPS = substr(table$FIPS,6,10)

# Creating Year column from Year_FIPS
table$Year_FIPS = substr(table$Year_FIPS,1,4)
colnames(table)[2] <- "year"

tst<-table[table$st_acs=="MI",]

save(table,file="table.rda")
