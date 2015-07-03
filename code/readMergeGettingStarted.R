library(dplyr)
library(xlsx)

#Adding a new column to each dataset called "Year_FIPS"
#It combines the year and FIPS column to make a new primary key

Fair.Market.Rents$Year_FIPS<-paste(Fair.Market.Rents$Year,Fair.Market.Rents$FIPS,
                                   sep="_")
Fair.Market.Rents<-select(Fair.Market.Rents,Year_FIPS,County,State,
                          Three_bedroom_monthly)

County.Health.Factor.Rankings$Year_FIPS<-paste(County.Health.Factor.Rankings$Year,
                                     County.Health.Factor.Rankings$FIPS,
                                     sep="_")
County.Health.Factor.Rankings<-select(County.Health.Factor.Rankings,Year_FIPS,
                                      County.Health.Factor.Ranking)

Unemployment$Year_FIPS<-paste(Unemployment$Year,Unemployment$FIPS,sep="_")
Unemployment<-select(Unemployment,Year_FIPS,Labor.Force,Unemployed)

Access10and06$Year_FIPS<-paste(Access10and06$Year,Access10and06$FIPS,sep="_")
Access10and06<-select(Access10and06,Year_FIPS,No.Car.and.Low.access.to.store)

Obesity.Prevalence$Year_FIPS<-paste(Obesity.Prevalence$Year,
                                  Obesity.Prevalence$FIPS, sep="_")
Obesity.Prevalence<-select(Obesity.Prevalence,Year_FIPS,Obesity.Prevalence)

Crime$Year_FIPS<-paste(Crime$Year,Crime$FIPS,sep="_")
Crime<-select(Crime,Year_FIPS,Murder,Rape,Robbery,Aggrevated.Assault,
              Motor.Vehicle.Theft,Arson)

Diagnosed.Diabetes.Prevalence$Year_FIPS<-paste(Diagnosed.Diabetes.Prevalence$Year,
                                               Diagnosed.Diabetes.Prevalence$FIPS,
                                               sep="_")
Diagnosed.Diabetes.Prevalence<-select(Diagnosed.Diabetes.Prevalence,Year_FIPS,
                                      Diagnosed.Diabetes.Prevalence)
Medicare$Year_FIPS<-paste(Medicare$Year,Medicare$FIPS,sep="_")
Medicare<-select(Medicare,Year_FIPS,
                 Medicare.Enrollees,Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B)

#Joining all datasets 
Table<-full_join(Fair.Market.Rents,County.Health.Factor.Rankings,by = "Year_FIPS")
Table<-full_join(Table,Unemployment,by = "Year_FIPS")
Table<-full_join(Table,Crime,by = "Year_FIPS")
Table<-full_join(Table,Diagnosed.Diabetes.Prevalence,by = "Year_FIPS")
Table<-full_join(Table,Obesity.Prevalence,by = "Year_FIPS")
Table<-full_join(Table,Medicare,by = "Year_FIPS")
Table<-full_join(Table,Access10and06,by = "Year_FIPS")

rm(Crime,Fair.Market.Rents,Medicare,Unemployment,Diagnosed.Diabetes.Prevalence,
   Obesity.Prevalence,Access10and06,County.Health.Factor.Rankings)


#Copying Primary key,labeleing it FIPS and moving to the front of the DF
#using this useful function found here:http://stackoverflow.com/a/18540144/1270695

Table$FIPS<-Table$Year_FIPS
Table<-Table[moveme(names(Table), "FIPS first")]


#Transform strings in primary key vector to refelct year only
Table$Year_FIPS = substr(Table$Year_FIPS,1,4)
colnames(Table)[2] <- "Year"

#Transform strings in new FIPS column to reflect FIPS codes only
Table$FIPS = substr(Table$FIPS,6,10)


#Converting chr to factor
Table$FIPS<-as.factor(Table$FIPS)
Table$Year<-as.factor(Table$Year)

#Converting certain variables to numeric for analysis
Table$Three_bedroom_monthly<-as.numeric(as.factor(Table$Three_bedroom_monthly))
Table$Labor.Force<-as.numeric(as.factor(Table$Labor.Force))
Table$Unemployed<-as.numeric(as.factor(Table$Unemployed))
Table$Diagnosed.Diabetes.Prevalence<-as.numeric(as.factor(Table$Diagnosed.Diabetes.Prevalence))
Table$Obesity.Prevalence<-as.numeric(as.factor(Table$Obesity.Prevalence))
Table$Medicare.Enrollees<-as.numeric(as.factor(Table$Medicare.Enrollees))
Table$Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B<-as.numeric(as.factor(Table$Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B))

#Saving in differnt formats

save(Table,file="Table.rda")                  
write.xlsx(Table, "C:\\Users\\Joseph\\Documents\\Table.xlsx",col.names=TRUE,
           sheetName="Sheet1",row.names=TRUE, append=FALSE, showNA=TRUE)
