clear all

cd "~/Dropbox/Asymmetric credulity/data/7_replicationfiles"
insheet using "rawdata_tess.csv", clear

gen pidr2 = partyid7
replace pidr2 = . if pidr2==-1

recode pidr2 (1 2 3 5 6 7 = 0) (4 = 1), gen(pureind)
recode pidr2 (1 2 = 1) (3 4 5 6 7 = 0), gen(dem_e) // democratic, exclusive
recode pidr2 (1 2 3 = 1) (4 5 6 7 = 0), gen(dem_i) // democratic, inclusive
recode pidr2 (6 7 = 1) (1 2 3 4 5 = 0), gen(rep_e) // republican, exclusive
recode pidr2 (5 6 7 = 1) (1 2 3 4 = 0), gen(rep_i) // republican, inclusive

gen pidr = (pidr2-1) / 6

recode pidr2 (1 7 = 4) (2 6 = 3) (3 5 = 2) (4 = 1), gen(pidstr2)
gen pidstr = (pidstr2 - 1) / 3

recode pidr2 (1/3=1) (5/7=2) (4=3), gen(pid3c)
recode pidr2 (1/3=1) (4/8=0), gen(democrat)
recode pidr2 (1/4=0) (5/8=1), gen(republican)

* Ideology
recode ideo (-1 8= .), gen(ideology2)
recode ideology2 (1 2 3 = 0) (4=.) (5 6 7=1), gen(cons_i)
gen ideology = (ideology - 1)/6

recode ideology2 (0/3 = 0) (4=.) (5/7=1), gen(conservative)
gen liberal = 1-conservative

recode q5 (4 = 1) (3 = 2) (2 = 3) (1 = 4) (98=.), gen(trust_gov2)
recode q6 (4 = 1) (3 = 2) (2 = 3) (1 = 4) (98=.), gen(trust_media2)

alpha trust_gov2 trust_media2 // .42
gen trust = ((trust_gov2 + trust_media2) - 2) / 6

recode q2 (5 = 1) (4 = 2) (3 = 3) (2 = 4) (1 = 5) (98 = .), gen(ohio2) 
recode q3 (5 = 1) (4 = 2) (3 = 3) (2 = 4) (1 = 5) (98 = .), gen(wisconsin2) 
recode q4 (5 = 1) (4 = 2) (3 = 3) (2 = 4) (1 = 5) (98 = .), gen(oil2) 

gen ohio = (ohio2 - 1) / 4
gen wisconsin = (wisconsin2 - 1) / 4
gen oil = (oil2 - 1) / 4

gen rum_ohio = ohio
gen rum_wisc = wisconsin
gen rum_oil = oil

gen consis_ohio = .
replace consis_ohio = 1 if dem_i==1 & q2_insert==1
replace consis_ohio = 0 if dem_i==1 & q2_insert==0
replace consis_ohio = 1 if rep_i==1 & q2_insert==0
replace consis_ohio = 0 if rep_i==1 & q2_insert==1
replace consis_ohio = 1 if pidr2==4 & q2_insert==0 // arbitrarily code pure independents as Republicans
replace consis_ohio = 0 if pidr2==4 & q2_insert==1

gen consis_wisc = .
replace consis_wisc = 1 if dem_i==1 & q3_insert==0
replace consis_wisc = 0 if dem_i==1 & q3_insert==1
replace consis_wisc = 1 if rep_i==1 & q3_insert==1
replace consis_wisc = 0 if rep_i==1 & q3_insert==0
replace consis_wisc = 1 if pidr2==4 & q3_insert==1 // arbitrarily code pure independents as Republicans
replace consis_wisc = 0 if pidr2==4 & q3_insert==0

gen gop_ohio = .
replace gop_ohio = 1 if q2_insert==1
replace gop_ohio = 0 if q2_insert==0

gen gop_wisc = 1-gop_ohio

* Consistency with respect to ideology, rather than partisanship
gen iconsis_ohio = .
replace iconsis_ohio = 1 if liberal==1 & q2_insert==1
replace iconsis_ohio = 0 if liberal==1 & q2_insert==0
replace iconsis_ohio = 1 if conservative==1 & q2_insert==0
replace iconsis_ohio = 0 if conservative==1 & q2_insert==1
replace iconsis_ohio = 1 if ideology2==4 & q2_insert==0 // arbitrarily code pure moderates as conservatives
replace iconsis_ohio = 0 if ideology2==4 & q2_insert==1

gen iconsis_wisc = .
replace iconsis_wisc = 1 if liberal==1 & q3_insert==0
replace iconsis_wisc = 0 if liberal==1 & q3_insert==1
replace iconsis_wisc = 1 if conservative==1 & q3_insert==1
replace iconsis_wisc = 0 if conservative==1 & q3_insert==0
replace iconsis_wisc = 1 if ideology2==4 & q3_insert==1 // arbitrarily code pure moderates as conservatives
replace iconsis_wisc = 0 if ideology2==4 & q3_insert==0

* Trim weights
gen weight2=weight
replace weight2 = 5 if weight2>5 & weight!=.

recode pidr2 (1 2 = 1) (3 = 2) (4 = .) (5 = 3) (6 7 = 4), gen(pid4c)
recode pidr2 (4=.), gen(pid6c)

* Education
rename educ4 educ_norc
recode educ (1/9 = 1) (10 11 = 2) (12 = 3) (13 14 = 4), gen(educ4)
lab def educ4 1 "HS Diploma or less" 2 "Some college" 3 "BA" 4 "Advanced Degree"
lab val educ4 educ4

replace educ = (educ - 1) / 13
lab def educ_norc 1 "No HS Diploma" 2 "HS Grad" 3 "Some college" 4 "BA or above"
lab val educ_norc educ_norc

* Age
replace age = (age-18) / 72

* Race
recode race (1=1) (2=2) (3=3) (4=4) (5 6 = 3)
recode race (3=4) (4=3)
lab def race 1 "White NH" 2 "Black" 3 "Hispanic" 4 "Other" 
lab val race race

* Region
lab def region 1 "Northeast" 2 "Midwest" 3 "South" 4 "West"
lab val region4 region

save "working_wide.dta", replace

reshape long consis iconsis rum gop, i(caseid weight *_e *_i pureind pidr2) j(issue) string
encode issue, gen(issue2) 
recode issue2 (1=1) (2=3) (3=2) // want the control oil issue to be high value
lab drop issue2
lab def issue2 1 "Ohio" 2 "Wisc" 3 "Oil"
lab val issue2 issue2

recode pidr2 (1 2  6 7 = 1) (3 4 5 = 0), gen(nonlean)
recode pidr2 (4=1) (1 2 3 5 6 7=0), gen(independent)


save "working_long.dta", replace
