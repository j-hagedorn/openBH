# Read Area Resource File (ARF)

# Use clone of A. Damico's download script to read ARF data 
  # remove the # in order to run this install.packages line only once
  # install.packages( c( 'SAScii' , 'descr' , 'RSQLite' , 'downloader' ) )
  ARF_2013 <- "https://raw.githubusercontent.com/j-hagedorn/usgsd/master/Area%20Resource%20File/download.R"
  source(ARF_2013)
  
# Modification of A. Damico's subsetting file  
  # load the 2013-2014 ARF data file created by source script above
  load("data/arf2013.rda")
  
  # the "AHRF 2013-2014 Technical Documentation.xls" file in the current working directory contains field labels
  # so create a smaller data table with only a few columns of interest
  # first, create a character vector containing only the columns you'll need:
  variables.to.keep <-
    c(
      "f00002" ,			# fips state + county code
      "f00008" , 			# state name
      "f12424" , 			# state abbreviation
      "f00010" , 			# county name
      "f13156" , 			# ssa beneficiary county code
      "f04439",       # census region code
      "f04448",       # census region name
      "f04440",       # census division code
      "f04449",       # census division name
      "f1389113",     # core based statistical area (CBSA) code
      "f1389213",     # core based statistical area (CBSA) name
      "f1406713",     # CBSA Indicator
      "f1419513",     # CBSA County Status
      "f0002013",     # Rural-Urban Continuum Code
      "f0453010" ,		# 2010 census population
      "f1257311" ,    # hospitals with Alc/Drug Abuse IP care
      "f1257411" ,     # Hosp w/ Psychiatric Care
      "f1261611" ,     # Hosp w/ Psych Child/Adolesc svs
      "f1262011" ,     # Hosp w/ Psych Emergency Svs
      "f1262311" ,     # Hosp w/ Psych Partial Hosp
      "f1527511" ,     # Hosp w/ Psych Res Tx
      "f1318511" ,     # Hosp Psych Short Term
      "f1322113" ,     # Comm Mental Health Ctrs
      "f1525714" ,     # # NHSC Mental Health Sites w/ Providers
      "f1526114" ,     # # NHSC FTE Mental Health Provider
      "f1212910" , 		# total active m.d.s non-federal & federal
      "f0954511",   # Total inpatient days, incl nursing homes
      "f1318811",   # Total inpatient days, ST psychiatric
      "f1068511",   # Total inpatient days, LT psychiatric
      "f1068911",   # Total inpatient days, inst mental retardation
      "f1069011",   # Total inpatient days, childrens psychiatric
      "f0957211",   # Emergency dept visits, short term general
      "f0957411",   # Emergency dept visits, ST non-gen + long term
      "f1526613"     # % good air quality days (2013)
    )
  
  # now create a new data frame 'arf.sub' containing only those specified columns from the 'arf' data frame
  arf.sub <- arf[ , variables.to.keep ]
  
  # rename the variables something more user-friendly
  names(arf.sub) <- c( "fips" , "state" , "stateab" , "county" , "ssa" , 
                       "census_reg_code", "census_reg_name", "census_div_code", "census_div_name", 
                       "cbsa_code", "cbsa_name", "cbsa_indicator", "cbsa_status",
                       "rural_urban", "pop2010" , 
                       "hosp_sud", "hosp_psy", "hosp_psy_kid", "hosp_psy_er", "hosp_psy_partial",
                       "hosp_psy_residtx", "hosp_psy_short", "cmh", "nhsc_mh", "nhsc_mh_fte", "md2010", 
                       "ip_days_total", "ip_days_psy_st", "ip_days_psy_lt", "ip_days_icf_mr", "ip_days_psy_kids",
                       "er_visits_st", "er_visits_lt", "good_air_days")
  
  # create refernce variables
  arf.sub$dataset <- "ARF"
  arf.sub$dataset_yr <- 2013
  
  # Create reference table
  library(readxl)
  ahrf_ref <- read_excel("doc/ahrf/AHRF 2013-2014 Technical Documentation.xlsx",
                         skip = 182)
  
  ahrf_ref <-
    ahrf_ref %>%
    filter(!is.na("COL-COL") & !is.na(CHARACTERISTICS))
  