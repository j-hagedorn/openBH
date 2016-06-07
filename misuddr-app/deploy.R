## deploy.R ##

library(shinyapps)

deployApp("misuddr-app", account = "joshh")
deployApp("misuddr-app", account = "tbdsolutions")

# Get info about ShinyApps accounts

accounts()
accountInfo("joshh")
accountInfo("tbdsolutions")

applications("tbdsolutions")
applications("joshh")
# terminateApp("exec-dash", account = "joshh", quiet = FALSE)
