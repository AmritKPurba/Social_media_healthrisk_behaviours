********************************************************************************
*# Time use diary imputed multiplicative effect modification & interaction analysis: social media > binge drinking 
********************************************************************************

/*
AK Purba [last updated: 21.02.2023]
Do file: data03a_TUD_imp_EMtable4Ab4Bb_vs1.do
Dataset: data01_master_vs3_TUD_imp_3_2.dta

Syntax: 
Multiplicative measure of effect modification - Poisson regression with robust standard errors (RR high PE/RR low PE) [4Ab]
Multiplicative measures of interaction - Poission regression with robust standard errors (RR11/RR10*RR01) [4Bb]
 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "Social_media_alcohol\DATASETS\data01_master_vs3_TUD_imp_3_2.dta", clear
set seed 574367

* Should say (data unchanged since 19jan2023 19:10)
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
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#ib1.hied_COB_imp, irr baselevel 

*A3: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#ib1.hied_COB_imp,irr baselevel 

*A4: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#ib1.hied_COB_imp, irr baselevel 

**low parental education
*A1: 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#hied_COB_imp, irr baselevel 
 
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
 

/// INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A1hied_reri , irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#hied_COB_imp, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq##hied_COB_imp, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A1smscq##i.hied_COB_imp, irr baselevel


*A2
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A2hied_reri, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#hied_COB_imp, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq##hied_COB_imp, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A2smscq##i.hied_COB_imp, irr baselevel

*A3
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A3hied_reri, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#hied_COB_imp, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq##hied_COB_imp, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A3smscq##i.hied_COB_imp, irr baselevel


*A4
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A4hied_reri, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#hied_COB_imp, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq##hied_COB_imp, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A4smscq##i.hied_COB_imp, irr baselevel

 
/// EFFECT MODIFCATION
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
*A1 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11, irr
*A2 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11, irr
*A3 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11, irr
*A4 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11, irr


/// EFFECT MODIFCATION
// Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq##hied_COB_imp, irr baselevel
*A2
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq##hied_COB_imp, irr baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq##hied_COB_imp, irr baselevel
*A4
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq##hied_COB_imp, irr baselevel


/// EFFECT MODIFCATION
// Checks of measure of multiplicative effect modification (high par ed/low par ed)
*A1: 1_1-<30min#1_high parentel ed/1_1-<30min#0_low parental ed
di  1.14 /1.08 
*A2: 1_30min-<1hr#1_high parentel ed/1_30min-<1hr#0_low parental ed 
di  1.18 /1.04   
*A3:  1_1-<2hrs#1_high parentel ed/1_1-<2hrs#0_low parental ed 
di  1.15 /1.08
*A4:  1_≥2hrs#1_high parentel ed/1_≥2hrs#0_low parental ed
di 0.98  / 1.20 


/// INTERACTION 
*Checks for measure of multiplicative interaction using A1 as example: 
*R11 (p11-p00): RR for high parental education and 1-<30mins SM use
*R10 (p10-p00): RR for low parental education and 1-<30mins SM use
*R01 (p01-p00): RR for high parental education and no SM use
*Calculation: R11/(R01*R10)


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

 
/// INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A1hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A1smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel


*A2
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A2hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A2smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel


*A3
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A3hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A3smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel


*A4
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A4hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*double check same as interaction
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp i.A4smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel


/// EFFECT MODIFICATION
*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use) 
*A1 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A2 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A3 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A4 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel

/// EFFECT MODIFICATION
*#Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A2 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A3
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
*A4 
mi estimate, irr esampvaryok: svy: poisson everbingedrink_rBcc_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel

/// EFFECT MODIFCATION
// Checks of measure of multiplicative effect modification (high par ed/low par ed)
*A1: 1_1-<30min#1_high parentel ed/1_1-<30min#0_low parental ed
di  1.13 /1.04 
*A2: 1_30min-<1hr#1_high parentel ed/1_30min-<1hr#0_low parental ed 
di  1.20 /1.05 
*A3:  1_1-<2hrs#1_high parentel ed/1_1-<2hrs#0_low parental ed 
di  1.17 /1.09 
*A4:  1_≥2hrs#1_high parentel ed/1_≥2hrs#0_low parental ed
di  1.15 /1.29 


/// INTERACTION 
*Checks for measure of multiplicative interaction using A1 as example: 
*R11 (p11-p00): RR for high parental education and 1-<30mins SM use
*R10 (p10-p00): RR for low parental education and 1-<30mins SM use
*R01 (p01-p00): RR for high parental education and no SM use
*Calculation: R11/(R01*R10)

*******************************************************************************


*******************************************************************************
