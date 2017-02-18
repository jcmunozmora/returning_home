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
***						Tables 1 to 3						***
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
******  Labels
****------------------------****

** Group of variables
global HH_level "stad_hh_size d_rural"
global Head_level "stad_head_age head_sex d_head_school"
global Displacement "_Idispla_de_2 _Idispla_de_3 _Idispla_de_4 _Idispla_de_5"
global Lost "lost_cattle lost_equip lost_five"
global displa "stad_hh_duration_displa_new stad_hh_duration_return_new "
global HH_production "prodrice prodbbiere prodexp"

* Labels
include "labels.do"

**----------------------------
***------------- Table 1:
*** Calorie Intake and Composition of the Diet per Adult Equivalent in 2006
**-----------------------------

*-- Variables
global var_table "depaladeq calaladeq perc_exp_p1 perc_kcal_p1 perc_exp_p7 perc_kcal_p7 perc_exp_p10 perc_kcal_p10 perc_exp_p2 perc_kcal_p2 perc_exp_p4 perc_kcal_p4"

*-- Making the table
eststo clear

**** Total 
qui eststo: estpost tabstat $var_table  , stats(mean sd)  columns(statistics) 

*** Rural vs Urban
qui eststo: estpost tabstat $var_table  if hh_rural==1 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if hh_rural==2 , stats(mean sd)   columns(statistics) 

	**** T-test

	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(hh_rural)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

*** PoorLevel
qui eststo: estpost tabstat $var_table  if pov_int==1 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if pov_int==2 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if pov_int==3 , stats(mean sd)   columns(statistics) 

	** Test
	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		anova `i' pov_int
	}
	matrix rownames size = $var_table 
	mat list size


*HH size 
qui eststo: estpost tabstat $var_table  if hh_size<=7 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if hh_size>7 , stats(mean sd)   columns(statistics)

gen h_size=(hh_size>7)

	**** T-test
	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(h_size)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

*Sex Head (0 Female 1 Male)
qui eststo: estpost tabstat $var_table  if head_sex==0 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if head_sex==1 , stats(mean sd)   columns(statistics)

	**** T-test
	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(head_sex)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

* Ever Displaced (d_displacement)
qui eststo: estpost tabstat $var_table  if d_displacement==0 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if d_displacement==1 , stats(mean sd)   columns(statistics)


	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(d_displacement)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size


esttab , cells("mean(fmt(%9.3f))" "sd(par([ ]) fmt(%9.3f))") replace fragment label  unstack mlabels(none)  collabels(none) 

**----------------------------
***------------- Table 2:
*** Food Expenses at the household level in 2006
**-----------------------------

*-- Variables
global var_table "hh_consumption_month per_nofood per_food per_food_own per_food_bought per_food_gift per_food_aid"

*-- Making the table
eststo clear

**** Total 
qui eststo: estpost tabstat $var_table  , stats(mean sd)  columns(statistics) 

*** Rural vs Urban
qui eststo: estpost tabstat $var_table  if hh_rural==1 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if hh_rural==2 , stats(mean sd)   columns(statistics) 

	**** T-test
	mat size=J(7,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(hh_rural)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

*** PoorLevel
qui eststo: estpost tabstat $var_table  if pov_int==1 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if pov_int==2 , stats(mean sd)   columns(statistics) 
qui eststo: estpost tabstat $var_table  if pov_int==3 , stats(mean sd)   columns(statistics) 

	** Test
	mat size=J(12,1,0)
	local j=1
	foreach i in $var_table  {
		anova `i' pov_int
	}
	matrix rownames size = $var_table 
	mat list size


*HH size 
qui eststo: estpost tabstat $var_table  if hh_size<=7 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if hh_size>7 , stats(mean sd)   columns(statistics)

	** Test
	mat size=J(7,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(h_size)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

*Sex Head (0 Female 1 Male)
qui eststo: estpost tabstat $var_table  if head_sex==0 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if head_sex==1 , stats(mean sd)   columns(statistics)

	** Test
	mat size=J(7,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(head_sex)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

* Ever Displaced (d_displacement)
qui eststo: estpost tabstat $var_table  if d_displacement==0 , stats(mean sd)   columns(statistics)
qui eststo: estpost tabstat $var_table  if d_displacement==1 , stats(mean sd)   columns(statistics)

	** Test
	mat size=J(7,1,0)
	local j=1
	foreach i in $var_table  {
		qui ttest `i', by(d_displacement)
		mat size[`j',1]=`r(p)' 
		local j=`j'+1
	}
	matrix rownames size = $var_table 
	mat list size

esttab , cells("mean(fmt(%9.3f))" "sd(par([ ]) fmt(%9.3f))") replace fragment label nonum  unstack   collabels(none) 

**----------------------------
***------------- Table 3:
*** Mean test for displaced households by place of destination after displacement
**-----------------------------

	*** Building the Instrument
	gen i_s_commune=(displa_dest==3 & d_displacement==1) 
	gen i_s_province=(displa_dest==4 & d_displacement==1) 
	gen i_s_colline=(displa_dest==2 & d_displacement==1) 
	gen i_s_o_commune=(displa_dest==5 & d_displacement==1)
	gen i_commune=(i_s_province==1|i_s_colline==1|i_s_commune==1)

	** T-test
	foreach i in hh_duration_displa_new hh_duration_return_new  hh_size head_age d_head_school landown_ae lost_cattle lost_equip lost_five {
		ttest `i' if d_displacement==1, by(i_commune)
	}



