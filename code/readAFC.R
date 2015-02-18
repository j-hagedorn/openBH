afc <- read.csv("http://www.dleg.state.mi.us/fhs/brs/txt/afc_sw.txt", header = F,
                col.names = c("CountyID","FacilityType","LicenseNo",
                              "FacilityName","SuppAddress","Street",
                              "City","State","Zip","Phone","Capacity",
                              "Effective","Expiration","Status",
                              "ServePhysHandicap","ServeDD","ServeMI","ServeAged","ServeTBI","ServeAlzheimers",
                              "SpecialCertDD","SpecialCertMI",
                              "ComLivDD","ComLivMI",
                              "Licensee","ViolationsPastYr",
                              "LicenseeAddress","LicenseeSuppAddress","LicenseeCity","LicenseeState",
                              "LicenseeZip","LicenseePhone","LicenseeStatus"))

# Recode Facility Type
library(car)
afc$TypeDesc <- recode(afc$FacilityType,
                       "'AF' = 'Family Home';
                       'AS' = 'Small Group';
                       'AM' = 'Medium Group';
                       'AL' = 'Large Group';
                       'AG' = 'Congregate';
                       'AI' = 'County Infirmary';
                       'AH' = 'Home for the Aged'")

# Dates as date class
library(lubridate)
afc$Effective <- ymd(afc$Effective)
afc$Expiration <- ymd(afc$Expiration)

# Log download date
afc$Downloaded <- Sys.Date()

# Write to file
write.csv(afc, file = "data/afc.csv")
