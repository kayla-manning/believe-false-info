cd "~/Classes/gov_52/us-pluralism/data/false_info"

* Text: Association between partisanship and the Oil item
use "working_wide.dta", clear
reg oil pidr

** Table 1
use "working_long.dta", clear
xtset caseid

reg rum i.consis##i.rep_i if independent==0 & issue2==1
reg rum i.consis##i.rep_i if nonlean==1 & issue2==1

reg rum i.consis##i.rep_i if independent==0 & issue2==2
reg rum i.consis##i.rep_i if nonlean==1 & issue2==2

xtreg rum i.consis##i.rep_i i.issue2 if independent==0 //  1-3 vs. 5-6
xtreg rum i.consis##i.rep_i i.issue2 if nonlean==1 // 1-2 vs. 6-7

* SI Section 6: Text-based claims
use "study2_long.dta", clear

reg rum i.consis##i.rep_i##positly wisconsin positly if independent==0 & issue=="_ohio", cluster (caseid)
reg rum i.consis##i.rep_i##positly wisconsin positly if independent==0 & issue=="_wisc", cluster (caseid)


* Table SI-2
use "study2_long.dta", clear
xtset caseid

reg rum i.consis##i.rep_i positly if independent==0 & issue=="_ohio"
margins, dydx(consis) at(rep_i==1) // Marginal effect mentioned in footnote
reg rum i.consis##i.rep_i positly if nonlean==1 & issue=="_ohio"

reg rum i.consis##i.rep_i positly if independent==0 & issue=="_wisc"
margins, dydx(consis) at(rep_i==1) // Marginal effect mentioned in footnote
reg rum i.consis##i.rep_i positly if nonlean==1 & issue=="_wisc"

xtreg rum i.consis##i.rep_i wisconsin positly if independent==0 & (issue=="_ohio" | issue=="_wisc"), cluster (caseid)
margins, dydx(consis) at(rep_i==1) // Marginal effect mentioned in footnote
xtreg rum i.consis##i.rep_i wisconsin positly if nonlean==1 & (issue=="_ohio" | issue=="_wisc")


* SI Section 6. (Text, based claims)
use "study2_long.dta", clear
xtset caseid

xtreg rum i.consis##i.rep_i i.issue2 acq_comb if independent==0 & (issue=="_incomp1" | issue=="_incomp2")
xtreg rum i.consis##i.rep_i i.issue2 acq_comb if independent==0 & (issue=="_hyp1" | issue=="_hyp2")
xtreg rum i.consis##i.rep_i i.issue2 acq_comb if independent==0 & (issue=="_breach1" | issue=="_breach2")

* Table SI-3
use "working_long.dta", clear
xtset caseid

reg rum i.iconsis##i.cons_i if ideology2!=4 & issue2==1
reg rum i.iconsis##i.cons_i if ideology2!=4 & issue2==2
xtreg rum i.iconsis##i.cons_i i.issue2 if ideology2!=4, cluster(caseid) //  1-3 vs. 5-6

* Table SI-4
use "study2_long.dta", clear
xtset caseid

reg rum i.iconsis##i.cons_i if ideology2!=4 & issue=="_ohio"
reg rum i.iconsis##i.cons_i if ideology2!=4 & issue=="_wisc"
xtreg rum i.iconsis##i.cons_i i.issue2 if ideology2!=4 & (issue=="_ohio" | issue=="_wisc"), cluster(caseid) //  1-3 vs. 5-6

* Table SI-5
use "working_long.dta", clear
xtset caseid
svyset [pw=weight2]

svy: reg rum i.consis##i.rep_i if independent==0 & issue2==1
svy: reg rum i.consis##i.rep_i if nonlean==1 & issue2==1
svy: reg rum i.consis##i.rep_i if independent==0 & issue2==2
svy: reg rum i.consis##i.rep_i if nonlean==1 & issue2==2

/* Run the following if you need to install reghdfe
ssc install reghdfe
ssc install ftools
reghdfe, compile
*/

reghdfe rum i.consis##i.rep_i i.issue2 if independent==0 [pweight=weight2], cluster(caseid) noabsorb //  1-3 vs. 5-6
reghdfe rum i.consis##i.rep_i i.issue2 if nonlean==1 [pweight=weight2], cluster(caseid) noabsorb // 1-2 vs. 6-7

* Figure SI-2
use "working_long.dta", clear
set scheme sj

reg rum i.consis##i.rep_i if independent==0 & issue2==1
margins, dydx(consis) at(rep_i=(0 1))
marginsplot, recast(scatter) graphregion(color(white)) xsc(r(-.5 1.5)) ///
	xlab(0 "Democrats" 1 "Republicans") title("Ohio") xtitle("") ytitle("") ysc(r(-.04 .12)) ///
	yline(0) ylab(0(.1).5)
graph save "ohio2pt.gph", replace

reg rum i.consis##i.rep_i if independent==0 & issue2==2
margins, dydx(consis) at(rep_i=(0 1))
marginsplot, recast(scatter) graphregion(color(white)) xsc(r(-.5 1.5)) ///
	xlab(0 "Democrats" 1 "Republicans") title("Wisconsin") xtitle("") ytitle("") ///
	yline(0) ylab(0(.1).5)
graph save "wisc2pt.gph", replace

graph combine "ohio2pt.gph" "wisc2pt.gph", graphregion(color(white)) ///
	rows(1) ycommon
graph export "ow2pt.png", replace width(2000)

* Table SI-6
use "working_long.dta", clear
xtset caseid

ologit rum i.consis##i.rep_i if independent==0 & issue2==1
ologit rum i.consis##i.rep_i if nonlean==1 & issue2==1

ologit rum i.consis##i.rep_i if independent==0 & issue2==2
ologit rum i.consis##i.rep_i if nonlean==1 & issue2==2

xtologit rum i.consis##i.rep_i i.issue2 if independent==0, vce(cluster caseid) //  1-3 vs. 5-6
xtologit rum i.consis##i.rep_i i.issue2 if nonlean==1 // 1-2 vs. 6-7

* Figure SI-3
use "working_long.dta", clear
set scheme sj

reg rum i.consis if issue2==1 & pid6c!=. // average = 0.085
reg rum i.consis##i.pid6c if issue2==1
margins, dydx(consis) at(pid6c=(1 2 3 5 6 7))
marginsplot, yline(0.085, lpattern(dash)) graphregion(color(white)) xtitle("") ///
	plotopts(connect(none)) title("Ohio") xlab(1 "Strong Democrat" 2 "Democrat" 3 "Lean Democrat" 5 "Lean Republican" 6 "Republican" 7 "Strong Republican", angle(45)) ///
	ytitle("Consistency Effect") ylab(0(.02).16) xoverhangs
graph save "pidstr_ohio.gph", replace

reg rum i.consis if issue2==2 & pid6c!=. // average = 0.061
reg rum i.consis##i.pid6c if issue2==2
margins, dydx(consis) at(pid6c=(1 2 3 5 6 7))
marginsplot, yline(0.061, lpattern(dash)) graphregion(color(white)) xtitle("") ///
	plotopts(connect(none)) title("Wisconsin") xlab(1 "Strong Democrat" 2 "Democrat" 3 "Lean Democrat" 5 "Lean Republican" 6 "Republican" 7 "Strong Republican", angle(45)) ///
	ytitle("Consistency Effect") ylab(0(.02).16) xoverhangs
graph save "pidstr_wisc.gph", replace

graph combine "pidstr_ohio.gph" "pidstr_wisc.gph", rows(1) ycommon graphregion(color(white)) ///
	xsize(6) ysize(4)
graph export "consis_6lev.png", replace width(2000) 


* Table SI-7
use "working_long.dta", clear
xtset caseid

reg rum i.consis if independent==1 & issue2==1
reg rum i.consis if independent==1 & issue2==2
xtreg rum i.consis i.issue2 if independent==1, cluster(caseid)


* Table SI-8
use "working_long.dta", clear
xtset caseid

xtreg rum c.educ c.pidr i.gender c.age i.region4 i.race i.issue2 if issue2!=3, re vce(cluster caseid)
xtreg rum c.educ c.pidr i.gender c.age i.region4 i.race i.issue2 if issue2!=3 & independent==0, re vce(cluster caseid)
xtreg rum i.consis##c.educ c.pidr i.gender c.age i.region4 i.race i.issue2 if issue2!=3 & independent==0, re vce(cluster caseid)

* Figure SI-4
use "working_long.dta", clear
set scheme sj
xtset caseid

xtreg rum i.consis##i.educ4 if issue2!=3 & independent==0
margins, dydx(consis) at(educ4=(1 2 3 4))
marginsplot, graphregion(color(white)) ysc(r(-.01 .14)) yline(0) ylab(0(.02).14) ///
	ytitle("Effect of Consistency Treatment") xoverhangs xtitle("Education level") ///
	title("")
graph save "educplot.gph", replace
graph export "educplot.png", width(1000) replace

* Figure SI-5
use "study2_long.dta", clear
xtset caseid

xtreg rum i.consis##i.educ4 if (issue=="_ohio" | issue=="_wisc") & independent==0
margins, dydx(consis) at(educ4=(1 2 3 4))
marginsplot, graphregion(color(white)) yline(0) ///
	ytitle("Effect of Consistency Treatment") xoverhangs xtitle("Education level") ///
	title("") yline(0) ysc(r(-0.01, .14)) ylab(0(.02).14)
graph save "educplot_s2.gph", replace
graph export "educplot_s2.png", width(1000) replace

* Figure SI-6
use "working_long.dta", clear
set scheme s2color
xtset caseid

xtreg rum i.consis##c.trust if issue2!=3 & democrat==1, re vce(cluster caseid) // Claim in footnote
xtreg rum i.consis##c.trust if issue2!=3 & republican==1, re vce(cluster caseid) // Claim in footnote
xtreg rum i.consis##c.trust##i.pid3c if issue2!=3, re vce(cluster caseid)
margins, dydx(consis) at(trust=(0 1) pid3c=(1 2))
marginsplot, graphregion(color(white)) xtitle("Political Trust") title("") ///
	xlab(0 "Low Trust" 1 "High Trust") xoverhangs yline(0, lcolor(black)) ///
	ytitle("Effect of Consistency Treatment") legend(order(1 "Democrats" 2 "Republicans")) ///
	plot1(lpattern(dash)) title("Study 1")
graph save "trustplot.gph", replace // Changed the Dem line to dashed manually
graph export "trustplot.png", width(1000) replace

use "study2_long.dta", clear
xtset caseid

xtreg rum i.consis##c.trust if issue2!=3 & democrat==1, re vce(cluster caseid)
xtreg rum i.consis##c.trust if issue2!=3 & republican==1, re vce(cluster caseid)
xtreg rum i.consis##c.trust##i.pid3c if issue2!=3, re vce(cluster caseid)
margins, dydx(consis) at(trust=(0 1) pid3c=(1 2))
marginsplot, graphregion(color(white)) xtitle("Political Trust") title("") ///
	xlab(0 "Low Trust" 1 "High Trust") xoverhangs yline(0, lcolor(black)) ///
	ytitle("Effect of Consistency Treatment") legend(order(1 "Democrats" 2 "Republicans")) ///
	plot1(lpattern(dash)) title("Study 2")
graph save "trustplot_s2.gph", replace // Changed the Dem line to dashed manually
graph export "trustplot_s2.png", width(1000) replace

grc1leg "trustplot.gph" "trustplot_s2.gph", graphregion(color(white)) rows(1) ycommon
graph play "trust_dash.grec" // This just makes the appropriate line in the legend be dashed

* Figure SI-7
use "working_long.dta", clear
xtset caseid
set scheme s2color

xtreg rum i.consis##c.trust##i.educ4##i.pid3c if issue2!=3, re vce(cluster caseid)
margins, dydx(consis) at(educ4=(1 2 3 4) pid3c=(1 2) trust=0)
marginsplot, graphregion(color(white)) ysc(r(-.01 .2)) yline(0, lcolor(black)) ///
	ytitle("Effect of Consistency Treatment") xoverhangs xtitle("Education level") ///
	title("Low trust") xlab(, angle(45)) legend(order(1 "Democrats" 2 "Republicans"))
graph play "gfix.grec" // Makes one line be dashed
graph save "eductrust1.gph", replace
	
margins, dydx(consis) at(educ4=(1 2 3 4) pid3c=(1 2) trust=1)
marginsplot, graphregion(color(white)) ysc(r(-.01 .2)) yline(0, lcolor(black)) ///
	ytitle("Effect of Consistency Treatment") xoverhangs xtitle("Education level") ///
	title("High trust") xlab(, angle(45))
graph play "gfix.grec" // Makes one line be dashed
graph save "eductrust2.gph", replace
	
grc1leg "eductrust1.gph" "eductrust2.gph", graphregion(color(white)) rows(1) ycommon
