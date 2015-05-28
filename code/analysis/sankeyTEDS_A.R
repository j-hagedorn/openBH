# Sankey diagram

# Load
load("~/GitHub/TEDS/data/TEDS_A/2012/35037-0001-Data.rda")
TEDS_A_2012 <- da35037.0001

# Change variable types
TEDS_A_2012$YEAR <- as.factor(TEDS_A_2012$YEAR)
TEDS_A_2012$DAYWAIT <- as.numeric(TEDS_A_2012$DAYWAIT)

# Subset for Michigan
MI_A_2012 <- subset(TEDS_A_2012, STFIPS == '(26) MICHIGAN')

# Get rid of NA values
naOmit_A_2012 <- subset(MI_A_2012, !is.na(LIVARAG)&!is.na(SERVSETA))

# Format data to be
library(dplyr)
dat_A_12 <- summarise(group_by(naOmit_A_2012,LIVARAG,SERVSETA), Weight=n())

# Create Sankey diagram
library(googleVis)

skA12 <- gvisSankey(dat_A_12, from="LIVARAG", to="SERVSETA", weight="Weight",
                  options=list(width=800, height=600,
                               sankey="{link: {color: { fill: '#d799ae' } },
                               node: { color: { fill: '#a61d4c' },
                               label: { color: '#871b47' } }}"))
plot(skA12)

cat(skA12$html$chart, file="TEDS_A_sankey.html")
