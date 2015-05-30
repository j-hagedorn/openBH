library(dplyr) 

Rents_in_50th_percentile<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FY2015_50_RevFinal.csv",header=TRUE)

#Dropping all states except Michigan
Rents_in_50th_percentile<-subset(Rents_in_50th_percentile,state_alpha=="MI")

#Choosing and renaming the variables I want
Rents_in_50th_percentile<-select(Rents_in_50th_percentile,FIPS=fips2010,Studio=Rent50_0,
                                 One_Bedroom=Rent50_1,Two_bedroom=Rent50_2,
                                 Three_bedroom=Rent50_3,Four_bedroom=Rent50_4,
                                 Population2010=pop2010)
                                 
#trying to delete the first column with no luck. Thought it should have been dropped
#in the previous subset function
Rents_in_50th_percentile$row.names<-NULL
