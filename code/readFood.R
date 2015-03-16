# Food Environment Atlas
# http://www.ers.usda.gov/data-products/food-environment-atlas/data-access-and-documentation-downloads.aspx#.VEXQQPnF-mE

library(XLConnect)
wb <- loadWorkbook("C:\\Users\\Josh\\Documents\\GitHub\\openBH\\data\\food\\DataDownload.xls",
                   create = TRUE)

food = readWorksheet(wb, sheet = getSheets(wb))

