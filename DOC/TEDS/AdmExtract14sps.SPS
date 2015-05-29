**************************************************************************************************************************************
*	This is to convert ASCII comma delimited admission data pulled from Oracle DB for Substance Abuse        *
*	These text files have commas between fields.  Similar ones are available for discharges,               *
*           .                                                                                                                                            *

*	
**************************************************************************************************************************************
*.
SET
   BLANKS=SYSMIS heading=yes
  UNDEFINED=WARN.
DATA LIST
  FILE='C:\Extracts\admission14.txt' 
  LIST (",") / 
  capayer (F9.0) program (F6.0) ssn(F9.0) caid(F11.0) medicdid (F10.0)
  typeadm (F1.0) codep (F1.0) datmonad(F2.0) datdayad(F2.0) datyrad(F4.0)
  dat24had (F4.0)
  svccatad(F2.0) prevtrmt(F2.0) refsrce(F2.0) county(F2.0) datbthmo(F2.0)  
  datbthda(F2.0) datbthyr(F4.0)  sex(F1.0)  racenew(F1.0) ethnic(F1.0) 
  mrtlstat(F1.0) veteran(F1.0) educatad(F2.0) intrain(F1.0) empstanw(F1.0) 
  psacodad(F2.0)  psartad(F1.0) psaagead(F2.0)  psausead(F2.0) psapread(F1.0) 
  ssacodad(F2.0) ssartad(F1.0) ssaagead(F2.0)  ssausead(F2.0)  ssapread(F1.0) 
  tsacodad(F2.0)  tsartad(F1.0) tsaagead(F2.0)  tsausead(F2.0)  tsapread(F1.0)  
  totincad(F6.0) noperson(F2.0)  
  corrstat(F2.0)  arrtot6a(F2.0)  arrdrg6a(F2.0)  arralc6a(F2.0)  
  arrtot5a(F2.0)  arrdrg5a(F2.0)  arralc5a(F2.0)  livargmt(F1.0) Opioid(F1.0)  
  primdiag(A6) secdiag(A6) pregnant(F1.0) othfaca1(F1.0) othfaca2(F1.0) 
  othfaca3(F1.0) daystx(F3.0)  primlang(A3) admclass(F1.0) mhissues (F1.0) drgcourt (F1.0)
  notinlab(F2.0) contact(A9) wss(F1.0) chldwlf (F1.0) slfhlp(F2.0).
EXECUTE .
*
* CREATING NEW SPSS SYSTEM FILE - Please wait......
*.

*FORMATS ETHNIC,  TYPEADM,   MRTLSTAT,  VETERAN,    LIVARGMT,    EMPSTANW, 
	PSAPREAD, SSAPREAD,  TSAPREAD,  PSARTAD, 
	SSARTAD,   TSARTAD,    PREGNANT, OPIOID,  INTRAIN,    
	OTHFACA1, OTHFACA2,  OTHFACA3,  SEX, RACENEW,  CODEP,   
	MHISSUES, DRGCOURT, ADMCLASS, WSS, CHLDWLF  (F1.0) /.

*FORMATS SVCCATAD, PREVTRMT, REFSRCE,  EDUCATAD, CORRSTAT,
	ARRTOT6A, ARRDRG6A, ARRALC6A, ARRTOT5A, ARRDRG5A, ARRALC5A, PSACODAD,
	PSAAGEAD, PSAUSEAD, SSACODAD, SSAAGEAD, SSAUSEAD,  TSACODAD, TSAAGEAD,
	TSAUSEAD,  NOPERSON, DATBTHDA, DATBTHMO, DATDAYAD, DATMONAD,  COUNTY,   
	NOTINLAB, SLFHLP (F2.0) /.

*FORMATS  DATBTHYR, DATYRAD, DAT24HAD (F4.0) /.

*FORMATS DAYSTX (F3.0) /.

*FORMATS PROGRAM, TOTINCAD  (F6.0) /.

*FORMATS MEDICDID (F10.0).

*FORMATS SSN CAPAYER (F9.0).

*FORMATS CAID (F11.0).

*MISSING VALUES
	SEX, TYPEADM (9) /
	REFSRCE, PREVTRMT, COUNTY, CORRSTAT,
	EDUCATAD, PSACODAD, PSAUSEAD, PSAAGEAD,
	SSACODAD, SSAUSEAD, SSAAGEAD, ARRTOT6A TO ARRALC5A (99) /
	RACENEW TO VETERAN, PSAPREAD, SSAPREAD, ABLEPAY TO OTHER (9)/
	PROGRAM, TOTINCAD  (999999)/.

*RECODE  REFSRCE,  PREVTRMT, COUNTY, RSCOUNTY, RSPROGRM, EMPSTAAD, EDUCATAD,
	INSURNCE, PSACODAD, PSAUSEAD, PSAAGEAD, SSACODAD, SSAUSEAD, SSAAGEAD,
	ARRTOT6A TO ARRALC5A, BAC (97,98=99).
*RECODE  RACENEW, MRTLSTAT, VETERAN, PSAPREAD, SSAPREAD, PUBASTAD, LEGSTAAD (7,8=9).
*RECODE  COUNTY (88 THRU 95 = 99).
*RECODE   TOTINCAD (999997,999998=999999).
*.

VARIABLE LABELS  
		PROGRAM 'Program license number'
		SSN 'Social Security Number'
		CAID 'CA id number'
		CODEP 'Codependent'
		ARRALC5A 'Drunk Driving Arrest 5 Yrs Adm'
		ARRALC6A 'Drunk Driving Arrest 6 Mos Adm'
		ARRDRG5A 'Drug Arrest 5 Yrs Adm'
		ARRDRG6A 'Drug Arrest 6 Mos Adm'
		ARRTOT5A 'Total Arrest 5 Yrs Adm'
		ARRTOT6A 'Total Arrest 6 Mos Adm'
		COUNTY   'County of Residence'
		DATBTHMO 'Date of Birth <Month>'
		DATBTHDA 'Date of Birth <Day>'
		DATBTHYR 'Date of Birth <Year>'
		DATDAYAD 'Date <Day> of Admission'
		DATMONAD 'Date <Month> of Admission'
		DATYRAD  'Date <Year> of Admission'
		DAT24HAD 'Date <Time> of Admission'
		DAYSTX  'Days of waiting to enter Treatment'
		EDUCATAD 'Education - Highest Yr. Comp. at Adm'
		EMPSTANW 'Current Employment Status at Adm'
		ETHNIC   'Ethnic Background'
		TOTINCAD 'Total annual Income at Adm'
		CORRSTAT Correctional Status - At Adm'
		LIVARGMT 'Living Arrangements'
		MEDICDID 'Medicaid number - new'
		OPIOID 'Opioid Part of Trmt'
		MRTLSTAT 'Marital Status'
		NOPERSON 'Number of Persons in Household'
		OTHFACA1 'Other factor 1 - At Adm'
		OTHFACA2 'Other factor 2 - At Adm'
		OTHFACA3 'Other factor 3 - At Adm'
		PREGNANT 'Pregnant at Admission'
		PREVTRMT 'Previous SA Admissions'
		PRIMDIAG 'Primary Diagnosis'
		PSAAGEAD 'PSA - Age at First Use - At Adm'
		PSACODAD 'PSA - Drug Code - At Adm'
		PSAPREAD 'PSA - Initially a Prscrptn - At Adm'
		PSARTAD  'PSA - Route of Admin - At Adm'
		PSAUSEAD 'PSA - Use 30 Days - At Adm'
		RACENEW     'Client Race'
		REFSRCE  'Referral Source'
		SECDIAG  'Secondary Diagnosis'
		SEX  'Client Gender'
		INTRAIN  'In School or Training at Admission'
		SSAAGEAD 'SSA - Age at First Use - At Adm'
		SSACODAD 'SSA - Drug Code - At Adm'
		SSAPREAD 'SSA - Initially a Prscrptn - At Adm'
		SSAUSEAD 'SSA - Use 30 Days - At Adm'
		SSARTAD  'SSA - Route of Admin - At Adm'
		SVCCATAD 'Service Category at Adm'
		TSACODAD 'TSA - Drug Code - At Adm'
		TSAAGEAD 'TSA - Age at First Use - At Adm'
		TSAPREAD 'TSA - Initially a Prscrptn - At Adm'
		TSAUSEAD 'TSA - Use 30 Days - At Adm'
		TSARTAD  'TSA - Route of Admin - At Adm'
		TYPEADM  'Admission  Type'
		VETERAN  'Veteran Status'
		CAPAYER 'CA Payer ID'
		MHISSUES 'Mental Health Indication'
		DRGCOURT 'Drug Court Involved'
		PRIMLANG 'Primary Language Spoken' 
		ADMCLASS 'Admission/Transfer'        
	           	NOTINLAB 'Not in Labor Force Detail'
		CONTACT 'Date of First Contact'
		WSS 'Womens Specialty Service'
		CHLDWLF 'Child Welfare Involved'
		SLFHLP 'Attend Self Help Groups'.

VALUE LABELS
	   SVCCATAD
	      11'Outpatient'     
	      21'Detox'         22'Res-Short term'
	      24'Resdntl-Long term'
	      31'IOP'    
	      61'Case Mangement'/
	   TYPEADM    
	       1'First Admission'      2'Readmission'/
	   REFSRCE
	      1'Outpatient'         
	      5'Resid-Detox'   	 6'Residential'
	      9'Intensive OutP'     	10'Hosp-Acute Care'
	     13'AAR'                  	14'Other SARF'
                 18'Prevention'	
	     19'Student Asst Prog'  20'Drug Court - Adult'
	     21'Drug Court-Adolescent'     
	     22'Community Corrections'
	     29'Other SA Prg'
	     30'Self'               31'Family Court'
	     32'Court'        33'Probation/Parole'
	     34'Police'             35'Secretary State'
	     36'Lawyer'             37'Mental Health'
	     38'DHS'                39'Fam,Friend,Rel'
	     40'Other Human Srvcs'  49'Corrections'
	     41'Employer'           42'Union'
	     43'Clergy'             44'School'
	     45'Physician'          46'Hospital (non SA)'
	     47'SA Client'          48'AA'
	     90'Other'/
	   SEX    
	      1'Male'                   2'Female'/
	   RACENEW
              4'White'          3'African American/Black'
	      5'Hispanic'           1'Native American' 
	      2'Asian, Pacific Islander'   8'Arab American'   
	      6'Multiracial'
	      9'Refused to Answer' 
                  0 'Unknown'/
	   ETHNIC
	      0'Not listed'         1'Puerto Rican'
	      2'Mexican'            3'Cuban'
	      4'Other Hispanic'     5'Arab-Chaldean'/
	   LIVARGMT
	      1'Independent'   2'Dependent'  3'Homeless'/
	   MRTLSTAT
	      1'Never Married'    2'Married|Cohabitating'
	      3'Widowed'          4'Divorced'
	      5'Separated'/
	   VETERAN, PREGNANT, INTRAIN, MHISSUES, DRGCOURT,  CODEP, WSS, CHLDWLF     
	      1 'Yes'              2'No'/
 	   Opioid
	      1 'Methadone'   2 'None'   3 'Burenorphine-naloxone'/
           INTRAIN
                  4 'in training program'
                  6 'in special education'
	      7 'attending college'
                  0 'not applicable'/
	   EMPSTANW
	      1'Employed Full-Time' 2'Employed Part-Time'
	      3'Unemployed'         4'Not in the labor force'
	      6'Retired'
	      8'Not Applicable'              /
	   PSACODAD, SSACODAD, TSACODAD
	      0'None'               10'Alcohol'
	     20'Heroin'             21'Methadone (illicit)'
	     22'Oth Opiates|Syn'    30'Barbiturates'
	     31'Oth Seds|Hypntcs'   32'Tranquilizers'
	     33'Benzodiazepine'    34'GHB, GBL' 	     
	     41'Cocaine'            42'Crack cocaine'
	     43'Methamphetamines'   44'Other Amphetamines'
	     45'Methcathinone'   
	     50'Hallucinogens'      51'PCP'
	     52'Marijuana|Hashish'  53'Ecstasy (MDMA, MDA)'
	     54'Ketamine'		60'Inhalants'
	     70'Over the Counter'   72 'Steroids'
	     81'Talwin and PBZ'        61'Antidepressants'
	     91'Other Substance'/
	   PSAPREAD, SSAPREAD, TSAPREAD
	      2'No'                 1'Yes'
	      0 'Not Applicable'/
	   PSAUSEAD, SSAUSEAD, TSAUSEAD
	      98 'Not Applicable'/
	   CORRSTAT
	      1 'In Prison'
	      2'In Jail' 		3'Parole'              4'Probation'
	      5'Juvenile detention center'	6'Court supervision'
	      7'Not under juris'
	      8'Awaiting Trial'      9'Awaiting Sent'
	      10'Refused to provide'    98 'Unknown'
                  0 'None'/
	   DATMONAD, datbthmo
	      1'January'            2'February'
	      3'March'              4'April'
	      5'May'                6'June'
	      7'July'               8'August'
	      9'September'          10'October'
	     11'November'           12'December'/
	   ARRTOT6A TO ARRALC5A
	     99'Missing'/
	   COUNTY
	      00'Out of State'  1'Alcona'          2'Alger'
	      3'Allegan'        4'Alpena'          5'Antrim'
	      6'Arenac'         7'Baraga'          8'Barry'
	      9'Bay'            10'Benzie'         11'Berrien'
	      12'Branch'        13'Calhoun'        14'Cass'
	      15'Charlevoix'    16'Cheboygan'      17'Chippewa'
	      18'Clare'         19'Clinton'        20'Crawford'
	      21'Delta'         22'Dickinson'      23'Eaton'
	      24'Emmet'         25'Genesee'        26'Gladwin'
	      27'Gogebic'       28'Grand Traverse' 29'Gratiot'
	      30'Hillsdale'     31'Houghton'       32'Huron'
	      33'Ingham'        34'Ionia'          35'Iosco'
	      36'Iron'          37'Isabella'       38'Jackson'
	      39'Kalamazoo'     40'Kalkaska'       41'Kent'
	      42'Keweenaw'      43'Lake'           44'Lapeer'
	      45'Leelanau'      46'Lenawee'        47'Livingston'
	      48'Luce'          49'Mackinac'       50'Macomb'
	      51'Manistee'      52'Marquette'      53'Mason'
	      54'Mecosta'       55'Menominee'      56'Midland'
	      57'Missaukee'     58'Monroe'         59'Montcalm'
	      60'Montmorency'   61'Muskegon'       62'Newaygo'
	      63'Oakland'       64'Oceana'         65'Ogemaw'
	      66'Ontonagon'     67'Osceola'        68'Oscoda'
	      69'Otsego'        70'Ottawa'         71'Presque Is'
	      72'Roscommon'     73'Saginaw'        74'St Clair'
	      75'St Joseph'     76'Sanilac'        77'Schoolcraft'
	      78'Shiawassee'    79'Tuscola'        80'Van Buren'
	      81'Washtenaw'     82'Wayne'          83'Wexford'
	      84'Detroit'       85'Wisconsin'      86'Indiana'
	      87'Ohio'          88'Illinois'       89'Canada'
	      96'Homeless'    97'Unknown'        98'Rfsd to Ans'
	      99'Missing'/
	   PSARTAD, SSARTAD, TSARTAD
	       1'Oral'          2'Smoking'
	       3'Inhalation'    4'Injection'
	       5'Other'          0 'Not Applicable'/
	   OTHFACA1, OTHFACA2, OTHFACA3
		0 'None'                    2'Adult child'
		3'Significant other'     4'Hearing impaired'
		5'Visually impaired'     6'Head injury'
		7'Developmentally disabled'    8'Mobility impaired'
		9'Mental illness'/
	    CAPAYER   
		1183123 'Pathways'        1183104 'Northern'
		1182832 'Genesee'         1183098 'Muskegon'
	       	1183052 'Mid-South'	1182930 'Kalamazoo'
	       	1183061 'network180'	1182903 'Macomb'              
	        1182896 'Oakland'             	1182878 'Lakeshore'
	        1182869 'Saginaw'         	1182841 'SAHL'
	        1182850 'Washtenaw'       	1183033 'Detroit'
	        1182994 'Western UP'          	1182976 'SEMCA'
	        1183024 'Riverhaven'	1183169 'Venture'
	        1182887 'Thumb Alliance'        	1182967 'CEI' /
	    ADMCLASS
	        1 'Admission'               2 'Transfer'/
	    NOTINLAB
	        01 'Homeaker'	02 'Student' 	03 'Retired' 
	        04 'Disabled'	05 'Inmate'	06 'Other'
	        07 'Not Seeking Work'	98 ' Not Applicable'.
	

FREQUENCIES   VARIABLES=CAPAYER SVCCATAD SEX RACENEW PSACODAD.

