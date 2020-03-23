library(tidyverse)
Tract_data<-read.csv("../tract_outcomes_early.csv")
#Trcat data has more than 7000 columns, So for analysis purpose we have taken 100 columns.
Tract_data<-Tract_data[,c(1:100)]
#Filter the Michigan stae data
Mi_tract_data<-Tract_data %>%
  filter(state == 26)
#total tract ids in data
length(Mi_tract_data$tract) ## 2755

#total unique tract ids in data
length(unique(Mi_tract_data$tract)) ## 2061

#convert NA values to zeroes
Mi_tract_data = aggregate(x = Mi_tract_data[,c(4:100)],
                          by = list(Mi_tract_data$tract),
                          FUN = sum, na.rm = TRUE) %>%
  rename(tract = Group.1)

Mi_tract_data<- round(Mi_tract_data,digits = 2)


##The michigan state has 2813 tract locations but in the tract_outcomes_early file has 2061 tract locations.

write.csv(Mi_tract_data,"../Mi_tract_data.csv")