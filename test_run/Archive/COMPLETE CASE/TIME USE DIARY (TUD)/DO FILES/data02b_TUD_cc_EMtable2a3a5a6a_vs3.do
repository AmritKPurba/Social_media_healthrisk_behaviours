


********************************************************************************

*Do file: data02b_TUD_cc_EMtable2a3a5a6a_vs3 (using updated weight)
*Dataset used: data01_TUD_cc_vs3
*tryitout Purba 28.11.22

*Purpose: syntax for TUD complete case analysis: Effect modification- approach 2 - Additive measure of effect modification- Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)
*Table 2A: Approach 2- Modification of the effect of social media use on CM cigarette use, by parental education (n=2109) (SAP 4Ca)
*Notes: Measure of additive effect modification calculated for each SM pairwise comparison (binary variables created from ordinal exposure var): RERI = RR11-RR10-RR01+1. Where RR11= EM exposed & SM exposed (compared with EM not exposed & SM not exposed); RR10= EM not exposed & SM exposed; and RR01= EM exposed & SM not exposed. EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Methodology by Andersson et al: Andersson T, Alfredsson L, Källberg H, Zdravkovic S, Ahlbom A. Calculating measures of biological interaction. Eur J Epidemiol. 2005;20(7):575-9. doi: 10.1007/s10654-005-7835-x. PMID: 16119429. Anderson method used to obtain RERI, SI and AP and 95% CI. P values to be calculated by hand.

*Purpose: syntax for TUD complete case analysis: Effect modification- approach 1 & 2 - Multiplicative measures of effect modification - Poisson regression with robust standard errors (RR low PE/RR high PE)
*Table 3A: Approach 1 & 2 - Modification of the effect of social media use on CM cigarette use, by parental education (n=2109) (SAP 4Ca)
*Notes: Measure of multiplicative effect modification is the ratio of RRs in strata of our effect modifier- RR in low PE/RR in high PE (for each SM time category excl no sm use as this is the reference/baseline)

*Purpose: syntax for TUD complete case analysis: Interaction- approach 2 - Additive measures of interaction - Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)
*Table 5a: Approach 2 - Interaction between social media use and parental education on the risk of CM cigarette use  (n=2109) (SAP 4Da)
*Notes:Measure of additive interaction calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RERI = RR11 RR10-RR01+1. Where RR11= EM exposed & SM exposed (compared with EM not exposed & SM not exposed); RR10= EM not exposed & SM exposed; and RR01= EM exposed & SM not exposed. EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use.Methodology by Andersson et al: Andersson T, Alfredsson L, Källberg H, Zdravkovic S, Ahlbom A. Calculating measures of biological interaction. Eur J Epidemiol. 2005;20(7):575-9. doi: 10.1007/s10654-005-7835-x. PMID: 16119429. Anderson method used to obtain RERI, SI and AP and 95% CI. P values to be calculated by hand

*Purpose: syntax for TUD complete case analysis: Interaction- approach 1 & 2 - Multiplicative measures of interaction - Poission regression with robust standard errors (RR11/RR10*RR01)
*Table 6A: Approach 1 & 2- Interaction between social media use and parental education on the risk of CM cigarette use  (n=2109) (SAP 4Da)
*Notes:Measure of multiplicative interaction calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RR11: effect of exposure and EM together compared to reference category of both factors absent / RR01: effect of exposure alone and no EM (ref cat) /RR10: effect of EM alone and no exposure (ref cat): RR11/(RR10*RR01)


*Ethnicity 6 category variable used as no issues raised during analysis 

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\TIME USE DIARY (TUD)\DATASETS\data01_TUD_cc_vs3.dta", clear

set seed 539873962

*Should say   (data unchanged since 01dec2022 11:49)


datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

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
0  0_high parental ed
1  1_low parentel ed
*0_high parental ed (ref cat) & 1_low parentel ed 

//Outcome 
codebook smok_rBcc
0  0_never smoked/tried cigs once
1  1_current or former smoker
 */

*******************************************************************************

// Relevant weight

*TUD non-response weight for whole country analyses and sample design weights to be used for RO2 TUD complete case
*svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)


*******************************************************************************
* Identify reference category to be used in EM and interaction analysis [C] Considering both exposure and EM jointly identify the stratum with the lowest risk of cigarette/e-cigarette use which will become our reference category: low parental education and 1-<30 mins social media use (as per- Estimating measures of interaction on an additive scale for preventive exposures). HOWEVER decision made to use high parental education and no SM use so results consistent with SCQ analysis reference category.
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel
svy: logit ecig_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel

*******************************************************************************

*#Pairwise comparison A1-A4:  unadjusted 

*******************************************************************************

set showbaselevels on
codebook avgsm_tud_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

*#Unadjusted prevalences   
tab smok_rBcc avgsm_tud_r5Ccc if hied_COBcc==0 
tab smok_rBcc avgsm_tud_r5Ccc if hied_COBcc==1
svy, subpop (if hied_COBcc==0): tab smok_rBcc avgsm_tud_r5Ccc, col per
svy, subpop (if hied_COBcc==1): tab smok_rBcc avgsm_tud_r5Ccc, col per

*#TABLE 2A,3A,5A,6A: Generate individual binary variables for SM use from original ordinal exposure var 
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

*#TABLE 2A,3A,5A,6A:1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
**low parental education 
*A1: 
svy: poisson smok_rBcc A1smscq#ib1.hied_COBcc, irr baselevel 
*RR =   .1917521


*A2: 
svy: poisson smok_rBcc A2smscq#ib1.hied_COBcc, irr baselevel 
*RR = .7795726 


*A3: 
svy: poisson smok_rBcc A3smscq#ib1.hied_COBcc,irr baselevel 
*RR = 2.032483 


*A4: 
svy: poisson smok_rBcc A4smscq#ib1.hied_COBcc, irr baselevel 
*RR = 1.483489


**high parental education
*A1: 
svy: poisson smok_rBcc A1smscq#hied_COBcc, irr baselevel 
*RR =  .9512761


*A2: 
svy: poisson smok_rBcc A2smscq#hied_COBcc,irr baselevel 
*RR = .9806874 


*A3: 
svy: poisson smok_rBcc A3smscq#hied_COBcc, irr baselevel 
*RR =   1.298362


*A4: 
svy: poisson smok_rBcc A4smscq#hied_COBcc, irr baselevel 
*RR =  1.685588


*#TABLE 5A+ 6A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson smok_rBcc hied_COBcc#A1smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A1smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A2smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A3smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A4smscq, irr baselevel 

/*#TABLE 2A,3A,5A: Generate indicator variables where (produced above):
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
label variable A1ind11 "lowpared_1-<30min"
label variable A1ind10 "high pared & 1-<30min"
label variable A1ind01 "low pared & no SM use"
 
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
label variable A2ind11 "low pared & 30min-<1hr"
label variable A2ind10 "high pared & 30min-<1hr"
label variable A2ind01 "low pared & no SM use"

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
label variable A3ind11 "low pared & 1-<2hrs"
label variable A3ind10 "high pared & 1-<2hrs"
label variable A3ind01 "low pared & no SM use"

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
label variable A4ind11 "low pared & ≥2hrs"
label variable A4ind10 "high pared & ≥2hrs"
label variable A4ind01 "low pared & no SM use"

*#TABLE 2A & 5A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11, irr baselevel
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11
estat vce
*RERI and 95% CI as per excel: -1.073 (-1.950, -0.195)
*SE = (u − l)/(2×1.96) = .44770408
di (-0.195-(-1.950))/(2*1.96)
*z score = Est/SE = -2.3966724
di -1.073/.44770408
gen z1c_unadj =-2.3966724
*2 tailed p value=  .0165447
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj

*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11, irr
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11
estat vce
*RERI and 95% CI as per excel: -0.286 (-1.421, 0.848)
*SE = (u − l)/(2×1.96) = .57882653
di (0.848-(-1.421))/(2*1.96)
*z score = Est/SE = -.49410313
di  -0.286/.57882653
gen z2c_unadj= -.49410313
*2 tailed p value=  .6212333
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj

*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11, irr
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11
estat vce
*RERI and 95% CI as per excel: 1.151 (-0.315, 2.617)
*SE = (u − l)/(2×1.96) = .74795918
di (2.617-(-0.315))/(2*1.96)
*z score = Est/SE = 1.538854
di 1.151 /.74795918
gen z3c_unadj= 1.538854
*2 tailed p value= .1238399  
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj

*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11, irr
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11
estat vce
*RERI and 95% CI as per excel: -0.015(-1.579, 1.549)
*SE = (u − l)/(2×1.96) = .79795918
di (1.549-(-1.579))/(2*1.96)
*z score = Est/SE = -.01879795
di -0.015/.79795918
gen z4c_unadj=-.01879795
*2 tailed p value= .9850023 
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj


*#TABLE 3A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11, irr
*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11, irr
*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11, irr
*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11, irr

*#TABLE 3A: Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1 
svy: poisson smok_rBcc A1smscq##hied_COBcc, irr baselevel
*A2
svy: poisson smok_rBcc A2smscq##hied_COBcc, irr baselevel
*A3 
svy: poisson smok_rBcc A3smscq##hied_COBcc, irr baselevel
*A4
svy: poisson smok_rBcc A4smscq##hied_COBcc, irr baselevel

*#TABLE 3A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di  .1917521 /.9512761 
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di  .7795726/.9806874
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di 2.032483  /1.298362 
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed
di 1.483489 /1.685588



/*TABLE 6A: Generate combined vars where:
ind00=0: EM not exposed & SM not exposed (reference category)
ind10=1 (SM): EM not exposed & SM exposed
ind01=2 (PAR ED): EM exposed & SM not exposed 
ind11=3: EM exposed & SM exposed
For the above EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Thus we need 4 estimates for the assessment of additive interaction for each pairwise comparison (A1-A4) */

gen A1hied_reri=0 if hied_COBcc==0 & A1smscq==0 
replace A1hied_reri=1 if hied_COBcc==0 & A1smscq==1
replace A1hied_reri=2 if hied_COBcc==1 & A1smscq==0 
replace A1hied_reri=3 if hied_COBcc==1 & A1smscq==1
label define A1hied_reri 0 "high ed # no sm use" 1"high ed # 1-<30min" 2"low ed # no sm use" 3"low ed # 1-<30min"
label values A1hied_reri A1hied_reri
tab A1hied_reri A1smscq, mi
tab A1hied_reri hied_COBcc, mi

gen A2hied_reri=0 if hied_COBcc==0 & A2smscq==0 
replace A2hied_reri=1 if hied_COBcc==0 & A2smscq==1
replace A2hied_reri=2 if hied_COBcc==1 & A2smscq==0 
replace A2hied_reri=3 if hied_COBcc==1 & A2smscq==1
label define A2hied_reri 0 "high ed # no sm use" 1"high ed # 30min-<1hr" 2"low ed # no sm use" 3"low ed # 30min-<1hr"
label values A2hied_reri A2hied_reri
tab A2hied_reri A2smscq, mi
tab A2hied_reri hied_COBcc, mi

gen A3hied_reri=0 if hied_COBcc==0 & A3smscq==0 
replace A3hied_reri=1 if hied_COBcc==0 & A3smscq==1
replace A3hied_reri=2 if hied_COBcc==1 & A3smscq==0 
replace A3hied_reri=3 if hied_COBcc==1 & A3smscq==1
label define A3hied_reri 0 "high ed # no sm use" 1"high ed # 1-<2hrs" 2"low ed # no sm use" 3"low ed # 1-<2hrs"
label values A3hied_reri A3hied_reri
tab A3hied_reri A3smscq, mi
tab A3hied_reri hied_COBcc, mi

gen A4hied_reri=0 if hied_COBcc==0 & A4smscq==0 
replace A4hied_reri=1 if hied_COBcc==0 & A4smscq==1
replace A4hied_reri=2 if hied_COBcc==1 & A4smscq==0 
replace A4hied_reri=3 if hied_COBcc==1 & A4smscq==1
label define A4hied_reri 0 "high ed # no sm use" 1"high ed # ≥2hrs" 2"low ed # no sm use" 3"low ed # ≥2hrs"
label values A4hied_reri A4hied_reri
tab A4hied_reri A4smscq, mi
tab A4hied_reri hied_COBcc, mi

*#TABLE 6A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
svy: poisson smok_rBcc i.A1hied_reri , irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A1smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson smok_rBcc A1smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A1smscq##i.hied_COBcc, irr baselevel


*A2
svy: poisson smok_rBcc i.A2hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A2smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A2smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A2smscq##i.hied_COBcc, irr baselevel


*A3 
svy: poisson smok_rBcc i.A3hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A3smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A3smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A3smscq##i.hied_COBcc, irr baselevel


*A4
svy: poisson smok_rBcc i.A4hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A4smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A4smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A4smscq##i.hied_COBcc, irr baselevel


/*
*TABLE 6A: Checks  
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RR for low parental education and 1-<30mins SM use
*R10 (p10-p00): RR for high parental education and 1-<30mins SM use
*R01 (p01-p00): RR for low parental education and no SM use
*Calculation: R11/(R01*R10) */	


*******************************************************************************

*#Pairwise comparison A1-A4: adjusted 

*******************************************************************************

*#TABLE 2A,3A,5A,6A: 1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: poisson smok_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =    .2151319 

*A2: 
svy: poisson smok_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  .9132243


*A3: 
svy: poisson smok_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.510045 

*A4: 
svy: poisson smok_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =   1.49232


**high parental education 
*A1: 
svy: poisson smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  .9917442


*A2: 
svy: poisson smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =   1.047525


*A3: 
svy: poisson smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =   1.1014

*A4: 
svy: poisson smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.642085



*#TABLE 5A & 6A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson smok_rBcc hied_COBcc#A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A2smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A3smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A4smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel



*#TABLE 2A & 5A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value) 
*#As above

*A1 
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.940 (-1.680, -0.201)
*SE = (u − l)/(2×1.96) = .37729592
di (-0.201-(-1.680))/(2*1.96)
*z score = Est/SE = -2.4914131
di -0.940/.37729592
gen z1c_adj=-2.4914131
*2 tailed p value = .0127236 
gen p1c_adj=2*(1-normal(abs(z1c_adj))) 
tab p1c_adj

*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.146 (-1.125, 0.833)
*SE = (u − l)/(2×1.96) = .4994898
di (0.833-(-1.125))/(2*1.96)
*z score = Est/SE = -.29229826
di -0.146/.4994898
gen z2c_adj=-.29229826
*2 tailed p value =  .7700586 
gen p2c_adj=2*(1-normal(abs(z2c_adj))) 
tab p2c_adj

*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 0.512 (-0.537, 1.560)
*SE = (u − l)/(2×1.96) = .53494898
di (1.560-(-0.537))/(2*1.96)
*z score = Est/SE = .95710062
di  0.512 /.53494898
gen z3c_adj=.95710062
*2 tailed p value =   .3385165 
gen p3c_adj=2*(1-normal(abs(z3c_adj))) 
tab p3c_adj

*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.084(-1.171, 1.002)
*SE = (u − l)/(2×1.96) = .55433673
di (1.002-(-1.171))/(2*1.96)
*z score = Est/SE = -.15153244
di  -0.084/.55433673
gen z4c_adj=-.15153244
*2 tailed p value =  .8795557 
gen p4c_adj=2*(1-normal(abs(z4c_adj))) 
tab p4c_adj


*#TABLE 3A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use) 
*A1 
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 3A: Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1
svy: poisson smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A2 
svy: poisson smok_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A3
svy: poisson smok_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A4 
svy: poisson smok_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 3A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di   .2151319  /.9917442
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di  .9132243/1.047525
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di 1.510045/1.1014
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed 
di    1.49232/1.642085



*#TABLE 6A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)

*A1
svy: poisson smok_rBcc i.A1hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc i.A1smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel


*A2
svy: poisson smok_rBcc i.A2hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc i.A2smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel


*A3
svy: poisson smok_rBcc i.A3hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc i.A3smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*A4
svy: poisson smok_rBcc i.A4hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc i.A4smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 6A: Checks 
* Measure of multiplicative interaction calculated for each SM category: RR11: effect of exposure and EM together compared to reference category of both factors absent / RR10: effect of exposure alone and no EM (ref cat) /RR01: effect of EM alone and no exposure (ref cat)											
* Calculation = RR11/RR10*RR01 */


*******************************************************************************



*******************************************************************************
