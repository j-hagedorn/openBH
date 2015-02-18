library(dplyr)
library(tidyr)

http://www.icpsr.umich.edu/cgi-bin/bob/terms2?study=33523&ds=1&bundle=rdata&path=NACJD

da33523.0001$IDNO <- as.factor(da33523.0001$IDNO)
da33523.0001$FIPS_ST <- as.factor(da33523.0001$FIPS_ST)
da33523.0001$FIPS_CTY <- as.factor(da33523.0001$FIPS_CTY)
da33523.0001$IDNO <- as.factor(da33523.0001$IDNO)

hist(da33523.0001$ROBBERY, breaks = 50)

plot(da33523.0001$ROBBERY, da33523.0001$)
cor(da33523.0001$ROBBERY, da33523.0001$AGASSLT)
my_lm <- lm(da33523.0001$ROBBERY~da33523.0001$AGASSLT)
summary(my_lm)


counties <- read.table("http://www2.census.gov/geo/docs/reference/codes/files/national_county.txt",
                       sep = ",")

state <-
  da33523.0001 %>%
  select(FIPS_ST,MURDER,RAPE) %>%
  group_by(FIPS_ST) %>%
  summarise(murders = sum(MURDER),
            murderdev = sd(MURDER),
            rapes = sum(RAPE)) %>%
  inner_join(counties, by = v2)




