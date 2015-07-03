library(gdata)#Requires latest verion of pearl
library(dplyr) 
library(scales)

#2015
rents15<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2015f/FY2015F_4050_Final.xls")
rents15<-mutate(rents15,Year="2015")

#Dropping all states except Michigan
rents15<-subset(rents15,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents15$fips2010)
rents15<-mutate(rents15,FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents15<-select(rents15,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents15<-select(rents15,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents15$Three_bedroom_monthly<-dollar(rents15$Three_bedroom)                             

#2014
rents14<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2014f/FY2014_4050_RevFinal.xls")
rents14<-mutate(rents14,Year="2014")

#Dropping all states except Michigan
rents14<-subset(rents14,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents14$fips2010)
rents14<-mutate(rents14,FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents14<-select(rents14,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents14<-select(rents14,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents14$Three_bedroom_monthly<-dollar(rents14$Three_bedroom_monthly)                             

#2013
rents13<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2013f/FY2013_4050_Final.xls")
rents13<-mutate(rents13,Year="2013")

#Dropping all states except Michigan
rents13<-subset(rents13,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents13$fips2010)
rents13<-mutate(rents13,FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents13<-select(rents13,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents13<-select(rents13,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents13$Three_bedroom_monthly<-dollar(rents13$Three_bedroom_monthly)                             


#2012
rents12<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2012f/FY2012_4050_Final.xls")
rents12<-mutate(rents12,Year="2012")

#Dropping all states except Michigan
rents12<-subset(rents12,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents12$FIPS<-gsub(99999,"",rents12$FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents12<-select(rents12,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents12<-select(rents12,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents12$Three_bedroom_monthly<-dollar(rents12$Three_bedroom_monthly)                             


#2011
rents11<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2011f/FY2011_4050_Final.xls")
rents11<-mutate(rents11,Year="2011")

#Dropping all states except Michigan
rents11<-subset(rents11,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents11$FIPS<-gsub(99999,"",rents11$FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents11<-select(rents11,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents11<-select(rents11,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents11$Three_bedroom_monthly<-dollar(rents11$Three_bedroom_monthly)                             


#2010
rents10<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2010f/FY2010_4050_Final_PostRDDs.xls")
rents10<-mutate(rents10,Year="2010")

#Dropping all states except Michigan
rents10<-subset(rents10,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents10$FIPS<-gsub(99999,"",rents10$FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents10<-select(rents10,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents10<-select(rents10,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents10$Three_bedroom_monthly<-dollar(rents10$Three_bedroom_monthly)                             

#2009
rents09<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2009r/FY2009_4050_Rev_Final.xls")
rents09<-mutate(rents09,Year="2009")

#Dropping all states except Michigan
rents09<-subset(rents09,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents09$FIPS<-gsub(99999,"",rents09$FIPS)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents09<-select(rents09,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents09<-select(rents09,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents09$Three_bedroom_monthly<-dollar(rents09$Three_bedroom_monthly)                             

#2008
rents08<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2008r/FMR_county_fy2008r_rdds.xls")
rents08<-mutate(rents08,Year="2008")

#Dropping all states except Michigan
rents08<-subset(rents08,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents08$FIPS<-gsub(99999,"",rents08$fips)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents08<-select(rents08,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents08<-select(rents08,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents08$Three_bedroom_monthly<-dollar(rents08$Three_bedroom_monthly)                             

#2007
rents07<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2007f/FY2007F_County_Town.xls")
rents07<-mutate(rents07,Year="2007")

#Dropping all states except Michigan
rents07<-subset(rents07,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents07$FIPS<-gsub(99999,"",rents07$fips)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents07<-select(rents07,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents07<-select(rents07,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents07$Three_bedroom_monthly<-dollar(rents07$Three_bedroom_monthly)                             

#2006
rents06<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2006r/FY2006_County_Town.xls")
rents06<-mutate(rents06,Year="2006")

#Dropping all states except Michigan
rents06<-subset(rents06,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents06$FIPS<-gsub(99999,"",rents06$fips)

#Choosing and renaming the variables I want
<<<<<<< HEAD
rents06<-select(rents06,FIPS,Year,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)
=======
rents06<-select(rents06,FIPS,Year,County=countyname,
                State=state_alpha,Three_bedroom_monthly=fmr3)
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39

#Format the vector of values as currency.
rents06$Three_bedroom_monthly<-dollar(rents06$Three_bedroom_monthly)                             

#############################################################
#Combinig and saving 
Fair.Market.Rents<-rbind(rents15,rents14,rents13,rents12,rents11,rents10,rents09,
                         rents08,rents07,rents06)

save(Fair.Market.Rents,file="Fair.Market.Rents.rda")
