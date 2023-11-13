

	use "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/merged_data_wide.dta", clear
	
	* Housekeeping 
	
	drop county
	order fips  REGION 
	drop year
	isid fips // looks good

	* Regressing the outcome variable on controls and rally participation - republic vote share
	
	reg pop_pct_rep2010  pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION 
				  
	predict  pop_pct_rep2010_e_1, residuals
				  
	reg rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION 
	
	predict rainy_e, residuals
	
	ttest pop_pct_rep2010_e_1== rainy_e
	
	* Regressing the outcome variable on controls and rally participation - demovratic vote share
	
	reg pop_pct_dem2010  pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION 
				  
	predict  pop_pct_dem2010_e_1, residuals		  
				  
	ttest pop_pct_dem2010_e_1== rainy_e
