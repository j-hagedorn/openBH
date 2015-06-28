library(dplyr)
library(gdata)#Requires latest version of perl

m12<-read.xls("http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2012.xls",method="csv")
m12<-mutate(m12,Year="2012")

# put into mxx all rows where mxx$County.name starts with "MI"
m12<-m12[grepl("MI", m12$County.name),]


#Selecting variables of interest
m12<-select(m12,FIPS=County.ID,Year,Medicare.Enrollees=Medicare.enrollees..2012.,
            Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B=X,
            Hospice.reimbursements.per.enrolle=X.5,Physician.reimbursements.per.enrollee=X.2)
###############################################################################
m11<-read.xls("http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2011.xls",method="csv")
m11<-mutate(m11,Year="2011")

# put into mxx all rows where mxx$County.name starts with "MI"
m11<-m11[grepl("MI", m11$County.name),]

#Selecting variables of interest
m11<-select(m11,FIPS=County.ID,Year,Medicare.Enrollees=Medicare.enrollees..2011.,
            Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B=X,
            Hospice.reimbursements.per.enrolle=X.5,Physician.reimbursements.per.enrollee=X.2)
##################################################################
m10<-read.xls("http://www.dartmouthatlas.org/downloads/tables/pa_reimb_county_2010.xls",method="csv")
m10<-mutate(m10,Year="2010")
# put into mxx all rows where mxx$County.name starts with "MI"
m10<-m10[grepl("MI", m10$County.name),]

#Selecting variables of interest
m10<-select(m10,FIPS=County.ID,Year,Medicare.Enrollees=Medicare.enrollees..2010.,
            Total.Medicare.reimbursements.per.enrollee.Parts.A.and.B=X,
            Hospice.reimbursements.per.enrolle=X.5,Physician.reimbursements.per.enrollee=X.2)
##################################################################
Medicare<-rbind(m12,m11,m10)
