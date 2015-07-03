<<<<<<< HEAD

# Source files at: http://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Physician-and-Other-Supplier.html

source("installFunctions.R")
load_or_install(c("ffbase", "jsonlite", "data.table", "parallel", "bigmemory", "bigtabulate","ggplot2","stringr","foreach","wordcloud","lsa","MASS","openNLP","tm","fastmatch","reshape","openNLPmodels.en",'e1071','gridExtra', 'XLConnect', 'reshape', 'dplyr', 'RColorBrewer'))

library(dplyr)

physician_medicare = "data/Medicare-Physician-and-Other-Supplier-PUF-CY2012.txt"
hospital_medicare = "data/Medicare_Provider_Charge_Inpatient_DRG100_FY2012.csv"

pm <- read.delim(physician_medicare, stringsAsFactors=FALSE)
pm <- tbl_df(pm)

hm = read.delim(hospital_medicare, sep = ",", stringsAsFactors=FALSE)
hm <- tbl_df(hm)

pm_MI <- 
  pm %>%
  filter(nppes_provider_state == "MI" | )

write.csv(pm_MI, "data/MedicarePhysicianSupplier_Michigan.csv")

# Make factor data types
provider_type              
medicare_participation_indicator
place_of_service               
hcpcs_code
hcpcs_description

pm_MI$nppes_provider_city <- as.factor(pm_MI$nppes_provider_city)
levels(pm_MI$nppes_provider_city)

#Subset

sub_pm = pm[, c("npi", 
                "nppes_provider_last_org_name",
                "nppes_provider_zip",
                "nppes_provider_state",
                "provider_type",
                "hcpcs_code", 
                "hcpcs_description",
                "line_srvc_cnt", 
                "bene_unique_cnt", 
                "bene_day_srvc_cnt", 
                "average_Medicare_allowed_amt", 
                "stdev_Medicare_allowed_amt", 
                "average_submitted_chrg_amt", 
                "stdev_submitted_chrg_amt", 
                "average_Medicare_payment_amt", 
                "stdev_Medicare_payment_amt")]

sub_pm = data.table(sub_pm)
setkey(sub_pm, "npi")
sub_pm = sub_pm[-1,] # Remove first row

sub_pm$provider_type <- as.factor(sub_pm$provider_type)
# levels(sub_pm$provider_type)

=======
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
>>>>>>> 3babeff477d4a503cff7c89ed52ba65267a9aa39
