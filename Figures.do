*******************************************************
************ Returning home 	***********************
********** Verwimp and Mu–oz		*******************
*************     2013    *****************************
set more off

** Working Directories
global w_folder "/Users/juancarlosmunoz/Dropbox/Documents/PhD_Tesis_2016/Chap4/Munoz-Verwimp(data)"

global results "/Users/juancarlosmunoz/Dropbox/Documents/PhD_Tesis_2016/Chap4/tables"
global graphs "/Users/juancarlosmunoz/Dropbox/Documents/PhD_Tesis_2016/Chap4/JDS_Submission/figures"

*** Open Data * province q4
u "$w_folder/data/Verwimp-Munoz_2015.dta", clear

****** Sampling corrections

	*** Samplit 
	* Stage 1: Sous-collines Prime unit of sample by Strata 
		* ---> Strata= 17 province plus 3 rural areas
	* Stage 2: Ramdonly chosen at the village


	** Defining the survey design

	**** WHOLE POPULATION
	gen total_souscollines=9915
	gen total_household=1383661
	gen strata=province
	replace strata=province+20 if hh_rural==1

	svyset suos_colline [pw=pond], strata(strata)  fpc(total_souscollines)   singleunit(centered) || idmen0 , fpc(total_household) 

	**** ONLY RURALEs
	*gen total_souscollines_rural=9614
	*gen total_household_rural=1306471
	*svyset suos_colline [pw=pond], strata(province)  fpc(total_souscollines_rural)  || hh2 , fpc(total_household_rural) 


** Group of variables
global HH_level "stad_hh_size d_rural"
global Head_level "stad_head_age head_sex d_head_school"
global Displacement "_Idispla_de_2 _Idispla_de_3 _Idispla_de_4 _Idispla_de_5"
global Lost "lost_cattle lost_equip lost_five"
global displa "stad_hh_duration_displa_new stad_hh_duration_return_new "
global HH_production "prodrice prodbbiere prodexp"


include "$w_folder/do-files/labels.do"

******************************************************************************************************
******************************************************************************************************
***********************  FIGURES *********************************************************************
******************************************************************************************************
******************************************************************************************************

***********************************************************************************
***********************  Figure 1 : Timing of Return and Duration of Displacement
***********************************************************************************


	scatter hh_duration_displa_new if d_displacement==1,  msymbol(X) mcolor(gs0) yscale(alt) xscale(alt) xlabel(, grid gmax) saving(yx)  graphregion(color(white)) ytitle(" ")  xtitle(" ")
	twoway histogram hh_duration_displa_new, color(white)   fcolor(g15)    fraction  xscale(alt reverse) horiz fxsize(25) saving(hy) graphregion(color(white)) 
	twoway histogram hh_duration_return_new, color(white)   fcolor(g15) fraction yscale(alt reverse) ylabel(0(.1).2, nogrid) xlabel(,grid gmax) fysize(25) saving(hx) graphregion(color(white)) 
	graph combine hy.gph yx.gph hx.gph, hole(3)  imargin(0 0 0 0) graphregion(margin(l=22 r=22)) graphregion(color(white)) 
	 graph export "$graph/graph_1.png", replace width(4147) height(2250)

***********************************************************************************
***********************  Figure 2 : Years since return and absence by arrival place after displacement.
***********************************************************************************

	graph hbox  hh_duration_return hh_duration_displa if d_displa==1, over(displa_dest1) graphregion(color(white))  box(1, color(gs5)  lpattern(dash_dot )) box(2, color(gs0))  legend(label(1 "Years since return") label(2 "Duration of absence") size(3))
	graph export "$graph/graph_3.png", replace width(4147) height(2250)


***********************************************************************************
***********************  Figure 3 : Figure 3. Total Food expenses per adult equivalent by duration of displacement and years since return.
***********************************************************************************
			* Defining new variable
			cap drop dif*
			gen dif_u=hh_duration_return_new-hh_duration_displa_new
			gen dif=1 if dif_u<-5
			replace dif=2 if dif_u>=-5 & dif_u<0
			replace dif=3 if dif_u==0
			replace dif=4 if dif_u>0 &  dif_u<=5
			replace dif=5 if dif_u>5
			replace dif=0 if d_displacement==0







			 cap lab drop dif
			 lab def dif 1 "<-5" 2 "{&ge}-5 - <0" 3 "0" 4 ">0 - {&le}5" 5 ">5"
			lab val dif dif

			** Graph 1: Total Expenses per day per adult
				qui su hh_consumption_daily_ae if d_displacement==0
				loc n_dis=r(mean)

			 	graph hbox hh_consumption_daily_ae  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Total Expenses per day per adult eq (Burundian Francs)",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
			 	graph export "$graphs/graph_0a_new.png", replace width(4147) height(2250)

			 	anova hh_consumption_daily_ae dif  if d_displacement==1

			** Graph 2: Food expenses per adult equivalent
				su depaladeq if d_displacement==0
				loc n_dis=r(mean)

			 	graph hbox depaladeq  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Food expenses per adult equivalent (Burundian Francs)",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
			 	graph export "$graphs/graph_0b_new.png", replace width(4147) height(2250)

			 	anova depaladeq  dif  if d_displacement==1

			** Graph 3: Total Expenses per day per adult
				qui su calaladeq if d_displacement==0
				loc n_dis=r(mean)

			 	graph hbox calaladeq  if d_displacement==1, over(dif, label(labsize(small) )) yline(`n_dis')  ytitle("Calorie intake per adult equivalent",size(small)) ylabel(,labsize(small)) graphregion(color(white))  bar(1,   color(gs5)) marker(1, msymbol(x) mcolor(gs5)) 
			 	graph export "$graphs/graph_0c_new.png", replace width(4147) height(2250)

			 	anova calaladeq  dif  if d_displacement==1



***********************************************************************************
***********************  Figure 4 : Kernel density estimate for the propensity score
***********************************************************************************
	forvalue i=1/3 {
	qui probit match_`i' $Head_level i.strata
	cap drop probit_p_`i'
	qui predict probit_p_`i', p
	}


	**** Match 1: All displaced vs non-displaced
		twoway (kdensity probit_p_1 if match_1==1,   lcolor(gs0)     ) (kdensity probit_p_1 if match_1==0, lcolor(gs5)  lpattern( dash_dot ) ), graphregion(color(white))  legend(label(1 "Treatment:Displaced") label(2 "Control:Never Displaced") size(3)  )  ytitle("Kernel Density Estimate") xtitle("") 
 		graph export "$graph/graph_7a.png", replace width(4147) height(2250)

	**** Match 2: Early return vs non-displaced
		twoway (kdensity probit_p_2 if match_2==1,   lcolor(gs0)     ) (kdensity probit_p_1 if match_2==0, lcolor(gs5)  lpattern( dash_dot ) ), graphregion(color(white))  legend(label(1 "Treatment:Early return (<= 1 year)") label(2 "Control:Never Displaced")  size(3))  ytitle("Kernel Density Estimate") xtitle("") 
 		graph export "$graph/graph_7b.png", replace width(4147) height(2250)

	**** Match 3: Lately return vs Early return
		twoway (kdensity probit_p_3 if match_3==1,   lcolor(gs0)     ) (kdensity probit_p_1 if match_3==0, lcolor(gs5)  lpattern( dash_dot ) ), graphregion(color(white))  legend(label(1 "Treatment:Lately return (>1 year)") label(2 "Control:Never Displaced") size(3))  ytitle("Kernel Density Estimate") xtitle("") 
 		graph export "$graph/graph_7c.png", replace width(4147) height(2250)

***********************************************************************************
***********************  Figure 5 : TEst
***********************************************************************************


local j="dif"
local i="k15a"
	preserve
	keep if d_displacement==1
	keep `j' `i'
	drop if `i'==9|`i'==.
	drop if `i'==0
	cap gen x=1
		collapse (sum) x, by(`j'  `i')
		bys `j': egen total=sum(x)
		gen prop=x/total
		replace prop=prop*100
		keep `j'  prop `i'
		reshape wide prop, i(`j') j(`i')

		cap lab drop dif
		lab def dif 1 "<-5" 2 "{&ge}-5 - <-1" 3 "{&ge}-1 - <0" 4 "0" 5 ">0 - {&le}1" 6 ">1 - {&le}5" 7 ">5"
		lab val dif dif

		graph bar prop*, over(`j', label(labsize(small)))   ytitle("%", size(small)) blabel(bar, position(inside) format(%9.0f) color(white) size(small))   bar(1,      lcolor(gs15)) bar(2,  color(gs7)    lcolor(gs6))   bar(3,  color(gs10)    lcolor(gs7)) bargap(-20)  graphregion(color(white))  ylabel(,labsize(small)) legend( region( style(none)) cols(3)  size(small) forcesize )


legend( label(1 "No") label(2 "Si") label(3 "No Sabe") size(medsmall))

		restore

