library(gdata)
library(dplyr)

dir.create("Access to store")
setwd("~/Access to store")

Access10<-read.xls("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Current_Version/DataDownload.xls",
         sheet=5)
Access10<-mutate(Access10,Year="2010")

Access10<-subset(Access10,State=="MI")

#rounding decimals to the largest integer
Access10$LACCESS_HHNV10<-round(Access10$LACCESS_HHNV10, digits = 0)

#Selecting variable of interest
Access10<-select(Access10,FIPS,Year,
                 No.Car.and.Low.access.to.store=LACCESS_HHNV10)
      

#############################################################################
Access06<-read.xls("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Archived_2011_Version/data_download_archive_2011.xls",
                   sheet=3)
Access06<-mutate(Access06,Year="2006")
Access06<-subset(Access06,STATE_NAME=="Michigan")

#rounding decimals to the largest integer
Access06$LOWI1MI<-round(Access06$HHNV1MI, digits = 0)


#Selecting variable of interest
Access06<-select(Access06,FIPS=FIPSNUM,Year,
                 No.Car.and.Low.access.to.store=HHNV1MI)

#Sorting all data rows based on FIPS column in increasing order  
Access06<-Access06[order(Access06[,"FIPS"]),]

####################################################################
#Documentation

download.file("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Current_Version/documentation.pdf",
              "Documentation10.PDF",mode="wb")
download.file("http://ers.usda.gov/datafiles/Food_Environment_Atlas/Data_Access_and_Documentation_Downloads/Archived_2011_Version/archived_documentation_2011.pdf",
              "Documentation06.PDF",mode="wb")


Access10and06<-rbind(Access10,Access06)

save(Access10and06,file="Access10and06.rda")
setwd("~/")
