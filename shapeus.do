cscript

spshape2dta ./cb_2018_us_county_500k/cb_2018_us_county_500k.shp,  saving(usacounties) replace
use usacounties.dta, clear
generate fips = real(GEOID)
save usacounties.dta, replace	
