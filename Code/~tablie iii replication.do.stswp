***** table iii replication
clear all

use "/Users/laurelkrovetz/Dropbox/data_clean/merged_data_wide.dta", clear

*********************************************
*********************************************
***************** table iii *****************
*********************************************
*********************************************

gen log_median_income = log(Median_income)

replace avg_attendance = 0 if avg_attendance==.
replace max_attendance = 0 if max_attendance==.

//protesters, % of population
reg pop_pct_proteset_avg rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg pop_pct_proteset_max rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg pop_pct_proteset_avg rainfall pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg pop_pct_proteset_avg rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant if pop_pct_proteset_avg>0

//protesters, 1,000s

gen avg_attendance_scaled = avg_attendance/1000
gen max_attendance_scaled = max_attendance/1000

reg avg_attendance_scaled rainy pct_rep2008 votes_rep2008 votes_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg max_attendance_scaled rainy pct_rep2008 votes_rep2008 votes_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg avg_attendance_scaled rainfall pct_rep2008 votes_rep2008 votes_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant

reg avg_attendance_scaled rainy pct_rep2008 votes_rep2008 votes_dem2008 pop_pct_totalvote2008 log_median_income pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_immigrant if avg_attendance_scaled>0

