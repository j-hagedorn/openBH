temp <- tempfile()
download.file("http://www.cdc.gov/brfss/smart/2012/cnty12asc.zip",temp)
data <- read.fwf(unz(temp, "CNTY12.asc"), widths = 285)
unlink(temp)
