********************************************************************************
*# Self-report imputed additive & multiplicative effect modification & interaction analysis: social media > cigarette use 
********************************************************************************

/*
AK Purba [last updated 21.02.2023]
Do file: data02a_SCQ_imp_EMtable2a3a5a6a_vs1.do
Dataset: data01_master_vs3_SCQ_imp_4_2

Syntax: 
Additive measure of effect modification (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)
Multiplicative measures of effect modification (cigarette use)- Poisson regression with robust standard errors (RR low PE/RR high PE)
Additive measures of interaction (cigarette use)- Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)
Multiplicative measures of interaction (cigarette use)- Poisson regression with robust standard errors (RR11/RR10*RR01)

 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "Social_media_cig_ecig\DATASETS\data01_master_vs3_SCQ_imp_4_2.dta", clear
set seed 9260589

* Should say (data unchanged since 18jan2023 09:21)
datasignature confirm

********************************************************************************

/// EXPOSURE, OUTCOME AND EM VARIABLE 
********************************************************************************

/*Exposure 
codebook smscq_r5C_imp
1  1_no SM use
2  2_1-<30min
3  3_30min-<1hr
4  4_1-<2hrs
5  5_≥2hrs
*A1: 1_no SM use (ref cat) & 2_1-<30min
*A2: 1_no SM use (ref cat) & 3_30min-<1hr
*A3: 1_no SM use (ref cat) & 4_1-<2hrs
*A4: 1_no SM use (ref cat) & 5_≥2hrs

//EM 
codebook hied_COB_imp
0  0_high parental ed
1  1_low parentel ed
*0_high parental ed (ref cat) & 1_low parentel ed 

//Outcome 
codebook smok_rB_imp
0  0_never smoked/tried cigs once
1  1_current or former smoker */

********************************************************************************
// PREVALENCES TABLE 2A,3A,5A and 6A
********************************************************************************

set showbaselevels on
codebook smscq_r5C_imp
codebook hied_COB_imp


***Declare survey design
mi svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 


***Unweighted prevalences (unweighted N: to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong
* whole sample
tab smok_rB_imp smscq_r5C_imp if _mi_m >0
* by parental education 
tab smok_rB_imp smscq_r5C_imp if _mi_m >0 & hied_COB_imp==0 // high par ed 
tab smok_rB_imp smscq_r5C_imp if _mi_m >0 & hied_COB_imp==1 // low par ed



*** Weighted prevalences
mi svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2)
* whole sample
mi estimate: svy: proportion smok_rB_imp, over (smscq_r5C_imp)
* by parental education 
mi estimate: svy, subpop(if hied_COB_imp==0) : proportion smok_rB_imp, over (smscq_r5C_imp) // high par ed 
mi estimate: svy, subpop(if hied_COB_imp==1) : proportion smok_rB_imp, over (smscq_r5C_imp) // low par ed


****************************************************************************************
*#Pairwise comparison A1-A4: unadjusted 
*******************************************************************************


*#TABLE 2A,3A,5A,6A: Generate individual binary variables for SM use from original ordinal exposure var 
mi xeq: tab smscq_r5C_imp, mi
mi passive: gen A1smscq=0 if smscq_r5C_imp==1
mi passive: replace A1smscq=1 if smscq_r5C_imp==2
label define A1smscq 0"0_no SM use" 1"1_1-<30min"
label variable A1smscq "1-<30min vs no SM use"
label values A1smscq A1smscq 
mi xeq: tab A1smscq smscq_r5C_imp,mi

mi passive: gen A2smscq=0 if smscq_r5C_imp==1
mi passive: replace A2smscq=1 if smscq_r5C_imp==3
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq
label variable A2smscq "30min-<1hr vs no SM use"
mi xeq: tab A2smscq smscq_r5C_imp,mi

mi passive: gen A3smscq=0 if smscq_r5C_imp==1
mi passive: replace A3smscq=1 if smscq_r5C_imp==4
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
label variable A3smscq "1-<2hrs vs no SM use"
mi xeq: tab A3smscq smscq_r5C_imp,mi

mi passive: gen A4smscq=0 if smscq_r5C_imp==1
mi passive: replace A4smscq=1 if smscq_r5C_imp==5
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
label variable A4smscq "≥2hrs vs no SM use"
mi xeq: tab A4smscq smscq_r5C_imp,mi

mi update 


*# TABLE 2A,3A,5A,6A:
*#1st command: Risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education
*#*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education  
*NOTE:error arises as we used if condition based on imputed/passive vars when creating A1smscq etc. mi estimate considers this a mistake but, if this is out intent we should specify the mi estimate command and include the esampvaryok option.

**low parental education 
*A1: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#ib1.hied_COB_imp,  baselevel 

*A2:
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#ib1.hied_COB_imp,  baselevel 

*A3: 
mi estimate, irr  esampvaryok: svy: poisson smok_rB_imp A3smscq#ib1.hied_COB_imp, baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#ib1.hied_COB_imp,  baselevel 


**high parental education
*A1:
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#hied_COB_imp, baselevel 

*A2: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#hied_COB_imp,  baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq#hied_COB_imp,  baselevel  

*A4: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#hied_COB_imp,  baselevel 


*#TABLE 5A & 6A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#A1smscq,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A1smscq,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A2smscq,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A3smscq, baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A4smscq, baselevel 


/*#TABLE 2A, 3A, 5A: Generate indicator variables where:
 ind11=1: EM exposed & SM exposed
 ind10 (SM) =1: EM not exposed & SM exposed
 ind01 (PAR ED) =1: EM exposed & SM not exposed 
 ind00=1: EM not exposed & SM not exposed (reference category)
 */
mi passive: gen A1ind11=1 if A1smscq==1 & hied_COB_imp==1  
mi passive: gen A1ind10=1 if A1smscq==1 & hied_COB_imp==0 
mi passive: gen A1ind01=1 if A1smscq==0 & hied_COB_imp==1  
mi passive: replace A1ind11=0 if A1ind11==.
mi passive: replace A1ind10=0 if A1ind10==.
mi passive: replace A1ind01=0 if A1ind01==.
mi passive: replace A1ind11=. if A1smscq==.
mi passive:replace A1ind10=. if A1smscq==.
mi passive: replace A1ind01=. if A1smscq==.
label variable A1ind11 "lowpared_1-<30min"
label variable A1ind10 "high pared & 1-<30min"
label variable A1ind01 "low pared & no SM use"
 
mi passive: gen A2ind11=1 if A2smscq==1 & hied_COB_imp==1  
mi passive: gen A2ind10=1 if A2smscq==1 & hied_COB_imp==0 
mi passive: gen A2ind01=1 if A2smscq==0 & hied_COB_imp==1  
mi passive: replace A2ind11=0 if A2ind11==.
mi passive: replace A2ind10=0 if A2ind10==.
mi passive: replace A2ind01=0 if A2ind01==.
mi passive:replace A2ind11=. if A2smscq==.
mi passive: replace A2ind10=. if A2smscq==.
mi passive: replace A2ind01=. if A2smscq==.
label variable A2ind11 "low pared & 30min-<1hr"
label variable A2ind10 "high pared & 30min-<1hr"
label variable A2ind01 "low pared & no SM use"

mi passive: gen A3ind11=1 if A3smscq==1 & hied_COB_imp==1  
mi passive: gen A3ind10=1 if A3smscq==1 & hied_COB_imp==0 
mi passive: gen A3ind01=1 if A3smscq==0 & hied_COB_imp==1 
mi passive: replace A3ind11=0 if A3ind11==.
mi passive: replace A3ind10=0 if A3ind10==.
mi passive: replace A3ind01=0 if A3ind01==.
mi passive: replace A3ind11=. if A3smscq==.
mi passive: replace A3ind10=. if A3smscq==.
mi passive: replace A3ind01=. if A3smscq==.
label variable A3ind11 "low pared & 1-<2hrs"
label variable A3ind10 "high pared & 1-<2hrs"
label variable A3ind01 "low pared & no SM use"

mi passive: gen A4ind11=1 if A4smscq==1 & hied_COB_imp==1  
mi passive: gen A4ind10=1 if A4smscq==1 & hied_COB_imp==0 
mi passive: gen A4ind01=1 if A4smscq==0 & hied_COB_imp==1 
mi passive: replace A4ind11=0 if A4ind11==.
mi passive: replace A4ind10=0 if A4ind10==.
mi passive: replace A4ind01=0 if A4ind01==.
mi passive: replace A4ind11=. if A4smscq==.
mi passive: replace A4ind10=. if A4smscq==.
mi passive: replace A4ind01=. if A4smscq==.
label variable A4ind11 "low pared & ≥2hrs"
label variable A4ind10 "high pared & ≥2hrs"
label variable A4ind01 "low pared & no SM use"

mi update


*#TABLE 2A & 5A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11,  baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11
estat vce
*/*RERI not reported for unadjusted estimates, if you need to report update calculation
RERI and 95% CI as per excel: -0.528 (-2.300, 1.243)
*SE = (u − l)/(2×1.96) = .90382653
di (1.243-(-2.300))/(2*1.96)
*z score = Est/SE = -.5841829
di -0.528/.90382653
gen z1c_unadj =-.5841829
*2 tailed p value= 0.5590972 
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.528
di 1.645854-2.044319-1.129961 +1 */

*A2 
mi estimate, irr esampvaryok: svy: poisson  smok_rB_imp A2ind01 A2ind10 A2ind11, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A2ind01 A2ind10 A2ind11
estat vce
/*RERI not reported for unadjusted estimates, if you need to report update calculation
RERI and 95% CI as per excel: -0.595(-2.365-1.176)
*SE = (u − l)/(2×1.96) = .90331633
di (1.176-(-2.365))/(2*1.96)
*z score = Est/SE = -.65868399
di -0.595/.90331633
gen z2c_unadj=-.65868399
*2 tailed p value= .5100987  
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.595
di   2.20899  -2.044318 -1.759337  +1 */

*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11
estat vce
/*RERI not reported for unadjusted estimates, if you need to report update calculation
RERI and 95% CI as per excel: -0.855 (-2.594-0.884)
*SE = (u − l)/(2×1.96) = .8872449
di (0.884-(-2.594))/(2*1.96)
*z score = Est/SE = -.96365727
di -0.855/.8872449
gen z3c_unadj=-.96365727
*2 tailed p value= .3352178
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.855
di  2.223936 - 2.044318-2.034505+1 */

*A4 
mi estimate, irr esampvaryok: svy: poisson  smok_rB_imp A4ind01 A4ind10 A4ind11, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A4ind01 A4ind10 A4ind11
estat vce
/*RERI not reported for unadjusted estimates, if you need to report update calculation
RERI and 95% CI as per excel: -1.021(-2.662-0.621)
*SE = (u − l)/(2×1.96) = .8375
di (0.621-(-2.662))/(2*1.96)
*z score = Est/SE =-1.2191045
di -1.021/.8375
gen z4c_unadj= -1.2191045
*2 tailed p value=  .2228045 
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -1.021
di  2.866574- 2.044317  -2.842913+1 */


*#TABLE 3A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11, baselevel
*A2 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2ind01 A2ind10 A2ind11, baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11, baselevel
*A4 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4ind01 A4ind10 A4ind11, baselevel

*#TABLE 3A: Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq##hied_COB_imp,  baselevel
*A2
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq##hied_COB_imp,  baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq##hied_COB_imp,  baselevel
*A4
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq##hied_COB_imp,  baselevel

*#TABLE 3A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di  1.06 /1.29  
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di  1.03 /2.34   
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di  1.23  /2.65 
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed
di 1.75 /3.63 



/*TABLE 6A: Generate combined vars where (produced above):
ind00=0: EM not exposed & SM not exposed (reference category)
ind10=1 (SM): EM not exposed & SM exposed
ind01=2 (PAR ED): EM exposed & SM not exposed 
ind11=3: EM exposed & SM exposed
For the above EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Thus we need 4 estimates for the assessment of additive interaction for each pairwise comparison (A1-A4) */

mi passive: gen A1hied_reri=0 if hied_COB_imp==0 & A1smscq==0 
mi passive: replace A1hied_reri=1 if hied_COB_imp==0 & A1smscq==1
mi passive: replace A1hied_reri=2 if hied_COB_imp==1 & A1smscq==0 
mi passive: replace A1hied_reri=3 if hied_COB_imp==1 & A1smscq==1
label define A1hied_reri 0 "high ed # no sm use" 1"high ed # 1-<30min" 2"low ed # no sm use" 3"low ed # 1-<30min"
label values A1hied_reri A1hied_reri
mi xeq: tab A1hied_reri A1smscq, mi
mi xeq: tab A1hied_reri hied_COB_imp, mi

mi passive:gen A2hied_reri=0 if hied_COB_imp==0 & A2smscq==0 
mi passive:replace A2hied_reri=1 if hied_COB_imp==0 & A2smscq==1
mi passive:replace A2hied_reri=2 if hied_COB_imp==1 & A2smscq==0 
mi passive:replace A2hied_reri=3 if hied_COB_imp==1 & A2smscq==1
label define A2hied_reri 0 "high ed # no sm use" 1"high ed # 30min-<1hr" 2"low ed # no sm use" 3"low ed # 30min-<1hr"
label values A2hied_reri A2hied_reri
mi xeq: tab A2hied_reri A2smscq, mi
mi xeq: tab A2hied_reri hied_COB_imp, mi

mi passive:gen A3hied_reri=0 if hied_COB_imp==0 & A3smscq==0 
mi passive:replace A3hied_reri=1 if hied_COB_imp==0 & A3smscq==1
mi passive:replace A3hied_reri=2 if hied_COB_imp==1 & A3smscq==0 
mi passive:replace A3hied_reri=3 if hied_COB_imp==1 & A3smscq==1
label define A3hied_reri 0 "high ed # no sm use" 1"high ed # 1-<2hrs" 2"low ed # no sm use" 3"low ed # 1-<2hrs"
label values A3hied_reri A3hied_reri
mi xeq: tab A3hied_reri A3smscq, mi
mi xeq: tab A3hied_reri hied_COB_imp, mi

mi passive:gen A4hied_reri=0 if hied_COB_imp==0 & A4smscq==0 
mi passive:replace A4hied_reri=1 if hied_COB_imp==0 & A4smscq==1
mi passive:replace A4hied_reri=2 if hied_COB_imp==1 & A4smscq==0 
mi passive:replace A4hied_reri=3 if hied_COB_imp==1 & A4smscq==1
label define A4hied_reri 0 "high ed # no sm use" 1"high ed # ≥2hrs" 2"low ed # no sm use" 3"low ed # ≥2hrs"
label values A4hied_reri A4hied_reri
mi xeq: tab A4hied_reri A4smscq, mi
mi xeq: tab A4hied_reri hied_COB_imp, mi

mi update 

*#TABLE 6A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A1hied_reri ,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#hied_COB_imp, baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq##hied_COB_imp,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A1smscq##i.hied_COB_imp, baselevel

*A2
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A2hied_reri,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#hied_COB_imp,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq##hied_COB_imp,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A2smscq##i.hied_COB_imp,  baselevel


*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A3hied_reri,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq#hied_COB_imp,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq##hied_COB_imp,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A3smscq##i.hied_COB_imp,  baselevel


*A4
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A4hied_reri,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#hied_COB_imp,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq##hied_COB_imp,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A4smscq##i.hied_COB_imp,  baselevel


/*
*#TABLE 6A: Checks  
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RR for low parental education and 1-<30mins SM use
*R10 (p10-p00): RR for high parental education and 1-<30mins SM use
*R01 (p01-p00): RR for low parental education and no SM use
*Calculation: R11/(R01*R10) */	



*******************************************************************************
*#Pairwise comparison A1-A4: adjusted 
*******************************************************************************

*# TABLE 2A,3A,5A,6A:
*#1st command: Risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education
*#*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 

**low parental education 
*A1: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 

*A2:
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 

*A3: 
mi estimate, irr  esampvaryok: svy: poisson smok_rB_imp A3smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
 
*A4: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 
 


**high parental education
*A1:
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*A2: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel  
  
*A4: 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 


*#TABLE 5A & 6A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A2smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A3smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp hied_COB_imp#ib1.A4smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 


*#TABLE 2A & 5A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.126 (-1.005 to 0.752)
*SE = (u − l)/(2×1.96) = .44821429
di (0.752-(-1.005))/(2*1.96)
*z score = Est/SE = -.28111554
di -0.126/.44821429
gen z1c_adj =-.28111554
*2 tailed p value= .7786218
gen p1c_adj=2*(1-normal(abs(z1c_adj))) 
tab p1c_adj


*A2 
mi estimate, irr esampvaryok: svy: poisson  smok_rB_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -1.228 (-2.402 to 0.054)
*SE = (u − l)/(2×1.96) = .62653061
di (0.054-(-2.402))/(2*1.96)
*z score = Est/SE = -1.96
di -1.228 /.62653061
gen z2c_adj= -1.96
*2 tailed p value=  .0499958 
gen p2c_adj=2*(1-normal(abs(z2c_adj))) 
tab p2c_adj


*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -1.252 (-2.455 to -0.049)
*SE = (u − l)/(2×1.96) = .61377551
di (-0.049-(-2.455))/(2*1.96)
*z score = Est/SE = -2.0398337
di -1.252/.61377551
gen z3c_adj=-2.0398337
*2 tailed p value=  .0413669 
gen p3c_adj=2*(1-normal(abs(z3c_adj))) 
tab p3c_adj


*A4 
mi estimate, irr esampvaryok: svy: poisson  smok_rB_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok post: svy: poisson smok_rB_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -1.237  (-2.426 to -0.047)
*SE = (u − l)/(2×1.96) =.60688776
di (-0.047-(-2.426))/(2*1.96)
*z score = Est/SE = -2.0382682
di -1.237/.60688776
gen z4c_adj=-2.0382682
*2 tailed p value= .0415231
gen p4c_adj=2*(1-normal(abs(z4c_adj))) 
tab p4c_adj



*#TABLE 3A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A2 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A4 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*##TABLE 3A:Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*A2
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*A4
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel

*#TABLE 3A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di 1.10  /1.28 
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di  1.04 /2.30   
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di   1.13  /2.52 
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed
di  1.64  / 3.47 


*#TABLE 6A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A1hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A1smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A2
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A2hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A2smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel

*A3 
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A3hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A3smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel

*A4
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A4hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel
mi estimate, irr esampvaryok: svy: poisson smok_rB_imp i.A4smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc,  baselevel


/**#TABLE 6A:
*#Checks  
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RR for low parental education and 1-<30mins SM use
*R10 (p10-p00): RR for high parental education and 1-<30mins SM use
*R01 (p01-p00): RR for low parental education and no SM use
*Calculation: R11/(R01*R10) */	



*******************************************************************************


		