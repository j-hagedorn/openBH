library(gdata)#requires installing the latest veriosn of perl and restarting computer
library(dplyr)


#Creating folder on home directory 
dir.create("CountyHealthRankings")
setwd("~/CountyHealthRankings")

#Grabbing the excell file from the website for the last 5years and adding year col.

County15<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2015CountyHealthRankingsNationalData.xls",
                   sheet=2)
County15<-mutate(County15,Year="2015")

County14<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2014%20County%20Health%20Rankings%20Data%20-%20v1.xls",
                   sheet=2)
County14<-mutate(County14,Year="2014")

County13<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2013%20County%20Health%20Rankings%20Data%20-%20v1.xls",
                   sheet=2)
County13<-mutate(County13,Year="2013")

County12<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2012%20County%20Health%20Rankings%20National%20Data_v2.xls",
                  sheet=2)
County12<-mutate(County12,Year="2012")

County11<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2011%20County%20Health%20Rankings%20National%20Data_v2.xls",
                   sheet=2)
County11<-mutate(County11,Year="2011")

County10<-read.xls("http://www.countyhealthrankings.org/sites/default/files/2010%20County%20Health%20Rankings%20National%20Data.xls",
                   sheet=2)
County10<-mutate(County10,Year="2010")

#Filtering data to variables of interest 
x1<-grep("Michigan",County15$X.1)
County15<-County15[x1,]
County15<-County15[c(2:84),]
County15<-select(County15,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=X.4)

x1<-grep("Michigan",County14$X.1)
County14<-County14[x1,]
County14<-select(County14,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=Health.Factors)

x1<-grep("Michigan",County13$X.1)
County13<-County13[x1,]
County13<-select(County13,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=Health.Factors)

x1<-grep("Michigan",County12$X.1)
County12<-County12[x1,]
County12<-select(County12,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=Health.Factors)

x1<-grep("Michigan",County11$X.1)
County11<-County11[x1,]
County11<-select(County11,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=Health.Factors)

x1<-grep("Michigan",County10$X.1)
County10<-County10[x1,]
County10<-select(County10,FIPS=X,Year,County=X.2,"County.Health.Factor.Ranking"=Health.Factors)

#Storing documentation and data from source 
#2015
download.file("http://www.countyhealthrankings.org/sites/default/files/2015%20CHR%20SAS%20Analytic%20Data%20Documentation.pdf",
              'SummaryReport2015.pdf',mode="wb")
download.file("http://www.countyhealthrankings.org/sites/default/files/2015CountyHealthRankingsNationalData.xls",
              'FullCounty2015Data.xls',mode="wb")
#2014
download.file("http://www.countyhealthrankings.org/sites/default/files/2014%20CHR%20analytic%20data%20documentation.pdf",
              'SummaryReport2014.pdf',mode="wb")
download.file("http://www.countyhealthrankings.org/sites/default/files/2014%20County%20Health%20Rankings%20Data%20-%20v1.xls",
              'FullCounty2014Data.xls',mode="wb")
#2013
download.file("http://www.countyhealthrankings.org/sites/default/files/2013%20County%20Health%20Rankings%20Data%20-%20v1.xls",
              'FullCounty2013Data.xls', mode="wb")
#2012
download.file("http://www.countyhealthrankings.org/sites/default/files/2012%20County%20Health%20Rankings%20National%20Data_v2.xls",
              'FullCounty2012Data.xls', mode="wb")
#2011
download.file("http://www.countyhealthrankings.org/sites/default/files/2011%20County%20Health%20Rankings%20National%20Data_v2.xls",
              'FullCounty2011Data.xls', mode="wb")
#2010
download.file("http://www.countyhealthrankings.org/sites/default/files/2010%20County%20Health%20Rankings%20National%20Data.xls",
              'FullCounty2010Data.xls', mode="wb")

#Combine with most recent ranking on top
County.Health.Factor.Rankings<-rbind(County15,County14,County13,County12,County11,
                                     County10)

save("County.Health.Factor.Rankings",file="County.Health.Factor.Rankings.rda")

#cleanup and set WD back to default home directory 
rm(x1)
setwd("~/")
