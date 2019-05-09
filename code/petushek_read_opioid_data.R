
#clear enviroment 
rm(list=ls())

library(dplyr)
library(tidyr)
library(ggplot2)
library(zipcode)
library(RColorBrewer)
library(zoo)
library(stringr)
library(xlsx)
library(gridExtra)
library(openxlsx)
library(reshape2)
library(maps)

setwd("/Users/petushek/Documents/Michigan State University/Research/MAPS Drug Utilization/Shiny_App1/Shiny_App")

data2013prescrib <- read.xlsx("Drug Utilization Report Data - 2013.xlsx", 2) %>%  mutate(year = 2013)
data2013dispens <- read.xlsx("Drug Utilization Report Data - 2013.xlsx", 3) %>%  mutate(year = 2013)
data2013patient <- read.xlsx("Drug Utilization Report Data - 2013.xlsx", 4) %>%  mutate(year = 2013)

data2014prescrib <- read.xlsx("Drug Utilization Report Data - 2014.xlsx", 2) %>%  mutate(year = 2014)
data2014dispens <- read.xlsx("Drug Utilization Report Data - 2014.xlsx", 3) %>%  mutate(year = 2014)
data2014patient <- read.xlsx("Drug Utilization Report Data - 2014.xlsx", 4) %>%  mutate(year = 2014)

data2015prescrib <- read.xlsx("Drug Utilization Report Data - 2015.xlsx", 2) %>%  mutate(year = 2015)
data2015dispens <- read.xlsx("Drug Utilization Report Data - 2015.xlsx", 3) %>%  mutate(year = 2015)
data2015patient <- read.xlsx("Drug Utilization Report Data - 2015.xlsx", 4) %>%  mutate(year = 2015)

data2016prescrib <- read.xlsx("Drug Utilization Report Data - 2016.xlsx", 2) %>%  mutate(year = 2016)
data2016dispens <- read.xlsx("Drug Utilization Report Data - 2016.xlsx", 3) %>%  mutate(year = 2016)
data2016patient <- read.xlsx("Drug Utilization Report Data - 2016.xlsx", 4) %>%  mutate(year = 2016)

data2017prescrib <- read.xlsx("Drug Utilization Report Data - 2017.xlsx", 2) %>%  mutate(year = 2017)
data2017dispens <- read.xlsx("Drug Utilization Report Data - 2017.xlsx", 3) %>%  mutate(year = 2017)
data2017patient <- read.xlsx("Drug Utilization Report Data - 2017.xlsx", 4) %>%  mutate(year = 2017) 


deathdata <- read.csv("Opioid_Heroin_Poisonings_data.csv", header = TRUE)
names(deathdata) <- c("county","year","deaths")
deathdata$county <- tolower(deathdata$county)

hospitalizationdata <- read.csv("Opioid_Hospitilaztions_data2017.csv", header = TRUE)
names(hospitalizationdata) <- c("county","hospitalizations","year")
hospitalizationdata$county <- tolower(hospitalizationdata$county)



countypop <- read.xlsx("countypopsallMI.xlsx", 1)
countypopest <- countypop[,1:9]
names(countypopest) <- c("county","2010","2011","2012","2013","2014",
                         "2015","2016","2017")
countypopest_long <- gather(countypopest,county,year,c(2:9),factor_key = TRUE)
countypopest_long <- melt(countypopest, id.vars=c("county"))
names(countypopest_long) <- c("county","year","population")

countypopest_long$county <- toupper(countypopest_long$county)

mapsallprescrib <- rbind(data2013prescrib,data2014prescrib,data2015prescrib,data2016prescrib,
                         data2017prescrib)
mapsalldispens <- rbind(data2013dispens,data2014dispens,data2015dispens,data2016dispens,
                        data2017dispens)
mapsallpatient <- rbind(data2013patient,data2014patient,data2015patient,data2016patient,
                        data2017patient)

mipopdata <- data.frame(year = c(2013,2014,2015,2016,2017), population = c(9899219,9914675,9918170,9933445,9962311))


miprescrib <- mapsallprescrib %>% filter(PRESCRIBER.STATE == "MI", str_detect(mapsallprescrib$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE")) 
miprescrib <- mutate(miprescrib, drug_type = ifelse(grepl("OPIATE",miprescrib$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))

names(miprescrib) <- c("county","prescriber_state","drug_name","dea_schedule","ahfs_description",
                       "count","units","year","drug_type")

miprescrib_state <- miprescrib %>% group_by(year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(mipopdata,by=c("year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% mutate(data_source = "prescriber")

#Michigan Statewide Dispenser Data

midispens <- mapsalldispens %>% filter(DISPENSER.STATE == "MI", str_detect(mapsalldispens$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE")) 
midispens <- mutate(midispens, drug_type = ifelse(grepl("OPIATE",midispens$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))

names(midispens) <- c("county","dispenser_state","drug_name","dea_schedule","ahfs_description",
                      "count","units","year","drug_type")

midispens_state <- midispens %>% group_by(year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(mipopdata,by=c("year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% mutate(data_source = "dispenser")


#Michigan Statewide Patient Data

mipatient <- mapsallpatient %>% filter(PATIENT.STATE == "MI", str_detect(mapsallpatient$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE")) 
mipatient <- mutate(mipatient, drug_type = ifelse(grepl("OPIATE",mipatient$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))

names(mipatient) <- c("county","patient_state","drug_name","dea_schedule","ahfs_description",
                      "count","units","year","drug_type")

mipatient_state <- mipatient %>% group_by(year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(mipopdata,by=c("year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% mutate(data_source = "Patient")


#Prescriber Data
upprescrib <- mapsallprescrib %>% filter(PRESCRIBER.STATE == "MI",
                                         str_detect(mapsallprescrib$PRESCRIBER.COUNTY, regex(paste(countypop$County_Name, collapse = "|"),ignore_case=TRUE)),
                                         str_detect(mapsallprescrib$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE")) 
upprescrib <- mutate(upprescrib, drug_type = ifelse(grepl("OPIATE",upprescrib$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))

names(upprescrib) <- c("county","prescriber_state","drug_name","dea_schedule","ahfs_description",
                       "count","units","year","drug_type")

upprescrib_county <- upprescrib %>% group_by(county, year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(countypopest_long,by=c("county","year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% arrange(desc(scriptperpop)) %>% mutate(data_source = "prescriber")



#Dispencer Data
updispens <- mapsalldispens %>% filter(DISPENSER.STATE == "MI",
                                       str_detect(mapsalldispens$DISPENSER.COUNTY, regex(paste(countypop$County_Name, collapse = "|"),ignore_case=TRUE)),
                                       str_detect(mapsalldispens$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE"))
updispens <- mutate(updispens, drug_type = ifelse(grepl("OPIATE",updispens$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))

names(updispens) <- c("county","dispenser_state","drug_name","dea_schedule","ahfs_description",
                      "count","units","year","drug_type")

updispens_county <- updispens %>% group_by(county, year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(countypopest_long,by=c("county","year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% arrange(desc(scriptperpop)) %>% mutate(data_source = "dispenser")



#Patient Data
uppatient <- mapsallpatient %>% filter(PATIENT.STATE == "MI",
                                       str_detect(mapsallpatient$PATIENT.COUNTY, regex(paste(countypop$County_Name, collapse = "|"),ignore_case=TRUE)),
                                       str_detect(mapsallpatient$AHFS.DESCRIPTION, "BENZODIAZEPINES|OPIATE"))
uppatient <- mutate(uppatient, drug_type = ifelse(grepl("OPIATE",uppatient$AHFS.DESCRIPTION),'OPIATE','BENZODIAZEPINES'))
uppatient$PATIENT.COUNTY <- sapply(uppatient$PATIENT.COUNTY, toupper)

names(uppatient) <- c("county","patienter_state","drug_name","dea_schedule","ahfs_description",
                      "count","units","year","drug_type")

uppatient_county <- uppatient %>% group_by(county, year, drug_type) %>% 
        summarise(tot_script = sum(count), tot_unit = sum(units)) %>% mutate(unitperscript = (tot_unit/tot_script)) %>%
        merge(countypopest_long,by=c("county","year")) %>% mutate(scriptperpop = (tot_script/population)*100) %>%  
        group_by(year, drug_type) %>% arrange(desc(scriptperpop)) %>% mutate(data_source = "patient")


upcounty2017 <- uppatient_county  %>% filter(year == 2017, drug_type == "OPIATE")  %>% 
        select(county, tot_script, scriptperpop, population) %>% 
        arrange(county)

upcounty2017 <- uppatient_county  %>% filter(year == 2017, drug_type == "OPIATE")  %>% 
        select(county, tot_script, scriptperpop, population) %>% 
        arrange(county)

countypop2010 <- countypop %>%  arrange(County_Name)


all_maps_data <- rbind(upprescrib_county,updispens_county,uppatient_county)

county_year_means <- all_maps_data %>% filter(drug_type =="OPIATE",data_source=="patient") %>%
        group_by(county) %>% summarise(mean = mean(scriptperpop), sd = sd(scriptperpop), 
                                       ci = 2.571*(sd(scriptperpop)/sqrt(5)),
                                       totalscript = sum(tot_script), totalunits = sum(tot_unit))

mapsmiavg <- mipatient_state %>% filter(drug_type =="OPIATE") %>% group_by(drug_type) %>%
        summarise(mean = mean(scriptperpop), sd = sd(scriptperpop), 
                  ci = 2.571*(sd(scriptperpop)/sqrt(5)),
                  totalscript = sum(tot_script), totalunits = sum(tot_unit))



cols <- c("county","year","drug", "scripts", "units", "units_per_script",
          "population","scripts_per_pop","source")
colnames(all_maps_data) <- cols
all_maps_data$county <- tolower(all_maps_data$county)
all_maps_data$drug <- tolower(all_maps_data$drug)


# Calculates death and hospitalization rate for >10 events
countypopest_long_lc <- countypopest_long 
countypopest_long_lc$county <- tolower(countypopest_long_lc$county)
hospitalizationdata2 <- hospitalizationdata %>% merge(countypopest_long_lc,by=c("county","year")) %>%
        mutate(hosperpop = ifelse(hospitalizations<10,NA,(hospitalizations/population)*1000))

deathdata$county <- gsub("saint joseph", "st. joseph", deathdata$county)
deathdata$county <- gsub("saint clair", "st. clair", deathdata$county)

deathdata2 <- deathdata %>% merge(countypopest_long_lc,by=c("county","year")) %>%
        mutate(deathperpop = ifelse(deaths<10,NA,(deaths/population)*1000))


write.csv(all_maps_data, file = "all_maps_data.csv",row.names=FALSE)
write.csv(deathdata2, file = "deathdata2.csv",row.names=FALSE)
write.csv(hospitalizationdata2, file = "hospitalizationdata2.csv",row.names=FALSE)


