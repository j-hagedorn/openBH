
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
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

# Clean data

kent_211 %<>%
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
                          city,", ",state,", ",zip))



# Aggregate

by_service <-
kent_211 %>%
  group_by(service_term) %>%
  summarize(n = n())

by_site <-
kent_211 %>%
  group_by(site_name) %>%
  summarize(services = n_distinct(service_term))
  

