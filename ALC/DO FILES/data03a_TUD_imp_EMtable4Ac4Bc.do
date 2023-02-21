

********************************************************************************


*Do file: data03a_TUD_imp_EMtable4Ac4Bc
*Dataset used: data01_master_vs3_TUD_imp_3_2.dta
*Amrit Purba 26.1.23

/* Syntax for TUD imputed analysis: 
Additive measure of effect modification- Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)[4Ac]
Additive measures of interaction - Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1) [4Bc]
 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "ALC\DATASETS\data01_master_vs3_TUD_imp_3_2.dta", clear

set seed 5754367

* Should say   (data unchanged since 19jan2023 19:10)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************
mi convert flong
mi set flong

*Recode hied_COB_imp so reference category is low par ed (=0) instead of high par ed
mi xeq: tab hied_COB_imp, mi
mi passive: gen hied_COB_impx=.
mi passive: replace hied_COB_impx=0 if hied_COB_imp==1 
mi passive: replace hied_COB_impx=1 if hied_COB_impx==.
label define hied_COB_impx 0"0_low parental ed" 1"1_high parental ed"
label values  hied_COB_impx hied_COB_impx
mi xeq: tab hied_COB_impx, mi
mi rename hied_COB_imp hied_COB_imp1
mi rename hied_COB_impx hied_COB_imp
mi xeq: tab hied_COB_imp, mi 

/*Exposure 
codebook avgsm_tud_5Cimp
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
0  0_low pared (ref cat)
1  1_high pared

//Outcome 
codebook everbingedrink_rBcc_imp
0  0_No
1  1_Yes */


*******************************************************************************
// Prevalences
*******************************************************************************

set showbaselevels on
codebook avgsm_tud_5Cimp
codebook hied_COB_imp

*#Declare survey design
mi svyset [pweight=TUD_WT_RO2_imp], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 



// Unweighted prevalences (unweighted N: to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
* whole sample
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0
* by parental education 
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0 & hied_COB_imp==0 // low par ed 
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0 & hied_COB_imp==1 // high par ed

// Weighted prevalences
* whole sample
mi estimate: svy: proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp)
* by parental education 
mi estimate: svy, subpop(if hied_COB_imp==0) : proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp) // low par ed 
mi estimate: svy, subpop(if hied_COB_imp==1) : proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp) // high par ed

*******************************************************************************
// UNADJUSTED 
*******************************************************************************

// Generate individual binary variables for SM use from original ordinal exposure var 

mi xeq: tab avgsm_tud_5Cimp, mi
mi passive: gen A1smscq=0 if avgsm_tud_5Cimp==1
mi passive: replace A1smscq=1 if avgsm_tud_5Cimp==2
label define A1smscq 0"0_no SM use" 1"1_1-<30min"
label variable A1smscq "1-<30min vs no SM use"
label values A1smscq A1smscq 
mi xeq: tab A1smscq avgsm_tud_5Cimp,mi

mi passive: gen A2smscq=0 if avgsm_tud_5Cimp==1
mi passive: replace A2smscq=1 if avgsm_tud_5Cimp==3
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq
label variable A2smscq "30min-<1hr vs no SM use"
mi xeq: tab A2smscq avgsm_tud_5Cimp,mi

mi passive: gen A3smscq=0 if avgsm_tud_5Cimp==1
mi passive: replace A3smscq=1 if avgsm_tud_5Cimp==4
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
label variable A3smscq "1-<2hrs vs no SM use"
mi xeq: tab A3smscq avgsm_tud_5Cimp,mi

mi passive: gen A4smscq=0 if avgsm_tud_5Cimp==1
mi passive: replace A4smscq=1 if avgsm_tud_5Cimp==5
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
label variable A4smscq "≥2hrs vs no SM use"
mi xeq: tab A4smscq avgsm_tud_5Cimp,mi

mi update 

/// EFFECT MODIFICATION AND INTERACTION 
*#*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
**high parental education 
*A1: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#ib1.hied_COB_imp, irr baselevel  

*A2: 
mi estimate, irr esampvaryok: svy: poisson  everbingedrink_rBcc_imp A2smscq#ib1.hied_COB_imp, irr baselevel  

*A3: 
mi estimate, irr esampvaryok: svy: poisson  everbingedrink_rBcc_imp A3smscq#ib1.hied_COB_imp,irr baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson  everbingedrink_rBcc_imp A4smscq#ib1.hied_COB_imp, irr baselevel 

**low parental education
*A1: 
mi estimate, irr esampvaryok: svy: poisson  everbingedrink_rBcc_imp A1smscq#hied_COB_imp, irr baselevel 
 
*A2: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#hied_COB_imp,irr baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#hied_COB_imp, irr baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#hied_COB_imp, irr baselevel 

/// EFFECT MODIFICATION
/*#Generate indicator variables where (produced above):
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
label variable A1ind11 "high pared_1-<30min"
label variable A1ind10 "low pared & 1-<30min"
label variable A1ind01 "high pared & no SM use"
 
mi passive: gen A2ind11=1 if A2smscq==1 & hied_COB_imp==1  
mi passive: gen A2ind10=1 if A2smscq==1 & hied_COB_imp==0 
mi passive: gen A2ind01=1 if A2smscq==0 & hied_COB_imp==1  
mi passive: replace A2ind11=0 if A2ind11==.
mi passive: replace A2ind10=0 if A2ind10==.
mi passive: replace A2ind01=0 if A2ind01==.
mi passive:replace A2ind11=. if A2smscq==.
mi passive: replace A2ind10=. if A2smscq==.
mi passive: replace A2ind01=. if A2smscq==.
label variable A2ind11 "high pared & 30min-<1hr"
label variable A2ind10 "low pared & 30min-<1hr"
label variable A2ind01 "high pared & no SM use"

mi passive: gen A3ind11=1 if A3smscq==1 & hied_COB_imp==1  
mi passive: gen A3ind10=1 if A3smscq==1 & hied_COB_imp==0 
mi passive: gen A3ind01=1 if A3smscq==0 & hied_COB_imp==1 
mi passive: replace A3ind11=0 if A3ind11==.
mi passive: replace A3ind10=0 if A3ind10==.
mi passive: replace A3ind01=0 if A3ind01==.
mi passive: replace A3ind11=. if A3smscq==.
mi passive: replace A3ind10=. if A3smscq==.
mi passive: replace A3ind01=. if A3smscq==.
label variable A3ind11 "high pared & 1-<2hrs"
label variable A3ind10 "low pared & 1-<2hrs"
label variable A3ind01 "high pared & no SM use"

mi passive: gen A4ind11=1 if A4smscq==1 & hied_COB_imp==1  
mi passive: gen A4ind10=1 if A4smscq==1 & hied_COB_imp==0 
mi passive: gen A4ind01=1 if A4smscq==0 & hied_COB_imp==1 
mi passive: replace A4ind11=0 if A4ind11==.
mi passive: replace A4ind10=0 if A4ind10==.
mi passive: replace A4ind01=0 if A4ind01==.
mi passive: replace A4ind11=. if A4smscq==.
mi passive: replace A4ind10=. if A4smscq==.
mi passive: replace A4ind01=. if A4smscq==.
label variable A4ind11 "high pared & ≥2hrs"
label variable A4ind10 "low pared & ≥2hrs"
label variable A4ind01 "high pared & no SM use"

mi update



/// INTERACTION
/*Generate combined vars where:
ind00=0: EM not exposed & SM not exposed (reference category)
ind10=1 (SM): EM not exposed & SM exposed
ind01=2 (PAR ED): EM exposed & SM not exposed 
ind11=3: EM exposed & SM exposed
For the above EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Thus we need 4 estimates for the assessment of additive interaction for each pairwise comparison (A1-A4) */


mi passive: gen A1hied_reri=0 if hied_COB_imp==0 & A1smscq==0 
mi passive: replace A1hied_reri=1 if hied_COB_imp==0 & A1smscq==1
mi passive: replace A1hied_reri=2 if hied_COB_imp==1 & A1smscq==0 
mi passive: replace A1hied_reri=3 if hied_COB_imp==1 & A1smscq==1
label define A1hied_reri 0 "low ed # no sm use" 1"low ed # 1-<30min" 2"high ed # no sm use" 3"high ed # 1-<30min"
label values A1hied_reri A1hied_reri
mi xeq: tab A1hied_reri A1smscq, mi
mi xeq: tab A1hied_reri hied_COB_imp, mi

mi passive: gen A2hied_reri=0 if hied_COB_imp==0 & A2smscq==0 
mi passive: replace A2hied_reri=1 if hied_COB_imp==0 & A2smscq==1
mi passive: replace A2hied_reri=2 if hied_COB_imp==1 & A2smscq==0 
mi passive: replace A2hied_reri=3 if hied_COB_imp==1 & A2smscq==1
label define A2hied_reri 0 "low ed # no sm use" 1"low ed # 30min-<1hr" 2"high ed # no sm use" 3"high ed # 30min-<1hr"
label values A2hied_reri A2hied_reri
mi xeq: tab  A2hied_reri A2smscq, mi
mi xeq: tab  A2hied_reri hied_COB_imp, mi

mi passive: gen A3hied_reri=0 if hied_COB_imp==0 & A3smscq==0 
mi passive: replace A3hied_reri=1 if hied_COB_imp==0 & A3smscq==1
mi passive: replace A3hied_reri=2 if hied_COB_imp==1 & A3smscq==0 
mi passive: replace A3hied_reri=3 if hied_COB_imp==1 & A3smscq==1
label define A3hied_reri 0 "low ed # no sm use" 1"low ed # 1-<2hrs" 2"high ed # no sm use" 3"high ed # 1-<2hrs"
label values A3hied_reri A3hied_reri
mi xeq: tab  A3hied_reri A3smscq, mi
mi xeq: tab  A3hied_reri hied_COB_imp, mi

mi passive: gen A4hied_reri=0 if hied_COB_imp==0 & A4smscq==0 
mi passive: replace A4hied_reri=1 if hied_COB_imp==0 & A4smscq==1
mi passive: replace A4hied_reri=2 if hied_COB_imp==1 & A4smscq==0 
mi passive: replace A4hied_reri=3 if hied_COB_imp==1 & A4smscq==1
label define A4hied_reri 0 "low ed # no sm use" 1"low ed # ≥2hrs" 2"high ed # no sm use" 3"high ed # ≥2hrs"
label values A4hied_reri A4hied_reri
mi xeq: tab  A4hied_reri A4smscq, mi
mi xeq: tab  A4hied_reri hied_COB_imp, mi

mi update 

/// INTERACTION 
// Risk ratios (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#A1smscq, irr baselevel 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A1smscq, irr baselevel 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A2smscq, irr baselevel 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A3smscq, irr baselevel 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A4smscq, irr baselevel 
 
/// EFFECT MODIFICATION AND INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of additive effect modification & interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11, irr baselevel
mi estimate,  esampvaryok post: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11
estat vce
/* RERI not reported for unadjusted estimates, update calculation if required: RERI and 95% CI as per excel: 0.069 (-0.555 to 0.694)
*SE = (u − l)/(2×1.96) = .31862245
di ( 0.694-(-0.555))/(2*1.96)
*z score = Est/SE = .21655725
di 0.069/.31862245
gen z1c_unadj =.21655725
*2 tailed p value= .8285534
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.162169
di 1.418941 - 1.31028-1.039506   +1 */

*A2 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11, irr
mi estimate, esampvaryok post: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11
estat vce
/* RERI not reported for unadjusted estimates, update calculation if required:
RERI and 95% CI as per excel: 0.294(-0.303 to 0.892 )
*SE = (u − l)/(2×1.96) =.30484694
di (0.892 -(-0.303))/(2*1.96)
*z score = Est/SE =.96441841
di 0.294/.30484694
gen z2c_unadj=.96441841
*2 tailed p value= .9860821
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj */


*A3 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11, irr
mi estimate, esampvaryok post: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11
estat vce
/* RERI not reported for unadjusted estimates, update calculation if required:
RERI and 95% CI as per excel: 0.025 (-0.880 to 0.929)
*SE = (u − l)/(2×1.96) = .46147959
di (0.929-(-0.880))/(2*1.96)
*z score = Est/SE = .05417358
di 0.025/.46147959
gen z3c_unadj=.05417358
*2 tailed p value= 0.9567969 
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj */

*A4 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11, irr
mi estimate, esampvaryok post: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11
estat vce
/* RERI not reported for unadjusted estimates, update calculation if required:
RERI and 95% CI as per excel: 0.074 (-0.807 to 0.955)
*SE = (u − l)/(2×1.96) = .4494898
di (0.955-(-0.807))/(2*1.96)
*z score = Est/SE = .1646311
di  0.074/.4494898
gen z4c_unadj=.1646311
*2 tailed p value= .8692343 
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj */


/// CHECKS 
/*(RR11): EM exposed and SM exposed
(RR10): SM exposed and EM not exposed
(RR01): EM exposed and SM not exposed
(RR00): SM not exposed and EM not exposed 

FORMULA FOR RERI:
RERI= RR11-RR01 -RR10 +1 */
*******************************************************************************

*# Adjusted 

*******************************************************************************

///EFFECT MODIFICATION AND INTERACTION 
*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**high parental education 
*A1: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A2: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

**low parental education
*A1: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A2: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

/// INTERACTION 
*#Risk ratios (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A2smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A3smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp hied_COB_imp#ib1.A4smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel

/// EFFECT MODIFICATION AND INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of additive effect modification & interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate,  esampvaryok post: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: 0.093 (-0.183 to 0.370)
*SE = (u − l)/(2×1.96) =.14107143
di (0.370-(-0.183))/(2*1.96)
*z score = Est/SE = .6592405
di 0.093/.14107143
gen z1c_adj =.6592405
*2 tailed p value=  .5097414
gen p1c_adj=2*(1-normal(abs(z1c_adj))) 
tab p1c_adj


*A2 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
mi estimate,  esampvaryok post: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: 0.155 (-0.143 to 0.454)
*SE = (u − l)/(2×1.96) = .15229592
di (0.454-(-0.143))/(2*1.96)
*z score = Est/SE =1.0177554
di 0.155 /.15229592
gen z2c_adj= 1.0177554
*2 tailed p value= .3087942
gen p2c_adj=2*(1-normal(abs(z2c_adj))) 
tab p2c_adj


*A3 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
mi estimate,  esampvaryok post: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: 0.085 (-0.290 to 0.461)
*SE = (u − l)/(2×1.96) = .19158163
di (0.461-(-0.290))/(2*1.96)
*z score = Est/SE = .44367511
di  0.085/.19158163
gen z3c_adj=.44367511
*2 tailed p value= .6572775
gen p3c_adj=2*(1-normal(abs(z3c_adj))) 
tab p3c_adj


*A4 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
mi estimate,  esampvaryok post: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: -0.139 (-0.528 to 0.249)
*SE = (u − l)/(2×1.96) = .19821429
di (0.249-(-0.528))/(2*1.96)
*z score = Est/SE = -.70126125
di  -0.139/.19821429
gen z4c_adj=-.70126125
*2 tailed p value=    .48314
gen p4c_adj=2*(1-normal(abs(z4c_adj))) 
tab p4c_adj


/// CHECKS 
/*(RR11): EM exposed and SM exposed
(RR10): SM exposed and EM not exposed
(RR01): EM exposed and SM not exposed
(RR00): SM not exposed and EM not exposed 

FORMULA FOR RERI:
RERI= RR11-RR01 -RR10 +1 */
*******************************************************************************


*******************************************************************************
