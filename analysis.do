* ============================================================================
* Date: Decemeber 2017
* Project: Leibniz PhD Network Survey 
*
* This program is intended to give provide a first glance on the socio-
* demographics.
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


/*

A lot of summaries and nice figures on:

gender composition
foreigners
age groups
parents
...



(and these statistics also cond. on sections)

We should consider spliiting these tasks so we do not have to work all on the
same file.

If we do graphs, we should settle on a graph scheme.

*/




* ============================================================================

save "${output}/final_data.dta", clear

