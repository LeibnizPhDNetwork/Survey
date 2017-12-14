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




* ============================================================================

/*
cd ${input}
unicode analyze "results_survey_2017-12-12.dta", redo
unicode encoding set ISO-8859-1
unicode translate "results_survey_2017-12-12.dta", transutf8*/																// tranlasting uncode strings (so we can see "ös and ßs")


* ============================================================================



* ============================================================================
* Section A
* ============================================================================



use "${input}/results_survey_2017-12-12.dta", clear

* start of PhD thesis (did not convert to appropriate time format;)


* Note: It would be nice if we had someone who has time to convert that into the appropriate time format.
* Unfortunately, I do not have time now bc I will be on vacacation starting on Monday.
/*
tab A_1__When_did_you_start_your_PhD

cap drop start_phd
gen start_phd = .
replace start_phd = A_1__When_did_you_start_your_PhD

label variable start_phd "Start of PhD thesis"

* expected submission date (did not convert to appropriate time format;)

tab A_2__When_do_you_expect_to_submi

cap drop expected_end_phd
gen expected_end = .
replace expected_end = A_2__When_do_you_expect_to_submi

label variable expected_end_phd "Expected submission date"

*/
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

* age

tab A_6__What_is_your_age_

cap drop age
gen age = .
replace age = A_6__What_is_your_age_

label variable age "Age"

* ============================================================================
* Section B
* ============================================================================

* Satsifaction

* tab B_1_How_satisfied_are_you_with_y

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

* level of payment

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

* maybe use that (Klartext, I guess) tab B_2_1__What_is_the_level_of_pay0

* income net ("I prefer not to answer" has been coded to missing)

tab B_2_2__What_is_your_personal_ave

cap drop income_net
gen income_net = .
replace income_net = 0 if B_2_2__What_is_your_personal_ave == "651 - 800"
replace income_net = 1 if B_2_2__What_is_your_personal_ave == "951 - 1100"
replace income_net = 2 if B_2_2__What_is_your_personal_ave == "1101 - 1250"
replace income_net = 3 if B_2_2__What_is_your_personal_ave == "1251 - 1400"
replace income_net = 4 if B_2_2__What_is_your_personal_ave == "1401 - 1550"
replace income_net = 5 if B_2_2__What_is_your_personal_ave == "1551 - 1700"
replace income_net = 6 if B_2_2__What_is_your_personal_ave == "1701 - 1850"
replace income_net = 7 if B_2_2__What_is_your_personal_ave == "1851 - 2000"
replace income_net = 8 if B_2_2__What_is_your_personal_ave == ">= 2001"

* working hours

* Someone has to destring working hours: A good way is to use "destring, force gen(...)" and then look at strings by hand.
* I suggest to use the median if respondendts indicate a range (e.g. 40-50 --> 56). We could already start.

* tab B_3__On_average__how_many_hours_
* tab B_4__On_average_in_the_last_6_mo

* distribution of working hours

* I am not entirely sure about whether I coded it right here, please double check with current survey

tab B_4__On_average_in_the_last_6_mo
*tab B_4__On_average_in_the_last_6_m0   <<<---- What about that ???

cap drop wh_p_phd
gen wh_p_phd = .
replace wh_p_phd = B_4__On_average_in_the_last_6_mo
label variable wh_p_phd "% of whs for PhD thesis"

tab B_4__On_average_in_the_last_6_m1

cap drop wh_p_res_pro
gen wh_p_res_pro = .
replace wh_p_res_pro = B_4__On_average_in_the_last_6_m1
label variable wh_p_res_pro "% of whs for research projects" 

tab B_4__On_average_in_the_last_6_m2

cap drop wh_p_teach
gen wh_p_teach = .
replace wh_p_teach = B_4__On_average_in_the_last_6_m2
label variable wh_p_teach "% of whs for teaching"

tab B_4__On_average_in_the_last_6_m3

cap drop wh_p_educ
gen wh_p_educ = .
replace wh_p_educ = B_4__On_average_in_the_last_6_m3
label variable wh_p_educ "% of whs for own education"

tab B_4__On_average_in_the_last_6_m4

cap drop wh_p_advisory
gen wh_p_advisory = .
replace wh_p_advisory = B_4__On_average_in_the_last_6_m4
label variable wh_p_advisory "% of whs for advisory"

tab B_4__On_average_in_the_last_6_m5

cap drop wh_p_funding
gen wh_p_funding = .
replace wh_p_funding = B_4__On_average_in_the_last_6_m5
label variable wh_p_funding "% of whs for funding"

tab B_4__On_average_in_the_last_6_m5

cap drop wh_p_funding
gen wh_p_funding = .
replace wh_p_funding = B_4__On_average_in_the_last_6_m5
label variable wh_p_funding "% of whs for funding"

tab B_4__On_average_in_the_last_6_m6

cap drop wh_p_pr
gen wh_p_pr = .
replace wh_p_pr = B_4__On_average_in_the_last_6_m6
label variable wh_p_pr "% of whs for PR"

tab B_4__On_average_in_the_last_6_m7

cap drop wh_p_present
gen wh_p_present = .
replace wh_p_present = B_4__On_average_in_the_last_6_m7
label variable wh_p_present"% of whs for scientific pres.s"

tab B_4__On_average_in_the_last_6_m8

cap drop wh_p_apl_res_fac
gen wh_p_apl_res_fac = .
replace wh_p_apl_res_fac = B_4__On_average_in_the_last_6_m8
label variable wh_p_apl_res_fac "% of whs for apl. res. facilities"

tab B_4__On_average_in_the_last_6_m9

cap drop wh_p_org_sc_meet
gen wh_p_org_sc_meet = .
replace wh_p_org_sc_meet = B_4__On_average_in_the_last_6_m9
label variable wh_p_org_sc_meet "% of whs for org. scientific meetings"

tab B_4__On_average_in_the_last_6_00

cap drop wh_p_reviewing
gen wh_p_reviewing = .
replace wh_p_reviewing = B_4__On_average_in_the_last_6_00
label variable wh_p_reviewing "% of whs for reviewing"

tab B_4__On_average_in_the_last_6_01

cap drop wh_p_superv
gen wh_p_superv = .
replace wh_p_superv = B_4__On_average_in_the_last_6_01
label variable wh_p_superv "% of whs for supervision"

tab B_4__On_average_in_the_last_6_02

cap drop wh_p_admin
gen wh_p_admin = .
replace wh_p_admin = B_4__On_average_in_the_last_6_02
label variable wh_p_admin "% of whs for administration"

tab B_4__On_average_in_the_last_6_03

cap drop wh_p_other
gen wh_p_other = .
replace wh_p_other = B_4__On_average_in_the_last_6_03
label variable wh_p_other "% of whs for other tasks"





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

* ever thought of quitting phd (N/A coded as missing)

tab B_15__Have_you_ever_thought_of_n

cap drop thought_quitting
gen thought_quitting = .
replace thought_quitting = 1 if B_15__Have_you_ever_thought_of_n == "Yes"
replace thought_quitting = 0 if B_15__Have_you_ever_thought_of_n == "No"

label variable thought_quitting "Thought of quitting PhD"
label define thought_quittingl 0 "No" 1 "Yes"
label variable thought_quitting thought_quittingl




* ============================================================================
* Section E
* ============================================================================

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

* number of children

* E_3__How_many_people_live_in_yo0 E_3__How_many_people_live_in_you

* ============================================================================

* Note to the the lime Survey group: Is it possible to disinguish between children
* and adults in the hh?


* ============================================================================

* childrenhh ("I prefer not to answer." coded as missing)

tab E_2__Do_you__or_your_partner__ha

cap drop children
gen children = .
replace children = 1 if E_2__Do_you__or_your_partner__ha == "Yes"
replace children = 0 if E_2__Do_you__or_your_partner__ha == "No"

label variable children "Children in HH"
label define childrenl 0 "No" 1 "Yes"
label variable children childrenl



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

* ============================================================================
* Section F
* ============================================================================


* Leibniz Network (knowledge of; N/A coded as missing)

tab F_1__Did_you_know_about_the_Leib

cap drop know_phdnet
gen know_phdnet = .
replace know_phdnet = 1 if F_1__Did_you_know_about_the_Leib == "Yes"
replace know_phdnet = 0 if F_1__Did_you_know_about_the_Leib == "No"

label variable know_phdnet "Knowledge about PhD network"
label define know_phdnetl 0 "No" 1 "Yes"
label variable know_phdnet know_phdnetl


* ============================================================================


numlabel, add																											// add numbers to the variable labels

save "${output}/final_data.dta", replace
