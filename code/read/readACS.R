library(acs)
library(dplyr)

# first install your census key in the console (Key<-"xxxxxx")
# To obtain a key visit http://api.census.gov/data/key_signup.html

# Formatting the specific georgraphies for which data will be collected
US<-geo.make(state="*",county="*")

# y = endyear


acs<-function(y){

  # Basic layout for fecting the data of a prespecified location(step above)
  
  if(y %in% c(2013,2012)){
    
    df<-acs.fetch(endyear = y,geo=US,
                variable = c('B01003_001',  # total population
                             'B09001_001',  # population under 18
                             'B19013_001',  # median household income
                             'B18101_001',  # number of disabled persons 
                             'B18104_001',  # number of persons with cognitive difficulty 
                             'B18105_001',  # number of persons with ambulatory difficulty 
                             'B18106_001',  # number of persons with Self-care Difficulty  
                             'B18107_001',  # number of persons with an independent living difficulty
                             'B19083_001',  # Gini Index Of Income Inequality
                             'B21001_001',  # number of veterans
                             'B22001_001',  # Receipt of Food Stamps/SNAP
                             'B23004_003',  # Worked in the past 12 months: 65 to 74 years
                             'B23006_002',  # Less than high school graduate
                             'C27006_001',  # Medicare Coverage
                             'C27007_001',  # Medicaid/Means-tested Public Coverage
                             'C27016_002',  # Under 1.38 of poverty threshold
                             'B02001_002',  # White alone
                             'B02001_003',  # Black alone
                             'B02001_005',  # Asian alone
                             'B03002_012')) # Hispanic alone
             
  
  ######
  # Creating a dataframe
  df<-data.frame(estimate(df))
  df<-df[-c(3144:3221),]
  
  # Creating fips & year vector
  fips<-as.vector(fips.county)
  # filtering out Guam,Puerto Rico,virgen islands 
  fips<-fips[-c(3144:3235),]
  
  # Cleaning FIPS vector to match the pattern of the primary key
  
  fips[nchar(fips[,2])==1,2] <- paste("0", fips[nchar(fips[,2])==1,2], sep="")
  fips[nchar(fips[,3])==1,3] <- paste("00", fips[nchar(fips[,3])==1,3], sep="")
  fips[nchar(fips[,3])==2,3] <- paste("0", fips[nchar(fips[,3])==2,3], sep="")
  fips$FIPS<-paste(fips$State.ANSI,fips$County.ANSI,sep="")
  fips<-select(fips,FIPS)
  
  # pasting to df
  df$FIPS<-fips$FIPS
  # Making year column
  df$Year<-y

  # Making primary key
  df$Year_FIPS<-paste(df$Year,df$FIPS,sep="_")
  df<-df[,-c(21,22)]
  
  #renaming variables
  colnames(df)= c("tltp_acs","t<18_acs","mdin_acs","disb_acs","cgnt_acs",
                  "ambu_acs","scdf_acs", "indf_acs","gini_acs","vetr_acs","snap_acs",
                  "eemp_acs","lshs_acs","medc_acs","mdmt_acs","inpt_acs","white_acs",
                  "black_acs","asian_acs",'hisp_acs',"Year_FIPS")
  # rearranging 
  df<-df[,c(21,1:20)]

  
  return(df)
  
  } else if(y %in% c(2011,2010)){
    
    US<-geo.make(state="*",county="*")
    
    df<-acs.fetch(endyear = y,geo=US,
                  variable = c('B01003_001',  # total population
                               'B09001_001',  # population under 18
                               'B19013_001',  # median household income
                               'B19083_001',  # Gini Index Of Income Inequality
                               'B21001_001',  # number of veterans
                               'B22001_001',  # Receipt of Food Stamps/SNAP
                               'B23004_003',  # Worked in the past 12 months: 65 to 74 years
                               'B23006_002')) # Less than high school graduate
                 
 ######
    # Creating a dataframe
    df<-data.frame(estimate(df))
    df<-df[-c(3144:3221),]
    
    # Creating fips & year vector
    fips<-as.vector(fips.county)
    # filtering out Guam,Puerto Rico,virgen islands 
    fips<-fips[-c(3144:3235),]
 
  # Cleaning FIPS vector to match the pattern of the primary key
 
    fips[nchar(fips[,2])==1,2] <- paste("0", fips[nchar(fips[,2])==1,2], sep="")
    fips[nchar(fips[,3])==1,3] <- paste("00", fips[nchar(fips[,3])==1,3], sep="")
    fips[nchar(fips[,3])==2,3] <- paste("0", fips[nchar(fips[,3])==2,3], sep="")
    fips$FIPS<-paste(fips$State.ANSI,fips$County.ANSI,sep="")
    fips<-select(fips,FIPS)
 
    # pasting to df
    df$FIPS<-fips$FIPS
    # Making year column
    df$Year<-y
    # Making primary key
    df$Year_FIPS<-paste(df$Year,df$FIPS,sep="_")
    df<-df[,-c(9,10)]
    
    #renaming variables
    colnames(df)= c("tltp_acs","t<18_acs","mdin_acs","gini_acs","vetr_acs","snap_acs",
                    "eemp_acs","lshs_acs","Year_FIPS")
    # rearranging 
    df<-df[,c(9,1:8)]
   
 
    return(df)
  }

}

acs13<-acs(y = 2013)
acs12<-acs(y = 2012)
acs11<-acs(y = 2011)
acs10<-acs(y = 2010)

acs<-bind_rows(acs13,acs12,acs11,acs10)
            rm(acs13,acs12,acs11,acs10,US,key)
#_________________________________________________________________________________

# Code for looking up specific tables (using table.name=x or table.number=x)
# varibles of the tables will be displayed along with the table
# Or you can lookup specific variables within tables instantly (using keyword=x)

acs.lookup(endyear = 2011,keyword="Income in the past 12 months below poverty level",case.sensitive=F)

acs.lookup(endyear = 2012,table.number="B03002",case.sensitive=F)

# To search tables on an excel sheet visit:
# http://www2.census.gov/acs2013_5yr/summaryfile/ACS_2013_SF_5YR_Appendices.xls


