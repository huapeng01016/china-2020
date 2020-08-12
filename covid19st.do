cscript

import delimited https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv
desc
rename v83 confirmed
drop if missing(fips)
save covid19_adj, replace


/* merge the files and calculate adjusted counts */
merge 1:1 fips using usacounties.dta
keep if _merge == 3
drop _merge

/* mereg into census population data */
merge 1:1 fips using census_popn
keep if _merge == 3

generate confirmed_adj = 100000*(confirmed/popestimate2019)
label var confirmed_adj "Cases per 100,000"
format %16.0fc confirmed_adj

save covid19_adj, replace

grmap, activate
drop if province_state == "Alaska" | province_state == "Hawaii"
spset, modify shpfile(usacounties_shp)
grmap confirmed_adj, clnumber(7)
