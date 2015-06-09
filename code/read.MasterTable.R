library(dplyr)
library(acs)#be sure to also create "census_key" to install API key
#            and hide in local enviroment 

#County Health rankings Data
v1<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\2015 County Health Rankings Michigan Data.csv",header=TRUE)
v2<-tbl_df(v1)

County.Health<-select(v2,FIPS,Under.18=X....18,Over.65=X..65.and.over,African.American=
                        X..African.American,American.Indian_Alaskan.Native=X..American.Indian..Alaskan.Native,Asian=X..Asian,
                      Native.Hawaiian.or.Other.Pacific.Islander=X..Native.Hawaiian..Other.Pacific.Islander,
                      Hispanic=X..Hispanic,Non.Hispanic.white=X..Non.Hispanic.white,
                      Not.Proficient.in.English=X..Not.Proficient.in.English,
                      Female=X..Female,Rural=X..Rural,Diabetic=X..Diabetic,
                      HIV.Cases=X..HIV.Cases,Number.of.Deaths=X..Deaths,
                      Food.Insecurity=X..Food.Insecure,Limited.access.to.Healthy.food=X..Limited.Access,
                      Motor.Vehicle.Deaths=X..Motor.Vehicle.Deaths,
                      Drug.Poisoning.Deaths=X..Drug.Poisoning.Deaths,
                      Uninsured.Adults=X..Uninsured,Uninsured.Children=X..Uninsured.2,
                      Healthcare.Costs=Costs,Could.not.see.doctor.due.to.cost=X..Couldn.t.Access,
                      Household.Income,Homicide.Rate)
rm(v1,v2)

#HUD 50th Percentile Rent estimates 

Rents<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FY2015_50_RevFinal.csv",header=TRUE)

#Dropping all states except Michigan
Rents<-subset(Rents,state_alpha=="MI")

#Removing the last 5 digits from the FIPS vector
FIPS<-gsub(99999,"",Rents$fips2010)
Rents<-mutate(Rents,FIPS=gsub(99999,"",Rents$fips2010))

#Choosing and renaming the variables I want
Rents<-select(Rents,FIPS,Avg.Rent.Studio=Rent50_0,
              Avg.Rent.One_Bedroom=Rent50_1,Avg.Rent.Two_bedroom=Rent50_2,
              Avg.Rent.Three_bedroom=Rent50_3,Avg.Rent.Four_bedroom=Rent50_4)

rm(FIPS)

M1<-merge(County.Health,Rents)
rm(County.Health,Rents)

#Unemployment for last three years and Median.Houshold.Income

Unemployment<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\MichiganUnemployment.csv",header=TRUE)

Unemployment<-select(Unemployment,FIPS=fips1,name,
                           Unemployment.Rate.2012=ID2012,
                           Unemployment.Rate.2013=ID20131,
                           Unemployment.Rate.2014=ID2014,
                           Median.Houshold.Income=Textbox20,
                           Median.Houshold.Income.compared.to.State=Textbox11)
M2<-merge(M1,Unemployment)
rm(M1,Unemployment)

# Install package, define geography

api.key.install(census_key, file = "key.rda") # hide key in local environment

# Define Michigan geography
lookup_MI <- geo.lookup(state = "MI", county = "*")
MIcounties <- as.vector(na.omit(lookup_MI$county))    #Get vector of counties from MI
MIbyCounty <- geo.make(state="MI", county=MIcounties) #Define region for acs.fetch query

# Get 5-year estimate data for population
#####

tst <- acs.fetch(endyear = 2012, 
                 span = 5, # x-year estimate
                 geography=MIbyCounty, 
                 #table.name,
                 #table.number, 
                 variable = c('B01003_001',
                              'B07402_001',
                              'B08303_001',
                              'B12007_001',
                              'B19057_001'
                 ), 
                 #keyword, 
                 #key, 
                 col.names = "auto")

# Make a dataframe
#####

tst <- data.frame(estimate(tst))
MI_df_13<-rename(tst,Total.Population=B01003_001,
                 Median.age=B07402_001,Travel.time.to.work=B08303_001,
                 Median.age.at.first.marriage=B12007_001,
                 Public.asst.income.per.household=B19057_001)

MI_df_13$Year <- 2013  #add year variable
MI_df_13$County <- rownames(MI_df_13) #create new var using rownames
rownames(MI_df_13) <- NULL #nullify existing rownames

#adding a FIPS column to link with 
MI_df_13$FIPS<-seq.int(26001,26165,2)

M3<-merge(M2,MI_df_13)
rm(M2,MI_df_13,lookup_MI,tst,MIcounties,census_key,MIbyCounty)

#Income maintenance per capita- Income Maintenance Payments consists largely of 
#supplemental security income payments, family assistance, food stamp payments, 
#and other assistance payments, including general assistance.


#grabbing the CSV
V2<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\IncomeMaintenance.csv",header=TRUE)

#selecting only the columns and rows that I want
IM<-select(V2,FIPS=GeoFips,Income.Maintenance.Per.Capita.2011=X2011,
           Income.Maintenance.Per.Capita.2012=X2012,
           Income.Maintenance.Per.Capita.2013=X2013)
IM<-IM[1:84, ]

M4<-merge(M3,IM)
rm(IM,V2,M3)

#Census data 
Family_Size<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\Average Fam Size.csv")
Uninsured<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\Uninsured.csv")


Family_Size<-tbl_df(Family_Size)
Uninsured<-tbl_df(Uninsured)

Family_Size<-Family_Size%>%select(GEO.id2,HC02_EST_VC10,HC03_EST_VC10,HC04_EST_VC10)
Uninsured<-Uninsured%>%select(GEO.id2,HC02_EST_VC04)

Both_merged<-merge(Family_Size,Uninsured)
Family_Dyn<-select(Both_merged,FIPS=GEO.id2,
                   Number_of_uninsured_under18=HC02_EST_VC04,
                   Married_Couples_with_Children_under18=HC02_EST_VC10,
                   Single_father_with_Children_under18=HC03_EST_VC10,
                   Single_mother_with_children_under18=HC04_EST_VC10)

M5<-merge(M4,Family_Dyn)
rm(Both_merged,Family_Size,Uninsured,Family_Dyn,M4)
