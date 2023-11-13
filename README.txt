README File

Purpose: to complete part 2 of problem set 2 for AEM 7010 for the Fall 2023 semester.

Data: the data used for this replication is not included in the GitHub repository. The authors include in their data appendix (https://yanagizawadrott.com/wp-content/uploads/2016/02/teaparty_appendix.pdf) their sources of data.
We used this data appendix to collect data on House election results from 2006, 2008, and 2010, as well as tea party rally attendance from two sources: NYTimes and Nate Silver, and census and weather data.
Weather and census data was gathered using an API.

Code: The code folder includes all STATA do-files needed to complete the replication.

• cleaning house election data.do: do file for cleaning and merging House county election results data
• cleaning tea party data.do: do file for cleaning and merging tea party rally attendance data
• Data_API.R: R code for gathering census and weather data with an API
• Data_merge.do: code for merging weather, census, House election, and tea party rally datasets
• table i replication.do: code for replicating table I
• table iii replication.do: code for replicating table III
• Replication_6 replaicates table 6 from the paper 
• Exclusion restiction includes the additional piece of analysis to validate the exclusion restiction of the instrument.


AEM 7010 PS2 Part 2: this is the PDF submission which includes all replicated figures and tables as well as responses to questions of the assignment

Instructions: to reproduce the analyses requested, please do the following:
1) gather and download all the respective data files 
2) run the various data cleaning and merging files (cleaning, API, and merge do files)
3) run the replication do files
(for all do files, be sure to change the file path to match with your computer's file path)
