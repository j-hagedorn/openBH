library(gdata)#Requires latest verion of pearl
library(dplyr)

#2012
o12<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o12<-subset(o12,Obesity.Prevalence=="Michigan")
o12<-mutate(o12,Year="2012")

o12<-select(o12,FIPS=X,Year,Obesity.Prevalence=X2012)

#2011
o11<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o11<-subset(o11,Obesity.Prevalence=="Michigan")
o11<-mutate(o11,Year="2011")

o11<-select(o11,FIPS=X,Year,Obesity.Prevalence=X2011)

#2010
o10<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o10<-subset(o10,Obesity.Prevalence=="Michigan")
o10<-mutate(o10,Year="2010")

o10<-select(o10,FIPS=X,Year,Obesity.Prevalence=X2010)

#2009
o09<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o09<-subset(o09,Obesity.Prevalence=="Michigan")
o09<-mutate(o09,Year="2009")

o09<-select(o09,FIPS=X,Year,Obesity.Prevalence=X2009)

#2008
o08<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o08<-subset(o08,Obesity.Prevalence=="Michigan")
o08<-mutate(o08,Year="2008")

o08<-select(o08,FIPS=X,Year,Obesity.Prevalence=X2008)

#2007
o07<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o07<-subset(o07,Obesity.Prevalence=="Michigan")
o07<-mutate(o07,Year="2007")

o07<-select(o07,FIPS=X,Year,Obesity.Prevalence=X2007)

#2006
o06<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o06<-subset(o06,Obesity.Prevalence=="Michigan")
o06<-mutate(o06,Year="2006")

o06<-select(o06,FIPS=X,Year,Obesity.Prevalence=X2006)

<<<<<<< HEAD
#2005
o05<-read.xls("http://www.cdc.gov/diabetes/atlas/countydata/OBPREV/OB_PREV_ALL_STATES.xlsx")
o05<-subset(o05,Obesity.Prevalence=="Michigan")
o05<-mutate(o05,Year="2005")

o05<-select(o05,FIPS=X,Year,Obesity.Prevalence=X2005)
=======
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Combine,save and set WD back to normal
Obesity.Prevalence<-rbind(o12,o11,o10,o09,o08,o07,o06)

save(Obesity.Prevalence,file="Obesity.Prevalence.rda")
