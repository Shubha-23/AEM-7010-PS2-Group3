
	* Table 6 replication 
	
	use "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/merged_data_wide.dta", clear
	
	* Housekeeping 
	
	drop county
	order fips  REGION 
	drop year
	isid fips // looks good
	
	* Regression results 
	
	* Republic vote % of pop
	
	eststo column_1: reg pop_pct_rep2010 rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				  , vce(cluster state)  

	eststo column_2: ivregress 2sls pop_pct_rep2010 pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				 pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				 (pop_pct_proteset_avg = rainy), vce(cluster state) first 

	sum pop_pct_rep2010
	di `r(mean)'
	
	* Democrat vote % of pop
	
	eststo column_3: reg pop_pct_dem2010 rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				  , vce(cluster state) 
				  
	eststo column_4: ivregress 2sls pop_pct_dem2010 pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				  (pop_pct_proteset_avg = rainy), vce(cluster state) first

	sum pop_pct_dem2010 
	di `r(mean)'
	
	* Republican vote share
	
	eststo column_5: reg vote_share_rep2010 rainy pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				  , vce(cluster state) 
				  
	eststo column_6: ivregress 2sls vote_share_rep2010 pct_rep2008 pop_pct_rep2008 pop_pct_dem2008 pop_pct_totalvote2008 /// election controls
				  pop_pct_white pop_pct_black pop_pct_hispanic pop_pct_rural pop_pct_immigrant Median_income Employment_pct_civilian_16 i.REGION /// demographic controls
				  (pop_pct_proteset_avg = rainy), vce(cluster state) first

	sum vote_share_rep2010 
	di `r(mean)'
	
	la var pop_pct_proteset_avg "% Protesting"
	la var rainy "Rainy Protest"
	
	esttab column_* using "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/AEM-7010-PS2-Group3/Output/Table6.tex", ///
	replace compress alignment(c) nogap se label keep(rainy pop_pct_proteset_avg) star(* 0.10 * 0.05 ** 0.01) mtitles("")
	
	
	
	
