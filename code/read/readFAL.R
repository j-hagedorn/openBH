library(gdata)
library(dplyr)

#County level no car no access to store
#http://ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads.aspx


#2010
  a10<-read.xls("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Current_Version/DataDownload.xls",
              sheet=5)

  # Filtering out PU
  a10<-a10[-grep("^72",a10$FIPS),]

  a10<-mutate(a10,Year="2010")
  a10[nchar(a10[,1])==4,1] <- paste("0", a10[nchar(a10[,1])==4,1], sep="")
  a10$Year_FIPS<-paste(a10$Year,a10$FIPS,sep="_")

  a10$LACCESS_HHNV10<-round(a10$LACCESS_HHNV10, digits = 0)

  a10<-select(a10,Year_FIPS,lila_fal=LACCESS_HHNV10)

  a10<-a10[-c(2967:2990),]

  a10$current<-"2012"

#2006
  a6<-read.xls("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Archived_2011_Version/data_download_archive_2011.xls",
             sheet=3)

  a6<-mutate(a6,Year=2006)
  a6[nchar(a6[,3])==4,3] <- paste("0", a6[nchar(a6[,3])==4,3], sep="")
  a6$Year_FIPS<-paste(a6$Year,a6$FIPSNUM,sep="_")

  a6$LOWI1MI<-round(a6$HHNV1MI, digits = 0)
  a6<-select(a6,Year_FIPS,lila_fal=HHNV1MI)
  a6$current<-"2008"


  lowacc<-rbind(a10,a6)
  rm(a10,a6)
