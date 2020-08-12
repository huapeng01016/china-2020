/*
	http://gddata.gd.gov.cn/data/dataSet/toDataDetails/29000_01300008
*/

cscript

version 16

frame create fileinfo str500 file long(date rows cols) str2000 header 
frame fileinfo : format %td date


local files : dir "./广东数据" files "*.xlsx"
foreach file in `files' {
			import excel "./广东数据/`file'", clear
		
			/* find out the date */
			if ustrword(A[2], 4) == "年" {
				local year = ustrword(A[2], 3)	
			}
			
			if ustrword(A[2], 6) == "月" {
				local month = ustrword(A[2], 5)	
			}
			
			if ustrword(A[2], 8) == "日" {
				local day = ustrword(A[2], 7)	
			}

			if "`year'" == "" | "`month'" == "" | "`day'" == "" {
di as error "can not find date!"
exit 198				
			}
			
			local date = date("`month'-`day'-`year'", "MDY")
			
			/* remove all missing vars */
			qui desc
			local varno = `r(k)'
			qui ds
			local varlist = "`r(varlist)'"
			forval i=1/`varno' {
				local var : word `i' of `varlist'
				cap assert `var' >= .
				if _rc == 0 {
					drop `var'
				}
			}
			
			/* get header */
			/* find where data starts */
			gen `c(obs_t)' id = _n
			summarize id if A=="1" | ustrpos(A, "市") == 3
			local min = `r(min)'-1
			di `min'			
			drop id

			qui desc			
			local varno = `r(k)'
			local obsno = `r(N)'
			qui ds
			local varlist = "`r(varlist)'"

			local header = ""
			forval obs = 3/`min' {
				if strtrim(A[`obs']) != "合计" & strtrim(B[`obs']) != "合计" {
					forval i=1/`varno' {
						local varname : word `i' of `varlist'
						local header = "`header'" + "`obs'" + strtrim(`varname'[`obs'])	
					}
				}
			}
			
			frame post fileinfo ("`file'") (`date') (`obsno') (`varno') ("`header'")		
}

frame fileinfo : save fileinfo1.dta, replace
exit
