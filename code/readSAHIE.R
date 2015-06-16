library(dplyr)

x<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\sahie2013.csv")

#Gathering all those 65 and under
x1<-grep(0,x$X.2)
agecat<-x[x1,]

#Gathering all races 65 and under
x2<-grep(0,agecat$X.3)
racecat<-agecat[x2,]

#gathering all sexes and races 65 and under
x3<-grep(0,racecat$X.4)
sexcat<-racecat[x3,]

#gathering all sexes,races and persons under 65 who are super poor
#(at or below 138% of poverty line)
x4<-grep(3,racecat$X.5)
poverty<-racecat[x4,]
         
#and of course broken down by counties in MI only
y1<-grep("MI",poverty$X.6)
y2<-poverty[y1,]
SAHIE<-y2[c(1:83),]

#Collecting and renaming variables of interest.LIP=Living in Poverty 
SAHIE<-select(SAHIE,FIPS=X,Year=Table.with.row.headings.in.column.A.and.column.headings.in.row.4.,
              All.Persons.Under65.LIP=X.7,Number.Uninsured.LIP=X.9,
              Number.of.Insured.LIP=X.11)
#cleanup
rm(agecat,poverty,racecat,sexcat,x,y2,x1,x2,x3,x4,y1,)
