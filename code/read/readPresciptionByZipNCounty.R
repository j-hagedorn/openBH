# Load libraries
library(readxl)
library(dplyr)
library(tidyverse)

# set directory to excel files that are stored
filePath <- paste(getwd(), "/data/drugPrescription/", sep = "")

# create a function to read in data from 2007-2012
read_older_xls <- function(docname) {
  # set file path
  path <- paste(filePath, docname, sep = "")
  
  # read sheet 1
  total_schedules <- read_xls(path,
                              sheet = 1)
  colnames(total_schedules) <- total_schedules[1, ] # reset column names
  total_schedules <- total_schedules[-1, ] # remove first row
  total_schedules <- total_schedules[-nrow(total_schedules), ] # remove total summary row
  
  # read sheet 2~4
  by_zip <- 
    bind_rows(
      read_xls(path, sheet = 2),
      read_xls(path, sheet = 3),
      read_xls(path, sheet = 4)
    )
  colnames(by_zip) <- by_zip[1, ] # reset column names
  by_zip <- by_zip[-1, ] # remove first row
  by_zip <- by_zip[-nrow(by_zip), ] # remove total summary row
  
  # read sheet 5
  out_of_state <- read_xls(path, sheet = 5)
  colnames(out_of_state) <- out_of_state[1, ] # reset column names
  out_of_state <- out_of_state[-1, ] # remove first row
  out_of_state <- out_of_state[-nrow(out_of_state), ] # remove total summary row
  
  # read sheet 6
  invalid_zip <- read_xls(path, sheet = 6)
  colnames(invalid_zip) <- invalid_zip[1, ] # reset column names
  invalid_zip <- invalid_zip[-1, ] # remove first row
  invalid_zip <- invalid_zip[-nrow(invalid_zip), ] # remove total summary row
  
  return(list(total_schedules, by_zip, out_of_state, invalid_zip))
}


# create a function to read in data from 2013-2017
read_newer_xlsx <- function(docname){
  # set file path
  path <- paste(filePath, docname, sep = "")
  
  # read in sheet 1
  drug_util_rpt <- read_xlsx(path, sheet = 1)
  drug_util_rpt <- drug_util_rpt[-nrow(drug_util_rpt),]
  
  # read in sheet 2
  prescrib_county <- read_xlsx(path, sheet = 2)
  prescrib_county <- prescrib_county[-nrow(prescrib_county), ] %>%
    mutate(
      id = rep("prescriber", nrow(prescrib_county)-1)
    ) %>%
    rename(
      'COUNTY' = 'PRESCRIBER COUNTY',
      'STATE' = 'PRESCRIBER STATE'
    )
  
  
  # read in sheet 3
  disp_county <- read_xlsx(path, sheet = 3)
  disp_county <- disp_county[-nrow(disp_county), ] %>%
    mutate(
      id = rep("dispenser", nrow(disp_county)-1)
    ) %>%
    rename(
      'COUNTY' = 'DISPENSER COUNTY',
      'STATE' = 'DISPENSER STATE'
    )
  
  # read in sheet 4
  pat_county <- read_xlsx(path, sheet = 4)
  pat_county <- pat_county[-nrow(pat_county), ] %>%
    mutate(
      id = rep("patient", nrow(pat_county)-1)
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
list_of_df_2007 <- read_older_xls("Drug_2007_Report.xls")
list_of_df_2008 <- read_older_xls("Drug_2008_Report.xls")
list_of_df_2009 <- read_older_xls("Drug_2009_Report.xls")
list_of_df_2010 <- read_older_xls("Drug_2010_Report.xls")
list_of_df_2011 <- read_older_xls("Drug_2011_Report.xls")
list_of_df_2012 <- read_older_xls("Drug_2012_Report.xls")

# load newer data
list_of_df_2013 <- read_newer_xlsx("Drug Utilization Report Data - 2013.xlsx")
list_of_df_2014 <- read_newer_xlsx("Drug Utilization Report Data - 2014.xlsx")
list_of_df_2015 <- read_newer_xlsx("Drug Utilization Report Data - 2015.xlsx")
list_of_df_2016 <- read_newer_xlsx("Drug Utilization Report Data - 2016.xlsx")
list_of_df_2017 <- read_newer_xlsx("Drug Utilization Report Data - 2017.xlsx")

