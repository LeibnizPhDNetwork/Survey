* ============================================================================
* Date: January 2018
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


global input "H:\PRIVAT\Leibniz PhD Network\Leibniz PhD survey\Data\input"			// macro for data input
global output "H:\PRIVAT\Leibniz PhD Network\Leibniz PhD survey\Data\output"			// macro for data output
global temp "H:\PRIVAT\Leibniz PhD Network\Leibniz PhD survey\Data\temp"			// macro for temp data




* ============================================================================

/*
cd ${input}
unicode analyze "results_survey_2017-12-12.dta", redo
unicode encoding set ISO-8859-1
unicode translate "results_survey_2017-12-12.dta", transutf8*/																// tranlasting uncode strings (so we can see "ös and ßs")


* ============================================================================

* ============================================================================
* First data editing
* ============================================================================


use "${input}/results-survey-2018-02-05.dta", clear

drop url 
drop if id == 33 // Drop one observation as it was a pretest interview


* ============================================================================
* Section A
* ============================================================================

* start of PhD thesis 

tab a_1
cap drop start_phd

gen startphd_1 = substr(a_1,1,4)
destring startphd_1, gen(startphd_year)
label variable startphd_year "Year PhD thesis has been started"
drop startphd_1

/* Can be used for further generation of variables (e.g. duration of PhD, etc.) */
gen startphd_2 = substr(a_1,6,2)
destring startphd_2, gen(startphd_month)
label variable startphd_month "Month PhD thesis has been started"
drop startphd_2

*gen start_phd = .
*replace start_phd = A_1__When_did_you_start_your_PhD
*label variable start_phd "Start of PhD thesis"

* expected submission date (did not convert to appropriate time format;)
tab a_2
cap drop expected_end_phd

gen endphd_1 = substr(a_2,1,4)
destring endphd_1, gen(endphd_year)
label variable endphd_year "Expected submission year"
drop endphd_1

/* Can be used for further generation of variables (e.g. duration of PhD, etc.) */
gen endphd_2 = substr(a_2,6,2)
destring endphd_2, gen(endphd_month)
label variable endphd_month "Expected submission month"
drop endphd_2

*gen expected_end = .
*replace expected_end = A_2__When_do_you_expect_to_submi
*label variable expected_end_phd "Expected submission date"

* section
tab a_3

cap drop section
gen section = .
replace section = 1 if a_3 == "Section A: Humanities and Educational Research"
replace section = 2 if a_3 == "Section B: Economics, Social Sciences, Spatial Research"
replace section = 3 if a_3 == "Section C: Life Sciences"
replace section = 4 if a_3 == "Section D: Mathematics, Natural Sciences, Engineering"
replace section = 5 if a_3 == "Section E: Environmental Research"

label variable section "Section of the Leibniz Association"
cap label drop
label define sectionl 1 "Sec. A" 2 "Sec. B" 3 "Sec. C" 4 "Sec. D" 5 "Sec. E", replace
label values section sectionl

* citizenship

tab a_4

cap drop citizenship
gen citizenship = .
replace citizenship = 1 if a_4 == "only German"
replace citizenship = 2 if a_4 == "German and others"
replace citizenship = 3 if a_4 == "other citizenship of an EU-member country"
replace citizenship = 4 if a_4 == "other citizenship outside the EU"

label variable citizenship "Citizenship"
cap label drop citizenshipl
label define citizenshipl 1 "Only German" 2 "German and others" 3 "Other EU-member country" 4 "Non EU-member country"
label values citizenship citizenshipl

* gender ("I prefer not to answer" has been coded as missing.)

tab a_5

cap drop female
gen female = .
replace female = 1 if a_5 == "Female"
replace female = 0 if a_5 == "Male"

label variable female "Female"
cap label drop femalel
label define femalel 0 "Male" 1 "Female"
label values female femalel

* age

tab a_6

cap drop age
gen age = .
replace age = a_6
label variable age "Age"

recode age (20/25 = 1) (26/30 = 2) (31/35 = 3) (36/50 = 4), gen(age_groups)

label define age_groupsl 1 "20 to 25" 2 "26 to 30" 3 "31 to 35" 4 "Older than 35"
label value age_groups age_groupsl


/* IDEA: Insert lower age group (<25) and upper age group (>35)? */

* ============================================================================
* Section B
* ============================================================================

* Satsifaction

tab b_1

cap drop satisfaction
gen satisfaction = .
replace satisfaction = 0 if b_1 == "Very dissatisfied"
replace satisfaction = 1 if b_1 == "Dissatisfied"
replace satisfaction = 2 if b_1 == "Rather dissatisfied"
replace satisfaction = 3 if b_1 == "Rather satisfied"
replace satisfaction = 4 if b_1 == "Satisfied"
replace satisfaction = 5 if b_1 == "Very satisfied"

label variable satisfaction "General Satisfaction situation at Leibniz Institute or Reserach Museum."
cap label drop satisfactionl
label define satisfactionl 0 "Very dissatisfied" 1 "Dissatisfied" 2 "Rather dissatisfied" 3 "Rather satisfied" 4 "Satisfied" 5 "Very satisfied"
label values satisfaction satisfactionl

* contract
tab b_2

cap drop contract
gen contract = .
replace contract = 0 if b_2 == "I don't know"
replace contract = 1 if b_2 == "Working contract"
replace contract = 2 if b_2 == "I have no funding/payment"
replace contract = 3 if b_2 == "Other"
replace contract = 4 if b_2 == "Stipend (by your institute)"
replace contract = 5 if b_2 == "Stipend (other)"
replace contract = 6 if b_2 == "Both, stipend and contract"

label variable contract "Type of funding"

# delimit ;
label define contractl 0 "I don't know" 1 "Working contract" 2 "I have no funding/payment"
3 "Other" 4 "Stipend (by your institute)" 5 "Stipend (other)" 6 "Both, stipend and contract", replace;
# delimit cr
label values contract contractl

* level of payment

gen b_2_1_new = substr(b_2_1,1,12) // creating a new variable as STATA had a problem reading special characters!

tab b_2_1_new

tab b_2_1a

cap drop salary_percent
gen salary_percent = .
replace salary_percent = 0 if b_2_1_new == "I don't know"
replace salary_percent = 1 if b_2_1_new == "100% E13 (TV"
replace salary_percent = 2 if b_2_1_new == "76 - 99% E13"
replace salary_percent = 3 if b_2_1_new == "66 - 75% E13"
replace salary_percent = 4 if b_2_1_new == "51 - 65% E13"
replace salary_percent = 5 if b_2_1_new == "50% E13 (TV-"
replace salary_percent = 6 if b_2_1_new == "25 - 49% E13"
replace salary_percent = 7 if b_2_1_new == "Less than 25"
replace salary_percent = 8 if b_2_1_new == "Other"

label variable salary_percent "%-level of salary of E13"
label define salary_percentl 0 "I don't know" 1 "100%" 2 "76 - 99%" 3 "66 - 75%" 4 "51 - 65%" 5 "50%" 6 "25 - 49%" 7 "< 25%" 8 "Other"
label values salary_percent salary_percentl

tab salary_percent b_2_1_new, m // controlling
tab salary_percent, m
drop b_2_1_new

* maybe use that (Klartext, I guess) tab B_2_1__What_is_the_level_of_pay0

* income net ("I prefer not to answer" has been coded to missing)

tab b_2_2

gen b_2_2_new = substr(b_2_2,1,3) // creating a new variable as STATA had a problem reading special characters!

/* Was ist mit Nebeneinkünften? In Zukunft abfragen! */
cap drop income_net
gen income_net = .
replace income_net = 0 if b_2_2_new == "<= " // <=500 
replace income_net = 1 if b_2_2_new == "501" // 501 - 650
replace income_net = 2 if b_2_2_new == "651" // 651 - 800
replace income_net = 3 if b_2_2_new == "801" // 801 - 950
replace income_net = 4 if b_2_2_new == "951" // 951 - 1100
replace income_net = 5 if b_2_2_new == "110" // 1101 - 1250
replace income_net = 6 if b_2_2_new == "125" // 1251 - 1400
replace income_net = 7 if b_2_2_new == "140" // 1401 - 1550
replace income_net = 8 if b_2_2_new == "155" // 1551 - 1700
replace income_net = 9 if b_2_2_new == "170" // 1701 - 1850
replace income_net = 10 if b_2_2_new == "185" // 1851 - 2000
replace income_net = 11 if b_2_2_new == ">= " // >= 2001"

label define income_netl ///
0 "<= 500 EURO" /// 
1 "501 - 650 EURO" /// 
2 "651 - 800 EURO" /// 
3 "801 - 950 EURO" /// 
4 "951 - 1100 EURO" /// 
5 "1101 - 1250 EURO" ///
6 "1251 - 1400 EURO" /// 
7 "1401 - 1550 EURO" /// 
8 "1551 - 1700 EURO" /// 
9 "1701 - 1850 EURO" ///
10 "1851 - 2000 EURO" /// 
11 ">= 2001 EURO"
label values income_net income_netl

tab income_net b_2_2 // controlling
*/

* working hours

* Someone has to destring working hours: A good way is to use "destring, force gen(...)" and then look at strings by hand.
* I suggest to use the median if respondendts indicate a range (e.g. 40-50 --> 56). We could already start.

* On average, how many hours do you typically work per week in total?
tab b_3 
tab b_3a

* tab B_4__On_average_in_the_last_6_mo

* distribution of working hours

* I am not entirely sure about whether I coded it right here, please double check with current survey

*tab B_4__On_average_in_the_last_6_m0   <<<---- What about that ???

cap drop wh_p_phd
gen wh_p_phd = .
replace wh_p_phd = b_4a
label variable wh_p_phd "% of whs for PhD thesis"
sum wh_p_phd, d

recode wh_p_phd (0/25 = 1) (26/50 = 2) (51/75 = 3) (75/100 = 4), gen(groups_wh_p_phd)
label define groups_wh_phdl ///
1 "Less than 25%" ///
2 "26 to 50%" ///
3 "51 to 75%" ///
4 "More than 75%"
label values groups_wh_p_phd groups_wh_phdl

/* JLS: MUSS NOCH AKTUALISIERT WERDEN
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
*/

* Duration of the contract 
tab b_5

cap drop duration_contract
gen duration_contract = .

replace duration_contract = 1 if b_5 == "Up to 6 months"
replace duration_contract = 2 if b_5 == "Up to 12 months"
replace duration_contract = 3 if b_5 == "Up to 18 months"
replace duration_contract = 4 if b_5 == "Up to 24 months"
replace duration_contract = 5 if b_5 == "Up to 36 months"
replace duration_contract = 6 if b_5 == "More than 36 months"
replace duration_contract = 99 if b_5 == "I don't know."

label define durationl ///
1 "Up to 6 months" ///
2 "Up to 12 months" ///
3 "Up to 18 months" /// 
4 "Up to 24 months" /// 
5 "Up to 36 months" ///
6 "More than 36 months" ///
99 "I don't know."
label values duration_contract durationl


*** "Please rate the supervision provided by your first/main supervisor

label define supervisionl ///
-2 "Fully disagree" ///
-1 "Partially disagree" ///
0 "Neither agree nor disagree" ///
1 "Partially agree" ///
2 "Fully agree" ///
99 "I prefer not to answer."

* My supervisor treats me politely"
tab b_12h

cap drop supervision_politely
gen supervision_politely = .

replace supervision_politely = -2 if b_12h == "Fully disagree"
replace supervision_politely = -1 if b_12h == "Partially disagree"
replace supervision_politely = 0 if b_12h == "Neither agree nor disagree"
replace supervision_politely = 1 if b_12h == "Partially agree"
replace supervision_politely = 2 if b_12h == "Fully agree"
replace supervision_politely = 99 if b_12h == "I prefer not to answer"

label variable supervision_politely "Supervisor treats me politely"
label values supervision_politely supervisionl


* phd council

tab b_14

cap drop phd_council
gen phd_council = .
replace phd_council = 0 if b_14 == "I don't know."
replace phd_council = 1 if b_14 == "No"
replace phd_council = 2 if b_14 == "Yes"

label variable phd_council "Existence of PhD Council"
cap label drop phd_councill
label define phd_councill 0 "I don't know." 1 "No" 2 "Yes"
label value phd_council phd_councill

* ever thought of quitting phd (N/A coded as missing)

tab b_15

cap drop thought_quitting
gen thought_quitting = .
replace thought_quitting = 1 if b_15 == "Yes"
replace thought_quitting = 0 if b_15 == "No"

label variable thought_quitting "Thought of quitting PhD"
label define thought_quittingl 0 "No" 1 "Yes"
label value thought_quitting thought_quittingl

*** What was/were the reason(s) for thinking about not continuing your doctorate? 

label define reason_quittingl ///
0 "No" ///
1 "Yes"

* Work-related difficulties with my supervisor
tab b_15_1e

cap drop reasons_wldiff
gen reasons_wldiff = .

replace reasons_wldiff = 0 if b_15_1e == "No"
replace reasons_wldiff = 1 if b_15_1e == "Yes"

label variable reasons_wldiff "Thought quitting? Work-related difficulties with supervisor"
label values reasons_wldiff reason_quittingl

* Personal difficulties with my supervisor
tab b_15_1f

cap drop reasons_pdiff
gen reasons_pdiff = .

replace reasons_pdiff = 0 if b_15_1f == "No"
replace reasons_pdiff = 1 if b_15_1f == "Yes"

label variable reasons_pdiff "Thought quitting? Personal difficulties with supervisor"
label values reasons_pdiff reason_quittingl


* ============================================================================
* Section E
* ============================================================================

* marital status ("prefer not to say" has been coded as missing)

tab e_1

cap drop marital_status
gen marital_status = .
replace marital_status = 1 if e_1 == "I have a partner/wife/husband"
replace marital_status = 0 if e_1 == "Single"

label variable marital_status "Marital status"
cap label drop
label define marital_statusl 0 "Single" 1 "Partner"
label value marital_status marital_statusl

* number of children

* E_3__How_many_people_live_in_yo0 E_3__How_many_people_live_in_you

* ============================================================================

* Note to the the lime Survey group: Is it possible to disinguish between children
* and adults in the hh?


* ============================================================================

* childrenhh ("I prefer not to answer." coded as missing)

tab e_2

cap drop children
gen children = .
replace children = 1 if e_2 == "Yes"
replace children = 0 if e_2 == "No"

label variable children "Children in HH"
label define childrenl 0 "No" 1 "Yes"
label value children childrenl

* age youngest child ("Prefer not to answer" has been coded as missing)

tab e_3_1

cap drop age_child
gen age_child = .
replace age_child = 1 if e_3_1 == "< 1 year"
replace age_child = 2 if e_3_1 == "1 - 2 years"
replace age_child = 3 if e_3_1 == "3 - 6 years"
replace age_child = 4 if e_3_1 == "7 - 10 years"
replace age_child = 5 if e_3_1 == "11 - 14 years"

label variable age_child "Age youngest child"
label define age_childl ///
1 "< 1 year" ///
2 "1 - 2 years" ///
3 "3 - 6 years"  ///
4 "7 - 10 years" ///
5 "11 - 14 years", replace
label value age_child age_childl

* ============================================================================
* Section F
* ============================================================================


* Leibniz Network (knowledge of; N/A coded as missing)

tab f_1

cap drop know_phdnet
gen know_phdnet = .
replace know_phdnet = 1 if f_1 == "Yes"
replace know_phdnet = 0 if f_1 == "No"

label variable know_phdnet "Knowledge about PhD network"
label define know_phdnetl 0 "No" 1 "Yes"
label value know_phdnet know_phdnetl


* ============================================================================


numlabel, add																											// add numbers to the variable labels

save "${output}/final_data.dta", replace
