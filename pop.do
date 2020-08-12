cscript

import delimited https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/totals/co-est2019-alldata.csv

generate fips = state*1000 + county
save census_popn, replace
