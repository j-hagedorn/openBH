library(gdata)
library(dplyr)

dir.create("Diagnosed.Diabetes.Prevalence")
setwd("~/Diagnosed.Diabetes.Prevalence")
#2012
d12<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d12<-subset(d12,Diagnosed.Diabetes.Prevalence=="Michigan")

d12<-select(d12,FIPS=X,Diagnosed.Diabetes.Prevalence=X2012)

#2011
d11<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d11<-subset(d11,Diagnosed.Diabetes.Prevalence=="Michigan")

d11<-select(d11,FIPS=X,Diagnosed.Diabetes.Prevalence=X2011)

#2010
d10<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d10<-subset(d10,Diagnosed.Diabetes.Prevalence=="Michigan")

d10<-select(d10,FIPS=X,Diagnosed.Diabetes.Prevalence=X2010)

#2009
d09<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d09<-subset(d09,Diagnosed.Diabetes.Prevalence=="Michigan")

d09<-select(d09,FIPS=X,Diagnosed.Diabetes.Prevalence=X2009)

#2008
d08<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d08<-subset(d08,Diagnosed.Diabetes.Prevalence=="Michigan")

d08<-select(d08,FIPS=X,Diagnosed.Diabetes.Prevalence=X2008)

#2007
d07<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d07<-subset(d07,Diagnosed.Diabetes.Prevalence=="Michigan")

d07<-select(d07,FIPS=X,Diagnosed.Diabetes.Prevalence=X2007)

#2006
d06<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d06<-subset(d06,Diagnosed.Diabetes.Prevalence=="Michigan")

d06<-select(d06,FIPS=X,Diagnosed.Diabetes.Prevalence=X2006)

#2005
d05<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/DMPREV/DM_PREV_ALL_STATES.xlsx")
d05<-subset(d05,Diagnosed.Diabetes.Prevalence=="Michigan")

d05<-select(d05,FIPS=X,Diagnosed.Diabetes.Prevalence=X2005)

#Combine,save and set WD back to normal
Diagnosed.Diabetes.Prevalence<-rbind(d12,d11,d10,d09,d08,d07,d06,d05)

rm(d12,d11,d10,d09,d08,d07,d06,d05)
setwd("~/")
