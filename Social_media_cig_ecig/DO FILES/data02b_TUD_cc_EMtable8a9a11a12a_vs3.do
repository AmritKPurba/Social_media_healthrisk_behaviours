********************************************************************************
//Time use diary complete case additive & multiplicative effect modification & interaction analysis: social media > e-cigarette use
********************************************************************************

/*
AK Purba [last updated 21.02.2023]
Do file: data02b_TUD_cc_EMtable8a9a11a12a_vs3.do
Dataset: data01_TUD_cc_vs3.dta


Syntax:
Additive measure of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)
Multiplicative measures of effect modification (e-cigarette use)- Poisson regression with robust standard errors (RR low PE/RR high PE)
Additive measures of interaction (e-cigarette use)- Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)
Multiplicative measures of interaction (e-cigarette use)- Poisson regression with robust standard errors (RR11/RR10*RR01)

*/

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "Social_media_cig_ecig\DATASETS\data01_TUD_cc_vs3.dta", clear
set seed 539873962

*Should say (data unchanged since 18jan2023 14:42)
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
codebook ecig_rBcc
0  0_never used ecig/tried once
1  1_current or former ecig user
 */

*******************************************************************************

// Relevant weight

*TUD non-response weight for whole country analyses and sample design weights to be used for RO2 TUD complete case
*svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)


*******************************************************************************
* Identify reference category to be used in EM and interaction analysis [C] Considering both exposure and EM jointly identify the stratum with the lowest risk of e-cigarette/e-e-cigarette use which will become our reference category: low parental education and 1-<30 mins social media use (as per- Estimating measures of interaction on an additive scale for preventive exposures). HOWEVER decision made to use high parental education and no SM use so results consistent with SCQ analysis reference category.
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit ecig_rBcc ib2.avgsm_tud_r5Ccc#i.hied_COBcc, or baselevel
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
tab ecig_rBcc avgsm_tud_r5Ccc if hied_COBcc==0 
tab ecig_rBcc avgsm_tud_r5Ccc if hied_COBcc==1
svy, subpop (if hied_COBcc==0): tab ecig_rBcc avgsm_tud_r5Ccc, col per
svy, subpop (if hied_COBcc==1): tab ecig_rBcc avgsm_tud_r5Ccc, col per

*#TABLE 8A,9A,11A,12A : Generate individual binary variables for SM use from original ordinal exposure var 
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

*#TABLE 8A,9A,11A,12A:1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
**low parental education 
*A1: 
svy: poisson ecig_rBcc A1smscq#ib1.hied_COBcc, irr baselevel 

*A2: 
svy: poisson ecig_rBcc A2smscq#ib1.hied_COBcc, irr baselevel 

*A3: 
svy: poisson ecig_rBcc A3smscq#ib1.hied_COBcc,irr baselevel 

*A4: 
svy: poisson ecig_rBcc A4smscq#ib1.hied_COBcc, irr baselevel 


**high parental education
*A1: 
svy: poisson ecig_rBcc A1smscq#hied_COBcc, irr baselevel 
 
*A2: 
svy: poisson ecig_rBcc A2smscq#hied_COBcc,irr baselevel 

*A3: 
svy: poisson ecig_rBcc A3smscq#hied_COBcc, irr baselevel 

*A4: 
svy: poisson ecig_rBcc A4smscq#hied_COBcc, irr baselevel 

*#TABLE 11A+ 12A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson ecig_rBcc hied_COBcc#A1smscq, irr baselevel 
svy: poisson ecig_rBcc hied_COBcc#ib1.A1smscq, irr baselevel 
svy: poisson ecig_rBcc hied_COBcc#ib1.A2smscq, irr baselevel 
svy: poisson ecig_rBcc hied_COBcc#ib1.A3smscq, irr baselevel 
svy: poisson ecig_rBcc hied_COBcc#ib1.A4smscq, irr baselevel 

/*#TABLE 8A,9A,11A: Generate indicator variables where (produced above):
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

*#TABLE 8A & 11A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11, irr baselevel
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11
estat vce
*RERI and 95% CI as per excel: -1.380 (-2.452, -0.308)
*SE = (u − l)/(2×1.96) = .54693878
di (-0.308-(-2.452))/(2*1.96)
*z score = Est/SE = -2.5231343
di -1.380/.54693878
gen z1c_unadj =-2.5231343
*2 tailed p value=  .0116314 
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -1.3797479
di  .4107385- 1.804811 - .9856754  +1

*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11, irr
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11
estat vce
*RERI and 95% CI as per excel: -0.733 (-2.012, 0.546)
*SE = (u − l)/(2×1.96) = .65255102
di (0.546-(-2.012))/(2*1.96)
*z score = Est/SE = -1.1232838
di  -0.733/.65255102
gen z2c_unadj=-1.1232838
*2 tailed p value=  .261317 
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj

*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11, irr
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11
estat vce
*RERI and 95% CI as per excel: 1.355(-0.533, 3.243)
*SE = (u − l)/(2×1.96) = .96326531
di (3.243-(-0.533))/(2*1.96)
*z score = Est/SE = 1.4066737
di 1.355/.96326531
gen z3c_unadj= 1.4066737
*2 tailed p value= .1595242
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj

*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11, irr
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11
estat vce
*RERI and 95% CI as per excel: -0.245(-2.434, 1.945)
*SE = (u − l)/(2×1.96) = 1.1170918
di (1.945-(-2.434))/(2*1.96)
*z score = Est/SE = -.21931949
di -0.245/1.1170918
gen z4c_unadj=-.21931949
*2 tailed p value= .8264012 
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj


*#TABLE 9A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11, irr
*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11, irr
*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11, irr
*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11, irr

*#TABLE 9A: Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1 
svy: poisson ecig_rBcc A1smscq##hied_COBcc, irr baselevel
*A2
svy: poisson ecig_rBcc A2smscq##hied_COBcc, irr baselevel
*A3 
svy: poisson ecig_rBcc A3smscq##hied_COBcc, irr baselevel
*A4
svy: poisson ecig_rBcc A4smscq##hied_COBcc, irr baselevel

*#TABLE 9A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di  .2275798 /.9856754 
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di  .6311447/1.067359 
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di   1.711602  /.929251  
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed
di 1.042852/1.322165



/*TABLE 12A: Generate combined vars where:
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

*#TABLE 12A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
svy: poisson ecig_rBcc i.A1hied_reri , irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A1smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson ecig_rBcc A1smscq##hied_COBcc, irr baselevel
svy: poisson ecig_rBcc i.A1smscq##i.hied_COBcc, irr baselevel


*A2
svy: poisson ecig_rBcc i.A2hied_reri, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A2smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A2smscq##hied_COBcc, irr baselevel
svy: poisson ecig_rBcc i.A2smscq##i.hied_COBcc, irr baselevel


*A3 
svy: poisson ecig_rBcc i.A3hied_reri, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A3smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A3smscq##hied_COBcc, irr baselevel
svy: poisson ecig_rBcc i.A3smscq##i.hied_COBcc, irr baselevel


*A4
svy: poisson ecig_rBcc i.A4hied_reri, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A4smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A4smscq##hied_COBcc, irr baselevel
svy: poisson ecig_rBcc i.A4smscq##i.hied_COBcc, irr baselevel


/*
*TABLE 12A: Checks  
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RR for low parental education and 1-<30mins SM use
*R10 (p10-p00): RR for high parental education and 1-<30mins SM use
*R01 (p01-p00): RR for low parental education and no SM use
*Calculation: R11/(R01*R10) */	


*******************************************************************************
*#Pairwise comparison A1-A4: adjusted 
*******************************************************************************

*#TABLE 8A,9A,11A,12A: 1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: poisson ecig_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A2: 
svy: poisson ecig_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A3: 
svy: poisson ecig_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A4: 
svy: poisson ecig_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 


**high parental education 
*A1: 
svy: poisson ecig_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A2: 
svy: poisson ecig_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A3: 
svy: poisson ecig_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*A4: 
svy: poisson ecig_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 

*#TABLE 11A & 12A: Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson ecig_rBcc hied_COBcc#A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc hied_COBcc#ib1.A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc hied_COBcc#ib1.A2smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc hied_COBcc#ib1.A3smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc hied_COBcc#ib1.A4smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel


*#TABLE 8A & 11A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value) 
*#As above

*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -1.206 (-2.108, -0.304)
*SE = (u − l)/(2×1.96) = .46020408
di (-0.304-(-2.108))/(2*1.96)
*z score = Est/SE = -2.6205765
di -1.206 /.46020408
gen z1c_adj=-2.6205765
*2 tailed p value =  .0087781
gen p1c_adj=2*(1-normal(abs(z1c_adj))) 
tab p1c_adj

*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce 
*RERI and 95% CI as per excel: -0.597 (-1.696, 0.501)
*SE = (u − l)/(2×1.96) = .56045918
di (0.501-(-1.696))/(2*1.96)
*z score = Est/SE = -1.065198
di -0.597/.56045918
gen z2c_adj=-1.065198
*2 tailed p value = .2867864
gen p2c_adj=2*(1-normal(abs(z2c_adj))) 
tab p2c_adj

*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 1.019 (-0.389, 2.428)
*SE = (u − l)/(2×1.96) = .71862245
di (2.428-(-0.389))/(2*1.96)
*z score = Est/SE = 1.4179908
di  1.019/.71862245
gen z3c_adj=1.4179908
*2 tailed p value = .1561935 
gen p3c_adj=2*(1-normal(abs(z3c_adj))) 
tab p3c_adj

*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.078(-1.451, 1.294)
*SE = (u − l)/(2×1.96) = .7002551
di (1.294-(-1.451))/(2*1.96)
*z score = Est/SE = -.11138798
di -0.078/.7002551
gen z4c_adj=-.11138798
*2 tailed p value = .9113087
gen p4c_adj=2*(1-normal(abs(z4c_adj))) 
tab p4c_adj


*#TABLE 9A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use) 
*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 9A: Measure of multiplicative effect modification (Ratio of RRs; 95% CI; P-values)
*A1
svy: poisson ecig_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A2 
svy: poisson ecig_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A3
svy: poisson ecig_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*A4 
svy: poisson ecig_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 9A: Checks of measure of multiplicative effect modification (low par ed/high par ed)
*A1: 1_1-<30min#1_low parentel ed/1_1-<30min#0_high parental ed
di   .2558255 /1.000528
*A2: 1_30min-<1hr#1_low parentel ed/1_30min-<1hr#0_high parental ed 
di   .7368746/1.204531
*A3:  1_1-<2hrs#1_low parentel ed/1_1-<2hrs#0_high parental ed 
di 1.589031/.838773
*A4:  1_≥2hrs#1_low parentel ed/1_≥2hrs#0_high parental ed 
di   1.112005/1.231304



*#TABLE 12A: Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)

*A1
svy: poisson ecig_rBcc i.A1hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson ecig_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc i.A1smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel


*A2
svy: poisson ecig_rBcc i.A2hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc i.A2smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel


*A3
svy: poisson ecig_rBcc i.A3hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc i.A3smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*A4
svy: poisson ecig_rBcc i.A4hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson ecig_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson ecig_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson ecig_rBcc i.A4smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#TABLE 12A: Checks 
* Measure of multiplicative interaction calculated for each SM category: RR11: effect of exposure and EM together compared to reference category of both factors absent / RR10: effect of exposure alone and no EM (ref cat) /RR01: effect of EM alone and no exposure (ref cat)											
* Calculation = RR11/RR10*RR01 */


*******************************************************************************


*******************************************************************************
