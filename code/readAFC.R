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

# Make a complete address field for geocoding
library(dplyr)
library(stringr)
afc_map <-
afc %>%
  mutate(GeoAddress = str_trim(paste(SuppAddress,Street,City,State,Zip,", usa", sep = " "))) %>%
  select(LicenseNo, GeoAddress)

# Add lat/long of addresses

# Define addresses variable for use in function
data <- afc_map

addresses <- afc_map$GeoAddress

  #initialise a dataframe to hold the results
  geocoded <- data.frame()
  # find out where to start in the address list (if the script was interrupted before):
  startindex <- 2527
  #if a temp file exists - load it up and count the rows!
  tempfilename <- paste0('addresses_temp_geocoded.rds')
  if (file.exists(tempfilename)){
    print("Found temp file - resuming from index:")
    geocoded <- readRDS(tempfilename)
    startindex <- nrow(geocoded)
    print(startindex)
  }
  
  # Start the geocoding process - address by address. geocode() function takes care of query speed limit.
  for (ii in seq(startindex, length(addresses))){
    print(paste("Working on index", ii, "of", length(addresses)))
    #query the google geocoder - this will pause here if we are over the limit.
    result = getGeoDetails(addresses[ii]) 
    print(result$status)     
    result$index <- ii
    #append the answer to the results file.
    geocoded <- rbind(geocoded, result)
    #save temporary results as we are going along
    saveRDS(geocoded, tempfilename)
  }
  
  #now we add the latitude and longitude to the main data
  data$lat <- geocoded$lat
  data$long <- geocoded$long
  data$accuracy <- geocoded$accuracy
  data$formatted_address <- geocoded$formatted_address

# join

data <-
afc %>%
  inner_join(data, by = "LicenseNo")

# Create logical variables (so we can easily make them numeric!)
data$ServePhysHandicap <- data$ServePhysHandicap == "Y"
data$ServeDD <- data$ServeDD == "Y"
data$ServeMI <- data$ServeMI == "Y"
data$ServeAged <- data$ServeAged == "Y"
data$ServeTBI <- data$ServeTBI == "Y"
data$ServeAlzheimers <- data$ServeAlzheimers == "Y"
data$SpecialCertDD <- data$SpecialCertDD == "Y"
data$SpecialCertMI <- data$SpecialCertMI == "Y"
data$ViolationsPastYr <- data$ViolationsPastYr == "YES"
data$Provisionals <- data$Status %in% c("1ST PROVISIONAL","2ND PROVISIONAL")

# Recode bed capacity in ranges
  data$BedRange <- recode(data$Capacity,
                         "1:6 = '01-06 beds'; 
                          7:12 ='07-12 beds';
                          13:20 = '13-20 beds';
                          else = '21+ beds'")
  data$BedRange <- as.factor(data$BedRange)

# Make Factor variable for DD, MI
  data$DDMI <- paste(data$ServeDD,data$ServeMI,
                     sep = "|")
  library(car)
  data$DDMI <- recode(data$DDMI, "'FALSE|TRUE'='MI'; 
                                 'TRUE|FALSE'='DD';
                                 'TRUE|TRUE'='DD|MI';
                                  else = 'Other'")
  data$DDMI <- as.factor(data$DDMI)

data$Populations <- paste(data$ServeDD,data$ServeMI,
                          data$ServeTBI,data$ServeAged,
                          data$ServePhysHandicap,data$ServeAlzheimers,
                          sep = "|")

# Write to file
write.csv(data, file = "data/afc.csv")
