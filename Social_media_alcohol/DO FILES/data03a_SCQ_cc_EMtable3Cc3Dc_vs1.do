********************************************************************************
*# Self-report complete case additive effect modification & interaction analysis: social media > binge drinking [RERI]
********************************************************************************

/*
Dataset: data01_master_vs3_SCQ_imp_4_1.dta
Do file: data03a_SCQ_cc_EMtable3Cc3Dc_vs1.do
Dataset : data01_SCQ_cc_alc.dta

Syntax: 
Additive measure of effect modification- Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)[3Cc]
Additive measures of interaction - Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1) [3Dc]

 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "ALC\DATASETS\data01_SCQ_cc_alc.dta", clear
set seed 574367

*should say   (data unchanged since 18jan2023 14:51)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

*Recode hied_COBcc so reference category is low par ed (=0) instead of high par ed
tab hied_COBcc
recode hied_COBcc 0=1 1=0
label define hied_COBccx 0"0_low parental ed" 1"1_high parental ed"
label values  hied_COBcc hied_COBccx
tab hied_COBcc
codebook hied_COBcc

/*Exposure 
codebook smscq_r5Ccc
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
codebook smscq_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 


*#Unadjusted prevalences   
tab everbingedrink_rBcc smscq_r5Ccc if hied_COBcc==1 // high pared
tab everbingedrink_rBcc smscq_r5Ccc if hied_COBcc==0 // low pared


svy, subpop (if hied_COBcc==1):proportion everbingedrink_rBcc, over (smscq_r5Ccc)  // high pared
svy, subpop (if hied_COBcc==0):proportion everbingedrink_rBcc, over (smscq_r5Ccc)   // low pared

*******************************************************************************
// UNADJUSTED 
*******************************************************************************

// Generate individual binary variables for SM use from original ordinal exposure var 
clonevar A1smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A1smscq 1=0 2=1 3 4 5 =.
label define A1smscq 0"0_no SM use" 1"1_1-<30min"
label variable A1smscq "1-<30min vs no SM use"
label values A1smscq A1smscq 
tab A1smscq smscq_r5Ccc,mi

clonevar A2smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A2smscq 1=0 3=1 2 4 5 =.
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq 
label variable A2smscq "30min-<1hr vs no SM use"
tab A2smscq smscq_r5Ccc,mi

clonevar A3smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A3smscq 1=0 4=1 2 3 5 =.
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
label variable A3smscq "1-<2hrs vs no SM use"
tab A3smscq smscq_r5Ccc,mi

clonevar A4smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A4smscq 1=0 5=1 2 3 4 =.
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
label variable A4smscq "≥2hrs vs no SM use"
tab A4smscq smscq_r5Ccc,mi

/// EFFECT MODIFICATION AND INTERACTION 
*#*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
**high parental education 
*A1: 
svy: poisson everbingedrink_rBcc A1smscq#ib1.hied_COBcc, irr baselevel 

*A2: 
svy: poisson everbingedrink_rBcc A2smscq#ib1.hied_COBcc, irr baselevel 

*A3: 
svy: poisson everbingedrink_rBcc A3smscq#ib1.hied_COBcc,irr baselevel 

*A4: 
svy: poisson everbingedrink_rBcc A4smscq#ib1.hied_COBcc, irr baselevel 

**low parental education
*A1: 
svy: poisson everbingedrink_rBcc A1smscq#hied_COBcc, irr baselevel 
 
*A2: 
svy: poisson everbingedrink_rBcc A2smscq#hied_COBcc,irr baselevel 

*A3: 
svy: poisson everbingedrink_rBcc A3smscq#hied_COBcc, irr baselevel 

*A4: 
svy: poisson everbingedrink_rBcc A4smscq#hied_COBcc, irr baselevel 

/// EFFECT MODIFICATION
/*#Generate indicator variables where (produced above):
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
// Risk ratios (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use 
svy: poisson everbingedrink_rBcc hied_COBcc#A1smscq, irr baselevel 
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A1smscq, irr baselevel 
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A2smscq, irr baselevel 
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A3smscq, irr baselevel 
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A4smscq, irr baselevel 
 
/// EFFECT MODIFICATION AND INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of additive effect modification & interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson everbingedrink_rBcc A1ind01 A1ind10 A1ind11, irr baselevel
svy: poisson everbingedrink_rBcc A1ind01 A1ind10 A1ind11
estat vce
*RERI and 95% CI as per excel: 0.217 (0.701 to 6.600)
*SE = (u − l)/(2×1.96) = 1.5048469
di (6.600-(0.701))/(2*1.96)
*z score = Est/SE = .14420072
di 0.217/1.5048469
gen z1c_unadj =.14420072
*2 tailed p value= .8853419
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.162169
di 3.161026- 2.151316-1.792411 +1

*A2 
svy: poisson everbingedrink_rBcc A2ind01 A2ind10 A2ind11, irr
svy: poisson everbingedrink_rBcc A2ind01 A2ind10 A2ind11
estat vce
*RERI and 95% CI as per excel: -0.724 (-2.921 to 1.474)
*SE = (u − l)/(2×1.96) = 1.1211735
di (1.474-(-2.921))/(2*1.96)
*z score = Est/SE = -.64575197
di -0.724  /1.1211735
gen z2c_unadj= -.64575197
*2 tailed p value=  .51844 
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.123876
di   3.90475-2.1513 -3.47698 +1

*A3 
svy: poisson everbingedrink_rBcc A3ind01 A3ind10 A3ind11, irr
svy: poisson everbingedrink_rBcc A3ind01 A3ind10 A3ind11
estat vce
*RERI and 95% CI as per excel: 0.225 (-1.062-1.512)
*SE = (u − l)/(2×1.96) = .65663265
di (1.512-(-1.062))/(2*1.96)
*z score = Est/SE = .34265734
di 0.225 /.65663265
gen z3c_unadj=.34265734
*2 tailed p value= .7318563 
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj


*A4 
svy: poisson everbingedrink_rBcc A4ind01 A4ind10 A4ind11, irr
svy: poisson everbingedrink_rBcc A4ind01 A4ind10 A4ind11
estat vce
*RERI and 95% CI as per excel: -0.432 (-2.144-1.279)
*SE = (u − l)/(2×1.96) = .87321429
di (1.279-(-2.144))/(2*1.96)
*z score = Est/SE = -.49472392
di -0.432/.87321429
gen z4c_unadj=-.49472392
*2 tailed p value= .620795  
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj


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
svy: poisson everbingedrink_rBcc A1smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A2: 
svy: poisson everbingedrink_rBcc A2smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A3: 
svy: poisson everbingedrink_rBcc A3smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A4: 
svy: poisson everbingedrink_rBcc A4smscq#ib1.hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

**low parental education
*A1: 
svy: poisson everbingedrink_rBcc A1smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A2: 
svy: poisson everbingedrink_rBcc A2smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A3: 
svy: poisson everbingedrink_rBcc A3smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

*A4: 
svy: poisson everbingedrink_rBcc A4smscq#hied_COBcc i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel 

/// INTERACTION 
*#Risk ratios (95% CI; P-value) for parental education [high parental education vs low parental education (rc)], within strata of SM use 
svy: poisson everbingedrink_rBcc hied_COBcc#A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A1smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A2smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A3smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
svy: poisson everbingedrink_rBcc hied_COBcc#ib1.A4smscq i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel

/// EFFECT MODIFICATION AND INTERACTION 
// Risk ratios (95% CI; P-values) for SM use and parental education (rc: low parental education & no SM use)
// Measure of additive effect modification & interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson everbingedrink_rBcc A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr baselevel
svy: poisson everbingedrink_rBcc A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: -0.558(-2.312 to 1.196)
*SE = (u − l)/(2×1.96) = .89489796
di (1.196-(-2.312))/(2*1.96)
*z score = Est/SE = -.62353478
di-0.558/0.89489796
gen z1c_adj =-.62353478
*2 tailed p value= .5329331
gen p1c_adj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_adj

*A2 
svy: poisson everbingedrink_rBcc A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
svy: poisson everbingedrink_rBcc A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: -0.948 (-2.889 to 0.992)
*SE = (u − l)/(2×1.96) = .99005102
di (0.992-(-2.889 ))/(2*1.96)
*z score = Est/SE = -.95752641
di -0.948/.99005102
gen z2c_adj= -.95752641
*2 tailed p value= .51844 
gen p2c_adj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_adj


*A3 
svy: poisson everbingedrink_rBcc A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
svy: poisson everbingedrink_rBcc A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: -0.092 (-1.464 to 1.281)
*SE = (u − l)/(2×1.96) = .7002551
di (1.281-(-1.464))/(2*1.96)
*z score = Est/SE = -.13138069
di -0.092/.7002551
gen z3c_adj=-.13138069
*2 tailed p value= .7318563
gen p3c_adj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_adj

*A4 
svy: poisson everbingedrink_rBcc A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, irr
svy: poisson everbingedrink_rBcc A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc
estat vce
*RERI and 95% CI as per excel: -0.594 (-2.289 to 1.102)
*SE = (u − l)/(2×1.96) = .86505102
di (1.102-(-2.289))/(2*1.96)
*z score = Est/SE = -.6866647
di -0.594 /.86505102
gen z4c_adj=-.6866647
*2 tailed p value= .620795 
gen p4c_adj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_adj


/// CHECKS 
/*(RR11): EM exposed and SM exposed
(RR10): SM exposed and EM not exposed
(RR01): EM exposed and SM not exposed
(RR00): SM not exposed and EM not exposed 

FORMULA FOR RERI:
RERI= RR11-RR01 -RR10 +1 */
*******************************************************************************

