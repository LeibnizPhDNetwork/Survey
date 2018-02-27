# This is the documentation of the first survey of the Leibniz PhD Network

# Guidelines for the data retrival




Code binary variables such that 0 refers to "No" and 1 to "Yes" 
Always begin categorical variables with 1 and start with the lowest category (e.g. Very dissatisfied; Less than 25; <=; Fully disagree)
Code the following answers as follows:
„Don’t know“ to 99
„Prefer not to answer“ to 98
 „Other“ to 97
Keep original names of the vriables, e.g. „c_4“
Example for a loop:
 

(Bsp: foreach v of var c_* {

                encode `v', gen(`v'_n) 

}

keep the items as labels, e.g. c_4 „work areas prefered after PhD“
