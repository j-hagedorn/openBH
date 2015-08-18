# Install package, define geography
  # install.packages("acs")
  library("acs")

# Install API key
  api.key.install(census_key, file = "key.rda") # hide key in local environment

# Define Michigan geography
  lookup_MI <- geo.lookup(state = "MI", county = "*")
  MIcounties <- as.vector(na.omit(lookup_MI$county))    #Get vector of counties from MI
  MIbyCounty <- geo.make(state="MI", county=MIcounties) #Define region for acs.fetch query

# Get 5-year estimate data for population
#####

tst <- acs.fetch(endyear = 2012, 
                     span = 5, # x-year estimate
                     geography=MIbyCounty, 
                     #table.name,
                     #table.number, 
                     variable = c('B01001_001',
                                  'B09001_001',
                                  'B07011_001',
                                  'B17001_001',
                                  'B18101_001',
                                  'B18104_001',
                                  'B18105_001',
                                  'B18106_001',
                                  'B18107_001',
                                  'B19083_001',
                                  'B21001_001',
                                  'B22001_001',
                                  'B23001_001',
                                  'B23004_001',
                                  'B23006_001',
                                  'C27006_001',
                                  'C27007_001',
                                  'C27016_002'
                                  ), 
                     #keyword, 
                     #key, 
                     col.names = "auto")


# Make a dataframe
#####

tst <- data.frame(estimate(tst))
colnames(MI_df_13)= c("TotalPop","Under18")
MI_df_13$Year <- 2013  #add year variable
MI_df_13$County <- rownames(MI_df_13) #create new var using rownames
rownames(MI_df_13) <- NULL #nullify existing rownames
  

# To search variables
  # Use: http://www2.census.gov/acs2013_5yr/summaryfile/UserTools/ACS_2013_SF_5YR_Appendices.xls
acs.lookup(endyear = 2013, 
           #keyword = c("disab"),
           #table.name, 
           table.number = "C27016", 
           case.sensitive = F)