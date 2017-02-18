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
***						Tables 4 to 9						***
***															***
***						February 2017						***
***	------------------------------------------------------	***


*** Define working path where the data will be located.
cd "/path/where/data/is/located"

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

****----------------------------------------------****
****** Results for Tables 4 to 9
****----------------------------------------------****

**----------------------------
***------------- Table 4:
*** Determinants of food security and nutrition among Burundian Households, 2006
**-----------------------------
	eststo clear

	local j=1
	foreach var of varlist ln_hh_consumption_daily_ae  ln_food_men_day ln_cal_men_day {
		* Column 1
		qui svy: reg `var'  d_displacement $HH_level $HH_production     i.strata
		est store m`j'
		local j=1+`j'
		* Column 2
		qui svy: reg `var'  d_displacement    $HH_level $HH_production $Head_level   i.strata
		est store m`j'
		local j=1+`j'
		* Column 3
		qui svy: reg `var' $displa  $HH_level $HH_production   i.strata
		est store m`j'
		local j=1+`j'
		* Column 4
		qui svy: reg `var' $displa $HH_level $HH_production $Head_level   i.strata
		est store m`j'
		local j=1+`j'
	}

	esttab m* , star(* 0.10 ** 0.05 *** 0.01) brackets label se compress nogaps depvars se(%9.3f) b(%9.3f) stats(N r2 F ,  labels("Observations"  "R2" "F" ) fmt(0 3) )  keep(d_displacement $displa $HH_level $HH_production $Head_level   ) order(d_displacement $displa $HH_level $HH_production $Head_level   )

**----------------------------
***------------- Table 5:
*** Determinants of having an early return (<=1 year) after displacement.  (Probit estimation)
**-----------------------------

	eststo clear
	qui svy: probit d_duration $HH_level $HH_production i.strata
	eststo mfx: margins, dydx(*) atmeans post
	est store m1

	qui svy: probit d_duration $HH_level $HH_production  $Head_level  i.strata
	eststo mfx: margins, dydx(*) atmeans post
	est store m2

	qui svy: probit d_duration $HH_level $HH_production  $Head_level d_no_displa _Idispla_de_2 _Idispla_de_3 _Idispla_de_5 i.strata
	eststo mfx: margins, dydx(*) atmeans post
	qui est store m3

	qui svy: probit d_duration $HH_level $HH_production  $Head_level d_no_displa _Idispla_de_2 _Idispla_de_3 _Idispla_de_5 $Lost i.strata
	eststo mfx: margins, dydx(*) atmeans post
	est store m4

	esttab m1 m2 m3 m4,  star(* 0.10 ** 0.05 *** 0.01)   brackets label se compress nogaps depvars se(%9.3f) b(%9.3f) margin  stats(N,  labels("Observations") fmt(0 ) ) keep($HH_level $HH_production  $Head_level d_no_displa _Idispla_de_2 _Idispla_de_3 _Idispla_de_5 $Lost ) order($HH_level $HH_production  $Head_level d_no_displa _Idispla_de_2 _Idispla_de_3 _Idispla_de_5 $Lost ) 

**----------------------------
***------------- Table 6:
*** Propensity Score for different treatments (Probit).
**-----------------------------
	* We define the three alternatives measures
		* match_1= All returned IDP (=1) vs Never-Displaced (=0)
		* match_2= HH Early return IDP (=1)  vs Never (=0)
		* match_3= Displaced HH	Lately return IDP (=1) vs Never Displaced HH

	eststo clear
	eststo:  svy: probit match_1 $Head_level i.province
	cap drop probit_p_1
	predict probit_p_1, p
	eststo mfx: margins, dydx(*) atmeans post
	est store m1

	forvalue i=2/3 {
	eststo clear
	eststo:  svy:  probit match_`i' $Head_level i.province
	cap drop probit_p_`i'
	predict probit_p_`i', p
	eststo mfx: margins, dydx(*) atmeans post
	est store m`i'
	}

	esttab m1 m2 m3 ,star(* 0.10 ** 0.05 *** 0.01) brackets label se compress nogaps se(%9.3f) b(%9.3f) margin  stats(N,  labels("Observations") fmt(0 ) ) keep($Head_level ) order($Head_level )

**----------------------------
***------------- Table 7.
*** Average Treatment effect on the Treated (ATT), using different treatments
**-----------------------------

* Randomly organized the data for the matching
set seed 12345
tempvar sortorder
gen `sortorder' = runiform()
sort `sortorder'

*- ATT Effects
	forvalue i=1/3 {
	psmatch2  match_`i' , n(5) out( hh_consumption_daily_ae) ate pscore(probit_p_1)
		*Balancing Properties
		pstest $Head_level i.province, sum both
		* Sensitivity to hidden bias (Rosenbaum bounds)
		rbounds delta, gamma(1 (0.1) 2) alpha(.90)
	psmatch2  match_`i' , n(5) out( depaladeq) ate pscore(probit_p_2)
		*Balancing Properties
		pstest $Head_level i.province, sum both
		* Sensitivity to hidden bias (Rosenbaum bounds)
		rbounds delta, gamma(1 (0.1) 2) alpha(.90)
	psmatch2  match_`i' , n(5) out( calaladeq) ate pscore(probit_p_3)
		*Balancing Properties
		pstest $Head_level i.province, sum both
		* Sensitivity to hidden bias (Rosenbaum bounds)
		rbounds delta, gamma(1 (0.1) 2) alpha(.90)
	}

**----------------------------
***------------- Table 8.
*** IV-approach
**-----------------------------

*** Building the Instrument
	gen i_s_commune=(displa_dest==3 & d_displacement==1) 
	gen i_s_province=(displa_dest==4 & d_displacement==1) 
	gen i_s_colline=(displa_dest==2 & d_displacement==1) 
	gen i_s_o_commune=(displa_dest==5 & d_displacement==1)
	gen i_commune=(i_s_province==1|i_s_colline==1|i_s_commune==1)

** Results
	eststo clear

	local j=1
	foreach var of varlist ln_hh_consumption_daily_ae  ln_food_men_day ln_cal_men_day {
		* Column I
		svy: reg `var'  d_displacement  $HH_level $HH_production $Head_level   i.strata
		est store iv`j'
		local j=`j'+1
		* Column II
		xi i.strata
		svy: ivreg `var' (d_displacement=i_commune)   $HH_level $HH_production $Head_level _Istrata*
		est store iv`j'
		local j=`j'+1
		svy: reg d_displacement i_commune $HH_level $HH_production $Head_level _Istrata* 
		estadd  scalar f_excluded=e(F) 
	}

esttab iv* , star(* 0.10 ** 0.05 *** 0.01)  brackets label se compress nogaps depvars se(%9.3f) b(%9.3f) margin  stats(N R2 f_excluded,  labels("Observations") fmt(0 3) ) keep(d_displacement   $Head_level $HH_level  $HH_production  ) order(d_displacement  $HH_level $HH_production $Head_level   )  

**----------------------------
***------------- Table 9.  
*** Divergence vs Convergence mechanism
**-----------------------------

cap drop dif*
	gen dif_u=hh_duration_return_new-hh_duration_displa_new
	gen dif=1 if dif_u<-5
	replace dif=2 if dif_u>=-5 & dif_u<0
	replace dif=4 if dif_u==0
	replace dif=6 if dif_u>0 &  dif_u<=5
	replace dif=7 if dif_u>5
	replace dif=0 if d_displacement==0


** Regressions

	eststo clear
	local j=1
	foreach var of varlist ln_hh_consumption_daily_ae  ln_food_men_day ln_cal_men_day {
		* Column 1
		qui svy: reg `var'  i.dif $HH_level $HH_production     i.strata
		est store m`j'
		local j=1+`j'
		* Column 2
		qui svy: reg `var'  i.dif    $HH_level $HH_production $Head_level   i.strata
		est store m`j'
		local j=1+`j'
	}

esttab m* , fragment star(* 0.10 ** 0.05 *** 0.01)  brackets label se compress nogaps depvars se(%9.3f) b(%9.3f) stats(N r2 F ,  labels("Observations"  "R2" "F" ) fmt(0 3) )  keep(*.dif $HH_level $HH_production $Head_level   ) order(*.dif $HH_level $HH_production $Head_level   ) 


