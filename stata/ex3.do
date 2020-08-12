/*
	http://gddata.gd.gov.cn/data/dataSet/toDataDetails/29000_01300008
*/

cscript

version 16

use fileinfo.dta, clear
sort cols date
by cols : list cols date if _n==1, clean 
