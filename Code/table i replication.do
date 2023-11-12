***** table i replication
clear all

use "/Users/laurelkrovetz/Dropbox/data_clean/merged_data.dta", clear

*********************************************
*********************************************
****************** table i ******************
*********************************************
*********************************************

replace pop_pct_rural = pop_pct_rural*100

// rainfall comparison
ttest rainfall if year==2010, by(rainy) reverse

//election 2008
ttest pct_rep if year==2008, by(rainy) reverse
ttest pop_pct_rep if year==2008, by(rainy) reverse
ttest pop_pct_dem if year==2008, by(rainy) reverse
ttest pop_pct_totalvote if year==2008, by(rainy)  reverse

//election 2006s
ttest pct_rep if year==2006, by(rainy) reverse
ttest pop_pct_rep if year==2006, by(rainy) reverse
ttest pop_pct_dem if year==2006, by(rainy) reverse
ttest pop_pct_totalvote if year==2006, by(rainy) reverse

// demographic variables
ttest Median_income if year==2010, by(rainy) reverse
ttest Total_population if year==2010, by(rainy) reverse
ttest pop_pct_rural if year==2010, by(rainy) reverse
ttest pop_pct_white if year==2010, by(rainy) reverse
ttest pop_pct_black if year==2010, by(rainy) reverse
ttest pop_pct_immigrant if year==2010, by(rainy) reverse
ttest pop_pct_hispanic if year==2010, by(rainy) reverse
