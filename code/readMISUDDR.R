library(plyr)
library(dplyr)
library(magrittr)
library(tidyr)
library(car)

## CLEAN & MERGE DATA

opioid <- read.csv("data/misuddr/Opioid deaths 99-14.csv",
                   nrows = 1344)
heroin <- read.csv("data/misuddr/Heroin deaths 99-14.csv",
                   nrows = 1344)
alldrug <- read.csv("data/misuddr/Total deaths 99-14.csv",
                    nrows = 1344)

opioid %<>%
  select(1:3) %>%
  mutate(cty_yr = paste0(County.Name,"_",Year))

heroin %<>%
  select(1:3) %>%
  mutate(cty_yr = paste0(County.Name,"_",Year)) %>%
  select(-County.Name, -Year)

alldrug %<>%
  select(1:3) %>%
  mutate(cty_yr = paste0(County.Name,"_",Year)) %>%
  select(-County.Name, -Year)

drug_death <-
  opioid %>%
  left_join(heroin, by = "cty_yr") %>%
  left_join(alldrug, by = "cty_yr") %>%
  select(county = County.Name,
         year = Year,
         opioid = Opiod.Deaths,
         heroin = Heroin.Deaths,
         alldrug = Total.Poisoning) %>%
  gather(cause, deaths, opioid:alldrug) %>%
  mutate(year = as.factor(year),
         county = ifelse(county %in% c("Detroit","Wayne \nexecluding \nDetroit"),
                         yes = "Wayne", no = as.character(county)),
         county = recode(county, 
                         "'Saint Clair'='St. Clair'; 
                         'Saint Joseph'='St. Joseph'")) %>%
  ungroup() %>% droplevels() %>%
  select(county,year,cause,deaths) %>%
  group_by(county,year,cause) %>%
  summarise(deaths = sum(deaths)) %>%
  mutate(key = paste0(county,"_",year))

## Remove unnecessary df

rm(opioid); rm(heroin); rm(alldrug)

## MAP COUNTIES

library(acs)
library(dplyr)
library(magrittr)

# Install API key
api.key.install(census_key, file = "key.rda") # hide key in local environment

# Define Michigan geography
lookup_MI <- geo.lookup(state = "MI", county = "*")
MIcounties <- as.vector(na.omit(lookup_MI$county))    #Get vector of counties from MI
MIbyCounty <- geo.make(state="MI", county=MIcounties) #Define region for acs.fetch query

#####

# Get 5-year estimate data for population
#####

# Use 2012 ACS estimates for 2013 404 population rates, since 2013 ACS data not published yet.

MI_2014 <- acs.fetch(endyear = 2014, 
                     span = 5, # x-year estimate
                     geography=MIbyCounty, 
                     #table.name,
                     #table.number, 
                     variable = c('B01001_001','B09001_001'), 
                     #keyword, 
                     #key, 
                     col.names = "auto")

MI_2013 <- acs.fetch(endyear = 2013, span = 5, geography=MIbyCounty,  
                     variable = c('B01001_001','B09001_001'), col.names = "auto")
MI_2012 <- acs.fetch(endyear = 2012, span = 5, geography=MIbyCounty,  
                     variable = c('B01001_001','B09001_001'), col.names = "auto")
MI_2011 <- acs.fetch(endyear = 2011, span = 5, geography=MIbyCounty,  
                     variable = c('B01001_001','B09001_001'), col.names = "auto")
MI_2010 <- acs.fetch(endyear = 2010, span = 5, geography=MIbyCounty,  
                     variable = c('B01001_001','B09001_001'), col.names = "auto")
MI_2009 <- acs.fetch(endyear = 2009, span = 5, geography=MIbyCounty,  
                     variable = c('B01001_001','B09001_001'), col.names = "auto")


# For endyears prior to 2009, no acs package CensusAPI data
#####

# Make a dataframe
#####

# ...for 2014
MI_df_14 <- data.frame(estimate(MI_2014))
colnames(MI_df_14)=c("TotalPop","Under18")
MI_df_14$Year <- 2014  #add year variable
MI_df_14$County <- rownames(MI_df_14) #create new var using rownames
rownames(MI_df_14) <- NULL #nullify existing rownames

# ...for 2013
MI_df_13 <- data.frame(estimate(MI_2013))
colnames(MI_df_13)=c("TotalPop","Under18")
MI_df_13$Year <- 2013  #add year variable
MI_df_13$County <- rownames(MI_df_13) #create new var using rownames
rownames(MI_df_13) <- NULL #nullify existing rownames

# ...for 2012
MI_df_12 <- data.frame(estimate(MI_2012))
colnames(MI_df_12)=c("TotalPop","Under18")
MI_df_12$Year <- endyear(MI_2012)  #add year variable
MI_df_12$County <- rownames(MI_df_12) #create new var using rownames
rownames(MI_df_12) <- NULL #nullify existing rownames

# ...for 2011
MI_df_11 <- data.frame(estimate(MI_2011))
colnames(MI_df_11)=c("TotalPop","Under18")
MI_df_11$Year <- endyear(MI_2011)  #add year variable
MI_df_11$County <- rownames(MI_df_11) #create new var using rownames
rownames(MI_df_11) <- NULL #nullify existing rownames

# ...for 2010
MI_df_10 <- data.frame(estimate(MI_2010))
colnames(MI_df_10)=c("TotalPop","Under18")
MI_df_10$Year <- endyear(MI_2010)  #add year variable
MI_df_10$County <- rownames(MI_df_10) #create new var using rownames
rownames(MI_df_10) <- NULL #nullify existing rownames

# ...for 2009
MI_df_09 <- data.frame(estimate(MI_2009))
colnames(MI_df_09)=c("TotalPop","Under18")
MI_df_09$Year <- endyear(MI_2009)  #add year variable
MI_df_09$County <- rownames(MI_df_09) #create new var using rownames
rownames(MI_df_09) <- NULL #nullify existing rownames

MI_df <- rbind(MI_df_14,MI_df_13,MI_df_12,MI_df_11,MI_df_10,MI_df_09) #bind the 4 years together
MI_df <- MI_df[,c(3,4,1,2)] #reorder columns
MI_df$Over18 <- MI_df$TotalPop-MI_df$Under18 # compute pop over 18
MI_df$County <- as.factor(MI_df$County)

# Clean up our messy environs
rm(MI_df_14);rm(MI_df_13);rm(MI_df_12);rm(MI_df_11);rm(MI_df_10);rm(MI_df_09)
rm(MI_2014);rm(MI_2013);rm(MI_2012);rm(MI_2011);rm(MI_2010);rm(MI_2009)
rm(lookup_MI);rm(MIbyCounty);rm(MIcounties)

MI_df <- MI_df[,c(1,7,8,6,2:5)] #reorder columns

pop_yr <-
MI_df %>%
  mutate(county = gsub(" County, Michigan","",County),
         key = paste0(county,"_",Year)) %>%
  select(key,TotalPop)

# Aggregate population numbers by CMHSP regions

drug_death %<>%
  left_join(pop_yr, by = "key") %>%
  mutate(CMHSP = recode(county, "'Alcona'='Northeast Michigan';
                                'Alger'='Pathways';
                        'Allegan'='Allegan';       
                        'Alpena'='Northeast Michigan';       
                        'Antrim'='North Country';       
                        'Arenac'='Bay-Arenac';        
                        'Baraga'='Copper Country';         
                        'Barry'='Barry';     
                        'Bay'='Bay-Arenac';         
                        'Benzie'='Manistee-Benzie';        
                        'Berrien'='Berrien';      
                        'Branch'='Pines'; 
                        'Calhoun'='Summit Pointe';    
                        'Cass'='Woodlands';
                        'Charlevoix'='North Country';   
                        'Cheboygan'='North Country';   
                        'Chippewa'= 'Hiawatha';       
                        'Clare'='Central Michigan';     
                        'Clinton'='CEI';       
                        'Crawford'='Northern Lakes';   
                        'Delta'='Pathways';      
                        'Dickinson'='Northpointe';    
                        'Eaton'='CEI';      
                        'Emmet'='North Country';
                        'Genesee'='Genesee';       
                        'Gladwin'='Central Michigan';    
                        'Gogebic'='Gogebic';    
                        'Grand Traverse'='Northern Lakes';
                        'Gratiot'='Gratiot';
                        'Hillsdale'='Lifeways';    
                        'Houghton'='Copper Country';      
                        'Huron'='Huron';
                        'Ingham'='CEI';        
                        'Ionia'='Ionia';    
                        'Iosco'='AuSable Valley';        
                        'Iron'='Northpointe';  
                        'Isabella'='Central Michigan';  
                        'Jackson'='Lifeways';    
                        'Kalamazoo'='Kalamazoo';  
                        'Kalkaska'='North Country'; 
                        'Kent'='Network180';
                        'Keweenaw'='Copper Country';       
                        'Lake'='West Michigan';
                        'Lapeer'='Lapeer';     
                        'Leelanau'='Northern Lakes';  
                        'Lenawee'='Lenawee';    
                        'Livingston'='Livingston';   
                        'Luce'='Pathways';
                        'Mackinac'='Hiawatha';       
                        'Macomb'='Macomb';
                        'Manistee'='Manistee-Benzie';     
                        'Marquette'='Pathways';   
                        'Mason'='West Michigan';
                        'Mecosta'='Central Michigan';     
                        'Menominee'='Northpointe';     
                        'Midland'='Central Michigan';
                        'Missaukee'='Northern Lakes';     
                        'Monroe'='Monroe';
                        'Montcalm'='Montcalm';
                        'Montmorency'='Northeast Michigan';
                        'Muskegon'='Muskegon';    
                        'Newaygo'='Newaygo'; 
                        'Oakland'='Oakland';    
                        'Oceana'='West Michigan';   
                        'Ogemaw'='AuSable Valley';      
                        'Ontonagon'='Copper Country';
                        'Osceola'='Central Michigan';       
                        'Oscoda'='AuSable Valley';      
                        'Otsego'='North Country';         
                        'Ottawa'='Ottawa';       
                        'Presque Isle'='Northeast Michigan';   
                        'Roscommon'='Northern Lakes';  
                        'Saginaw'='Saginaw';     
                        'Sanilac'='Sanilac';      
                        'Schoolcraft'='Hiawatha';  
                        'Shiawassee'='Shiawassee';   
                        'St. Clair'='St. Clair'; 
                        'St. Joseph'='St. Joseph';  
                        'Tuscola'='Tuscola';
                        'Van Buren'='Van Buren';   
                        'Washtenaw'='Washtenaw';      
                        'Wayne'='Detroit-Wayne';     
                        'Wexford'='Northern Lakes'"))

drug_death$PIHP <- recode(drug_death$CMHSP, "'Copper Country'='1';
                       'Network180'='3'; 
                       'Gogebic'='1';
                       'Hiawatha'='1';
                       'Northpointe'='1'; 
                       'Pathways'='1';
                       'AuSable Valley'='2';
                       'Manistee-Benzie'='2';
                       'North Country'='2';
                       'Northeast Michigan'='2';
                       'Northern Lakes'='2';
                       'Allegan'='3';
                       'Muskegon'='3';
                       'Network180'='3';
                       'Ottawa'='3';
                       'West Michigan'='3';
                       'Barry'='4';
                       'Berrien'='4';
                       'Kalamazoo'='4';
                       'Pines'='4';
                       'St. Joseph'='4';
                       'Summit Pointe'='4';
                       'Van Buren'='4';
                       'Woodlands'='4';
                       'Bay-Arenac'='5';
                       'CEI'='5';
                       'Central Michigan'='5';
                       'Gratiot'='5';
                       'Huron'='5';
                       'Ionia'='5';
                       'Lifeways'='5';
                       'Montcalm'='5';
                       'Newaygo'='5';
                       'Saginaw'='5';
                       'Shiawassee'='5';
                       'Tuscola'='5';
                       'Lenawee'='6';
                       'Livingston'='6';
                       'Monroe'='6';
                       'Washtenaw'='6';
                       'Detroit-Wayne'='7';
                       'Oakland'='8';
                       'Macomb'='9';
                       'Genesee'='10';
                       'Lapeer'='10';
                       'Sanilac'='10';
                       'St. Clair'='10'")

drug_death$PIHPname <- recode(drug_death$PIHP, "'1'='Northcare';
                           '2'='NMRE';
                           '3'='LRE';
                           '4'='SWMBH';
                           '5'='MSHN'; 
                           '6'='CMHPSM';
                           '7'='DWMHA';
                           '8'='OCCMHA';
                           '9'='MCMHS';
                           '10'='Region10'")

# Remove
rm(pop_yr); rm(MI_df); rm(byCMHSP)

drug_death %<>%
  ungroup() %>% droplevels() %>%
  group_by(year,cause) %>%
  mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1),
         pct_deaths = round(deaths/sum(deaths)*100, digits = 1)) %>%
  select(PIHPname,CMHSP,county,year,cause,
         deaths,pct_deaths,deaths_per_100k,TotalPop) %>%
  ungroup() %>% droplevels()

write.csv(drug_death, "misuddr-app/data/drug_death.csv")
