clear all
cd "~/Dropbox/Asymmetric credulity/data/7_replicationfiles"

insheet using "positly_full.csv", clear
gen positly = 1
save "positly.dta", replace

insheet using "dynata_full.csv", clear
gen positly = 0
append using "positly.dta"

drop if distributionchannel!="anonymous" // Test responses

rename v49 age_p
rename v53 gender_p
rename v55 income_p

foreach var in year_of_birth education educationscore femaleas1maleas0 incomescore participant_id assignment_id computer_country device {
	rename `var' `var'_p
	}

gen pidr2 = .
replace pidr2 = 7 if pidstr_r==1
replace pidr2 = 6 if pidstr_r==2
replace pidr2 = 5 if pidlean==2
replace pidr2 = 4 if pidlean==3
replace pidr2 = 3 if pidlean==1
replace pidr2 = 2 if pidstr_d==2
replace pidr2 = 1 if pidstr_d==1

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

recode ideol (8 = .), gen(ideology2)

recode pidr2 (1 2  6 7 = 1) (3 4 5 = 0), gen(nonlean)
recode pidr2 (4=1) (1 2 3 5 6 7=0), gen(independent)

recode ideology2 (1 2 3 = 0) (4=.) (5 6 7=1), gen(cons_i)
gen ideology = (ideology - 1)/6

recode ideology2 (0/3 = 0) (4=.) (5/7=1), gen(conservative)
gen liberal = 1-conservative

gen rum_ohio = rep1
gen rum_wisc = rep2
gen rum_oil = acq2
gen rum_sac = acq1

alpha acq*, gen(acq_comb)
replace acq_comb = (5 - acq_comb) / 4

gen rum_hyp1 = hyp1
gen rum_hyp2 = hyp2
gen rum_incomp1 = incomp1 
gen rum_incomp2 = incomp2
gen rum_breach1 = breach1
gen rum_breach2 = breach2

foreach var of varlist rum_* {
	replace `var' = 5 - `var' 
	}

rename i1dr incomp1dr
rename i2dr incomp2dr
rename b1dr breach1dr
rename b2dr breach2dr

gen consis_ohio = .
replace consis_ohio = 1 if dem_i==1 & r1dr=="Republican"
replace consis_ohio = 0 if dem_i==1 & r1dr=="Democratic"
replace consis_ohio = 1 if rep_i==1 & r1dr=="Democratic"
replace consis_ohio = 0 if rep_i==1 & r1dr=="Republican"
replace consis_ohio = 1 if pidr2==4 & r1dr=="Democratic" // arbitrarily code pure independents as Republicans
replace consis_ohio = 0 if pidr2==4 & r1dr=="Republican"

gen consis_wisc = .
replace consis_wisc = 1 if dem_i==1 & r2dr=="Republican"
replace consis_wisc = 0 if dem_i==1 & r2dr=="Democratic"
replace consis_wisc = 1 if rep_i==1 & r2dr=="Democratic"
replace consis_wisc = 0 if rep_i==1 & r2dr=="Republican"
replace consis_wisc = 1 if pidr2==4 & r2dr=="Democratic" // arbitrarily code pure independents as Republicans
replace consis_wisc = 0 if pidr2==4 & r2dr=="Republican"

foreach var in hyp1 hyp2 incomp1 incomp2 breach1 breach2 {
	gen consis_`var' = .
	replace consis_`var' = 1 if dem_i==1 & `var'dr=="Republican"
	replace consis_`var' = 0 if dem_i==1 & (`var'dr=="Democratic" | `var'dr=="Democrat")
	replace consis_`var' = 1 if rep_i==1 & (`var'dr=="Democratic" | `var'dr=="Democrat")
	replace consis_`var' = 0 if rep_i==1 & `var'dr=="Republican"
	replace consis_`var' = 1 if pidr2==4 & (`var'dr=="Democratic" | `var'dr=="Democrat")
	replace consis_`var' = 0 if pidr2==4 & `var'dr=="Republican"
	}

* Consistency with respect to ideology, rather than partisanship
gen iconsis_ohio = .
replace iconsis_ohio = 1 if liberal==1 & r1dr=="Republican"
replace iconsis_ohio = 0 if liberal==1 & r1dr=="Democratic"
replace iconsis_ohio = 1 if conservative==1 & r1dr=="Democratic"
replace iconsis_ohio = 0 if conservative==1 & r1dr=="Republican"
replace iconsis_ohio = 1 if ideology2==4 & r1dr=="Democratic" // arbitrarily code pure moderates as conservatives
replace iconsis_ohio = 0 if ideology2==4 & r1dr=="Republican"

gen iconsis_wisc = .
replace iconsis_wisc = 1 if liberal==1 & r2dr=="Republican"
replace iconsis_wisc = 0 if liberal==1 & r2dr=="Democratic"
replace iconsis_wisc = 1 if conservative==1 & r2dr=="Democratic"
replace iconsis_wisc = 0 if conservative==1 & r2dr=="Republican"
replace iconsis_wisc = 1 if ideology2==4 & r2dr=="Democratic" // arbitrarily code pure moderates as conservatives
replace iconsis_wisc = 0 if ideology2==4 & r2dr=="Republican"

* Political trust
foreach var of varlist trust_1-trust_4 {
	replace `var' = (`var' - 1) / 3
	}

alpha trust_1-trust_4, gen(trust) // .68	

* Education
recode educ (1 2 = 1) (3=2) (4=3) (5=4), gen(educ4)
lab def educ4 1 "HS Diploma or less" 2 "Some college" 3 "BA" 4 "Advanced Degree"
lab val educ4 educ4

* Scale rumor 0-1
foreach var of varlist rum_* {
	replace `var' = `var' / 4
	}
	
save "study2_wide.dta", replace
	
reshape long consis iconsis rum, i(responseid *_e *_i pidr2) j(issue) string
encode issue, gen(issue2) 

encode responseid, gen(caseid)

gen wisconsin = 0 
replace wisconsin = 1 if issue2==10

save "study2_long.dta", replace
