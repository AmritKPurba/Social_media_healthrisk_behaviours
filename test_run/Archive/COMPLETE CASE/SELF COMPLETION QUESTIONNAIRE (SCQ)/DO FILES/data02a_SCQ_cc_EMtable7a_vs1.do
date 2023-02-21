


********************************************************************************

*Do file: data02a_SCQ_cc_EMtable7a_vs1
*Dataset used: data01_SCQ_cc_vs1
*Amrit Purba 10.05.2022

*Purpose: syntax for SCQ complete case analysis: Effect modification- approach 1 - Additive measures of effect modification - Linear regression with robust standard errors (RD low PE-high PE)
*Table 7a: Approach 1 - Modification of the effect of social media use on CM e-cigarette use, by parental education (n=6234) (SAP 3Cb)
*Notes: Measure of additive effect modification calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RD in low PE-RD in high PE 

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\SELF COMPLETION QUESTIONNAIRE (SCQ)\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 5753997

*should say (data unchanged since 09may2022 11:14, except 2 variables have been added)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

//Exposure 
codebook smscq_r5Ccc
*1  1_no SM use
*2  2_1-<30min
*3  3_30min-<1hr
*4  4_1-<2hrs
*5  5_≥2hrs
*A1: 1_no SM use (ref cat) & 2_1-<30min
*A2: 1_no SM use (ref cat) & 3_30min-<1hr
*A3: 1_no SM use (ref cat) & 4_1-<2hrs
*A4: 1_no SM use (ref cat) & 5_≥2hrs

//EM 
codebook hied_COBcc
*0  0_high parental ed
*1  1_low parentel ed
*0_high parental ed (ref cat) & 1_low parentel ed 

//Outcome 
codebook ecig_rBcc
*0  0_never used ecig/tried once
*1  1_current or former ecig user

*******************************************************************************

*#Pairwise comparison A1-A4: additive measure of effect modification - unadjusted 

*******************************************************************************

set showbaselevels on
codebook smscq_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 

*#Unadjusted prevalences   
svy, subpop (if hied_COBcc==1): tab ecig_rBcc smscq_r5Ccc, col obs
svy, subpop (if hied_COBcc==0): tab ecig_rBcc smscq_r5Ccc, col obs
svy, subpop (if hied_COBcc==1): tab ecig_rBcc smscq_r5Ccc, col per
svy, subpop (if hied_COBcc==0): tab ecig_rBcc smscq_r5Ccc, col per
svy, subpop (if hied_COBcc==1):proportion ecig_rBcc, over (smscq_r5Ccc) 
svy, subpop (if hied_COBcc==0):proportion ecig_rBcc, over (smscq_r5Ccc) 

*#Generate individual binary variables for SM use from original ordinal exposure var 
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

*#1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rBcc smscq_r5Ccc#ib1.hied_COBcc, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: regress ecig_rBcc A1smscq#ib1.hied_COBcc, baselevel 
*RD = 0.1836503 
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.3018999
*Pr = no sm use low par ed = 0.1182497
di 0.3018999-0.1182497
*RD = 0.1836503 

*A2:
svy: regress ecig_rBcc A2smscq#ib1.hied_COBcc, baselevel 
*RD = 0.1845351 
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.3027848
*Pr = no sm use low par ed = 0.1182497
di 0.3027848-0.1182497
*RD = 0.1845351 

*A3: 
svy: regress ecig_rBcc A3smscq#ib1.hied_COBcc, baselevel
*RD = 0.099405 
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.2176547
*Pr = no sm use low par ed = 0.1182497 
di 0.2176547-0.1182497 
*RD = 0.099405 

*A4: 
svy: regress ecig_rBcc A4smscq#ib1.hied_COBcc, baselevel 
*RD = 0.1957838 
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.3140334
*Pr = no sm use low par ed = 0.1182497
di 0.3140334-0.1182497
*RD = 0.1957838 

**high parental education
*A1:
svy: regress ecig_rBcc A1smscq#hied_COBcc, baselevel 
*RD = 0.0026473 
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins high par ed = 0.106099
*Pr = no sm use high par ed = 0.1034517
di 0.106099-0.1034517
*RD = 0.0026473

*A2: 
svy: regress ecig_rBcc A2smscq#hied_COBcc, baselevel 
*RD = 0.1006323
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2040841
*Pr = no sm use high par ed = 0.1034517
di 0.2040841-0.1034517
*RD = 0.1006324

*A3: 
svy: regress ecig_rBcc A3smscq#hied_COBcc, baselevel  
*RD = 0.089326
margins A3##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.1927777
*Pr = no sm use high par ed = 0.1034517
di 0.1927777-0.1034517
*RD = 0.089326

*A4: 
svy: regress ecig_rBcc A4smscq#hied_COBcc, baselevel 
*RD = 0.1735757
margins A4##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.2770275 
*Pr = no sm use high par ed = 0.1034517
di 0.2770275-0.1034517
*RD = 0.1735758

/*#Generate indicator variables where:
 ind11=1: EM exposed & SM exposed
 ind10 (SM) =1: EM not exposed & SM exposed
 ind01 (PAR ED) =1: EM exposed & SM not exposed 
 ind00=1: EM not exposed & SM not exposed (reference category)
 Syntax as per Andersson et al
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

*#Risk differences (95% CI; P-value)  for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: regress ecig_rBcc A1ind01 A1ind10 A1ind11, baselevel
*A2 
svy: regress ecig_rBcc A2ind01 A2ind10 A2ind11, baselevel
*A3 
svy: regress ecig_rBcc A3ind01 A3ind10 A3ind11, baselevel
*A4 
svy: regress ecig_rBcc A4ind01 A4ind10 A4ind11, baselevel

*#Measure of additive effect modification (95% CI; P-value)
*A1 
svy: regress ecig_rBcc A1smscq##hied_COBcc , baselevel
*A2 
svy: regress ecig_rBcc A2smscq##hied_COBcc , baselevel
*A3 
svy: regress ecig_rBcc A3smscq##hied_COBcc , baselevel
*A4 
svy: regress ecig_rBcc A4smscq##hied_COBcc , baselevel
*svy: regress ecig_rBcc smscq_r5Ccc##hied_COBcc , baselevel

*#Checks of measure of additive effect modification (RD in low PE- RD in high PE)
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di  0.1836503-0.0026473  
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di  .1845351-.1006323  
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di  .099405-.089326
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed
di  .1957838-.1735757 

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: regress ecig_rBcc smscq_r5Ccc##hied_COBcc , baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: regress ecig_rBcc c.smscq_r5Ccc##hied_COBcc , baselevel
* coeff = .0470972 , as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 0.0470972. Thus a one step increase in SM category has a linear relationship with increased ecig use, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: regress ecig_rBcc smscq_r5Ccc##hied_COBcc , baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of ecig use in high par ed group increases as time spent on SM increases
*1_low parentel ed = 0.0391 - significant linear relationship - risk of e-cig use in low par ed group increases as time spent on SM increases


*******************************************************************************

*#Pairwise comparison A1-A4: additive measure of effect modification - adjusted 

*******************************************************************************

*#1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rBcc smscq_r5Ccc#ib1.hied_COBcc, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education
*A1: 
svy: regress ecig_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.1717922  
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.2762421
*Pr = no sm use low par ed = 0.1044499
di 0.2762421-0.1044499
*RD = 0.1717922 

*A2: 
svy: regress ecig_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.1939281
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.2700741
*Pr = no sm use low par ed = 0.076146
di 0.2700741-0.076146
*RD = 0.1939281

*A3: 
svy: regress ecig_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.0930633
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.19233
*Pr = no sm use low par ed = 0.0992667
di 0.19233-0.0992667
*RD = 0.0930633

*A4: 
svy: regress ecig_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.2164625
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.2995627
*Pr = no sm use low par ed = 0.08310034 
di 0.2995627-0.08310034 
*RD = 0.21646236 

**high parental education
*A1: 
svy: regress ecig_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.0029657 
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<30min high par ed = 0.1085232
*Pr = no sm use high par ed = 0.1055575
di 0.1085232-0.1055575
*RD = 0.0029657 

*A2:
svy: regress ecig_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.110815 
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2115845
*Pr = no sm use high par ed = 0.1007695
di  0.2115845-0.1007695
*RD = 0.110815

*A3: 
svy: regress ecig_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.1036056
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.199409
*Pr = no sm use high par ed = 0.0958034
di 0.199409-0.0958034
*RD = 0.1036056

*A4: 
svy: regress ecig_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.2053088
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.2842537
*Pr = no sm use high par ed = 0.0789448
di  0.2842537-0.0789448
*RD = 0.2053089

*#Risk differences (95% CI; P-value)  for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: regress ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2 
svy: regress ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#Measure of additive effect modification (95% CI; P-value)
*A1 
svy: regress ecig_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2
svy: regress ecig_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress ecig_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress ecig_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#Checks of measure of additive effect modification (RD in low PE- RD in high PE)
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di 0.1717922-0.0029657
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di   0.1939281-0.110815
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di  0.0930633-0.1036056
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed 
di  0.2164625-0.2053088

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: regress ecig_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: regress ecig_rBcc c.smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
* coeff = 0.0531689, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 0.0532261. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: regress ecig_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of e-cigarette use in high par ed group increases as time spent on SM increases
*1_low parentel ed = 0.0177 - significant linear relationship - risk of e-cigarette use in low par ed group increases as time spent on SM increases

*******************************************************************************



*******************************************************************************