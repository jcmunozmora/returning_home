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
***						February 2017						***
***	------------------------------------------------------	***


* Renaming some variables 

cap rename hh6 hh_rural
cap rename pov3 d_poverty
cap rename b8 head_sex
cap rename displ_ever d_displacement
cap rename npers hh_size
cap rename b6 head_age
cap rename ecole_ter head_schooling
cap rename q6 suos_colline
cap rename q5 colline
cap rename k3 displa_dest
cap rename k4 displa_country

cap rename deptot hh_consumption
cap rename depnalim hh_consumption_nonfood 
cap rename depalim hh_consumption_food
cap rename time_since2 hh_duration_return
cap rename duur2 hh_duration_displa


* Labels for the main variables used for the analysis
***** Labels 
lab var depaladeq "Food expenses per day**"
lab var calaladeq "Daily calorie intake**"
lab var perc_exp_p1 "Beans:\% exp"
lab var perc_kcal_p1 "Beans:\% Kcal"
lab var perc_exp_p7  "Manioc Farine:\% exp"
lab var perc_kcal_p7 "Manioc Farine:\% Kcal"
lab var perc_exp_p10 "Maize:\% exp"
lab var perc_kcal_p10 "Maize:\% Kcal"
lab var perc_exp_p2  "Sweet Potatoes:\% exp"
lab var perc_kcal_p2 "Sweet Potatoes:\% Kcal"
lab var perc_exp_p4 "Cooking Bananas:\% exp"
lab var perc_kcal_p4"Cooking Bananas:\% Kcal"

lab var hh_consumption_month "Total expenses (1000 Burundian Francs - per month)"
lab var per_nofood "\% Non-food"
lab var per_food "\%  Food"
lab var per_food_own "From own production (% of food expenses)" 
lab var per_food_bought "Bought ( % of food expenses)"
lab var per_food_gift "Gift ( % of food expenses)"
lab var per_food_aid "Aid (i% of food expenses)"

replace hh_consumption_month=hh_consumption_month/1000

cap label var head_age "Age"
cap label var head_sex "Sex"

cap label var landown "Land size"
cap label var hh_size "Household size"
cap label var head_sex "Age head"
cap label def d_displacement 0 "Never" 1 "At least one"
cap label val d_displacement d_displacement
cap label def d_poverty 1 "Non-poor" 2 "Poor" 3 "Food Poor"
cap label val d_poverty d_poverty

cap label var hh_duration_displa "Duration of Forced Displacement"
cap label var hh_duration_return "Number of years ago since return"

cap label var d_displacement "Returned IDH (yes=1)"
cap label var stad_hh_duration_displa_new "Duration of absence"
cap label var stad_hh_duration_return_new "Years since Return"
cap label var hh_duration_displa_new "Duration of absence"
cap label var hh_duration_return_new "Years since Return"
cap label var stad_hh_size "Household size"
cap label var d_rural "Rural Household (yes=1)"

cap label var prodrice  "Produce Rice (yes=1)"
cap label var prodbbiere  "Produce banana Beer (yes=1)"
cap label var prodexp "Produce export crop (yes=1)"
cap label var stad_head_age "Household Head Age"
cap label var head_sex "Household Head Sex (Male=1)"
cap label var d_head_school "Household Head Went to school (yes=1)"


