library(leaflet)
library(rgdal) #for reading/writing geo files
library(rgeos)
library(sp)
library(dplyr)
library(rgbif)
library(rjson)

# Reading in shape file. 

setwd("~/shape")
url<-"http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_20m.zip"
downloaddir<-"~/shape"
destname<-"shape.zip"
download.file(url, destname)
unzip(destname, exdir=downloaddir, junkpaths=TRUE)

data<-readOGR(dsn=".",layer="cb_2014_us_county_20m",verbose=FALSE)

setwd("~/")

# Manipulating table for variables

load('C:\\Users\\Joseph\\Documents\\table.rda')

# pick the year you would like 

table<-table[table$year==2012,]

# Creating stationary variables for every popup

table$pop<-prettyNum(table$tltp_acs, big.mark=",")
table$Unemployment<-paste(round((table$unmpl_bls/table$lbrf_bls)*100,digits=1), "%",sep="")
table$Murders<-table$mudr_fbi
table$Median_Income<-paste("$",prettyNum(table$mdin_acs, big.mark=","),sep="")
table$HighSchool<-paste(round((table$lshs_acs/table$tltp_acs)*100,digits=1),"%",sep="")


# Here I am creating the choropleth variables along with its non-numeric twin for the 
# popup.This way I can feed the polygon argument as well as make a "readable"version
# with the "%" for the popup. 

table$Obesity<-paste(round((table$ospv_cdc/table$tltp_acs)*100,digits=1),"%",sep="")
table$ObBin<-round((table$ospv_cdc/table$tltp_acs)*100,digits=1)

table$Diabetics<-paste(round((table$ddpv_cdc/table$tltp_acs)*100,digits=1),"%",sep="")
table$DiaBin<-round((table$ddpv_cdc/table$tltp_acs)*100,digits=1)

table$Veterans<-paste(round((table$vetr_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$VetBin<-round((table$vetr_acs/table$tltp_acs)*100,digits=1)

table$Poverty<-paste(round((table$inpt_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$PovBin<-round((table$inpt_acs/table$tltp_acs)*100,digits=1)

table$white<-paste(round((table$white_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$WhBn<-round((table$white_acs/table$tltp_acs)*100,digits=1)

table$black<-paste(round((table$black_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$BlBn<-round((table$black_acs/table$tltp_acs)*100,digits=1)

table$asian<-paste(round((table$asian_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$AsBn<-round((table$asian_acs/table$tltp_acs)*100,digits=1)

table$hisp<-paste(round((table$hisp_acs/table$tltp_acs)*100,digits=1),"%",sep="")
table$HpBn<-round((table$hisp_acs/table$tltp_acs)*100,digits=1)

# selecting variables 

table<-select(table,FIPS,
              Unemployment,
              Obesity,
              ObBin,
              Diabetics,
              DiaBin,
              Murders,
              cnty_acs,
              st_acs,
              Population=tltp_acs,
              Median_Income,
              HighSchool,
              pop,
              Veterans,
              VetBin,
              Poverty,
              PovBin,
              white,
              WhBn,
              black,
              BlBn,
              asian,
              AsBn,
              hisp,
              HpBn)


# Manipulating the polygon to make primary key "FIPS" and merging with table
# sp package needs to be loaded and the SpatialPolygonsDataFrame must be the first 
# argument of the merge

data$FIPS<-paste(data$STATEFP,data$COUNTYFP,sep="")
data<-merge(data,table,by ="FIPS")
data$location<-paste(data$cnty_acs,data$st_acs,sep =",")

# Here I'm removing the "names" column because it contained foreighn charecters
# that r was having a hard time interpreting(like french hyphens). So I just took out that 
# column 

data<-data[,-7]

# This directory might be differnt for you. The data.rda must be 
# saved to your shiny-app folder

save(data,file="~/leaflet-app/data.rda")
