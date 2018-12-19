library(tidyverse); library(magrittr); library(readxl)

## CLEAN & MERGE DATA

df <- 
  read_excel("data/misuddr/Overdose deaths by type of drug, 1999-2017.xlsx", col_names = F) %>%
  select(-X__1) %>% t() %>% as_tibble() %>% select(V3:V88)

df[1,1] <- "year"; df[1,2] <- "cause"
colnames(df) = df[1, ] # the first row will be the header
df <- df[-1, ]   

drug_death <-
  df %>%
  fill(year, .direction = "down") %>%
  gather(key = "county", value = "deaths", -year, -cause) %>%
  select(county,year,cause,deaths) %>%
  mutate(
    key = paste0(county,"_",year),
    deaths = as.numeric(deaths)
  )

## Remove unnecessary df
rm(df)

## MAP COUNTIES

library(tidycensus)

# Note: API key installed using tidycensus::census_api_key(..., install = T)

acs_vars <- load_variables(2016,"acs5",cache = T)

#####

# Get 5-year estimate data for population
#####

# Use previous year ACS estimates for most recent years 
# if ACS data has not been published yet.

df <- tibble()

for (i in 2010:2016) {
  x <- 
    get_acs(
      geography = "county",
      variables = c('B01001_001','B09001_001'),
      year = i,
      output = "wide",
      state = "MI",
      survey = "acs5"
    ) %>%
    mutate(year = i)
  
  df %<>% bind_rows(x)
}

pop_yr <-
  df %>% 
  rename(
    county = NAME,
    TotalPop = B01001_001E,
    TotalPop_moe = B01001_001M,
    Under18 = B09001_001E,
    Under18_moe = B09001_001M
  ) %>%
  mutate(
    year = fct_expand(as.character(year),as.character(1999:2017)),
    year = fct_relevel(year,as.character(1999:2017))
  ) %>%
  complete(county,year) %>%
  group_by(county) %>%
  # Apply 2016 population values 'down' to 2017
  fill(TotalPop, .direction = "down") %>%
  # Apply 2010 population values 'up' to 1999
  fill(TotalPop, .direction = "up") %>%
  ungroup() %>%
  mutate(
    county = str_replace(county, " County, Michigan",""),
    key = paste0(county,"_",year)
  ) %>%
  select(key,TotalPop)

# Aggregate population numbers by CMHSP regions

drug_death %<>%
  inner_join(pop_yr, by = "key") %>%
  mutate(
    CMHSP = dplyr::recode(
      county, 
      `Alcona` = 'Northeast Michigan',`Alger`='Pathways',`Allegan`='Allegan',
      `Alpena`='Northeast Michigan',`Antrim`='North Country',
      `Arenac`='Bay-Arenac',`Baraga`='Copper Country',`Barry`='Barry',
      `Bay`='Bay-Arenac',`Benzie`='Manistee-Benzie',`Berrien`='Berrien',
      `Branch`='Pines',`Calhoun`='Summit Pointe',`Cass`='Woodlands',
      `Charlevoix`='North Country',`Cheboygan`='North Country',
      `Chippewa`= 'Hiawatha',`Clare`='Central Michigan',`Clinton`='CEI',
      `Crawford`='Northern Lakes',`Delta`='Pathways',`Dickinson`='Northpointe',
      `Eaton`='CEI',`Emmet`='North Country',`Genesee`='Genesee',
      `Gladwin`='Central Michigan',`Gogebic`='Gogebic',
      `Grand Traverse`='Northern Lakes',`Gratiot`='Gratiot',
      `Hillsdale`='Lifeways',`Houghton`='Copper Country',`Huron`='Huron',
      `Ingham`='CEI',`Ionia`='Ionia',`Iosco`='AuSable Valley',
      `Iron`='Northpointe',`Isabella`='Central Michigan',`Jackson`='Lifeways',
      `Kalamazoo`='Kalamazoo',`Kalkaska`='North Country',`Kent`='Network180',
      `Keweenaw`='Copper Country',`Lake`='West Michigan',`Lapeer`='Lapeer',
      `Leelanau`='Northern Lakes',`Lenawee`='Lenawee',`Livingston`='Livingston',
      `Luce`='Pathways',`Mackinac`='Hiawatha',`Macomb`='Macomb',
      `Manistee`='Manistee-Benzie',`Marquette`='Pathways',
      `Mason`='West Michigan',`Mecosta`='Central Michigan',
      `Menominee`='Northpointe',`Midland`='Central Michigan',
      `Missaukee`='Northern Lakes',`Monroe`='Monroe',`Montcalm`='Montcalm',
      `Montmorency`='Northeast Michigan',`Muskegon`='Muskegon',`Newaygo`='Newaygo', 
      `Oakland`='Oakland',`Oceana`='West Michigan',`Ogemaw`='AuSable Valley',
      `Ontonagon`='Copper Country',`Osceola`='Central Michigan',
      `Oscoda`='AuSable Valley',`Otsego`='North Country',`Ottawa`='Ottawa',
      `Presque Isle`='Northeast Michigan',`Roscommon`='Northern Lakes', 
      `Saginaw`='Saginaw',`Sanilac`='Sanilac',`Schoolcraft`='Hiawatha', 
      `Shiawassee`='Shiawassee',`St. Clair`='St. Clair',`St. Joseph`='St. Joseph',  
      `Tuscola`='Tuscola',`Van Buren`='Van Buren',`Washtenaw`='Washtenaw',
      `Wayne`='Detroit-Wayne',`Wexford`='Northern Lakes'
    ),
    PIHP = dplyr::recode(
      CMHSP, 
      `Copper Country`=1,`Network180`=3,`Gogebic`=1,`Hiawatha`=1,`Northpointe`=1, 
      `Pathways`=1,`AuSable Valley`=2,`Manistee-Benzie`=2,`North Country`=2,
      `Northeast Michigan`=2,`Northern Lakes`=2,`Allegan`=3,`Muskegon`=3,
      `Network180`=3,`Ottawa`=3,`West Michigan`=3,`Barry`=4,`Berrien`=4,
      `Kalamazoo`=4,`Pines`=4,`St. Joseph`=4,`Summit Pointe`=4,`Van Buren`=4,
      `Woodlands`=4,`Bay-Arenac`=5,`CEI`=5,`Central Michigan`=5,`Gratiot`=5,
      `Huron`=5,`Ionia`=5,`Lifeways`=5,`Montcalm`=5,`Newaygo`=5,`Saginaw`=5,
      `Shiawassee`=5,`Tuscola`=5,`Lenawee`=6,`Livingston`=6,`Monroe`=6,
      `Washtenaw`=6,`Detroit-Wayne`=7,`Oakland`=8,`Macomb`=9,`Genesee`=10,
      `Lapeer`=10,`Sanilac`=10,`St. Clair`=10
    ),
    PIHPname = dplyr::recode(
      as.character(PIHP), 
      `1`='Northcare',`2`='NMRE',`3`='LRE',`4`='SWMBH',`5`='MSHN', `6`='CMHPSM',
      `7`='DWMHA',`8`='OCCMHA',`9`='MCMHS',`10`='Region10'
    )
  )

# Remove
rm(pop_yr); rm(x); rm(df); rm(i)

drug_death %<>%
  ungroup() %>% droplevels() %>%
  group_by(year,cause) %>%
  mutate(deaths_per_100k = round(deaths/TotalPop*100000, digits = 1),
         pct_deaths = round(deaths/sum(deaths,na.rm=T)*100, digits = 1)) %>%
  select(PIHPname,CMHSP,county,year,cause,
         deaths,pct_deaths,deaths_per_100k,TotalPop) %>%
  ungroup() %>% droplevels()

write_csv(drug_death, "misuddr-app/data/drug_death.csv")
