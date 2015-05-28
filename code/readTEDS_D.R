
load("~/GitHub/teds/TEDS/data/TEDS_D/2010/34898-0001-Data.rda")
TEDS_D_2010 <- da34898.0001

# Check out structure
names(TEDS_D_2010)
str(TEDS_D_2010)

TEDS_D_2010$DISYR <- as.factor(TEDS_D_2010$DISYR)
TEDS_D_2010$DAYWAIT <- as.numeric(TEDS_D_2010$DAYWAIT)
TEDS_D_2010$LOS <- as.numeric(TEDS_D_2010$LOS)
