

********************************************************************************

*Do file: data02b_TUD_cc_EMtable1a4a_vs3.do
*Dataset used: data01_TUD_cc_vs3 (using updated weight)
*Amrit Purba 24.1.23

*Purpose: syntax for TUD complete case analysis: Effect modification- approach 1 - Additive measures of effect modification - Linear regression with robust standard errors (RD low PE-high PE)
*Table 1A: Approach 1-  Modification of the effect of social media on CM cigarette use, by parental education (n=2109) (SAP 4Ca)
*Notes: measure of additive effect modification represents the size of the absolute difference between RDs for CM smoking by SM use, within low parental education group compared with high parental education group (baseline/ref cat) FORMULA: RD contrast- RD in low PE-RD in high PE (for each SM time category excl no sm use as this is the reference/baseline)

*Purpose: syntax for TUD complete case analysis: Interaction- approach 1 - Additive measures of interaction - Linear regression with robust standard errors (RD11-(RD10+RD01))
*Table 4A: Approach 1- Interaction between social media use and parental education on the risk of CM cigarette use  (n=2109) (SAP 4Da)
*Notes: Measure of additive interaction calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RD11= effect of exposure and EM together compared to reference category of both factors absent / RD10= effect of exposure alone and no EM (ref cat) /RD01= effect of EM alone and no exposure (ref cat). Measure= RD11-(RD10+RD01)


*Ethnicity 6 category variable used as no issues raised during analysis 

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "test_run/DATASETS\data01_TUD_cc_vs3.dta", clear

set seed 575363

*Should say (data unchanged since 18jan2023 14:42)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

/*Exposure 
codebookavgsm_tud_r5Ccc
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
1  1_current or former smoker */

*******************************************************************************

// Relevant weight

*TUD non-response weight for whole country analyses and sample design weights to be used for RO2 TUD complete case
*svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)


*******************************************************************************
* Identify reference category to be used in EM and interaction analysis [C] Considering both exposure and EM jointly identify the stratum with the lowest risk of cigarette/e-cigarette use which will become our reference category: low parental education and 1-<30 mins social media use (as per- Estimating measures of interaction on an additive scale for preventive exposures). HOWEVER decision made to use high parental education and no SM use so results consistent with SCQ analysis reference category.
svyset [pweight = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel
svy: logit ecig_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel

*******************************************************************************

*#Pairwise comparison A1-A4: unadjusted 

*******************************************************************************

set showbaselevels on
codebook avgsm_tud_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

*#Unadjusted prevalences   
tab smok_rBcc avgsm_tud_r5Ccc if hied_COBcc==0  //high
tab smok_rBcc avgsm_tud_r5Ccc if hied_COBcc==1 //low
svy, subpop (if hied_COBcc==0): tab smok_rBcc avgsm_tud_r5Ccc, col per //high
svy, subpop (if hied_COBcc==1): tab smok_rBcc avgsm_tud_r5Ccc, col per //low

*#TABLE 1A & 4A: Generate individual binary variables for SM use from original ordinal exposure var 
clonevar A1smscq =avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A1smscq 1=0 2=1 3 4 5 =.
label define A1smscq 0"0_no SM use" 1"1_1-<30min"
label variable A1smscq "1-<30min vs no SM use"
label values A1smscq A1smscq 
tab A1smscq avgsm_tud_r5Ccc,mi

clonevar A2smscq =avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A2smscq 1=0 3=1 2 4 5 =.
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq 
label variable A2smscq "30min-<1hr vs no SM use"
tab A2smscq avgsm_tud_r5Ccc,mi

clonevar A3smscq =avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A3smscq 1=0 4=1 2 3 5 =.
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
label variable A3smscq "1-<2hrs vs no SM use"
tab A3smscq avgsm_tud_r5Ccc,mi

clonevar A4smscq =avgsm_tud_r5Ccc
codebook avgsm_tud_r5Ccc
recode A4smscq 1=0 5=1 2 3 4 =.
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
label variable A4smscq "≥2hrs vs no SM use"
tab A4smscq avgsm_tud_r5Ccc,mi

*#TABLE 1A & 4A: 1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rBcc avgsm_tud_r5Ccc#ib1.hied_COBcc, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: regress smok_rBcc A1smscq#ib1.hied_COBcc, baselevel 

*A2:
svy: regress smok_rBcc A2smscq#ib1.hied_COBcc, baselevel 

*A3: 
svy: regress smok_rBcc A3smscq#ib1.hied_COBcc, baselevel

*A4: 
svy: regress smok_rBcc A4smscq#ib1.hied_COBcc, baselevel 


**high parental education
*A1:
svy: regress smok_rBcc A1smscq#hied_COBcc, baselevel 

*A2: 
svy: regress smok_rBcc A2smscq#hied_COBcc, baselevel 

*A3: 
svy: regress smok_rBcc A3smscq#hied_COBcc, baselevel  

*A4: 
svy: regress smok_rBcc A4smscq#hied_COBcc, baselevel 


*#TABLE 4A: Risk differences (95% CI; P-value)  for parental education [low parental education vs high parental education (rc)], within strata of SM use
svy: regress smok_rBcc hied_COBcc#A1smscq, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A1smscq, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A2smscq, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A3smscq, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A4smscq, baselevel

 
/*#TABLE 1A: Generate indicator variables where:
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
label variable A1ind11 "low pared & 1-<30min"
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

*#TABLE 1A:Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use) 
*A1:
svy: regress smok_rBcc A1ind01 A1ind10 A1ind11, baselevel
*A2:
svy: regress smok_rBcc A2ind01 A2ind10 A2ind11, baselevel
*A3: 
svy: regress smok_rBcc A3ind01 A3ind10 A3ind11, baselevel
*A4:
svy: regress smok_rBcc A4ind01 A4ind10 A4ind11, baselevel

*#TABLE 1A:Measure of additive effect modification (95% CI; P-value)
*A1: 
svy: regress smok_rBcc A1smscq##hied_COBcc , baselevel
*A2:
svy: regress smok_rBcc A2smscq##hied_COBcc , baselevel
*A3: 
svy: regress smok_rBcc A3smscq##hied_COBcc , baselevel
*A4: 
svy: regress smok_rBcc A4smscq##hied_COBcc , baselevel
*svy: regress smok_rBccavgsm_tud_r5Ccc##hied_COBcc , baselevel

*#TABLE 1A: Checks of measure of additive effect modification (RD in low PE- RD in high PE) 
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di -20.2 -5.2 
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di -9.9  - 3.7 
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di 8.4 -8.7 
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed
di  18.2  -13.0 

/*TABLE 4A: Generate combined vars where:
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

*#TABLE 4A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use) 
*#Measure of additive interaction (95% CI; P-value)
*A1
svy: regress smok_rBcc i.A1hied_reri
*double check same as interaction
svy: regress smok_rBcc A1smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A1smscq##hied_COBcc
svy: regress smok_rBcc i.A1smscq##i.hied_COBcc

*A2
svy: regress smok_rBcc i.A2hied_reri
*double check same as interaction
svy: regress smok_rBcc A2smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A2smscq##hied_COBcc
svy: regress smok_rBcc i.A2smscq##i.hied_COBcc

*A3
svy: regress smok_rBcc i.A3hied_reri
*double check same as interaction
svy: regress smok_rBcc A3smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A3smscq##hied_COBcc
svy: regress smok_rBcc i.A3smscq##i.hied_COBcc

*A4
svy: regress smok_rBcc i.A4hied_reri
*double check same as interaction
svy: regress smok_rBcc A4smscq#hied_COBcc
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A4smscq##hied_COBcc
svy: regress smok_rBcc i.A4smscq##i.hied_COBcc

/*
*#TABLE 4A: Checks 
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for low parental education and 1-<30mins SM use
*R10 (p10-p00): RD for high parental education and 1-<30mins SM use
*R01 (p01-p00): RD for low parental education and no SM use
*Calculation: R11-(R01+R10) */

*******************************************************************************

*#Pairwise comparison A1-A4:  adjusted 

*******************************************************************************

*#TABLE 1A & 4A: 1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rBccavgsm_tud_r5Ccc#ib1.hied_COBcc, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education
*A1: 
svy: regress smok_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel

*A2: 
svy: regress smok_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel

*A3: 
svy: regress smok_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel

*A4: 
svy: regress smok_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel

**high parental education
*A1: 
svy: regress smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*A2:
svy: regress smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel  

*A3: 
svy: regress smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*A4: 
svy: regress smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 


*#TABLE 4A: Risk differences (95% CI; P-value)  for parental education [low parental education vs high parental education (rc)], within strata of SM use
svy: regress smok_rBcc hied_COBcc#A1smscq  i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A1smscq  i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A2smscq  i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A3smscq  i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc hied_COBcc#ib1.A4smscq  i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel



*#TABLE 1A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: regress smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2 
svy: regress smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#TABLE 1A:Measure of additive effect modification (95% CI; P-value)
*A1 
svy: regress smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2 
svy: regress smok_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress smok_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress smok_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#TABLE 1A:Checks of measure of additive effect modification (RD in low PE- RD in high PE)
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di -16.6   -4.8 
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di -5.8  -3.6 
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di  3.1  -4.3 
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed 
di 18.0 -11.6 


*#TABLE 4A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive interaction (95% CI; P-value)
*A1
svy: regress smok_rBcc i.A1hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
svy: regress smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc i.A1smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A2
svy: regress smok_rBcc i.A2hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
svy: regress smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc i.A2smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A3
svy: regress smok_rBcc i.A3hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
svy: regress smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc i.A3smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A4
svy: regress smok_rBcc i.A4hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
svy: regress smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: regress smok_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
svy: regress smok_rBcc i.A4smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*#TABLE 4A:Checks 
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for low parental education and 1-<30mins SM use
*R10 (p10-p00): RD for high parental education and 1-<30mins SM use
*R01 (p01-p00): RD for low parental education and no SM use
*Calculation: R1-(R2+R3) */



*******************************************************************************


*******************************************************************************