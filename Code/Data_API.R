install.packages(c("httr", "jsonlite"))
install.packages('rnoaa')
library(httr)
library(jsonlite)
library(rnoaa)
library(tidyverse)
library(haven)

# Precipitation data 

# Getting a list of all the counties in the data set

county_list_1 <- GET("https://www.ncei.noaa.gov/cdo-web/api/v2/locations?locationcategoryid=CNTY&datasetid=GHCND&limit=1000&offset=0",
                   add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))
county_list_2 <- GET("https://www.ncei.noaa.gov/cdo-web/api/v2/locations?locationcategoryid=CNTY&datasetid=GHCND&limit=1000&offset=1000",
                     add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))
county_list_3 <- GET("https://www.ncei.noaa.gov/cdo-web/api/v2/locations?locationcategoryid=CNTY&datasetid=GHCND&limit=1000&offset=2000",
                     add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))
county_list_4 <- GET("https://www.ncei.noaa.gov/cdo-web/api/v2/locations?locationcategoryid=CNTY&datasetid=GHCND&limit=1000&offset=3000",
                     add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))

county_list <- rbind(fromJSON(rawToChar(county_list_1$content))$results,
                    fromJSON(rawToChar(county_list_2$content))$results,
                    fromJSON(rawToChar(county_list_3$content))$results,
                    fromJSON(rawToChar(county_list_4$content))$results) 


# Looping over all counties and years to get the precipitation data 

years <- c(1980:2010)
county_codes <- county_list %>% select(id) %>% distinct() %>% as.matrix() 
# Big list of all county data
precip_data_list <- list()

for(i in 30){
  for(j in 3026:3138){
    
    skip=0
    df <- c() %>% as.data.frame() 
    print(c(i,j))
      
      repeat{
        
        # url 
        url <- GET(paste0("https://www.ncei.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=",
                          county_codes[j], "&startdate=", years[i], "-04-15&enddate=", years[i], "-04-15&limit=1000&offset=", skip),
                   add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))
        
        check <-fromJSON(rawToChar(url$content))$results
        
        if(!is.null(check)){
          
          # Getting max entries
          max <- fromJSON(rawToChar(url$content))$metadata$resultset$count
          
          # Getting the data for the current iteration
          data <- fromJSON(rawToChar(url$content))$results %>% as.data.frame() %>% filter(datatype == "PRCP")
          
          # Appedning anf continuing with the loop
          df <- rbind(df, data)
          
          skip <- skip + 1000
          if(skip >= max) {
            stop = TRUE
            break
          }
          else {
            skip <- skip + 1000
          }
        } else {
          stop = TRUE
          break
        } 
      }
    
     if(length(df)>0){
       df$county_code <- county_codes[j]
     }
      precip_data_list[[j]] <- df
  }
  
}


##### Dummy cleaning

prcp_data <- bind_rows(precip_data_list, .id = "column_label") %>% 
  select(-column_label) %>% 
  rename(id=county_code) %>% 
  left_join(county_list) %>% 
  select(-c(datatype, attributes, mindate, maxdate, datacoverage))
  
write_dta(prcp_data, "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/precip_data.dta")


############## Scratch space ##############

url <- GET(paste0("https://www.ncei.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=FIPS:01101",
                   "&startdate=", 2010, "-04-01&enddate=", 2010, "-04-30&limit=1000&offset=", skip),
           add_headers(token="VotivwfvTGdMbvHAZgCnDmhFZZBNplBM"))

a <-fromJSON(rawToChar(url$content))$results

if(is.null(a)){
  print("hi")
} else {
  print("bye")
}

############## End ##############

# ACS data 

census_data_detailed <- GET(paste0("api.census.gov/data/2009/acs/acs5?get=",
                          "REGION,",
                         # "B00001_001E,", # population unweighted
                          "B01003_001E,", # total population
                          # "B01001A_001E,", # Total white
                         # "B02001_002E", # white
                         # "B01001B_001E,", # Total African-american
                        # "B02001_003E", # African american
                        #  "B01001I_001E,", # Hispanic/ Latino
                          "B05001_006E,", #Non-US citizen
                          "B05001PR_006E,", # Non-US citizen in PR
                          "B20002_001E", #median income
                   "&for=county:*&in=state:*&key=10063ee3a8de2b4d7600272186007b68868cb674"))

census_data_profile <- GET(paste0("api.census.gov/data/2009/acs/acs5/profile?get=",
                                   "REGION,", "DP03_0005PE,",
                                  "DP05_0059PE,", #pct white
                                  "DP05_0060PE,", # pct black
                                  "DP05_0066PE", # pct hispanic
                                   "&for=county:*&in=state:*&key=10063ee3a8de2b4d7600272186007b68868cb674"))

data_detailed <- fromJSON(rawToChar(census_data_detailed$content))
data_profile <- fromJSON(rawToChar(census_data_profile$content))

# Census 2000 data 

census_2000_rural <-  GET("api.census.gov/data/2000/dec/sf1?get=P002001,P002005&for=county:*&in=state:*&key=10063ee3a8de2b4d7600272186007b68868cb674")
data_rural <- fromJSON(rawToChar(census_2000_rural$content))

# P002001 - total population
# P002005 - total rural population

# Final demographic variable file 

# Clean and merge

colnames(data_detailed) <- data_detailed[1,]
data_detailed <- data_detailed[-1,]
data_detailed_cleaned <- data_detailed %>% 
  as.data.frame() %>% 
  rename(
    Total_population=B01003_001E,
    Immigrant=B05001_006E,
    Immigrant_PR=B05001PR_006E,
    Median_income=B20002_001E
  )

colnames(data_profile) <- data_profile[1,]
data_profile <- data_profile[-1,]
data_profile_cleaned <- data_profile %>% 
  as.data.frame() %>% 
  rename(
    Employment_pct_civilian_16=DP03_0005PE,
    Pct_white=DP05_0059PE,
    Pct_black=DP05_0060PE,
    Pct_hisp=DP05_0066PE
  )

colnames(data_rural) <- data_rural[1,]
data_rural <- data_rural[-1,]
data_rural <- data_rural %>% 
  as.data.frame() %>% 
  rename(
    Total_population_2000=P002001,
    Total_population_rural_2000=P002005
  )

# Final merge of demographic data 

Demo_data <- data_detailed_cleaned %>% 
  inner_join(data_profile_cleaned) %>% 
  left_join(data_rural)

write_dta(Demo_data, "/Users/shubhalakshminag/Dropbox/Cornell coursework/Semester 1/Applied micro 1/PS 2/data_clean/demo_data.dta")



