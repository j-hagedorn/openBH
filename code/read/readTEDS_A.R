
load("~/GitHub/teds/TEDS/data/TEDS_A/2010/33261-0001-Data.rda")
TEDS_A_2010 <- da33261.0001

names(TEDS_A_2010)
str(TEDS_A_2010)

levels(TEDS_A_2012$PMSA)



library(dplyr)
TEDS_A_2012_MI <-
  TEDS_A_2012 %>%
  filter(STFIPS == "(26) MICHIGAN")

TEDS_A_2012_LRP <-
  TEDS_A_2012 %>%
  filter(PMSA == "(3000) GRAND RAPIDS-MUSKEGON-HOLLAND, MI MSA")

GEO_MI <-
  TEDS_A_2012 %>%
  filter(STFIPS == "(26) MICHIGAN") %>%
  group_by(STFIPS,PMSA,CBSA) %>%
  summarize(num = n())

hist(TEDS_A_2012_LRP$DAYWAIT, breaks = 100)

geo_ref <-
  TEDS_A_2012_MI %>%
  group_by(CBSA, PMSA) %>%
  summarize(
    admits = n()
    ) 
  



# Some questions (work alot with the data on the MI side, digging into teds)
# Is SAMHSA defining changes similarly across states?  Is this a pilot?
# What groups are leading the charge on this?  Room for input?
# Have data specs been developed?  Are they available for review?
# Timeframe for rollout? 
# Adding new variables?
  # If yes, what? 
# Removing any SU variables?
  # Which?
# Expanding choices for certain variables?
  # e.g. DSMCRIT, to cover MI diagnostic groups?
# Changes to data elements that look at similar issues?
  # e.g. LIVARAG, which is similar to (but different than) field found in QI file.
  # If no change, discussions to standardize...?
