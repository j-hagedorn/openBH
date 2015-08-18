library(dplyr)

#County arrest data
#http://www.icpsr.umich.edu

# This is the only file where downlading from the internet is troublesome because
# I have to log in first before they give me access to the zip file. I also had a hard
# time putting the "load" command in the function. This is why I am loading them first. 

load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_35019\\DS0004\\35019-0004-Data.rda")
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_34582\\DS0004\\34582-0004-Data.rda")
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_33523\\DS0004\\33523-0004-Data.rda")
load("C:\\Users\\Joseph\\Documents\\GitHub\\openBH\\data\\FBI\\ICPSR_30763\\DS0004\\30763-0004-Data.rda")

# f = file name 
# y = year
# d = current year available for grouping

fbi<-function(f,y,d){
  library(dplyr)
  df<-f

# Adding zeros where approriate on fips variables 

df[nchar(df[,5])==1,5] <- paste("0", df[nchar(df[,5])==1,5], sep="")
df[nchar(df[,6])==1,6] <- paste("00", df[nchar(df[,6])==1,6], sep="")
df[nchar(df[,6])==2,6] <- paste("0", df[nchar(df[,6])==2,6], sep="")

# Making primary key and cleaning vector

df$FIPS<-paste(df$FIPS_ST,df$FIPS_CTY,sep="")
df$Year<-y
df$Year_FIPS<-paste(df$Year,df$FIPS,sep="_")
df<-df[-grep("777$|999$",df$Year_FIPS),]

df<-select(df,Year_FIPS,mudr_fbi=MURDER,rape_fbi=RAPE,robry_fbi=ROBBERY,
            agva_fbi=AGASSLT,mtvt_fbi=MVTHEFT,arsn_fbi=ARSON)

df$current<-d
rm(f)

return(df)
}

c12<-fbi(f = da35019.0004,y = "2012",d = "2015")
c11<-fbi(f = da34582.0004,y = "2011",d = "2014")
c10<-fbi(f = da33523.0004,y = "2010",d = "2013")
c09<-fbi(f = da30763.0004,y = "2009",d = "2012")

fbi<-rbind(c12,c11,c10,c09)
rm(da30763.0004,da33523.0004,da34582.0004,da35019.0004,c12,c11,c10,c09)


