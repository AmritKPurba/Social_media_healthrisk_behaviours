
*# Self-report imputed additive effect modification & interaction analysis: social media > cigarette use
********************************************************************************

/*
AK Purba [last updated 21.02.2023]
Do file: data02a_SCQ_imp_EMtable1a4a_vs1.do
Dataset: data01_master_vs3_SCQ_imp_4_2.dta


Syntax: 
Additive measures of effect modification (cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)
Additive measures of interaction (cigarette use)- Linear regression with robust standard errors (RD11-(RD10+RD01))
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

// PREVALENCES TABLE 1A & TABLE 4A

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
 
*****************************************************************************************

*#Pairwise comparison A1-A4: unadjusted 

*******************************************************************************
mi svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2)


*#TABLE 1A & 4A: Generate individual binary variables for SM use from original ordinal exposure var 
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

*# TABLE 1A & 4A:
*#1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rB_imp smscq_r5C_imp#ib1.hied_COB_imp, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
*NOTE:error arises as we used if condition based on imputed/passive vars when creating A1smscq etc. mi estimate considers this a mistake but, if this is out intent we should specify the mi estimate command and include the esampvaryok option.

**low parental education 
*A1: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq#ib1.hied_COB_imp, baselevel 

*A2:
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq#ib1.hied_COB_imp, baselevel 

*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#ib1.hied_COB_imp, baselevel

*A4: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq#ib1.hied_COB_imp, baselevel 



**high parental education
*A1:
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq#hied_COB_imp, baselevel 

*A2: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq#hied_COB_imp, baselevel 

*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#hied_COB_imp, baselevel  

*A4: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq#hied_COB_imp, baselevel 



*#TABLE 4A: Risk differences (95% CI; P-value)  for parental education [low parental education vs high parental education (rc)], within strata of SM use
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#A1smscq, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A1smscq, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A2smscq, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A3smscq, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A4smscq, baselevel

 
/*#TABLE 1A: Generate indicator variables where:
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


*#TABLE 1A:Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use) 
*A1:
mi estimate, esampvaryok: svy: regress smok_rB_imp A1ind01 A1ind10 A1ind11, baselevel
*A2:
mi estimate, esampvaryok: svy: regress smok_rB_imp A2ind01 A2ind10 A2ind11, baselevel
*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3ind01 A3ind10 A3ind11, baselevel
*A4:
mi estimate, esampvaryok: svy: regress smok_rB_imp A4ind01 A4ind10 A4ind11, baselevel


*#TABLE 1A:Measure of additive effect modification (95% CI; P-value)
*A1: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq##hied_COB_imp , baselevel
*A2:
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq##hied_COB_imp , baselevel
*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq##hied_COB_imp , baselevel
*A4: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq##hied_COB_imp , baselevel


*#TABLE 1A: Checks of measure of additive effect modification (RD in low PE- RD in high PE) 
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di 1.3 - 2.9 
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di 0.6  -13.6 
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di 4.9  -16.7
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed
di 16.4 -26.7 



/*TABLE 4A: Generate combined vars where:
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

mi passive: gen A2hied_reri=0 if hied_COB_imp==0 & A2smscq==0 
mi passive: replace A2hied_reri=1 if hied_COB_imp==0 & A2smscq==1
mi passive: replace A2hied_reri=2 if hied_COB_imp==1 & A2smscq==0 
mi passive: replace A2hied_reri=3 if hied_COB_imp==1 & A2smscq==1
label define A2hied_reri 0 "high ed # no sm use" 1"high ed # 30min-<1hr" 2"low ed # no sm use" 3"low ed # 30min-<1hr"
label values A2hied_reri A2hied_reri
mi xeq: tab  A2hied_reri A2smscq, mi
mi xeq: tab  A2hied_reri hied_COB_imp, mi

mi passive: gen A3hied_reri=0 if hied_COB_imp==0 & A3smscq==0 
mi passive: replace A3hied_reri=1 if hied_COB_imp==0 & A3smscq==1
mi passive: replace A3hied_reri=2 if hied_COB_imp==1 & A3smscq==0 
mi passive: replace A3hied_reri=3 if hied_COB_imp==1 & A3smscq==1
label define A3hied_reri 0 "high ed # no sm use" 1"high ed # 1-<2hrs" 2"low ed # no sm use" 3"low ed # 1-<2hrs"
label values A3hied_reri A3hied_reri
mi xeq: tab  A3hied_reri A3smscq, mi
mi xeq: tab  A3hied_reri hied_COB_imp, mi

mi passive: gen A4hied_reri=0 if hied_COB_imp==0 & A4smscq==0 
mi passive: replace A4hied_reri=1 if hied_COB_imp==0 & A4smscq==1
mi passive: replace A4hied_reri=2 if hied_COB_imp==1 & A4smscq==0 
mi passive: replace A4hied_reri=3 if hied_COB_imp==1 & A4smscq==1
label define A4hied_reri 0 "high ed # no sm use" 1"high ed # ≥2hrs" 2"low ed # no sm use" 3"low ed # ≥2hrs"
label values A4hied_reri A4hied_reri
mi xeq: tab  A4hied_reri A4smscq, mi
mi xeq: tab  A4hied_reri hied_COB_imp, mi


mi update

*#TABLE 4A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use) 
*#Measure of additive interaction (95% CI; P-value)
*A1
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A1hied_reri
*double check same as interaction
mi estimate, esampvaryok: svy: regress  smok_rB_imp A1smscq#hied_COB_imp
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq##hied_COB_imp
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A1smscq##i.hied_COB_imp

*A2
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A2hied_reri
*double check same as interaction
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq#hied_COB_imp
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq##hied_COB_imp
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A2smscq##i.hied_COB_imp

*A3
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A3hied_reri
*double check same as interaction
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#hied_COB_imp
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq##hied_COB_imp
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A3smscq##i.hied_COB_imp

*A4
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A4hied_reri
*double check same as interaction
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq#hied_COB_imp
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq##hied_COB_imp
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A4smscq##i.hied_COB_imp
/*
*#Checks 
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for low parental education and 1-<30mins SM use
*R10 (p10-p00): RD for high parental education and 1-<30mins SM use
*R01 (p01-p00): RD for low parental education and no SM use
*Calculation: R11-(R01+R10) */

*******************************************************************************

*#Pairwise comparison A1-A4: adjusted 

*******************************************************************************

*# TABLE 1A & 4A: 
*1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rB_imp smscq_r5C_imp#ib1.hied_COB_imp, baselevel
*2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)

**low parental education
*A1: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A2: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A4: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq#ib1.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel


**high parental education
*A1: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A2:
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A3: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A4: 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel


*# TABLE 4A: Risk differences (95% CI; P-value)  for parental education [low parental education vs high parental education (rc)], within strata of SM use
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#A1smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A1smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A2smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A3smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp hied_COB_imp#ib1.A4smscq  i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel


*# TABLE 1A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use)

*A1 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1ind01 A1ind10 A1ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A2 
mi estimate, esampvaryok: svy: regress smok_rB_imp A2ind01 A2ind10 A2ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3ind01 A3ind10 A3ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A4 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4ind01 A4ind10 A4ind11 i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*# TABLE 1A: Measure of additive effect modification (95% CI; P-value)

*A1 
mi estimate, esampvaryok: svy: regress smok_rB_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A2 
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A3 
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*A4 
mi estimate, esampvaryok: svy: regress smok_rB_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*# TABLE 1A: Checks of measure of additive effect modification (RD in low PE- RD in high PE)

*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di 2.6 -2.0 
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di 1.4 -12.4 
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di  3.4 -14.9 
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed 
di 14.2 -24.6 


*# TABLE 4A: Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive interaction (95% CI; P-value)
*A1
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A1hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
mi estimate, esampvaryok: svy: regress  smok_rB_imp A1smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress  smok_rB_imp A1smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A1smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A2
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A2hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
mi estimate, esampvaryok: svy: regress  smok_rB_imp A2smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress smok_rB_imp A2smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress smok_rB_imp i.A2smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A3
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A3hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
mi estimate, esampvaryok: svy: regress smok_rB_imp A3smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress  smok_rB_imp A3smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A3smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

*A4
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A4hied_reri i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*double check same as interaction
mi estimate, esampvaryok: svy: regress  smok_rB_imp A4smscq#hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
mi estimate, esampvaryok: svy: regress  smok_rB_imp A4smscq##hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel
mi estimate, esampvaryok: svy: regress  smok_rB_imp i.A4smscq##i.hied_COB_imp i.eth_rBcc  i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel

**# TABLE 4A: Checks 
*DONE
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RD for low parental education and 1-<30mins SM use
*R10 (p10-p00): RD for high parental education and 1-<30mins SM use
*R01 (p01-p00): RD for low parental education and no SM use
*Calculation: R1-(R2+R3) */



*******************************************************************************


*******************************************************************************