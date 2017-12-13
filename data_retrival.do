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




global input "H:\leibnizSurvey\input\"			// macro for data input
global output "H:\leibnizSurvey\output\"			// macro for data output
global temp "H:\leibnizSurvey\temp\"			// macro for temp data


cd ${input}

* ============================================================================
unicode analyze "results_survey_2017-12-12.dta", redo
unicode encoding set ISO-8859-1
unicode translate "results_survey_2017-12-12.dta", transutf8

use "${input}/results_survey_2017-12-12.dta", clear


* ============================================================================


* gender ("I prefer not to answer" has been coded as missing.)

tab A_5__What_is_your_gender_

cap drop female
gen female = .
replace female = 1 if A_5__What_is_your_gender_ == "Female"
replace female = 0 if A_5__What_is_your_gender_ == "Male"

label variable female "Female"
cap label drop femalel
label define femalel 0 "Male" 1 "Female"
label values female femalel

* citizenship

tab A_4__What_is_your_citizenship_

cap drop citizenship
gen citizenship = .
replace citizenship = 1 if A_4__What_is_your_citizenship_ == "only German"
replace citizenship = 2 if A_4__What_is_your_citizenship_ == "German and others"
replace citizenship = 3 if A_4__What_is_your_citizenship_ == "other citizenship of an EU-member country"
replace citizenship = 4 if A_4__What_is_your_citizenship_ == "other citizenship outside the EU"

label variable citizenship "Citizenship"
cap label drop citizenshipl
label define citizenshipl 1 "Only German" 2 "German and others" 3 "Other EU-member country" 4 "Non EU-member country"
label values citizenship citizenshipl

* age

tab A_6__What_is_your_age_

cap drop age
gen age = .
replace age = A_6__What_is_your_age_

label variable age "Age"

* Satsifaction

cap drop satisfaction
gen satisfaction = .
replace satisfaction = 0 if B_1_How_satisfied_are_you_with_y == "Very dissatisfied"
replace satisfaction = 1 if B_1_How_satisfied_are_you_with_y == "Dissatisfied"
replace satisfaction = 2 if B_1_How_satisfied_are_you_with_y == "Rather dissatisfied"
replace satisfaction = 3 if B_1_How_satisfied_are_you_with_y == "Rather satisfied"
replace satisfaction = 4 if B_1_How_satisfied_are_you_with_y == "Satisfied"
replace satisfaction = 5 if B_1_How_satisfied_are_you_with_y == "Very satisfied"

label variable satisfaction "General Satisfaction situation at Leibniz Institute or Reserach Museum."
cap label drop satisfactionl
label define satisfactionl 0 "Very dissatisfied" 1 "Dissatisfied" 2 "Rather dissatisfied" 3 "Rather satisfied" 4 "Satisfied" 5 "Very satisfied"
label values satisfaction satisfactionl

* phd council

tab B_14__Do_you_have_a_PhD_council_

cap drop phd_council
gen phd_council = .
replace phd_council = 0 if B_14__Do_you_have_a_PhD_council_ == "I don't know."
replace phd_council = 1 if B_14__Do_you_have_a_PhD_council_ == "No"
replace phd_council = 2 if B_14__Do_you_have_a_PhD_council_ == "Yes"

label variable phd_council "Existence of PhD Council"
cap label drop phd_councill
label define phd_councill 0 "I don't know." 1 "No" 2 "Yes"
label values phd_council phd_councill

* marital status ("prefer not to say" has been coded as missing)

tab E_1__What_is_your_current_family

cap drop marital_status
gen marital_status = .
replace marital_status = 1 if E_1__What_is_your_current_family == "I have a partner/wife/husband"
replace marital_status = 0 if E_1__What_is_your_current_family == "Single"

label variable marital_status "Marital status"
cap label drop
label define marital_statusl 0 "Single" 1 "Partner"
label values marital_status marital_statusl

* section

tab A_3__Which_section_of_the_Leibni

cap drop section
gen section = .
replace section = 1 if A_3__Which_section_of_the_Leibni == "Section A: Humanities and Educational Research"
replace section = 2 if A_3__Which_section_of_the_Leibni == "Section B: Economics, Social Sciences, Spatial Research"
replace section = 3 if A_3__Which_section_of_the_Leibni == "Section C: Life Sciences"
replace section = 4 if A_3__Which_section_of_the_Leibni == "Section D: Mathematics, Natural Sciences, Engineering"
replace section = 5 if A_3__Which_section_of_the_Leibni == "Section E: Environmental Research"

label variable section "Section of the Leibniz Association"
cap label drop
label define sectionl 1 "Section A" 2 "Section B" 3 "Section C" 4 "Section D" 5 "Section E"
label values section sectionl

* Leibniz Network (knowledge of; N/A coded as missing)

tab F_1__Did_you_know_about_the_Leib

cap drop know_phdnet
gen know_phdnet = .
replace know_phdnet = 1 if F_1__Did_you_know_about_the_Leib == "Yes"
replace know_phdnet = 0 if F_1__Did_you_know_about_the_Leib == "No"

label variable know_phdnet "Knowledge about PhD network"
label define know_phdnetl 0 "No" 1 "Yes"
label variable know_phdnet know_phdnetl

* childrenhh ("I prefer not to answer." coded as missing)

tab E_2__Do_you__or_your_partner__ha

cap drop children
gen children = .
replace children = 1 if E_2__Do_you__or_your_partner__ha == "Yes"
replace children = 0 if E_2__Do_you__or_your_partner__ha == "No"

label variable children "Children in HH"
label define childrenl 0 "No" 1 "Yes"
label variable children childrenl

* number of children

* E_3__How_many_people_live_in_yo0 E_3__How_many_people_live_in_you

* ============================================================================

* Note to the the lime Survey group: Is it possible to disinguish between children
* and adults in the hh?


* ============================================================================

* age youngest child ("Prefer not to answer" has been coded as missing)

tab E_3_1_How_old_is_the_youngest_ch

cap drop age_child
gen age_child = .
replace age_child = 1 if E_3_1_How_old_is_the_youngest_ch == "1 - 2 years"
replace age_child = 2 if E_3_1_How_old_is_the_youngest_ch == "11 - 14 years"
replace age_child = 3 if E_3_1_How_old_is_the_youngest_ch == "3 - 6 years"
replace age_child = 4 if E_3_1_How_old_is_the_youngest_ch == "7 - 10 years"
replace age_child = 5 if E_3_1_How_old_is_the_youngest_ch == "< 1 year"

label variable age_child "Age youngest child"
label define age_childl 1 "1 - 2 years" 2 "11 - 14 years" 3 "3 - 6 years" 4 "7 - 10 years" 5 "< 1 year"
label variable age_child age_childl

* ever thought of quitting phd (N/A coded as missing)

tab B_15__Have_you_ever_thought_of_n

cap drop thought_quitting
gen thought_quitting = .
replace thought_quitting = 1 if B_15__Have_you_ever_thought_of_n == "Yes"
replace thought_quitting = 0 if B_15__Have_you_ever_thought_of_n == "No"

label variable "Thought of quitting PhD"
label define thought_quittingl 0 "No" 1 "Yes"
label variable thought_quitting thought_quittingl

* contract
tab B_2__On_what_contract_are_you_wo

cap drop contract
gen contract = .
replace contract = 0 if B_2__On_what_contract_are_you_wo == "I don't know"
replace contract = 1 if B_2__On_what_contract_are_you_wo == "Working contract"
replace contract = 2 if B_2__On_what_contract_are_you_wo == "I have no funding/payment"
replace contract = 3 if B_2__On_what_contract_are_you_wo == "Other"
replace contract = 4 if B_2__On_what_contract_are_you_wo == "Stipend (by your institute)"
replace contract = 5 if B_2__On_what_contract_are_you_wo == "Stipend (other)"
replace contract = 6 if B_2__On_what_contract_are_you_wo == "Both, stipend and contract"

label variable contract "Type of funding"

# delimit ;
label define contractl 0 "I don't know" 1 "Working contract" 2 "I have no funding/payment"
3 "Stipend (by your institute)" 4 "Stipend (by your institute)" 5 "Stipend (other)" 6 "Both, stipend and contract";
# delimit cr

label variable contract contractl

tab B_2_1__What_is_the_level_of_paym

cap drop salary_percent
gen salary_percent = .
replace salary_percent = 0 if B_2_1__What_is_the_level_of_paym == "I don't know."
replace salary_percent = 1 if B_2_1__What_is_the_level_of_paym == "100% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 2 if B_2_1__What_is_the_level_of_paym == "76 - 99% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 3 if B_2_1__What_is_the_level_of_paym == "66 - 75% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 4 if B_2_1__What_is_the_level_of_paym == "51 - 65% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 5 if B_2_1__What_is_the_level_of_paym == "50% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 6 if B_2_1__What_is_the_level_of_paym == "25 - 49% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 7 if B_2_1__What_is_the_level_of_paym == "Less than 25% E13 (TV-L, TVÖD-Bund, TVÜ etc.)"
replace salary_percent = 8 if B_2_1__What_is_the_level_of_paym == "Other"

label variable salary_percent "%-level of salary of E13"
label define salary_percent 0 "I don't know." 1 "100%" 2 "76 - 99%" 3 "66 - 75%" 4 "51 - 65%" 5 "50%" 6 "25 - 49%" 7 "< 25%" 8 "Other"


* ============================================================================


numlabel, add

save "${output}/final_data.dta", replace
