# Read CMS Measure Inventory
# 
library(readxl); library(httr); library(tidyverse); library(stringr)
url <- "https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/QualityMeasures/Downloads/CMS-Measures-Inventory-June-2017.xlsx"
GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))
cms <- read_excel(tf, sheet = 2, na = c("9999","n/a","Not specified","Not Specified",""))

# Rename columns 
names(cms) <- make.names(names(cms),unique=T)

tst <-
cms %>% 
  mutate_if(is.character,funs(str_trim,as.factor)) %>%
  mutate(
    BH = grepl("*Mental|Behavior|Schizophreni*|Depressi*", Measure.Title),
    SUD = grepl("*Tobacco|Alcohol|Substance|opioid|smoking*", Measure.Title),
    comorbid = grepl("*Cardiovascular|Diabetes|Obesity|Wellness|BMI|Comorbidity|Hypertension|Blood Pressure|Pain|BCN*", Measure.Title),
    MIPS = grepl("*MIPS*", Program.with.Status),
    MUS2 = grepl("*Meaningful Use*", Program.with.Status),
    ip_psy = grepl("*Inpatient Psychiatric Facility Quality Reporting*", Program.with.Status),
    HEDIS = grepl("^National Committee National Committee for Quality Assurance*", Steward),
    readmit = grepl("*Hospital Readmission Reduction Program*", Program.with.Status)
  ) %>%
  filter(BH == T | SUD == T | comorbid == T | HEDIS == T)
         
        
## Other CMS measure lists
## "https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/QualityMeasures/Downloads/CMS-Quality-Measures-Inventory.zip"

cms_inv <- read_excel("measure_portfolio/data/CMS_Quality_Measures_Inventory.xlsx", 
                      sheet = 2)

## "https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/QualityMeasures/Downloads/Measures-Under-Development.zip"

cms_mud <- read_excel("measure_portfolio/data/CMS_Measures_Under_Development.xlsx", 
                      sheet = 1)