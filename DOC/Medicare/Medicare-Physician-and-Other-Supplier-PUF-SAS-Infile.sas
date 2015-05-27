DATA WORK.Medicare_PS_PUF;
	LENGTH
		npi              					$ 10
		nppes_provider_last_org_name 		$ 70
		nppes_provider_first_name 			$ 20
		nppes_provider_mi					$ 1
		nppes_credentials 					$ 20
		nppes_provider_gender				$ 1
		nppes_entity_code 					$ 1
		nppes_provider_street1 				$ 55
		nppes_provider_street2				$ 55
		nppes_provider_city 				$ 40
		nppes_provider_zip 					$ 20
		nppes_provider_state				$ 2
		nppes_provider_country				$ 2
		provider_type 						$ 43
		medicare_participation_indicator 	$ 1
		place_of_service					$ 1
		hcpcs_code       					$ 5
		hcpcs_description 					$ 30
		line_srvc_cnt      					8
		bene_unique_cnt    					8
		bene_day_srvc_cnt   				8
		average_Medicare_allowed_amt   		8
		stdev_Medicare_allowed_amt  		8
		average_submitted_chrg_amt  		8
		stdev_submitted_chrg_amt   			8
		average_Medicare_payment_amt   		8
		stdev_Medicare_payment_amt   		8;

	INFILE 'C:\My documents\Medicare-Physician-and-Other-Supplier-PUF-CY2012.txt'
		lrecl=32767
		dlm='09'x
		pad missover
		firstobs = 3
		dsd;

	INPUT
		npi             
		nppes_provider_last_org_name 
		nppes_provider_first_name 
		nppes_provider_mi 
		nppes_credentials 
		nppes_provider_gender 
		nppes_entity_code 
		nppes_provider_street1 
		nppes_provider_street2 
		nppes_provider_city 
		nppes_provider_zip 
		nppes_provider_state 
		nppes_provider_country 
		provider_type 
		medicare_participation_indicator 
		place_of_service 
		hcpcs_code       
		hcpcs_description 
		line_srvc_cnt    
		bene_unique_cnt  
		bene_day_srvc_cnt 
		average_Medicare_allowed_amt 
		stdev_Medicare_allowed_amt 
		average_submitted_chrg_amt 
		stdev_submitted_chrg_amt 
		average_Medicare_payment_amt 
		stdev_Medicare_payment_amt;

	LABEL
		npi     							= "National Provider Identifier"       
		nppes_provider_last_org_name 		= "Last Name/Organization Name"
		nppes_provider_first_name 			= "First Name"
		nppes_provider_mi					= "Middle Initial"
		nppes_credentials 					= "Credentials"
		nppes_provider_gender 				= "Gender"
		nppes_entity_code 					= "Entity Type"
		nppes_provider_street1 				= "Street Address 1"
		nppes_provider_street2 				= "Street Address 2"
		nppes_provider_city 				= "City"
		nppes_provider_zip 					= "Zip Code"
		nppes_provider_state 				= "State Code"
		nppes_provider_country 				= "Country Code"
		provider_type	 					= "Provider Type"
		medicare_participation_indicator 	= "Medicare Participation"
		place_of_service 					= "Place of Service"
		hcpcs_code       					= "HCPCS Code"
		hcpcs_description 					= "HCPCS Description"
		line_srvc_cnt    					= "Number of Services"
		bene_unique_cnt  					= "Number of Medicare Beneficiaries"
		bene_day_srvc_cnt 					= "Number of Medicare Beneficiary/Day Services"
		average_Medicare_allowed_amt 		= "Average Medicare Allowed Amount"
		stdev_Medicare_allowed_amt 			= "Standard Deviation of Medicare Allowed Amount"
		average_submitted_chrg_amt 			= "Average Submitted Charge Amount"
		stdev_submitted_chrg_amt 			= "Standard Deviation of Submitted Charge Amount" 
		average_Medicare_payment_amt 		= "Average Medicare Payment Amount"
		stdev_Medicare_payment_amt 			= "Standard Deviation of Medicare Payment Amount";
RUN;
