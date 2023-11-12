***** cleaning tea party rally attendance data
set seed 09282000

*** NY Times Data
import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/tea party rally/rally_participation_NYtimes.xlsx", clear

//separating city from state and population from state
split A, p(", ")
split A2, p(" – ")

// manually cleaning an irregularity
replace A22 = "1,000" if A21 == "NC 1,000"
replace A21 = "NC" if A21 == "NC 1,000"

// dropping and renaming
drop A A2 
rename A1 city
rename A21 state

// removing text from population variable
split A22, p("(")
drop A22
drop A222

//renaming and converting attendance to numeric
rename A221 attendance1
replace attendance1 = subinstr(attendance1, ",", "", .)
destring attendance1, replace

//manually cleaning some observations
replace city = "Bound Brook" if city=="Bound Book"
replace city="Des Moines" if city=="Des Monies"
drop if attendance1==1000 & city=="Des Moines"
replace attendance1=1500 if city=="Des Moines"

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/rally_participation_NYtimes_temp.dta", replace

*** other data

import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/tea party rally/rally_participation_teaparty.xlsx", firstrow clear

// separating city and state
split TeaPartyLocation, p(", ")

//renaming variables
rename TeaPartyLocation1 city
rename TeaPartyLocation2 state
rename NumberofAttendeesLowEst attendance2

drop TeaPartyLocation

*browse if state == ""

replace state = strupper(state)

// manually filling in/correcting state variable where state information is missing from typos in data 
replace state = "FL" if city=="Naples FL (1)" | city=="Naples FL (2)" | city=="Port Charlotte" | city=="Stuart FL"
replace state = "OR" if city=="Coos Bay"
replace state = "NC" if city=="Edenton, NC"
replace state = "TX" if city=="Marble Falls,"
replace state = "RI" if city=="Rhode Island"
replace state = "CA" if city=="San Diego"
replace state = "PA" if city=="South Waverly,PA"
replace state = "WA" if city=="Sumner Cty"
replace state = "MO" if city=="Cape Girardeau"
replace state = "IA" if state=="IOWA"
replace state="KS" if state=="KS – EVENING" | state=="KS – AFTERNOON"
replace state="OR" if state=="OREGON"

// some cases where there is no space between , and state abbreviation, fixing that here
split city, p(",")
drop city
rename city1 city
drop city2

//duplicate city observations, removing numbers (1) and (2) from state abbreviation
split state, p("(")
drop state
drop state2
rename state1 state

//manually cleaning some city and state observations
replace city = "Naples" if city=="Naples FL (1)" | city=="Naples FL (2)"
replace city = "Stuart" if city=="Stuart FL"
replace state = "DC" if state=="D.C."
replace city="Corpus Christi" if city=="Corpus Cristi"

// using the average attendance for duplicate city/state observations
duplicates tag city state, gen(citydup)
browse if citydup>0

replace attendance = (2000+2000)/2 if city=="Boston" & state=="MA"
replace attendance = (75+300)/2 if city=="Bradenton" & state=="FL "
replace attendance = (3000+1500)/2 if city=="Columbia" & state=="SC "
replace attendance = (1000+500)/2 if city=="Lexington" & state=="KY"
replace attendance = (1000+300)/2 if city=="Pensacola" & state=="FL "
replace attendance = (300+1000)/2 if city=="San Jose" & state=="CA "
replace attendance = (1000+500)/2 if city=="Southlake" & state=="TX "
replace attendance = (250+600)/2 if city=="Traverse City" & state=="MI"
replace attendance = (2000+2000)/2 if city=="Naples" & state=="FL"

//removing duplicate city state observations after averaging
bysort city state: drop if !mod(_n,2) & citydup==1
drop citydup

//removing excess spaces from state
replace state = strtrim(state)

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/rally_participation_teaparty_temp.dta", replace

*** merging attendance datasets 
merge 1:1 city state using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/rally_participation_NYtimes_temp.dta"
drop _merge                                                                     

order city state attendance1 attendance2

//taking average and maximum of attendance from two data sources
replace attendance1=0 if attendance1==.
replace attendance2=0 if attendance2==.

gen max_attendance =cond(attendance2>attendance1,attendance2,attendance1)
egen avg_attendance = rowtotal(attendance1 attendance2) 
replace avg_attendance = avg_attendance/2

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/rally_participation_teaparty_combined_temp.dta", replace

***** merging in county names
import excel "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/tea party rally/uscities.xlsx", firstrow clear

rename state_id state
rename county_name county
rename county_fips fips

//for cities in two counties, randomly dropping one observation from each pair
duplicates tag city state, gen(citystatedup)
*browse city state county if citystatedup>0
sort city state
gen random = runiform()
sort city state random
bysort city state: drop if _n!=1 & citystatedup>0

keep city state county fips

merge 1:1 city state using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/temp data/rally_participation_teaparty_combined_temp.dta"

drop if _merge!=3
drop _merge

collapse (mean) avg_attendance (max) max_attendance (first) state city county, by(fips)

save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/rally_participation_teaparty_combined_cleaned.dta", replace

