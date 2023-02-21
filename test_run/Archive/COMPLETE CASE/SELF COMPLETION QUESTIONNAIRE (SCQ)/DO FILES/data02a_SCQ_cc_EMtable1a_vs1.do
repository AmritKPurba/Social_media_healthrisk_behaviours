


********************************************************************************

*Do file: data02a_SCQ_cc_EMtable1a_vs1
*Dataset used: data01_SCQ_cc_vs1
*Amrit Purba 10.05.2022

*Purpose: syntax for SCQ complete case analysis: Effect modification- approach 1 - Additive measures of effect modification - Linear regression with robust standard errors (RD low PE-high PE)
*Table 1A: Approach 1-  Modification of the effect of social media on CM cigarette use, by parental education (n=6234) (SAP 3Ca)
*Notes: measure of additive effect modification represents the size of the absolute difference between RDs for CM smoking by SM use, within low parental education group compared with high parental education group (baseline/ref cat) FORMULA: RD contrast- RD in low PE-RD in high PE (for each SM time category excl no sm use as this is the reference/baseline)

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\SELF COMPLETION QUESTIONNAIRE (SCQ)\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 575363

*should say  (data unchanged since 09may2022 11:14, except 2 variables have been added)
datasignature confirm

********************************************************************************

//Exposure, outcome and EM variable

****************************************************************************

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
0  0_high parental ed
1  1_low parentel ed
*0_high parental ed (ref cat) & 1_low parentel ed 

//Outcome 
codebook smok_rBcc
0  0_never smoked/tried cigs once
1  1_current or former smoker */

*******************************************************************************

*#Pairwise comparison A1-A4: additive measure of effect modification - unadjusted 

*******************************************************************************

set showbaselevels on
codebook smscq_r5Ccc
codebook hied_COBcc

*#Declare survey design
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 

*#Unadjusted prevalences   
tab smok_rBcc smscq_r5Ccc if hied_COBcc==1
tab smok_rBcc smscq_r5Ccc if hied_COBcc==0

svy, subpop (if hied_COBcc==1): tab smok_rBcc smscq_r5Ccc, col obs
svy, subpop (if hied_COBcc==0): tab smok_rBcc smscq_r5Ccc, col obs
svy, subpop (if hied_COBcc==1): tab smok_rBcc smscq_r5Ccc, col per
svy, subpop (if hied_COBcc==0): tab smok_rBcc smscq_r5Ccc, col per
svy, subpop (if hied_COBcc==1):proportion smok_rBcc, over (smscq_r5Ccc) 
svy, subpop (if hied_COBcc==0):proportion smok_rBcc, over (smscq_r5Ccc) 

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
svy: regress smok_rBcc A1smscq#ib1.hied_COBcc, baselevel 
*RD = 0.0398219
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.2682751
*Pr = no sm use low par ed = 0.2284531
di 0.2682751-0.2284531
*RD = 0.0398219

*A2:
svy: regress smok_rBcc A2smscq#ib1.hied_COBcc, baselevel 
*RD = 0.1183348
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.346788 
*Pr = no sm use low par ed = 0.2284531
di 0.346788-0.2284531
*RD = 0.1183349

*A3: 
svy: regress smok_rBcc A3smscq#ib1.hied_COBcc, baselevel
*RD = 0.0756895
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.3041426
*Pr = no sm use low par ed = 0.2284531
di 0.3041426-0.2284531
*RD = 0.0756895

*A4: 
svy: regress smok_rBcc A4smscq#ib1.hied_COBcc, baselevel 
*RD = 0.187723
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.4161761
*Pr = no sm use low par ed = 0.2284531
di 0.4161761-0.2284531
*RD = 0.187723

**high parental education
*A1:
svy: regress smok_rBcc A1smscq#hied_COBcc, baselevel 
*RD = 0.0176005
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins high par ed = 0.1546268
*Pr = no sm use high par ed = 0.1370263
di 0.1546268-0.1370263
*RD = 0.0176005

*A2: 
svy: regress smok_rBcc A2smscq#hied_COBcc, baselevel 
*RD = 0.1013605
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2383869
*Pr = no sm use high par ed = 0.1370263
di 0.2383869-0.1370263
*RD = 0.1013605

*A3: 
svy: regress smok_rBcc A3smscq#hied_COBcc, baselevel  
*RD = 0.1259323
margins A3##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.2629586
*Pr = no sm use high par ed = 0.1370263
di 0.2629586-0.1370263
*RD = 0.1259323

*A4: 
svy: regress smok_rBcc A4smscq#hied_COBcc, baselevel 
*RD = 0.2427114
margins A4##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.3797377 
*Pr = no sm use high par ed = 0.1370263
di 0.3797377-0.1370263
*RD = 0.2427114
 
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

*#Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use) 
*A1:
svy: regress smok_rBcc A1ind01 A1ind10 A1ind11, baselevel
*A2:
svy: regress smok_rBcc A2ind01 A2ind10 A2ind11, baselevel
*A3: 
svy: regress smok_rBcc A3ind01 A3ind10 A3ind11, baselevel
*A4:
svy: regress smok_rBcc A4ind01 A4ind10 A4ind11, baselevel

*#Measure of additive effect modification (95% CI; P-value)
*A1: 
svy: regress smok_rBcc A1smscq##hied_COBcc , baselevel
*A2:
svy: regress smok_rBcc A2smscq##hied_COBcc , baselevel
*A3: 
svy: regress smok_rBcc A3smscq##hied_COBcc , baselevel
*A4: 
svy: regress smok_rBcc A4smscq##hied_COBcc , baselevel
*svy: regress smok_rBcc smscq_r5Ccc##hied_COBcc , baselevel

*#Checks of measure of additive effect modification (RD in low PE- RD in high PE) 
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di 0.0398219-0.0176005
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di 0.1183348-0.1013605  
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di 0.0756895-0.1259323 
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed
di 0.187723-0.2427114 

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**
*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: regress smok_rBcc smscq_r5Ccc##hied_COBcc , baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: regress smok_rBcc c.smscq_r5Ccc##hied_COBcc , baselevel
* coeff = 0.0667542, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 0.0667542. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: regress smok_rBcc smscq_r5Ccc##hied_COBcc , baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of smoking in high par ed group increases as time spent on SM increases, which aligns with our risk differences
*1_low parentel ed = 0.0269 - significant linear relationship - risk of smoking in low par ed group increases as time spent on SM increases, which aligns with our risk differences

*******************************************************************************

*#Pairwise comparison A1-A4: additive measure of effect modification - adjusted 

*******************************************************************************

*#1st command: risk differences (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) / this command suitable for when treating SM use as ordinal var: svy: regress smok_rBcc smscq_r5Ccc#ib1.hied_COBcc, baselevel
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education
*A1: 
svy: regress smok_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD =  0.0349636 
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.235202
*Pr = no sm use low par ed = 0.2002384 
di 0.235202-0.2002384
*RD = 0.0349636 

*A2: 
svy: regress smok_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.097268 
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.3256265
*Pr = no sm use low par ed = 0.2283585
di 0.3256265-0.2283585
*RD = 0.097268

*A3: 
svy: regress smok_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD =  0.0436966 
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.2960749 
*Pr = no sm use low par ed = 0.2523783
di  0.2960749-0.2523783
*RD = 0.0436966 

*A4: 
svy: regress smok_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , baselevel
*RD = 0.1256144
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.3831023
*Pr = no sm use low par ed = 0.257488  
di 0.3831023-0.257488 
*RD = 0.1256143

**high parental education
*A1: 
svy: regress smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD =  0.013195
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<30min high par ed = 0.156485
*Pr = no sm use high par ed = 0.14329
di 0.156485-0.14329
*RD = 0.013195 

*A2:
svy: regress smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.0969533 
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2384836  
*Pr = no sm use high par ed = 0.1415303
di 0.2384836-0.1415303
*RD = 0.0969533

*A3: 
svy: regress smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.1177221 
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed =  0.2600973
*Pr = no sm use high par ed = 0.1423752
di 0.2600973-0.1423752
*RD =  0.1177221 

*A4: 
svy: regress smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*RD = 0.2177228
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.3802213
*Pr = no sm use high par ed = 0.1624985
di 0.3802213-0.1624985
*RD =  0.2177228

*#Risk differences (95% CI; P-value) for SM use and parental education (rc: high parental education & no SM use)
*A1 
svy: regress smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2 
svy: regress smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#*#Measure of additive effect modification (95% CI; P-value)
*A1 
svy: regress smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A2 
svy: regress smok_rBcc A2smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A3 
svy: regress smok_rBcc A3smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
*A4 
svy: regress smok_rBcc A4smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 

*#Checks of measure of additive effect modification (RD in low PE- RD in high PE)
*A1: 1_1-<30min#1_low parentel ed - 1_1-<30min#0_high parental ed
di 0.0349636-0.013195 
*A2: 1_30min-<1hr#1_low parentel ed - 1_30min-<1hr#0_high parental ed 
di 0.097268-0.0969533
*A3:  1_1-<2hrs#1_low parentel ed -  1_1-<2hrs#0_high parental ed 
di  0.0436966-0.1177221
*A4:  1_≥2hrs#1_low parentel ed - 1_≥2hrs#0_high parental ed 
di  0.1256144-0.2177228


**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**
*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: regress smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: regress smok_rBcc c.smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
* coeff = 0.0605432, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 0.0605432. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: regress smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, baselevel 
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of smoking in high par ed group increases as time spent on SM increases, which aligns with our risk differences
*1_low parentel ed = 0.0842 - nonsignificant linear relationship - risk of smoking in low par ed group does not seem to increases as time spent on SM increases, which does aligns with our risk differences. We also have a very small sample size in the low parental education group which will influence significance. 


*******************************************************************************



*******************************************************************************