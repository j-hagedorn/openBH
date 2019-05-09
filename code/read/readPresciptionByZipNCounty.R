# Load libraries
library(readxl)
library(dplyr)
library(tidyverse)

# set directory to excel files that are stored
filePath <- paste(getwd(), "/data/drugPrescription/", sep = "")

# create a function to read in data from 2007-2012
read_older_xls <- function(docname, year) {
  # set file path
  path <- paste(filePath, docname, sep = "")
  
  # read sheet 1
  total_schedules <- read_xls(path, sheet = 1)
  colnames(total_schedules) <- total_schedules[1, ] # reset column names
  total_schedules <- total_schedules[-1, ] # remove first row
  total_schedules <- total_schedules[-nrow(total_schedules), ] # remove total summary row
  total_schedules <- total_schedules %>%
    mutate(YEAR = rep(year, nrow(total_schedules)))
  
  # read sheets 2~4
  if( year == 2012){
    by_zip <- read_xls(path, sheet = 2, col_names = FALSE)
    colnames(by_zip) <- by_zip[2, ] # reset column names
    by_zip <- by_zip[-1:-2, ] # remove first two rows
    by_zip <- by_zip[-nrow(by_zip), ] # remove total summary row
    
    rest_by_zip <- rbind(
      read_xls(path, sheet = 3, col_names = FALSE),
      read_xls(path, sheet = 4, col_names = FALSE)
    )
    colnames(rest_by_zip) <- colnames(by_zip)
    by_zip <- rbind(by_zip, rest_by_zip) %>%
      mutate( YEAR = rep(year, nrow(rest_by_zip)+nrow(by_zip))
    )
  } else {
    by_zip <- 
    rbind(
      read_xls(path, sheet = 2, col_names = FALSE),
      read_xls(path, sheet = 3, col_names = FALSE),
      read_xls(path, sheet = 4, col_names = FALSE)
    )
  colnames(by_zip) <- by_zip[2, ] # reset column names
  by_zip <- by_zip[-1:-2, ] # remove first row
  by_zip <- by_zip[-nrow(by_zip), ] # remove total summary row
  by_zip <- by_zip %>%
    mutate(YEAR = rep(year, nrow(by_zip)))
  }
  
  # read sheet 5
  out_of_state <- read_xls(path, sheet = 5)
  colnames(out_of_state) <- out_of_state[1, ] # reset column names
  out_of_state <- out_of_state[-1, ] # remove first row
  out_of_state <- out_of_state[-nrow(out_of_state), ] # remove total summary row
  out_of_state <- out_of_state %>%
    mutate(YEAR = rep(year, nrow(out_of_state)))
  
  # read sheet 6
  invalid_zip <- read_xls(path, sheet = 6)
  colnames(invalid_zip) <- invalid_zip[1, ] # reset column names
  invalid_zip <- invalid_zip[-1, ] # remove first row
  invalid_zip <- invalid_zip[-nrow(invalid_zip), ] # remove total summary row
  invalid_zip <- invalid_zip %>%
    mutate(YEAR = rep(year, nrow(invalid_zip)))
  
  return(list(total_schedules, by_zip, out_of_state, invalid_zip))
}


# create a function to read in data from 2013-2017
read_newer_xlsx <- function(docname, year){
  # set file path
  path <- paste(filePath, docname, sep = "")
  
  # read in sheet 1
  drug_util_rpt <- read_xlsx(path, sheet = 1)
  drug_util_rpt <- drug_util_rpt[-nrow(drug_util_rpt),]
  drug_util_rpt <- drug_util_rpt %>%
    mutate(YEAR = rep(year, nrow(drug_util_rpt)))
  
  # read in sheet 2
  prescrib_county <- read_xlsx(path, sheet = 2)
  prescrib_county <- prescrib_county[-nrow(prescrib_county), ] %>%
    mutate(
      id = rep("prescriber", nrow(prescrib_county)-1),
      YEAR = rep(year, nrow(prescrib_county)-1)
    ) %>%
    rename(
      'COUNTY' = 'PRESCRIBER COUNTY',
      'STATE' = 'PRESCRIBER STATE'
    )
  
  
  # read in sheet 3
  disp_county <- read_xlsx(path, sheet = 3)
  disp_county <- disp_county[-nrow(disp_county), ] %>%
    mutate(
      id = rep("dispenser", nrow(disp_county)-1),
      YEAR = rep(year, nrow(disp_county)-1)
    ) %>%
    rename(
      'COUNTY' = 'DISPENSER COUNTY',
      'STATE' = 'DISPENSER STATE'
    )
  
  # read in sheet 4
  pat_county <- read_xlsx(path, sheet = 4)
  pat_county <- pat_county[-nrow(pat_county), ] %>%
    mutate(
      id = rep("patient", nrow(pat_county)-1),
      YEAR = rep(year, nrow(pat_county)-1)
    ) %>%
    rename(
      'COUNTY' = 'PATIENT COUNTY',
      'STATE' = 'PATIENT STATE'
    )
  
  # bind all dataframes organized by county
  by_county <- rbind(prescrib_county, disp_county, pat_county)
  
  return(list(drug_util_rpt, by_county))
}

# load older data
list_of_df_2007 <- read_older_xls("Drug_2007_Report.xls", 2007)
list_of_df_2008 <- read_older_xls("Drug_2008_Report.xls", 2008)
list_of_df_2009 <- read_older_xls("Drug_2009_Report.xls", 2009)
list_of_df_2010 <- read_older_xls("Drug_2010_Report.xls", 2010)
list_of_df_2011 <- read_older_xls("Drug_2011_Report.xls", 2011)
list_of_df_2012 <- read_older_xls("Drug_2012_Report.xls", 2012)

# load newer data
list_of_df_2013 <- read_newer_xlsx("Drug Utilization Report Data - 2013.xlsx", 2013)
list_of_df_2014 <- read_newer_xlsx("Drug Utilization Report Data - 2014.xlsx", 2014)
list_of_df_2015 <- read_newer_xlsx("Drug Utilization Report Data - 2015.xlsx", 2015)
list_of_df_2016 <- read_newer_xlsx("Drug Utilization Report Data - 2016.xlsx", 2016)
list_of_df_2017 <- read_newer_xlsx("Drug Utilization Report Data - 2017.xlsx", 2017)

# combine data from all years organized by zipcode
total_2012 <- as.data.frame(list_of_df_2012[1])
total_2011 <- as.data.frame(list_of_df_2011[1])
colnames(total_2012) <- colnames(total_2011)

by_zip_2007 <- as.data.frame(list_of_df_2007[2])
by_zip_2010 <- as.data.frame(list_of_df_2010[2])
by_zip_2012 <- as.data.frame(list_of_df_2012[2])
by_zip_2011 <- as.data.frame(list_of_df_2011[2])
colnames(by_zip_2007) <- colnames(by_zip_2011)
colnames(by_zip_2010) <- colnames(by_zip_2011)
colnames(by_zip_2012) <- colnames(by_zip_2011)

out_of_state_2012 <- as.data.frame(list_of_df_2012[3])
out_of_state_2011 <- as.data.frame(list_of_df_2011[3])
colnames(out_of_state_2012) <- colnames(out_of_state_2011)

invalid_zip_2012 <- as.data.frame(list_of_df_2012[4])
invalid_zip_2011 <- as.data.frame(list_of_df_2011[4])
colnames(invalid_zip_2012) <- colnames(invalid_zip_2011)

combined_total_report_by_zip <- rbind(
  as.data.frame(list_of_df_2007[1]),
  as.data.frame(list_of_df_2008[1]),
  as.data.frame(list_of_df_2009[1]),
  as.data.frame(list_of_df_2010[1]),
  as.data.frame(list_of_df_2011[1]),
  total_2012
)

combined_by_zip <- rbind(
  by_zip_2007,
  as.data.frame(list_of_df_2008[2]),
  as.data.frame(list_of_df_2009[2]),
  by_zip_2010,
  as.data.frame(list_of_df_2011[2]),
  by_zip_2012
)

combined_out_of_state <- rbind(
  as.data.frame(list_of_df_2007[3]),
  as.data.frame(list_of_df_2008[3]),
  as.data.frame(list_of_df_2009[3]),
  as.data.frame(list_of_df_2010[3]),
  as.data.frame(list_of_df_2011[3]),
  out_of_state_2012
)

combined_invalid_zip <- rbind(
  as.data.frame(list_of_df_2007[4]),
  as.data.frame(list_of_df_2008[4]),
  as.data.frame(list_of_df_2009[4]),
  as.data.frame(list_of_df_2010[4]),
  as.data.frame(list_of_df_2011[4]),
  invalid_zip_2012
)


# combine data from all years organized by county
combined_total_by_county <- rbind(
  as.data.frame(list_of_df_2013[1]),
  as.data.frame(list_of_df_2014[1]),
  as.data.frame(list_of_df_2015[1]),
  as.data.frame(list_of_df_2016[1]),
  as.data.frame(list_of_df_2017[1])
)

combined_by_county <- rbind(
  as.data.frame(list_of_df_2013[2]),
  as.data.frame(list_of_df_2014[2]),
  as.data.frame(list_of_df_2015[2]),
  as.data.frame(list_of_df_2016[2]),
  as.data.frame(list_of_df_2017[2])
)



