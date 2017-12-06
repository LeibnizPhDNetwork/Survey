* ============================================================================
* Date: Decemeber 2017
* Project: Leibniz PhD Network Survey 
*
* This program is intended to transform the raw data into a working sample
* 
* database used:	- XXX.dta
* 
* output:			- XXX.dta
*
* key variables:	- XXX
*					- YYY
*					- ...
*
* ============================================================================


clear all	
clear matrix
set more off
capture log close



global input "H://..."			// macro for data input
global output "H://..."			// macro for data output
global temp "H://..."			// macro for temp data




* ============================================================================

use "${input}/surveydata.dta", clear


* ============================================================================


* A lot of data cleaning and recoding *



* ============================================================================

save "${output}/final_data.dta", clear

