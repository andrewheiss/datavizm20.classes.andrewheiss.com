library(tidyverse)

# Install this package, which lets us access the BLS API
# devtools::install_github("keberwein/blscrapeR")
library(blscrapeR)
# Also, get a BLS API key at http://data.bls.gov/registrationEngine/
# And then run set_bls_key("YOUR_KEY_IN_QUOTATIONS") to install the key


# I found this list at the BLS's "Create customized tables" page for the Local
# Area Unemployment Statistics they offer: https://data.bls.gov/cgi-bin/dsrv?la
state_lookup <- tribble(
  ~bls_id, ~state,
  "ST0100000000000", "Alabama",
  "ST0200000000000", "Alaska",
  "ST0400000000000", "Arizona",
  "ST0500000000000", "Arkansas",
  "ST0600000000000", "California",
  "ST0800000000000", "Colorado",
  "ST0900000000000", "Connecticut",
  "ST1000000000000", "Delaware",
  "ST1100000000000", "District of Columbia",
  "ST1200000000000", "Florida",
  "ST1300000000000", "Georgia",
  "ST1500000000000", "Hawaii",
  "ST1600000000000", "Idaho",
  "ST1700000000000", "Illinois",
  "ST1800000000000", "Indiana",
  "ST1900000000000", "Iowa",
  "ST2000000000000", "Kansas",
  "ST2100000000000", "Kentucky",
  "ST2200000000000", "Louisiana",
  "ST2300000000000", "Maine",
  "ST2400000000000", "Maryland",
  "ST2500000000000", "Massachusetts",
  "ST2600000000000", "Michigan",
  "ST2700000000000", "Minnesota",
  "ST2800000000000", "Mississippi",
  "ST2900000000000", "Missouri",
  "ST3000000000000", "Montana",
  "ST3100000000000", "Nebraska",
  "ST3200000000000", "Nevada",
  "ST3300000000000", "New Hampshire",
  "ST3400000000000", "New Jersey",
  "ST3500000000000", "New Mexico",
  "ST3600000000000", "New York",
  "ST3700000000000", "North Carolina",
  "ST3800000000000", "North Dakota",
  "ST3900000000000", "Ohio",
  "ST4000000000000", "Oklahoma",
  "ST4100000000000", "Oregon",
  "ST4200000000000", "Pennsylvania",
  "ST4400000000000", "Rhode Island",
  "ST4500000000000", "South Carolina",
  "ST4600000000000", "South Dakota",
  "ST4700000000000", "Tennessee",
  "ST4800000000000", "Texas",
  "ST4900000000000", "Utah",
  "ST5000000000000", "Vermont",
  "ST5100000000000", "Virginia",
  "ST5300000000000", "Washington",
  "ST5400000000000", "West Virginia",
  "ST5500000000000", "Wisconsin",
  "ST5600000000000", "Wyoming"
) %>% 
  # The official variable ID for seasonally adjusted LAS statistics is "LAS" + state id + "03"
  # Again, I only figured this out by poking aroung the BLS customized tables page
  mutate(las_seasonally_adjusted = paste0("LAS", bls_id, "03"))


# This comes from the Census Bureau 
# https://en.wikipedia.org/wiki/List_of_regions_of_the_United_States
us_state_regions <- tribble(
  ~region, ~division, ~state,
  "Northeast", "New England", c("Connecticut", "Maine", "Massachusetts", "New Hampshire", "Rhode Island", "Vermont"),
  "Northeast", "Mid-Atlantic", c("New Jersey", "New York", "Pennsylvania"),
  "Midwest", "East North Central", c("Illinois", "Indiana", "Michigan", "Ohio", "Wisconsin"),
  "Midwest", "West North Central", c("Iowa", "Kansas", "Minnesota", "Missouri", "Nebraska", "North Dakota", "South Dakota"),
  "South", "South Atlantic", c("Delaware", "Florida", "Georgia", "Maryland", "North Carolina", "South Carolina", "Virginia", "District of Columbia", "West Virginia"),
  "South", "East South Central", c("Alabama", "Kentucky", "Mississippi", "Tennessee"),
  "South", "West South Central", c("Arkansas", "Louisiana", "Oklahoma", "Texas"),
  "West", "Mountain", c("Arizona", "Colorado", "Idaho", "Montana", "Nevada", "New Mexico", "Utah", "Wyoming"),
  "West", "Pacific", c("Alaska", "California", "Hawaii", "Oregon", "Washington")
) %>% 
  unnest(state)


# Get data from the BLS API
#
# You can only get 50 states at a time with the BLS API (only 25 without an API
# key), so we have to get the data in two chunks
unemployment_raw1 <- bls_api(state_lookup$las_seasonally_adjusted[1:50], 
                             startyear = 2006, endyear = 2016, Sys.getenv("BLS_KEY"))

unemployment_raw2 <- bls_api(state_lookup$las_seasonally_adjusted[51], 
                             startyear = 2006, endyear = 2016, Sys.getenv("BLS_KEY"))

# Combine the separate pieces into one raw data frame
unemployment_raw <- bind_rows(unemployment_raw1, unemployment_raw2) %>% 
  dateCast()  # Add time-series dates


# Clean up this data frame by removing unnecessary columns, joining in state
# names and region names, etc.
unemployment_clean <- unemployment_raw %>% 
  left_join(state_lookup, by = c("seriesID" = "las_seasonally_adjusted")) %>% 
  # Ignore the first letter in the month column (M) by only keeping characters #2-100
  # None of these actually are ever 100 characters long, but I used 100 just in case
  mutate(month = as.numeric(substr(period, 2, 100))) %>% 
  select(year, state, month, month_name = periodName, unemployment = value, date) %>% 
  left_join(us_state_regions, by = "state")


# Save this puppy so we don't have to keep hitting the BLS API
write_csv(unemployment_clean, "~/Desktop/unemployment.csv")
