library(gdata)#requires latest version of pearl
library(dplyr)

E14<-read.xls("http://www.bls.gov/lau/laucnty14.xlsx",skip=1,method="csv")
E14<-mutate(E14,Year="2014")

E14<-subset(E14,State==026)
E14$FIPS<-seq.int(from=26001,to=26165,by=2)

E14<-select(E14,FIPS,Year, Labor.Force=X.4,Unemployed=X.6)

##########################################################################
E13<-read.xls("http://www.bls.gov/lau/laucnty13.xlsx",skip=1,method="csv")
E13<-mutate(E13,Year="2013")

E13<-subset(E13,State==026)
E13$FIPS<-seq.int(from=26001,to=26165,by=2)

E13<-select(E13,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
##########################################################################
E12<-read.xls("http://www.bls.gov/lau/laucnty12.xlsx",skip=1,method="csv")
E12<-mutate(E12,Year="2012")

E12<-subset(E12,State==026)
E12$FIPS<-seq.int(from=26001,to=26165,by=2)

E12<-select(E12,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
#########################################################################
E11<-read.xls("http://www.bls.gov/lau/laucnty11.xlsx",skip=1,method="csv")
E11<-mutate(E11,Year="2011")

E11<-subset(E11,State==026)
E11$FIPS<-seq.int(from=26001,to=26165,by=2)

E11<-select(E11,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
#########################################################################
E10<-read.xls("http://www.bls.gov/lau/laucnty10.xlsx",skip=1,method="csv")
E10<-mutate(E10,Year="2010")

E10<-subset(E10,State==026)
E10$FIPS<-seq.int(from=26001,to=26165,by=2)

E10<-select(E10,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
#########################################################################
E09<-read.xls("http://www.bls.gov/lau/laucnty09.xlsx",skip=1,method="csv")
E09<-mutate(E09,Year="2009")

E09<-subset(E09,State==026)
E09$FIPS<-seq.int(from=26001,to=26165,by=2)

E09<-select(E09,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
#########################################################################
E08<-read.xls("http://www.bls.gov/lau/laucnty08.xlsx",skip=1,method="csv")
E08<-mutate(E08,Year="2008")

E08<-subset(E08,State==026)
E08$FIPS<-seq.int(from=26001,to=26165,by=2)

E08<-select(E08,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
##########################################################################
E07<-read.xls("http://www.bls.gov/lau/laucnty07.xlsx",skip=1,method="csv")
E07<-mutate(E07,Year="2007")

E07<-subset(E07,State==026)
E07$FIPS<-seq.int(from=26001,to=26165,by=2)

E07<-select(E07,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
##########################################################################
E06<-read.xls("http://www.bls.gov/lau/laucnty06.xlsx",skip=1,method="csv")
E06<-mutate(E06,Year="2006")

E06<-subset(E06,State==026)
E06$FIPS<-seq.int(from=26001,to=26165,by=2)

E06<-select(E06,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)
###########################################################################
E05<-read.xls("http://www.bls.gov/lau/laucnty05.xlsx",skip=1,method="csv")
E05<-mutate(E05,Year="2005")

E05<-subset(E05,State==026)
E05$FIPS<-seq.int(from=26001,to=26165,by=2)

E05<-select(E05,FIPS,Year,Labor.Force=X.4,Unemployed=X.6)

Unemployment<-rbind(E14,E13,E11,E10,E09,E08,E07,E06,E05)

save(Unemployment,file="Unemployment.rda")
