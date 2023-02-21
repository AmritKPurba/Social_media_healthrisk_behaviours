

********************************************************************************

*Do file: data02a_SCQ_cc_INtable6a_vs1
*Dataset used: data01_SCQ_cc_vs1
*Amrit Purba 10.05.2022

*Purpose: syntax for SCQ complete case analysis: Interaction- approach 1 & 2 - Multiplicative measures of interaction - Poission regression with robust standard errors (RR11/RR10*RR01)
*Table 6a: Approach 1 & 2- Interaction between social media use and parental education on the risk of CM cigarette use  (n=6234) (SAP 3Dc)
*Notes:Measure of multiplicative interaction calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RR11: effect of exposure and EM together compared to reference category of both factors absent / RR01: effect of exposure alone and no EM (ref cat) /RR10: effect of EM alone and no exposure (ref cat): RR11/(RR10*RR01) */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\SELF COMPLETION QUESTIONNAIRE (SCQ)\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 5753612

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

*#Pairwise comparison A1-A4: mutliplicative measure of interaction (ratio of RRs) - unadjusted 

*******************************************************************************
set showbaselevels on
codebook smscq_r5Ccc
codebook hied_COBcc

*#Declare survey design 
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 

*#Unadjusted prevalences   
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

*#Risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education
*#*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education) 
**low parental education 
*A1: 
svy: poisson smok_rBcc A1smscq#ib1.hied_COBcc, irr baselevel 
*RR =  1.174311
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.2682751
*Pr = no sm use low par ed = 0.2284531
di 0.2682751/0.2284531
*RR =  1.174311

*A2: 
svy: poisson smok_rBcc A2smscq#ib1.hied_COBcc, irr baselevel 
*RR = 1.517983  
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hrs low par ed = 0.346788
*Pr = no sm use low par ed = 0.2284531
di 0.346788/0.2284531
*RR = 1.517983 

*A3: 
svy: poisson smok_rBcc A3smscq#ib1.hied_COBcc,irr baselevel 
*RR = 1.331313
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.3041426
*Pr = no sm use low par ed = 0.2284531
di 0.3041426/0.2284531
*RR = 1.331313

*A4: 
svy: poisson smok_rBcc A4smscq#ib1.hied_COBcc, irr baselevel 
*RR = 1.821713 
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.4161761
*Pr = no sm use low par ed = 0.2284531
di 0.4161761/0.2284531
*RR = 1.821713

**high parental education
*A1: 
svy: poisson smok_rBcc A1smscq#hied_COBcc, irr baselevel 
*RR = 1.128446
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins high par ed = 0.1546268
*Pr = no sm use high par ed = 0.1370263 
di 0.1546268/0.1370263
 *RR = 1.1284461
 
*A2: 
svy: poisson smok_rBcc A2smscq#hied_COBcc,irr baselevel 
*RR = 1.739716
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2383869 
*Pr = no sm use high par ed = 0.1370263 
di 0.2383869/0.1370263 
*RR = 1.739716

*A3: 
svy: poisson smok_rBcc A3smscq#hied_COBcc, irr baselevel 
*RR = 1.919038
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.2629586 
*Pr = no sm use high par ed = 0.1370263 
di 0.2629586/0.1370263 
*RR = 1.9190374

*A4: 
svy: poisson smok_rBcc A4smscq#hied_COBcc, irr baselevel 
*RR = 2.771275
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.3797377 
*Pr = no sm use high par ed = 0.1370264 
di 0.3797377/0.1370264 
*RR = 2.771274

/*Generate combined vars where (produced above):
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

*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)
*A1
svy: poisson smok_rBcc i.A1hied_reri , irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A1smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson smok_rBcc A1smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A1smscq##i.hied_COBcc, irr baselevel
*checks R11= 1.957836 / R01= 1.667221 / R10= 1.128446
di 1.957836/(1.667221*1.128446)

*A2
svy: poisson smok_rBcc i.A2hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A2smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A2smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A2smscq##i.hied_COBcc, irr baselevel
*checks R11= 2.530813 / R01= 1.667221 / R10= 1.739716 
di 2.530813/( 1.667221*1.739716 )

*A3 
svy: poisson smok_rBcc i.A3hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A3smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A3smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A3smscq##i.hied_COBcc, irr baselevel
*checks R11= 2.219593 / R01= 1.667221 / R10= 1.919038
di 2.219593/(1.667221*1.919038)

*A4
svy: poisson smok_rBcc i.A4hied_reri, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A4smscq#hied_COBcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on additive scale (both commands do the same thing!)
svy: poisson smok_rBcc A4smscq##hied_COBcc, irr baselevel
svy: poisson smok_rBcc i.A4smscq##i.hied_COBcc, irr baselevel
*checks R11= 3.037197 / R01= 1.667221 / R10= 2.771275
di 3.037197/(1.667221*2.771275)

/*
*#Checks  
*Checks for measure of additive interaction using A1 as example: 
*R11 (p11-p00): RR for low parental education and 1-<30mins SM use
*R10 (p10-p00): RR for high parental education and 1-<30mins SM use
*R01 (p01-p00): RR for low parental education and no SM use
*Calculation: R11/(R01*R10) */			

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc , irr baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: poisson smok_rBcc c.smscq_r5Ccc##hied_COBcc , irr baselevel
* coeff (RR) = 1.310167, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 31%. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc , irr baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of smoking in high parental education group increases as time spent on SM increases, which aligns with our RRs
*1_low parentel ed = 0.0772 - no significant linear relationship - risk of smoking in low par ed group does not increases as time spent on SM increases, which aligns with our RRs. Non significant test could be a result of low sample size in low parental education group.			

*******************************************************************************

*#Pairwise comparison A1-A4: multiplicative measure of interaction (ratio of RRs) - adjusted 

*******************************************************************************

*1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: poisson smok_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.091932 
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.2090561 
*Pr = no sm use low par ed = 0.1914552
di 0.2090561/0.1914552
*RR = 1.0919322

*A2: 
svy: poisson smok_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 1.352404
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.3137372 
*Pr = no sm use low par ed = 0.2319847 
di 0.3137372 /0.2319847
*RR = 1.3524047

*A3: 
svy: poisson smok_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.108793
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.2822413
*Pr = no sm use low par ed = 0.2545482
di 0.2822413/0.2545482
*RR = 1.1087931

*A4: 
svy: poisson smok_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.554539
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.3795989 
*Pr = no sm use low par ed = 0.2441875
di 0.3795989 /0.2441875
*RR = 1.5545386

**high parental education
*A1: 
svy: poisson smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.121268
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<30min high par ed = 0.1586224  
*Pr = no sm use high par ed = 0.141467 
di 0.1586224 /0.141467
*RR = 1.1212679

*A2: 
svy: poisson smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 1.774741
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2416792  
*Pr = no sm use high par ed = 0.1361772
di 0.2416792 /0.1361772
*RR = 1.7747406

*A3: 
svy: poisson smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 1.878659
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.2615795
*Pr = no sm use high par ed = 0.1392373
di 0.2615795/0.1392373
*RR = 1.878659

*A4: 
svy: poisson smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.62595
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.3815474
*Pr = no sm use high par ed = 0.1452988 
di 0.3815474/ 0.1452988
*RR = 2.6259501

*#Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use
svy: poisson smok_rBcc hied_COBcc#A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A2smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A3smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A4smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of multiplicative interaction (Ratio of RRs; 95% CI; P-values)

*A1
svy: poisson smok_rBcc i.A1hied_reri i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*double check same as interaction
svy: poisson smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*yes no issues
*now get -pvalues and measure of interaction on mult scale (both commands do the same thing!)
svy: poisson smok_rBcc A1smscq##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc i.A1smscq##i.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
*checks R11=  1.477773 / R01= 1.353356/ R10=1.121268 
di 1.477773 /(1.353356 *1.121268 )

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

*#Checks 
* Measure of multiplicative interaction calculated for each SM category: RR11: effect of exposure and EM together compared to reference category of both factors absent / RR10: effect of exposure alone and no EM (ref cat) /RR01: effect of EM alone and no exposure (ref cat)											
* Calculation = RR11/RR10*RR01 */

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , irr baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: poisson smok_rBcc c.smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
* coeff (RR) = 1.282705, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 29%. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of smoking in high parental education group increases as time spent on SM increases, which aligns with our RRs
*1_low parentel ed = 0.1592- no significant linear relationship - risk of smoking in low par ed group does not increase as time spent on SM increases, which aligns with our RRs. Non significant test could be a result of low sample size in low parental education group.
*******************************************************************************



*******************************************************************************



