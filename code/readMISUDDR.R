library(dplyr)
library(magrittr)
library(tidyr)

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
  gather(cause, deaths, opioid:alldrug)

# Combine rest of Wayne and Detroit

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

# Map counties to 404 CMHs and PIHP regions
#####
library(car)

MI_df$CMHSP<-recode(MI_df$County, "'Alcona County, Michigan'='Northeast Michigan';
                    'Alger County, Michigan'='Pathways';
                    'Allegan County, Michigan'='Allegan';       
                    'Alpena County, Michigan'='Northeast Michigan';       
                    'Antrim County, Michigan'='North Country';       
                    'Arenac County, Michigan'='Bay-Arenac';        
                    'Baraga County, Michigan'='Copper Country';         
                    'Barry County, Michigan'='Barry';     
                    'Bay County, Michigan'='Bay-Arenac';         
                    'Benzie County, Michigan'='Manistee-Benzie';        
                    'Berrien County, Michigan'='Berrien';      
                    'Branch County, Michigan'='Pines'; 
                    'Calhoun County, Michigan'='Summit Pointe';    
                    'Cass County, Michigan'='Woodlands';
                    'Charlevoix County, Michigan'='North Country';   
                    'Cheboygan County, Michigan'='North Country';   
                    'Chippewa County, Michigan'= 'Hiawatha';       
                    'Clare County, Michigan'='CMH for Central Michigan';     
                    'Clinton County, Michigan'='Clinton Eaton Ingham';       
                    'Crawford County, Michigan'='Northern Lakes';   
                    'Delta County, Michigan'='Pathways';      
                    'Dickinson County, Michigan'='Northpointe';    
                    'Eaton County, Michigan'='Clinton Eaton Ingham';      
                    'Emmet County, Michigan'='North Country';
                    'Genesee County, Michigan'='Genesee';       
                    'Gladwin County, Michigan'='CMH for Central Michigan';    
                    'Gogebic County, Michigan'='Gogebic';    
                    'Grand Traverse County, Michigan'='Northern Lakes';
                    'Gratiot County, Michigan'='Gratiot';
                    'Hillsdale County, Michigan'='Lifeways';    
                    'Houghton County, Michigan'='Copper Country';      
                    'Huron County, Michigan'='Huron';
                    'Ingham County, Michigan'='Clinton Eaton Ingham';        
                    'Ionia County, Michigan'='Ionia';    
                    'Iosco County, Michigan'='AuSable Valley';        
                    'Iron County, Michigan'='Northpointe';  
                    'Isabella County, Michigan'='CMH for Central Michigan';  
                    'Jackson County, Michigan'='Lifeways';    
                    'Kalamazoo County, Michigan'='Kalamazoo';  
                    'Kalkaska County, Michigan'='North Country'; 
                    'Kent County, Michigan'='Network180';
                    'Keweenaw County, Michigan'='Copper Country';       
                    'Lake County, Michigan'='West Michigan';
                    'Lapeer County, Michigan'='Lapeer';     
                    'Leelanau County, Michigan'='Northern Lakes';  
                    'Lenawee County, Michigan'='Lenawee';    
                    'Livingston County, Michigan'='Livingston';   
                    'Luce County, Michigan'='Pathways';
                    'Mackinac County, Michigan'='Hiawatha';       
                    'Macomb County, Michigan'='Macomb';
                    'Manistee County, Michigan'='Manistee-Benzie';     
                    'Marquette County, Michigan'='Pathways';   
                    'Mason County, Michigan'='West Michigan';
                    'Mecosta County, Michigan'='CMH for Central Michigan';     
                    'Menominee County, Michigan'='Northpointe';     
                    'Midland County, Michigan'='CMH for Central Michigan';
                    'Missaukee County, Michigan'='Northern Lakes';     
                    'Monroe County, Michigan'='Monroe';
                    'Montcalm County, Michigan'='Montcalm';
                    'Montmorency County, Michigan'='Northeast Michigan';
                    'Muskegon County, Michigan'='Muskegon';    
                    'Newaygo County, Michigan'='Newaygo'; 
                    'Oakland County, Michigan'='Oakland';    
                    'Oceana County, Michigan'='West Michigan';   
                    'Ogemaw County, Michigan'='AuSable Valley';      
                    'Ontonagon County, Michigan'='Copper Country';
                    'Osceola County, Michigan'='CMH for Central Michigan';       
                    'Oscoda County, Michigan'='AuSable Valley';      
                    'Otsego County, Michigan'='North Country';         
                    'Ottawa County, Michigan'='Ottawa';       
                    'Presque Isle County, Michigan'='Northeast Michigan';   
                    'Roscommon County, Michigan'='Northern Lakes';  
                    'Saginaw County, Michigan'='Saginaw';     
                    'Sanilac County, Michigan'='Sanilac';      
                    'Schoolcraft County, Michigan'='Hiawatha';  
                    'Shiawassee County, Michigan'='Shiawassee';   
                    'St. Clair County, Michigan'='St. Clair'; 
                    'St. Joseph County, Michigan'='St. Joseph';  
                    'Tuscola County, Michigan'='Tuscola';
                    'Van Buren County, Michigan'='Van Buren';   
                    'Washtenaw County, Michigan'='Washtenaw';      
                    'Wayne County, Michigan'='Detroit-Wayne';     
                    'Wexford County, Michigan'='Northern Lakes'") 

MI_df$PIHP<-recode(MI_df$CMHSP, "'Copper Country'='1';
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
                   'Clinton Eaton Ingham'='5';
                   'CMH for Central Michigan'='5';
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

MI_df$PIHPname<-recode(MI_df$PIHP, "'1'='Northcare';
                       '2'='NMRE';
                       '3'='LRP';
                       '4'='SWMBH';
                       '5'='MSHN'; 
                       '6'='CMHPSM';
                       '7'='DWMHA';
                       '8'='OCCMHA';
                       '9'='MCMHS';
                       '10'='Region10'")

MI_df <- MI_df[,c(1,7,8,6,2:5)] #reorder columns

tst <- 
MI_df %>%
  mutate(county_short = gsub(" County, Michigan","",County),
         )

# Aggregate population numbers by CMHSP regions
byCMHSP <- summarize(group_by(MI_df, Year, CMHSP), 
                     TotalPop = sum(TotalPop), 
                     Under18 = sum(Under18),
                     Over18 = sum(Over18))


## MAKE PARETO CHART

library(plotly)

drug_death %>%
  filter(year == 2014) %>%
  plot_ly(x = county, y = deaths, type = "bar", color = cause, colors = "Set3") %>%
  layout(xaxis = list(title = "Type of Need", showticklabels = F),
         yaxis = list(title = "# times included in planning"),
         legend = list(xanchor = "right", yanchor = "top", x = 1, y = 1, 
                       font = list(size = 10)),
         barmode = "stack")
