

********************************************************************************

*Do file: data02a_SCQ_cc_INtable5a_vs1
*Dataset used: data01_SCQ_cc_vs1
*Amrit Purba 10.05.2022

*Purpose: syntax for SCQ complete case analysis: Interaction- approach 2 - Additive measures of interaction - Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)
*Table 5a: Approach 2 - Interaction between social media use and parental education on the risk of CM cigarette use  (n=6234) (SAP 3Da)
*Notes:Measure of additive interaction calculated for each SM pairwise comparison (binary vars created from ordinal exposure var): RERI = RR11 RR10-RR01+1. Where RR11= EM exposed & SM exposed (compared with EM not exposed & SM not exposed); RR10= EM not exposed & SM exposed; and RR01= EM exposed & SM not exposed. EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use.Methodology by Andersson et al: Andersson T, Alfredsson L, Källberg H, Zdravkovic S, Ahlbom A. Calculating measures of biological interaction. Eur J Epidemiol. 2005;20(7):575-9. doi: 10.1007/s10654-005-7835-x. PMID: 16119429. Anderson method used to obtain RERI, SI and AP and 95% CI. P values to be calculated by hand*/

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\SELF COMPLETION QUESTIONNAIRE (SCQ)\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 5766367

*should say  (data unchanged since 09may2022 11:14)
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

******************************************************************************

*#Pairwise comparison A1-A4: additive measure of interaction (RERI) - unadjusted 

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

*#Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson smok_rBcc hied_COBcc#A1smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A1smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A2smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A3smscq, irr baselevel 
svy: poisson smok_rBcc hied_COBcc#ib1.A4smscq, irr baselevel 
 
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

*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson smok_rBcc A1ind01 A1ind10  A1ind11, irr baselevel
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11
estat vce
*RERI and 95% CI as per excel: 0.162 (-1.467-1.791)
*SE = (u − l)/(2×1.96) = 0.83112245
di (1.791-(-1.467))/(2*1.96)
*z score = Est/SE = 0.19491713
di 0.162/0.83112245
gen z1c_unadj =0.1949171
*2 tailed p value= 0.8454579
gen p1c_unadj=2*(1-normal(abs(z1c_unadj))) 
tab p1c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.162169
di 1.957836-1.667221-1.128446 +1

*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11, irr
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11
estat vce
*RERI and 95% CI as per excel: 0.124(-1.409-1.657)
*SE = (u − l)/(2×1.96) = 0.78214286
di (1.657-(-1.409))/(2*1.96)
*z score = Est/SE = 0.15853881
di 0.124 /0.78214286
gen z2c_unadj= 0.15853881
*2 tailed p value= 0.8740323 
gen p2c_unadj=2*(1-normal(abs(z2c_unadj))) 
tab p2c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.123876
di   2.530813-1.667221-1.739716 +1

*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11, irr
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11
estat vce
*RERI and 95% CI as per excel: -0.367 (-1.839-1.106)
*SE = (u − l)/(2×1.96) = 0.75127551
di (1.106-(-1.839))/(2*1.96)
*z score = Est/SE = -0.48850255
di -0.367/0.75127551
gen z3c_unadj=-0.48850255
*2 tailed p value= 0.6251939
gen p3c_unadj=2*(1-normal(abs(z3c_unadj))) 
tab p3c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.366666
di  2.219593-1.667221-1.919038+1

*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11, irr
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11
estat vce
*RERI and 95% CI as per excel: -0.401 (-1.732-0.930)
*SE = (u − l)/(2×1.96) = 0.67908163
di (0.930-(-1.732))/(2*1.96)
*z score = Est/SE = -0.59050338
di -0.401/0.67908163
gen z4c_unadj=-0.59050338
*2 tailed p value=  0.5548532 
gen p4c_unadj=2*(1-normal(abs(z4c_unadj))) 
tab p4c_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.401298
di  3.037197-1.66722-2.771275+1

*#Checks
/*(RR11): EM exposed and SM exposed
(RR10): SM exposed and EM not exposed
(RR01): EM exposed and SM not exposed
(RR00): SM not exposed and EM not exposed 

FORMULA FOR RERI:
RERI= RR11-RR01 -RR10 +1 */

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

*#Pairwise comparison A1-A4: additive measure of interaction (RERI) (RERI)- adjusted 

*******************************************************************************

*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
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
di 0.3137372/0.2319847
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
di 0.3795989  /0.2441875
*RR = 1.5545386

**high parental education
*A1: 
svy: poisson smok_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.121268
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<30min high par ed = 0.1586224   
*Pr = no sm use high par ed = 0.141467
di 0.1586224/0.141467
*RR = 1.1212679

*A2: 
svy: poisson smok_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 1.774741 
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2416792  
*Pr = no sm use high par ed = 0.1361772
di 0.2416792/0.1361772
*RR = 1.7747406

*A3: 
svy: poisson smok_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 1.878659
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.2615795 
*Pr = no sm use high par ed = 0.1392373 
di 0.2615795/0.1392373 
*RR = 1.8786597

*A4: 
svy: poisson smok_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.62595
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.3815474 
*Pr = no sm use high par ed = 0.1452988
di 0.3815474 /0.1452988
*RR = 2.6259501

*#Risk ratios (95% CI; P-value) for parental education [low parental education vs high parental education (rc)], within strata of SM use 
svy: poisson smok_rBcc hied_COBcc#A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A1smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A2smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A3smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
svy: poisson smok_rBcc hied_COBcc#ib1.A4smscq i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel

*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive interaction (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val.

*A1 
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 0.003 (-1.099, 1.105)
*SE = (u − l)/(2×1.96) = 0.5622449
di (1.105-(-1.099))/(2*1.96)
*z score = Est/SE = 0.00533575
di 0.003/0.5622449
gen z1c_adj=0.00533575
*2 tailed p value = 0.9957427 
gen p1c_adj=2*(1-normal(abs(z1c_adj))) 
tab p1c_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.003149
di 1.477773-1.353356-1.121268 +1

*A2 
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.174 (-1.525-1.176)
*SE = (u − l)/(2×1.96) = 0.68903061
di (1.176-(-1.525))/(2*1.96)
*z score = Est/SE = -0.37399293
di -0.174 /0.68903061
gen z2c_adj=-0.25252869
*2 tailed p value = 0.8006324
gen p2c_adj=2*(1-normal(abs(z2c_adj))) 
tab p2c_adj
*Checks: RERI= RR11-RR01 -RR10 +1 =-0.174402
di 2.30389-1.703551-1.774741 +1

*A3 
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.680 (-2.088-0.729)
*SE = (u − l)/(2×1.96) = 0.71862245
di (0.729-(-2.088))/(2*1.96)
*z score = Est/SE = -0.94625488
di -0.680 /0.71862245
gen z3c_adj=-0.94625488
*2 tailed p value = 0.3440186 
gen p3c_adj=2*(1-normal(abs(z3c_adj))) 
tab p3c_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.679768
di 2.027052- 1.828161 - 1.878659+1

*A4 
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson smok_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.694 (-1.902-0.514)
*SE = (u − l)/(2×1.96) = 0.61632653
di (0.514-(-1.902))/(2*1.96)
*z score = Est/SE = -1.1260265
di -0.694/0.61632653
gen z4c_adj=-1.1260265
*2 tailed p value = 0.2601543 
gen p4c_adj=2*(1-normal(abs(z4c_adj))) 
tab p4c_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.693998
di   2.61254-1.680588- 2.62595 +1

*#Checks
/*(RR11): EM exposed and SM exposed
(RR10): SM exposed and EM not exposed
(RR01): EM exposed and SM not exposed
(RR00): SM not exposed and EM not exposed 

FORMULA FOR RERI:
RERI= RR11-RR01 -RR10 +1 */

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , irr baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: poisson smok_rBcc c.smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
* coeff (RR) = 1.282705, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 28%. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: poisson smok_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of smoking in high parental education group increases as time spent on SM increases, which aligns with our RRs
*1_low parentel ed = 0.1592 - no significant linear relationship - risk of smoking in low par ed group does not increase as time spent on SM increases, which aligns with our RRs. Non significant test could be a result of low sample size in low parental education group.
*******************************************************************************



*******************************************************************************