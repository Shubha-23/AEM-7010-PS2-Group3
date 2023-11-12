***** merging election, rally attendance, precipiation, and demographic datasets
clear all


	* Housekeeping 
	
	cd "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean"
	
	* Import rally participation data 
	
	use "rally_participation_teaparty_combined_cleaned", clear
	gen year = 2010
	
	tempfile rally_particip
	save `rally_particip', replace
	
	* Merge with house election data 
	
	use "house_election_county_clean", clear
	
	* Converting to wide 

	drop county geo_unit county_yes
	reshape wide totalvote pct_dem pct_rep votes_dem votes_rep ///
	log_pct_rep log_votes_rep log_pct_dem log_votes_dem log_totalvote, i(fips) j(year)

	merge 1:1  fips using `rally_particip' 
	drop _merge 
	save "election_particip_data_wide", replace 
	

	/*
	merge 1:1 county state fips year using `rally_particip' // merged 479, 3 counties had rally participations but no elections 
	
	* Coding counties which didn't have codes
	
	gen no_election = (_merge==2)
	drop _merge
	
	* Dropping one duplicate observation 
	duplicates tag fips year, generate(dups)
	sort county state fips year
	replace avg_attendance = avg_attendance[_n-1] if dups==1
	replace avg_attendance = avg_attendance[_n+1] if dups==1
	replace max_attendance = max_attendance[_n-1] if dups==1
	replace max_attendance = max_attendance[_n+1] if dups==1
	
	drop if fips == 35013 & year==2010 & missing(totalvote)
	drop dups
	
	save "election_particip_data", replace
	*/
		
		
*** collapsing precipiation data/election_particip_data
* use "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/precip_data.dta", clear
 
 use "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/precip_data.dta", clear
 rename id fips

 collapse value, by(fips)
 
 /*
 drop name name2 name21
 rename name1 county
 rename name22 state
 
 split name, p(" County")
 split name2, p(", ")
 */
 
 split fips, p(":")
 drop fips fips1
 rename fips2 fips
 destring fips, replace
 
* collapse (mean) value (first) state county, by(fips)

rename value rainfall
replace rainfall = rainfall*0.0393701*0.1 // converting mm to inches
gen rainy = (rainfall >=0.1)


* destring fips, replace
* replace fips = 10001 if county=="Kent" & state=="DE" // missing fips data

// merging rainfall data with election and rally participation data - WIDE

merge 1:1 fips using "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/election_particip_data_wide.dta"
drop _merge 
save "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/rainfall_election_particip_wide.dta", replace



/*
// merging rainfall data with election and rally participation data
*merge 1:m county state fips using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/election_particip_data.dta"
merge 1:m county state fips using "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/election_particip_data.dta"

* Looking into the unmerged data 

preserve 
keep if _m ==1
* 6 counties in Alaska have rainfall data but no elction data
restore

drop _merge

sort county state fips year

bysort county state fips : replace avg_attendance = avg_attendance[_n+1] if avg_attendance==.
bysort county state fips : replace avg_attendance = avg_attendance[_n+1] if avg_attendance==.

bysort county state fips : replace max_attendance = max_attendance[_n+1] if max_attendance==.
bysort county state fips : replace max_attendance = max_attendance[_n+1] if max_attendance==.

* save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/rainfall_election_particip.dta", replace
save "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/rainfall_election_particip.dta", replace

*/

// demographic data
* use "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/demo_data.dta", clear
use "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/demo_data.dta", clear

replace state = usubstr(state, 2, .) if usubstr(state,1,1) == "0"  
gen fips = state + county
destring fips, replace

rename county county_code
rename state state_code

destring, replace

/*
destring Total_population, replace
destring Median_income, replace
destring Total_white, replace
destring Total_black, replace
destring Total_hispanic, replace
destring Immigrant, replace
destring Total_population_rural_2000, replace
destring Total_population_2000, replace
*/


* Merging with the wide data 

merge 1:1 fips using "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/rainfall_election_particip_wide.dta"

foreach i in 2006 2008 2010 {

	gen pop_pct_rep`i' = (votes_rep`i' / Total_population)*100
	gen pop_pct_dem`i' = (votes_dem`i' / Total_population)*100
	gen pop_pct_totalvote`i' = (totalvote`i' / Total_population)*100

}


gen pop_pct_rural = (Total_population_rural_2000)/Total_population_2000
gen pop_pct_immigrant = (Immigrant/Total_population)*100
rename Pct_white pop_pct_white
rename Pct_black pop_pct_black
rename Pct_hisp pop_pct_hispanic

gen pop_pct_proteset_avg = (avg_attendance/Total_population)*100
replace pop_pct_proteset_avg = 0 if missing(pop_pct_proteset_avg)
gen pop_pct_proteset_max = (max_attendance/Total_population)*100
replace pop_pct_proteset_max=0 if missing(pop_pct_proteset_max)

save "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/merged_data_wide.dta", replace



/*

// merging demographic data with rainfall data with election and rally participation data
* merge 1:m fips using "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/rainfall_election_particip.dta"
merge 1:m fips using "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/rainfall_election_particip.dta"

gen pop_pct_rep = (votes_rep / Total_population)*100
gen pop_pct_dem = (votes_dem / Total_population)*100
gen pop_pct_totalvote = (totalvote / Total_population)*100
gen pop_pct_rural = (Total_population_rural_2000)/Total_population_2000
* gen pop_pct_white = (Total_white/Total_population)*100
* gen pop_pct_black = (Total_black/Total_population)*100
* gen pop_pct_hispanic = (Total_hispanic/Total_population)*100
gen pop_pct_immigrant = (Immigrant/Total_population)*100

rename Pct_white pop_pct_white
rename Pct_black pop_pct_black
rename Pct_hisp pop_pct_hispanic

gen pop_pct_proteset_avg = (avg_attendance/Total_population)*100
gen pop_pct_proteset_max = (max_attendance/Total_population)*100

* save "/Users/laurelkrovetz/Dropbox/AEM 7010/problem sets/ps 2/clean data/merged_data.dta", replace

save "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/merged_data.dta", replace

