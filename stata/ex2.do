/*
	http://gddata.gd.gov.cn/data/dataSet/toDataDetails/29000_01300008
*/

cscript

version 16

use fileinfo.dta, clear
sort date
list if date[_n] != date[_n-1] + 1 & _n > 1

/* 
	* 12mar2020 repreated twice
	* 22apr2020 is missing		
*/