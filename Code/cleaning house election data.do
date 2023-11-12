***** cleaning house election data
clear all

************************
*** 2006 county data ***
************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2006.xlsx", firstrow clear sheet("County")

drop if _n==1

*renaming variables
rename A county
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep
rename N votes_dem // number of democratic votes
rename O votes_rep // number of republican votes
rename AT statecode
rename AU countycode
rename AV fips
rename AX geo_unit

// destringing percentage republican and democratic votes
replace pct_dem ="" if pct_dem== "-"
destring pct_dem, replace

replace pct_rep ="" if pct_rep== "-"
destring pct_rep, replace

//scaling up percetnages to 100
replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep county state totalvote pct_dem pct_rep votes_dem votes_rep statecode countycode fips geo_unit

// dropping observations for states, or missing data
drop if county == ""
drop if state == "T"
drop if state=="PR"
drop if county == "Overseas"

gen year = 2006
gen county_yes = (geo_unit=="County")

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

duplicates drop 

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2006_county_temp.dta", replace

****************************************
*** 2006 congressional district data ***
****************************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2006.xlsx", firstrow clear sheet("Cong Dist")

drop if _n==1
drop if _n>535 // keeping only district observations ("counties shared among congressional districts beyong this line")

rename A district
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep 
rename N votes_dem 
rename O votes_rep 
rename AT statecode
rename AU districtcode
rename AV fips
rename AW geo_unit

destring pct_dem, replace
destring pct_rep, replace

replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep district state totalvote pct_dem pct_rep votes_dem votes_rep statecode districtcode fips geo_unit

drop if district==""
drop if state =="T"

destring votes_dem, replace
destring votes_rep, replace

gen year = 2006

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2006_congdist_temp.dta", replace

************************
*** 2008 county data ***
************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2008.xlsx", firstrow clear sheet("County")

drop if _n==1

*renaming variables
rename A county
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep
rename N votes_dem 
rename O votes_rep 
rename AT statecode
rename AU countycode
rename AV fips
rename AX geo_unit

replace pct_dem ="" if pct_dem== "-"
destring pct_dem, replace
replace pct_rep ="" if pct_rep== "-"
destring pct_rep, replace

replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep county state totalvote pct_dem pct_rep votes_dem votes_rep statecode countycode fips geo_unit 

gen year = 2008
gen county_yes = (geo_unit=="County")

drop if county == ""
drop if state == "T"
drop if state=="PR"
drop if county == "Overseas"

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

duplicates drop 

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2008_county_temp.dta", replace

****************************************
*** 2008 congressional district data ***
****************************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2008.xlsx", firstrow clear sheet("Cong Dist")

drop if _n==1
drop if _n>535

rename A district
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep 
rename N votes_dem 
rename O votes_rep 
rename AT statecode
rename AU districtcode
rename AV fips
rename AW geo_unit

destring pct_dem, replace
destring pct_rep, replace

replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep district state totalvote pct_dem pct_rep votes_dem votes_rep statecode districtcode fips geo_unit

gen year = 2008

drop if district==""
drop if state =="T"

destring votes_dem, replace
destring votes_rep, replace

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2008_congdist_temp.dta", replace

************************
*** 2010 county data ***
************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2010.xlsx", firstrow clear sheet("County")

drop if _n==1

*renaming variables
rename A county
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep
rename N votes_dem 
rename O votes_rep 
rename AW statecode
rename AX countycode
rename AY fips
rename BA geo_unit

replace pct_dem ="" if pct_dem== "-"
destring pct_dem, replace
replace pct_rep ="" if pct_rep== "-"
destring pct_rep, replace

replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep county state totalvote pct_dem pct_rep votes_dem votes_rep statecode countycode fips geo_unit

gen year = 2010
gen county_yes = (geo_unit=="County")

drop if county == ""
drop if state == "T"
drop if state=="PR"
drop if county == "Overseas"

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

duplicates drop 

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2010_county_temp.dta", replace

****************************************
*** 2010 congressional district data ***
****************************************

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/house_election_data 2/House_Election_Data_2010.xlsx", firstrow clear sheet("Cong Dist")

drop if _n==1
drop if _n>535

rename A district
rename B state
rename C totalvote
rename J pct_dem
rename K pct_rep 
rename N votes_dem 
rename O votes_rep 
rename AW statecode
rename AX districtcode
rename AY fips
rename AZ geo_unit

destring pct_dem, replace
destring pct_rep, replace

replace pct_dem = pct_dem*100
replace pct_rep = pct_rep*100

keep district state totalvote pct_dem pct_rep votes_dem votes_rep statecode districtcode fips geo_unit

gen year = 2010

drop if district==""
drop if state =="T"

destring votes_dem, replace
destring votes_rep, replace

//generating log of election controls 
gen log_pct_rep = ln(pct_rep)
gen log_votes_rep = ln(votes_rep)
gen log_pct_dem = ln(pct_dem)
gen log_votes_dem = ln(votes_dem)
gen log_totalvote = ln(totalvote)

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2010_congdist_temp.dta", replace

*********************************************
*********************************************
********** merging county datasets **********
*********************************************
*********************************************

use "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2006_county_temp.dta", clear

append using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2008_county_temp.dta"

append using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2010_county_temp.dta"

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/house_election_county_clean.dta", replace

***********************************************
***********************************************
********** merging district datasets **********
***********************************************
***********************************************
use "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2006_congdist_temp.dta", clear

append using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2008_congdist_temp.dta"

append using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/house_election_2010_congdist_temp.dta"

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/house_election_congdist_clean.dta", replace

