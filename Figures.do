***	------------------------------------------------------	***
***	------------------------------------------------------	***
***				Returning Home After Civil War				***
***															***
***			Philip Verwimp and Juan Carlos Munoz-Mora		***
***			Journal of Development Studies (2017)			***
***															***
*** 				Replication do-files 					***
***															***
***	------------------------------------------------------	***
***						Figures								***
***															***
***						February 2017						***
***	------------------------------------------------------	***

*** Define working path where the data will be located.
cd "/path/where/data/is/located"

*** Main source information: the Core Welfare Indicator Questionnaire –CWIQ– for Burundi (2006). From the original data set (7199 households), we left out households with missing observations in the variables of interest (displacement and expenditure).

u "Verwimp-Munoz_2017.dta", clear

*** Define working path where the data will be located.
cd "/Users/juancarlosmunoz/Dropbox/Documents/PhD_Tesis_2016/Chap4/JDS_Final_Submission/githun_respository"

*** Main source information: the Core Welfare Indicator Questionnaire –CWIQ– for Burundi (2006). From the original data set (7199 households), we left out households with missing observations in the variables of interest (displacement and expenditure).

u "Verwimp-Munoz_2017.dta", clear

****------------------------****
****** Declare Sampling Design
****------------------------****

	*** Sampling structure
	* Stage 1: Sous-collines is the basic unit of sampling by Strata 
		* ---> Strata= 17 province plus 3 rural areas
	* Stage 2: Households were randomly chosen at the village

	**** Whole population 
	gen total_souscollines=9915
	gen total_household=1383661
	gen strata=province
	replace strata=province+20 if hh_rural==1

	svyset suos_colline [pw=pond], strata(strata)  fpc(total_souscollines)   singleunit(centered) || idmen0 , fpc(total_household) 

****------------------------****
****** Main controls and Labels
****------------------------****

** Group of variables
global HH_level "stad_hh_size d_rural"
global Head_level "stad_head_age head_sex d_head_school"
global Displacement "_Idispla_de_2 _Idispla_de_3 _Idispla_de_4 _Idispla_de_5"
global Lost "lost_cattle lost_equip lost_five"
global displa "stad_hh_duration_displa_new stad_hh_duration_return_new "
global HH_production "prodrice prodbbiere prodexp"

include "labels.do"

**----------------------------
***------------- Figure 1:
***  Timing of Return and Duration of Displacement
**-----------------------------	

	scatter  hh_duration_displa_new hh_duration_return_new  if d_displacement==1,  msymbol(X) mcolor(gs0) yscale(alt) xscale(alt) xlabel(, grid gmax) saving(yx)  graphregion(color(white)) ytitle(" ")  xtitle(" ")
	twoway histogram hh_duration_displa_new if d_displacement==1, color(white)   fcolor(g15)    fraction  xscale(alt reverse) horiz fxsize(25) saving(hy) graphregion(color(white)) 
	twoway histogram hh_duration_return_new if d_displacement==1, color(white)   fcolor(g15) fraction yscale(alt reverse) ylabel(0(.1).2, nogrid) xlabel(,grid gmax) fysize(25) saving(hx) graphregion(color(white)) 
	graph combine hy.gph yx.gph hx.gph, hole(3)  imargin(0 0 0 0) graphregion(margin(l=22 r=22)) graphregion(color(white)) 

	graph export "figures/graph_1.png", replace width(4147) height(2250)
**----------------------------
***------------- Figure 2:
***  Years since return and absence by arrival place after displacement.
**-----------------------------

	graph hbox  hh_duration_return_new hh_duration_displa_new if d_displacement==1, over(displa_dest1) graphregion(color(white))  box(1, color(gs5)  lpattern(dash_dot )) box(2, color(gs0))  legend(label(1 "Years since return") label(2 "Duration of absence") size(3))

	graph export "figures/graph_2.png", replace width(4147) height(2250)
**----------------------------
***------------- Figure 3:
***  Net difference between years since return minus years of displacement and household welfare 
**-----------------------------
* Defining new variable
cap drop dif*
gen dif_u=hh_duration_return_new-hh_duration_displa_new
gen dif=1 if dif_u<-5
replace dif=2 if dif_u>=-5 & dif_u<0
replace dif=3 if dif_u==0
replace dif=4 if dif_u>0 &  dif_u<=5
replace dif=5 if dif_u>5
replace dif=0 if d_displacement==0

** Labels
cap lab drop dif
lab def dif 1 "<-5" 2 "{&ge}-5 - <0" 3 "0" 4 ">0 - {&le}5" 5 ">5"
lab val dif dif

** Graph 1: Total Expenses per day per adult
	qui su hh_consumption_daily_ae if d_displacement==0
	loc n_dis=r(mean)

 	graph hbox hh_consumption_daily_ae  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Total Expenses per day per adult eq (Burundian Francs)",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
 	graph export "figures/graph_3a.png", replace width(4147) height(2250)

 	anova hh_consumption_daily_ae dif  if d_displacement==1

** Graph 2: Food expenses per adult equivalent
	su depaladeq if d_displacement==0
	loc n_dis=r(mean)

 	graph hbox depaladeq  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Food expenses per adult equivalent (Burundian Francs)",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
 	graph export "figures/graph_3b.png", replace width(4147) height(2250)

 	anova depaladeq  dif  if d_displacement==1

** Graph 3: Total Expenses per day per adult
	qui su calaladeq if d_displacement==0
	loc n_dis=r(mean)

 	graph hbox calaladeq  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Calorie intake per adult equivalent",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
 	graph export "figures/graph_3c.png", replace width(4147) height(2250)

 	anova calaladeq  dif  if d_displacement==1


