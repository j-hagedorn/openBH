
library(readxl)
library(dplyr)
library(magrittr)

kent_211 <- read_excel("data/211/kent_211_Resources_May2016.xlsx")

# Remove spaces from colnames
names(kent_211)[1] <- "service_term"
names(kent_211)[2] <- "service_phone_1"
names(kent_211)[3] <- "service_phone_2"
names(kent_211)[4] <- "service_phone_3"
names(kent_211)[5] <- "site_name"
names(kent_211)[6] <- "building_line"
names(kent_211)[7] <- "address_1"
names(kent_211)[8] <- "address_2"
names(kent_211)[9] <- "city"
names(kent_211)[10] <- "state"
names(kent_211)[11] <- "zip"
names(kent_211)[12] <- "county"
names(kent_211)[13] <- "confidential"
names(kent_211)[14] <- "url"
names(kent_211)[15] <- "phone_1"
names(kent_211)[16] <- "phone_2"
names(kent_211)[17] <- "phone_3"
names(kent_211)[18] <- "phone_4"
names(kent_211)[19] <- "phone_5"

# Function to capitalize first letter

simpleCap <- function(x) {
  x <- tolower(x)
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

# Clean data

tst <-
kent_211 %>%
  mutate(service_term = as.factor(service_term),
         service_phone_1 = as.character(service_phone_1),
         service_phone_2 = as.character(service_phone_2),
         service_phone_3 = as.character(service_phone_3),
         service_phone = ifelse(is.na(service_phone_1) == T,
                                yes = ifelse(is.na(service_phone_2) == T,
                                             yes = service_phone_3,
                                             no = service_phone_2),
                                no = service_phone_1),
         site_name = as.factor(site_name),
         building_line = as.factor(building_line),
         address = paste0(address_1," ",
                          ifelse(is.na(address_2) == T,
                                 "",address_2),", ",
                          city,", ",state,", ",zip)) %>%
  # Define address variable for use in function
  mutate(address = paste0(toupper(address_1), ", ",
                          toupper(address_2), ", ",
                          toupper(city), ", ",
                          toupper(state), ", ",
                          zip))



###############################################

# Add lat/long of addresses
library(ggmap)




#initialise a dataframe to hold the results
geocoded <- data.frame()
# find out where to start in the address list (if the script was interrupted before):
# startindex <- 2527
#if a temp file exists - load it up and count the rows!
tempfilename <- paste0('addresses_temp_geocoded.rds')
if (file.exists(tempfilename)) {
  print("Found temp file - resuming from index:")
  geocoded <- readRDS(tempfilename)
  startindex <- nrow(geocoded)
  print(startindex)
}

# Start the geocoding process - address by address. geocode() function takes care of query speed limit.
for (ii in seq(1904, length(geo$address))) {
  print(paste("Working on index", ii, "of", length(geo$address)))
  #query the google geocoder - this will pause here if we are over the limit.
  result = geocode(location = geo$address[ii],
                   output = "latlona", 
                   source = "google") 
  print(result$status)     
  result$index <- ii
  #append the answer to the results file.
  geocoded <- rbind(geocoded, result)
  #save temporary results as we are going along
  saveRDS(geocoded, tempfilename)
}
# errored on index 334, 408, 546, 720

#now we add the latitude and longitude to the main data
geo$lat <- geocoded$lat
geo$long <- geocoded$long
geo$accuracy <- geocoded$accuracy
geo$formatted_address <- geocoded$formatted_address

# Aggregate

by_service <-
kent_211 %>%
  group_by(service_term) %>%
  summarize(n = n())

by_site <-
kent_211 %>%
  group_by(site_name) %>%
  summarize(services = n_distinct(service_term))
  

