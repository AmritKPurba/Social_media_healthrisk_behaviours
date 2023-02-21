

********************************************************************************

*Do file:data03b_TUD_cc_EMtable4Ca4Da_vs1
*Dataset used: data01_TUD_cc_alc.dta
*Amrit Purba 26.1.23

/* Syntax for TUD complete case analysis: Additive measure of effect modification - Linear regression with robust standard errors (RD high PE-low PE) [4Ca]
Additive measure of interaction - Linear regression with robust standard errors (RD11-(RD10+RD01)) [4Da] */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "ALC\DATASETS\data01_TUD_cc_alc.dta", clear

set seed 575363

* Should say (data unchanged since 25jan2023 09:42)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

*Identify reference category to be used in EM and interaction analysis considering both exposure and EM jointly identify the stratum with the lowest risk of ever binge drinking which will become our reference category: low parental education and 1-<30 mins (as per- Estimating measures of interaction on an additive scale for preventive exposures). However to be consistent with SCQ analyses we will use low parental education and no SM use, as estimates between both SM time categories are similar.
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit everbingedrink_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel
logit everbingedrink_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel

*Recode hied_COBcc so reference category is low par ed (=0) instead of high par ed
tab hied_COBcc
recode hied_COBcc 0=1 1=0
label define hied_COBccx 0"0_low parental ed" 1"1_high parental ed"
label values  hied_COBcc hied_COBccx
tab hied_COBcc
codebook hied_COBcc

/*Exposure 
codebook avgsm_tud_r5Ccc
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
codebook hied_COBcc
0  0_low pared (ref cat)
1  1_high pared

//Outcome 
codebook everbingedrink_rBcc
0  0_No
1  1_Yes */

*******************************************************************************
// Prevalences
*******************************************************************************

set showbaselevels on
codebook avgsm_tud_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

*#Unadjusted prevalences   
tab everbingedrink_rBcc avgsm_tud_r5Ccc if hied_COBcc==1 // high pared
tab everbingedrink_rBcc avgsm_tud_r5Ccc if hied_COBcc==0 // low pared


*#Weighted prevalences
svy, subpop (if hied_COBcc==1):proportion everbingedrink_rBcc, over (avgsm_tud_r5Ccc)  // high pared
svy, subpop (if hied_COBcc==0):proportion everbingedrink_rBcc, over (avgsm_tud_r5Ccc)   // low pared

*******************************************************************************
// UNADJUSTED
*******************************************************************************

// Generate individual binary variables for SM use from original ordinal exposure var 
clonevar A1smscq = avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A1smscq 1=0 2=1 3 4 5 =.
label define A1smscq 0"0_no SM use" 1"1_1-<30min"
label variable A1smscq "1-<30min vs no SM use"
label values A1smscq A1smscq 
tab A1smscq avgsm_tud_r5Ccc,mi

clonevar A2smscq = avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A2smscq 1=0 3=1 2 4 5 =.
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq 
label variable A2smscq "30min-<1hr vs no SM use"
tab A2smscq avgsm_tud_r5Ccc,mi

clonevar A3smscq = avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A3smscq 1=0 4=1 2 3 5 =.
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
label variable A3smscq "1-<2hrs vs no SM use"
tab A3smscq avgsm_tud_r5Ccc,mi

clonevar A4smscq = avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A4smscq 1=0 5=1 2 3 4 =.
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
label variable A4smscq "≥2hrs vs no SM use"
tab A4smscq avgsm_tud_r5Ccc,mi


/// EFFECT MODIFICATION AND INTERACTION 
// 1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) /
// 2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**high parental education 
*A1: 
svy: regress everbingedrink_rBcc A1smscq#ib1.hied_COBcc, baselevel 

*A2:
svy: regress everbingedrink_rBcc A2smscq#ib1.hied_COBcc, baselevel 

*A3: 
svy: regress everbingedrink_rBcc A3smscq#ib1.hied_COBcc, baselevel

*A4: 
svy: regress everbingedrink_rBcc A4smscq#ib1.hied_COBcc, baselevel 

**low parental education
*A1:
svy: regress everbingedrink_rBcc A1smscq#hied_COBcc, baselevel 

*A2: 
svy: regress everbingedrink_rBcc A2smscq#hied_COBcc, baselevel 

*A3: 
svy: regress everbingedrink_rBcc A3smscq#hied_COBcc, baselevel  

*A4: 
svy: regress everbingedrink_rBcc A4smscq#hied_COBcc, baselevel 

 
/// EFFECT MODIFICATION 
/*#Generate indicator variables where:
 ind11=1: EM exposed & SM exposed
 ind10 (SM) =1: EM not exposed & SM exposed
 ind01 (PAR ED) =1: EM exposed & SM not exposed 
 ind00=1: EM not exposed & SM not exposed (reference category)
 */

*missing vals in A1smscq
tab A1smscq, mi
*no missing vals in hied_COBcc
tab hied_COBcc, mi
gen A1ind11=1 if A1smscq==1 & hied_COBcc==1  
gen A1ind10=1 if A1smscq==1 & hied_COBcc==0 
gen A1ind01=1 if A1smscq==0 & hied_COBcc==1  
replace A1ind11=0 if A1ind11==.
replace A1ind10=0 if A1ind10==.
replace A1ind01=0 if A1ind01==.
replace A1ind11=. if A1smscq==.
replace A1ind10=. if A1smscq==.
replace A1ind01=. if A1smscq==.
label variable A1ind11 "high pared_1-<30min"
label variable A1ind10 "low pared & 1-<30min"
label variable A1ind01 "high pared & no SM use"
 
*missing vals in A2smscq
tab A2smscq, mi
gen A2ind11=1 if A2smscq==1 & hied_COBcc==1  
gen A2ind10=1 if A2smscq==1 & hied_COBcc==0 
gen A2ind01=1 if A2smscq==0 & hied_COBcc==1  
replace A2ind11=0 if A2ind11==.
replace A2ind10=0 if A2ind10==.
replace A2ind01=0 if A2ind01==.
replace A2ind11=. if A2smscq==.
replace A2ind10=. if A2smscq==.
replace A2ind01=. if A2smscq==.
label variable A2ind11 "high pared & 30min-<1hr"
label variable A2ind10 "low pared & 30min-<1hr"
label variable A2ind01 "high pared & no SM use"

*missing vals in A3smscq
tab A3smscq, mi
gen A3ind11=1 if A3smscq==1 & hied_COBcc==1  
gen A3ind10=1 if A3smscq==1 & hied_COBcc==0 
gen A3ind01=1 if A3smscq==0 & hied_COBcc==1 
replace A3ind11=0 if A3ind11==.
replace A3ind10=0 if A3ind10==.
replace A3ind01=0 if A3ind01==.
replace A3ind11=. if A3smscq==.
replace A3ind10=. if A3smscq==.
replace A3ind01=. if A3smscq==.
label variable A3ind11 "high pared & 1-<2hrs"
label variable A3ind10 "low pared & 1-<2hrs"
label variable A3ind01 "high pared & no SM use"

*missing vals in A4smscq
tab A4smscq, mi
gen A4ind11=1 if A4smscq==1 & hied_COBcc==1  
gen A4ind10=1 if A4smscq==1 & hied_COBcc==0 
gen A4ind01=1 if A4smscq==0 & hied_COBcc==1 
replace A4ind11=0 if A4ind11==.
replace A4ind10=0 if A4ind10==.
replace A4ind01=0 if A4ind01==.
replace A4ind11=. if A4smscq==.
replace A4ind10=. if A4smscq==.
replace A4ind01=. if A4smscq==.
label variable A4ind11 "high pared & ≥2hrs"
label variable A4ind10 "low pared & ≥2hrs"
label variable A4ind01 "high pared & no SM use"


/// INTERACTION
/*Generate combined vars where:
ind00=0: EM not exposed & SM not exposed (reference category)
ind10=1 (SM): EM not exposed & SM exposed
ind01=2 (PAR ED): EM exposed & SM not exposed 
ind11=3: EM exposed & SM exposed
For the above EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Thus we need 4 estimates for the assessment of additive interaction for each pairwise comparison (A1-A4) */

gen A1hied_reri=0 if hied_COBcc==0 & A1smscq==0 
replace A1hied_reri=1 if hied_COBcc==0 & A1smscq==1
replace A1hied_reri=2 if hied_COBcc==1 & A1smscq==0 
replace A1hied_reri=3 if hied_COBcc==1 & A1smscq==1
label define A1hied_reri 0 "low ed # no sm use" 1"low ed # 1-<30min" 2"high ed # no sm use" 3"high ed # 1-<30min"
label values A1hied_reri A1hied_reri
tab A1hied_reri A1smscq, mi
tab A1hied_reri hied_COBcc, mi

gen A2hied_reri=0 if hied_COBcc==0 & A2smscq==0 
replace A2hied_reri=1 if hied_COBcc==0 & A2smscq==1
replace A2hied_reri=2 if hied_COBcc==1 & A2smscq==0 
replace A2hied_reri=3 if hied_COBcc==1 & A2smscq==1
label define A2hied_reri 0 "low ed # no sm use" 1"low ed # 30min-<1hr" 2"high ed # no sm use" 3"high ed # 30min-<1hr"
label values A2hied_reri A2hied_reri
tab A2hied_reri A2smscq, mi
tab A2hied_reri hied_COBcc, mi

gen A3hied_reri=0 if hied_COBcc==0 & A3smscq==0 
replace A3hied_reri=1 if hied_COBcc==0 & A3smscq==1
replace A3hied_reri=2 if hied_COBcc==1 & A3smscq==0 
replace A3hied_reri=3 if hied_COBcc==1 & A3smscq==1
label define A3hied_reri 0 "low ed # no sm use" 1"low ed # 1-<2hrs" 2"high ed # no sm use" 3"high ed # 1-<2hrs"
label values A3hied_reri A3hied_reri
tab A3hied_reri A3smscq, mi
tab A3hied_reri hied_COBcc, mi

gen A4hied_reri=0 if hied_COBcc==0 & A4smscq==0 
replace A4hied_reri=1 if hied_COBcc==0 & A4smscq==1
replace A4hied_reri=2 if hied_COBcc==1 & A4smscq==0 
replace A4hied_reri=3 if hied_COBcc==1 & A4smscq==1
label define A4hied_reri 0 "low ed # no sm use" 1"low ed # ≥2hrs" 2"high ed # no sm use" 3"high ed # ≥2hrs"
label values A4hied_reri A4hied_reri
tab A4hied_reri A4smscq, mi
tab A4hied_reri hied_COBcc, mi



/// INTERACTION 
// Risk differences (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use
svy: regress everbingedrink_rBcc hied_COBcc#A1smscq, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A1smscq, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A2smscq, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A3smscq, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A4smscq, baselevel

/// INTERACTION 
// Risk differences (95% CI; P-value) for SM use and parental education (rc: low parental education & no SM use) and Measure of additive interaction (95% CI; P-value)
*A1
svy: regress everbingedrink_rBcc i.A1hied_reri
*double check same as interaction
svy: regress everbingedrink_rBcc A1smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A1smscq##hied_COBcc
svy: regress everbingedrink_rBcc i.A1smscq##i.hied_COBcc

*A2
svy: regress everbingedrink_rBcc i.A2hied_reri
*double check same as interaction
svy: regress everbingedrink_rBcc A2smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A2smscq##hied_COBcc
svy: regress everbingedrink_rBcc i.A2smscq##i.hied_COBcc

*A3
svy: regress everbingedrink_rBcc i.A3hied_reri
*double check same as interaction
svy: regress everbingedrink_rBcc A3smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A3smscq##hied_COBcc
svy: regress everbingedrink_rBcc i.A3smscq##i.hied_COBcc

*A4
svy: regress everbingedrink_rBcc i.A4hied_reri
*double check same as interaction
svy: regress everbingedrink_rBcc A4smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A4smscq##hied_COBcc
svy: regress everbingedrink_rBcc i.A4smscq##i.hied_COBcc


/// EFFECT MODIFICATION 
// Risk differences (95% CI; P-value) for SM use and parental education (rc: low parental education & no SM use) 
*A1:
svy: regress everbingedrink_rBcc A1ind01 A1ind10 A1ind11, baselevel
*A2:
svy: regress everbingedrink_rBcc A2ind01 A2ind10 A2ind11, baselevel
*A3: 
svy: regress everbingedrink_rBcc A3ind01 A3ind10 A3ind11, baselevel
*A4:
svy: regress everbingedrink_rBcc A4ind01 A4ind10 A4ind11, baselevel


/// EFFECT MODIFICATION
// Measure of additive effect modification (95% CI; P-value)
*A1: 
svy: regress everbingedrink_rBcc A1smscq##hied_COBcc , baselevel
*A2:
svy: regress everbingedrink_rBcc A2smscq##hied_COBcc , baselevel
*A3: 
svy: regress everbingedrink_rBcc A3smscq##hied_COBcc , baselevel
*A4: 
svy: regress everbingedrink_rBcc A4smscq##hied_COBcc , baselevel
*svy: regress everbingedrink_rBcc avgsm_tud_r5Ccc##hied_COBcc , baselevel



/// EFFECT MODIFICATION
// Checks measure of additive effect modification (RD in high PE- RD in low PE) 
*A1: 1_1-<30min#1_high parentel ed - 1_1-<30min#0_low parental ed
di 10.8 --3.4 
*A2: 1_30min-<1hr#1_high parentel ed - 1_30min-<1hr#0_low parental ed 
di 7.3 --10.5 
*A3:  1_1-<2hrs#1_high parentel ed -  1_1-<2hrs#0_lowh parental ed 
di 2.5 -7.0 
*A4:  1_≥2hrs#1_high parentel ed - 1_≥2hrs#0_low parental ed
di -5.7 -2.6 


/// INTERACTION 
//Checks measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for high parental education and 1-<30mins SM use
*R10 (p10-p00): RD for low parental education and 1-<30mins SM use
*R01 (p01-p00): RD for high parental education and no SM use
*Calculation: R11-(R01+R10) */

*******************************************************************************
/// ADJUSTED
*******************************************************************************

/// EFFECT MODIFICATION AND INTERACTION
// 1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
// 2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**high parental education
*A1: 
svy: regress everbingedrink_rBcc A1smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel

*A2: 
svy: regress everbingedrink_rBcc A2smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel

*A3: 
svy: regress everbingedrink_rBcc A3smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel

*A4: 
svy: regress everbingedrink_rBcc A4smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel

**low parental education
*A1: 
svy: regress everbingedrink_rBcc A1smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 

*A2:
svy: regress everbingedrink_rBcc A2smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel  

*A3: 
svy: regress everbingedrink_rBcc A3smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 

*A4: 
svy: regress everbingedrink_rBcc A4smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 


/// INTERACTION 
// Risk differences (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use
svy: regress everbingedrink_rBcc hied_COBcc#A1smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A1smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A2smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A3smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel
svy: regress everbingedrink_rBcc hied_COBcc#ib1.A4smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel


/// INTERACTION 
// Risk differences (95% CI; P-value) for SM use and parental education (rc: low parental education & no SM use) and Measure of additive interaction (95% CI; P-value)
*A1
svy: regress everbingedrink_rBcc i.A1hied_reri  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*double check same as interaction
svy: regress everbingedrink_rBcc A1smscq#hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A1smscq##hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
svy: regress everbingedrink_rBcc i.A1smscq##i.hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc

*A2
svy: regress everbingedrink_rBcc i.A2hied_reri  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*double check same as interaction
svy: regress everbingedrink_rBcc A2smscq#hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A2smscq##hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
svy: regress everbingedrink_rBcc i.A2smscq##i.hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc

*A3
svy: regress everbingedrink_rBcc i.A3hied_reri  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*double check same as interaction
svy: regress everbingedrink_rBcc A3smscq#hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A3smscq##hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
svy: regress everbingedrink_rBcc i.A3smscq##i.hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc

*A4
svy: regress everbingedrink_rBcc i.A4hied_reri  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*double check same as interaction
svy: regress everbingedrink_rBcc A4smscq#hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress everbingedrink_rBcc A4smscq##hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
svy: regress everbingedrink_rBcc i.A4smscq##i.hied_COBcc  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc


/// EFFECT MODIFICATION 
// Risk differences (95% CI; P-value) for SM use and parental education (rc: low parental education & no SM use)
*A1 
svy: regress everbingedrink_rBcc A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A2 
svy: regress everbingedrink_rBcc A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A3 
svy: regress everbingedrink_rBcc A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A4 
svy: regress everbingedrink_rBcc A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 


/// EFFECT MODIFICATION
// Measure of additive effect modification (95% CI; P-value)
*A1 
svy: regress everbingedrink_rBcc A1smscq##hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A2 
svy: regress everbingedrink_rBcc A2smscq##hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A3 
svy: regress everbingedrink_rBcc A3smscq##hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 
*A4 
svy: regress everbingedrink_rBcc A4smscq##hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel 


/// EFFECT MODIFICATION
// Checks measure of additive effect modification (RD in high PE- RD in low PE) 
*A1: 1_1-<30min#1_high parentel ed - 1_1-<30min#0_low parental ed
di 9.9 --5.5 
*A2: 1_30min-<1hr#1_high parentel ed - 1_30min-<1hr#0_low parental ed 
di 9.7 --6.1    
*A3:  1_1-<2hrs#1_high parentel ed -  1_1-<2hrs#0_lowh parental ed 
di 2.9 -7.9 
*A4:  1_≥2hrs#1_high parentel ed - 1_≥2hrs#0_low parental ed
di 1.4 -4.9 


/// INTERACTION 
//Checks measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for high parental education and 1-<30mins SM use
*R10 (p10-p00): RD for low parental education and 1-<30mins SM use
*R01 (p01-p00): RD for high parental education and no SM use
*Calculation: R11-(R01+R10) */


*******************************************************************************


*******************************************************************************