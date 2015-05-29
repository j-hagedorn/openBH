# Sankey diagram

# Load
load("~/GitHub/teds/TEDS/data/TEDS_D/2010/34898-0001-Data.rda")
TEDS_D_2010 <- da34898.0001

# Change variable types
TEDS_D_2010$DISYR <- as.factor(TEDS_D_2010$DISYR)
TEDS_D_2010$DAYWAIT <- as.numeric(TEDS_D_2010$DAYWAIT)
TEDS_D_2010$LOS <- as.numeric(TEDS_D_2010$LOS)

# Get rid of NA values
naOmit_D_2010 <- subset(TEDS_D_2010, !is.na(LIVARAG)&!is.na(SERVSETD))

# Format data to be
library(dplyr)
dat <- summarise(group_by(naOmit_D_2010,LIVARAG,SERVSETD), Weight=n())

# Create Sankey diagram
library(googleVis)

sk1 <- gvisSankey(dat, from="LIVARAG", to="SERVSETD", weight="Weight")
plot(sk1)

sk2 <- gvisSankey(dat, from="LIVARAG", to="SERVSETD", weight="Weight",
                      options=list(width=600, height=600,
                                    sankey="{link: {color: { fill: '#d799ae' } },
                                    node: { color: { fill: '#a61d4c' },
                                    label: { color: '#871b47' } }}"))
plot(sk2)

# sk1$html$chart
