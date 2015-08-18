library(dplyr)

#2012
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_35019\\DS0004\\35019-0004-Data.rda")
Crime12<-subset(da35019.0004,da35019.0004$FIPS_ST=="26")
Crime12<-mutate(Crime12,Year="2012")

#Using Fips_St and Fips_Cty pattern to make FIPS column
Crime12<-Crime12[-84,]
Crime12$FIPS<-seq.int(26001,26165,2)

#Selecting varibales of interest
Crime12<-select(Crime12,FIPS,Year,Murder=MURDER,Rape=RAPE,Robbery=ROBBERY,
              Aggrevated.Assault=AGASSLT,Motor.Vehicle.Theft=MVTHEFT,
              Arson=ARSON)
rm(da35019.0004)

#2011
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_34582\\DS0004\\34582-0004-Data.rda")
Crime11<-subset(da34582.0004,da34582.0004$FIPS_ST=="26")
Crime11<-mutate(Crime11,Year="2011")

#Using Fips_St and Fips_Cty pattern to make FIPS column
Crime11<-Crime11[-84,]
Crime11$FIPS<-seq.int(26001,26165,2)

#Selecting variables of interest
Crime11<-select(Crime11,FIPS,Year,Murder=MURDER,Rape=RAPE,Robbery=ROBBERY,
              Aggrevated.Assault=AGASSLT,Motor.Vehicle.Theft=MVTHEFT,
              Arson=ARSON)
rm(da34582.0004)

#2010
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_33523\\DS0004\\33523-0004-Data.rda")
Crime10<-subset(da33523.0004,da33523.0004$FIPS_ST=="26")
Crime10<-mutate(Crime10,Year="2010")

#Using Fips_St and Fips_Cty pattern to make FIPS column
Crime10<-Crime10[-84,]
Crime10$FIPS<-seq.int(26001,26165,2)

#Selecting variables of interest
Crime10<-select(Crime10,FIPS,Year,Murder=MURDER,Rape=RAPE,Robbery=ROBBERY,
                Aggrevated.Assault=AGASSLT,Motor.Vehicle.Theft=MVTHEFT,
                Arson=ARSON)
rm(da33523.0004)

#2009
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_30763\\DS0004\\30763-0004-Data.rda")
Crime09<-subset(da30763.0004,da30763.0004$FIPS_ST=="26")
Crime09<-mutate(Crime09,Year="2009")

#Using Fips_St and Fips_Cty pattern to make FIPS column
Crime09<-Crime09[-84,]
Crime09$FIPS<-seq.int(26001,26165,2)

#Selecting variables of interest
Crime09<-select(Crime09,FIPS,Year,Murder=MURDER,Rape=RAPE,Robbery=ROBBERY,
                Aggrevated.Assault=AGASSLT,Motor.Vehicle.Theft=MVTHEFT,
                Arson=ARSON)
rm(da30763.0004)

Crime<-rbind(Crime12,Crime11,Crime10,Crime09)
save(Crime,file="Crime12.rda")
