library(gdata)#Requires latest verion of pearl
library(dplyr) 
library(scales)

dir.create("Average Rent per County")
setwd("~/Average Rent per County")

rents15<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2015f/FY2015F_4050_Final.xls")

#Dropping all states except Michigan
rents15<-subset(rents15,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents15$fips2010)
rents15<-mutate(rents15,FIPS)

#Choosing and renaming the variables I want
rents15<-select(rents15,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents15$Four_bedroom<-dollar(rents15$Four_bedroom)
rents15$Three_bedroom<-dollar(rents15$Three_bedroom)                             
rents15$Two_bedroom<-dollar(rents15$Two_bedroom)
rents15$One_bedroom<-dollar(rents15$One_bedroom)
rents15$Studio<-dollar(rents15$Studio)

#################################
rents14<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2014f/FY2014_4050_RevFinal.xls")

#Dropping all states except Michigan
rents14<-subset(rents14,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents14$fips2010)
rents14<-mutate(rents14,FIPS)

#Choosing and renaming the variables I want
rents14<-select(rents14,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents14$Four_bedroom<-dollar(rents14$Four_bedroom)
rents14$Three_bedroom<-dollar(rents14$Three_bedroom)                             
rents14$Two_bedroom<-dollar(rents14$Two_bedroom)
rents14$One_bedroom<-dollar(rents14$One_bedroom)
rents14$Studio<-dollar(rents14$Studio)

#######################################################
rents13<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2013f/FY2013_4050_Final.xls")

#Dropping all states except Michigan
rents13<-subset(rents13,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",rents13$fips2010)
rents13<-mutate(rents13,FIPS)

#Choosing and renaming the variables I want
rents13<-select(rents13,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents13$Four_bedroom<-dollar(rents13$Four_bedroom)
rents13$Three_bedroom<-dollar(rents13$Three_bedroom)                             
rents13$Two_bedroom<-dollar(rents13$Two_bedroom)
rents13$One_bedroom<-dollar(rents13$One_bedroom)
rents13$Studio<-dollar(rents13$Studio)

##################################################################
rents12<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2012f/FY2012_4050_Final.xls")

#Dropping all states except Michigan
rents12<-subset(rents12,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents12$FIPS<-gsub(99999,"",rents12$FIPS)

#Choosing and renaming the variables I want
rents12<-select(rents12,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents12$Four_bedroom<-dollar(rents12$Four_bedroom)
rents12$Three_bedroom<-dollar(rents12$Three_bedroom)                             
rents12$Two_bedroom<-dollar(rents12$Two_bedroom)
rents12$One_bedroom<-dollar(rents12$One_bedroom)
rents12$Studio<-dollar(rents12$Studio)

#############################################################
rents11<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2011f/FY2011_4050_Final.xls")

#Dropping all states except Michigan
rents11<-subset(rents11,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents11$FIPS<-gsub(99999,"",rents11$FIPS)

#Choosing and renaming the variables I want
rents11<-select(rents11,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents11$Four_bedroom<-dollar(rents11$Four_bedroom)
rents11$Three_bedroom<-dollar(rents11$Three_bedroom)                             
rents11$Two_bedroom<-dollar(rents11$Two_bedroom)
rents11$One_bedroom<-dollar(rents11$One_bedroom)
rents11$Studio<-dollar(rents11$Studio)

######################################################
rents10<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2010f/FY2010_4050_Final_PostRDDs.xls")

#Dropping all states except Michigan
rents10<-subset(rents10,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents10$FIPS<-gsub(99999,"",rents10$FIPS)

#Choosing and renaming the variables I want
rents10<-select(rents10,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents10$Four_bedroom<-dollar(rents10$Four_bedroom)
rents10$Three_bedroom<-dollar(rents10$Three_bedroom)                             
rents10$Two_bedroom<-dollar(rents10$Two_bedroom)
rents10$One_bedroom<-dollar(rents10$One_bedroom)
rents10$Studio<-dollar(rents10$Studio)

###########################################################
rents09<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2009r/FY2009_4050_Rev_Final.xls")

#Dropping all states except Michigan
rents09<-subset(rents09,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents09$FIPS<-gsub(99999,"",rents09$FIPS)

#Choosing and renaming the variables I want
rents09<-select(rents09,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents09$Four_bedroom<-dollar(rents09$Four_bedroom)
rents09$Three_bedroom<-dollar(rents09$Three_bedroom)                             
rents09$Two_bedroom<-dollar(rents09$Two_bedroom)
rents09$One_bedroom<-dollar(rents09$One_bedroom)
rents09$Studio<-dollar(rents09$Studio)

###########################################################

rents08<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2008r/FMR_county_fy2008r_rdds.xls")

#Dropping all states except Michigan
rents08<-subset(rents08,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents08$FIPS<-gsub(99999,"",rents08$fips)

#Choosing and renaming the variables I want
rents08<-select(rents08,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents08$Four_bedroom<-dollar(rents08$Four_bedroom)
rents08$Three_bedroom<-dollar(rents08$Three_bedroom)                             
rents08$Two_bedroom<-dollar(rents08$Two_bedroom)
rents08$One_bedroom<-dollar(rents08$One_bedroom)
rents08$Studio<-dollar(rents08$Studio)

########################################################

rents07<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2007f/FY2007F_County_Town.xls")

#Dropping all states except Michigan
rents07<-subset(rents07,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents07$FIPS<-gsub(99999,"",rents07$fips)

#Choosing and renaming the variables I want
rents07<-select(rents07,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents07$Four_bedroom<-dollar(rents07$Four_bedroom)
rents07$Three_bedroom<-dollar(rents07$Three_bedroom)                             
rents07$Two_bedroom<-dollar(rents07$Two_bedroom)
rents07$One_bedroom<-dollar(rents07$One_bedroom)
rents07$Studio<-dollar(rents07$Studio)

#############################################################
rents06<-read.xls("http://www.huduser.org/portal/datasets/fmr/fmr2006r/FY2006_County_Town.xls")

#Dropping all states except Michigan
rents06<-subset(rents06,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
rents06$FIPS<-gsub(99999,"",rents06$fips)

#Choosing and renaming the variables I want
rents06<-select(rents06,FIPS,Studio=fmr0,
                One_bedroom=fmr1,Two_bedroom=fmr2,
                Three_bedroom=fmr3,Four_bedroom=fmr4)

#Format the vector of values as currency.
rents06$Four_bedroom<-dollar(rents06$Four_bedroom)
rents06$Three_bedroom<-dollar(rents06$Three_bedroom)                             
rents06$Two_bedroom<-dollar(rents06$Two_bedroom)
rents06$One_bedroom<-dollar(rents06$One_bedroom)
rents06$Studio<-dollar(rents06$Studio)
#############################################################
#Combinig, saving and setting WD back to normal
Fair.Market.Rents<-rbind(rents15,rents14,rents13,rents12,rents11,rents10,rents09,
                         rents08,rents07,rents06)
rm(FIPS)
save(Fair.Market.Rents,file="Fair.Market.Rents.rda")
setwd("~/")
