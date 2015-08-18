
library(dplyr)

#medicare spending variables per county
x1<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\pa_reimb_county_2012 (1).csv")
x2<-grep("MI",x1$County.name)
x3<-x1[x2, ]
x4<-select(x3,-starts_with("X"))
rm(x3,x2,x1)

#Selected measures of primary care access and quality
y1<-read.csv("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\PC_County_rates_2012 (1).csv")
y2<-grep("MI",y1$County.Name)
y3<-y1[y2, ]
y4<-select(y3,-starts_with("X"))


DartmouthCnty<-merge(x4,y4)
rm(y1,y2,y3,x4,y4)
