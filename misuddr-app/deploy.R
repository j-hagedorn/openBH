## deploy.R ##

library(rsconnect)

deployApp("misuddr-app", account = "joshh")
deployApp("misuddr-app", account = "tbdsolutions")

# Get info about ShinyApps accounts
accounts()
accountInfo("joshh")
accountInfo("tbdsolutions")

applications("tbdsolutions")
applications("joshh")
# terminateApp("exploreSIS_node_lrp", account = "joshh", quiet = FALSE)
