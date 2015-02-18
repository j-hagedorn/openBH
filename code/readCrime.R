library(dplyr)
library(tidyr)

# Load UCRP_2012
  # Uniform Crime Reporting Program Data: County-Level Detailed Arrest and Offense Data, 2012 (ICPSR 35019)
  # Source: "https://www.icpsr.umich.edu/icpsrweb/NACJD/studies/35019?groupResults=false&amp;archive=NACJD&amp;q=uniform+crime+county&amp;searchSource=revise&amp;paging.startRow=1"
  load("data/crime/ICPSR_35019/DS0001/35019-0001-Data.rda")
  UCRP_2012 <- da35019.0001
  rm(da35019.0001)
  UCRP_2012$dataset <- "UCRP"
  UCRP_2012$dataset_yr <- 2012
  # Convert vars to factors
  UCRP_2012$IDNO <- as.factor(UCRP_2012$IDNO)
  UCRP_2012$FIPS_ST <- as.factor(UCRP_2012$FIPS_ST)
  UCRP_2012$FIPS_CTY <- as.factor(UCRP_2012$FIPS_CTY)
  UCRP_2012$IDNO <- as.factor(UCRP_2012$IDNO)


# Load UCRP_2011
  # Uniform Crime Reporting Program Data: County-Level Detailed Arrest and Offense Data, 2011 (ICPSR 34582)
  # Source: "https://www.icpsr.umich.edu/icpsrweb/NACJD/studies/34582?groupResults=false&amp;archive=NACJD&amp;q=uniform+crime+county&amp;searchSource=revise&amp;paging.startRow=1"
  load("data/crime/ICPSR_33523/DS0001/33523-0001-Data.rda")
  UCRP_2011 <- da33523.0001
  rm(da33523.0001) 
  UCRP_2011$dataset <- "UCRP"
  UCRP_2011$dataset_yr <- 2011


hist(UCRP_2012$ROBBERY, breaks = 50)

plot(UCRP_2012$ROBBERY, UCRP_2012$)
cor(UCRP_2012$ROBBERY, UCRP_2012$AGASSLT)
my_lm <- lm(UCRP_2012$ROBBERY~UCRP_2012$AGASSLT)
summary(my_lm)


fips <- read.csv("http://www2.census.gov/geo/docs/reference/codes/files/national_county.txt")

state <-
  da33523.0001 %>%
  select(FIPS_ST,MURDER,RAPE) %>%
  group_by(FIPS_ST) %>%
  summarise(murders = sum(MURDER),
            murderdev = sd(MURDER),
            rapes = sum(RAPE)) %>%
  inner_join(fips, by = v2)




