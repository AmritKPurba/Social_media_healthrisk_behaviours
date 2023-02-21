

********************************************************************************

*Do file: data02a_SCQ_cc_EMtable8a_vs1
*Dataset used: data01_SCQ_cc_vs1
*Amrit Purba 10.05.2022

*Purpose: syntax for SCQ complete case analysis: Effect modification- approach 2 - Additive measure of effect modification- Poission regression with robust standard errors (RERI=RR11-RR01-RR10+1)
*Table 8a: Approach 2-  Modification of the effect of SM use on CM e-cigarette use by parental education (n=6234) (SAP 3Ca)
*Notes: Measure of additive effect modification calculated for each SM pairwise comparison (binary variables created from ordinal exposure var): RERI = RR11-RR10-RR01+1. Where RR11= EM exposed & SM exposed (compared with EM not exposed & SM not exposed); RR10= EM not exposed & SM exposed; and RR01= EM exposed & SM not exposed. EM exposed is low parental education, EM not exposed is high parental education. SM exposed is our time categories and SM not exposed is no SM use. Methodology by Andersson et al: Andersson T, Alfredsson L, Källberg H, Zdravkovic S, Ahlbom A. Calculating measures of biological interaction. Eur J Epidemiol. 2005;20(7):575-9. doi: 10.1007/s10654-005-7835-x. PMID: 16119429. Anderson method used to obtain RERI, SI and AP and 95% CI. P values to be calculated by hand.*/

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\SELF COMPLETION QUESTIONNAIRE (SCQ)\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 5765367

*should say  (data unchanged since 09may2022 11:14, except 2 variables have been added)
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

*#Pairwise comparison A1-A4: additive measure of effect modification (RERI) - unadjusted 

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
label values A1smscq A1smscq 
tab A1smscq smscq_r5Ccc,mi

clonevar A2smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A2smscq 1=0 3=1 2 4 5 =.
label define A2smscq 0"0_no SM use" 1"1_30min-<1hr"
label values A2smscq A2smscq 
tab A2smscq smscq_r5Ccc,mi

clonevar A3smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A3smscq 1=0 4=1 2 3 5 =.
label define A3smscq 0"0_no SM use" 1"1_1-<2hrs"
label values A3smscq A3smscq 
tab A3smscq smscq_r5Ccc,mi

clonevar A4smscq = smscq_r5Ccc
codebook smscq_r5Ccc
recode A4smscq 1=0 5=1 2 3 4 =.
label define A4smscq 0"0_no SM use" 1"1_≥2hrs"
label values A4smscq A4smscq 
tab A4smscq smscq_r5Ccc,mi

*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)

**low parental education 
*A1: 
svy: poisson ecig_rBcc A1smscq#ib1.hied_COBcc, irr baselevel 
*RR =  2.553072
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.3018999
*Pr = no sm use low par ed = 0.1182497
di 0.3018999/0.1182497
*RR =  2.5530712

*A2: 
svy: poisson ecig_rBcc A2smscq#ib1.hied_COBcc, irr baselevel 
*RR = 2.560555  
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hrs low par ed = 0.3027848 
*Pr = no sm use low par ed = 0.1182497
di 0.3027848 /0.1182497
*RR = 2.5605545

*A3: 
svy: poisson ecig_rBcc A3smscq#ib1.hied_COBcc,irr baselevel 
*RR = 1.840637
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.2176547
*Pr = no sm use low par ed = 0.1182497
di 0.2176547/0.1182497
*RR = 1.8406364

*A4: 
svy: poisson ecig_rBcc A4smscq#ib1.hied_COBcc, irr baselevel 
*RR =  2.655681
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.3140334
*Pr = no sm use low par ed = 0.1182497
di 0.3140334/0.1182497
*RR = 2.6556803

**high parental education
*A1: 
svy: poisson ecig_rBcc A1smscq#hied_COBcc, irr baselevel 
*RR =  1.02559
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins high par ed = 0.106099
*Pr = no sm use high par ed = 0.1034517
di 0.106099/0.1034517
 *RR = 1.0255897
 
*A2: 
svy: poisson ecig_rBcc A2smscq#hied_COBcc,irr baselevel 
*RR = 1.972747
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2040841 
*Pr = no sm use high par ed = 0.1034517
di 0.2040841/0.1034517
*RR = 1.9727477

*A3: 
svy: poisson ecig_rBcc A3smscq#hied_COBcc, irr baselevel 
*RR = 1.863456
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.1927777
*Pr = no sm use high par ed = 0.1034517
di 0.1927777/0.1034517 
*RR = 1.8634561

*A4: 
svy: poisson ecig_rBcc A4smscq#hied_COBcc, irr baselevel 
*RR = 2.677842
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.2770275 
*Pr = no sm use high par ed = 0.1034518
di 0.2770275/0.1034518 
*RR = 2.6778413

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
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*1st command produces the RRs for SM use and parental education, 2nd command generates the regression coefficients in the form of ln(RR) and 3rd provides covariance matrix of coefficients of poisson model (with robust standard errors as outcome is binomial and not true poisson (count)) - variance matrix estimator with the svy option is always of the sandwich form, which accounts for the survey sampling and is automatically robust to violations of the distribution assumption (Poisson in this case)) [C] Enter information (from 2nd and 3rd commands) into excel document to generate RERI & 95% CI (saved in relevant literature folder: Andersson_epinetcalculation.xls). Note excel does not produce p vals- use 95% CI and calcualte SE, Z score and p val. 

*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11, irr baselevel
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11
estat vce
*RERI and 95% CI as per excel: 1.750 (-0.043-3.542)
*SE = (u − l)/(2×1.96) = 0.91454082
di (3.542-(-0.043))/(2*1.96)
*z score = Est/SE = 1.9135286
di 1.750/0.91454082
gen z1e_unadj =1.9135286
*2 tailed p value= 0.0556804 
gen p1e_unadj=2*(1-normal(abs(z1e_unadj))) 
tab p1e_unadj
*Checks: RERI= RR11-RR01 -RR10+1 = 1.749636
di 2.918268-1.143042-1.02559 +1

*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11, irr
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11
estat vce
*RERI and 95% CI as per excel: 0.811 (-0.654-2.276)
*SE = (u − l)/(2×1.96) = 0.74744898
di (2.276-(-0.654))/(2*1.96)
*z score = Est/SE = 1.0850239
di 0.811/0.74744898
gen z2e_unadj=1.0850239
*2 tailed p value= 0.2779111 
gen p2e_unadj=2*(1-normal(abs(z2e_unadj))) 
tab p2e_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.811033
di 2.926822-1.143042-1.972747+1

*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11, irr
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11
estat vce
*RERI and 95% CI as per excel: 0.097 (-1.268-1.463)
*SE = (u − l)/(2×1.96) = 0.69668367
di (1.463-(-1.268))/(2*1.96)
*z score = Est/SE = 1.196566
di 0.097/0.69668367
gen z3e_unadj=0.13923105
*2 tailed p value= 0.8892676 
gen p3e_unadj=2*(1-normal(abs(z3e_unadj))) 
tab p3e_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 =0.097427
di 2.103925-1.143042-1.863456+1

*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11, irr
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11
estat vce
*RERI and 95% CI as per excel: 0.215 (-0.967-1.405)
*SE = (u − l)/(2×1.96) = 0.60510204
di (1.405-(-0.967))/(2*1.96)
*z score = Est/SE = 0.35531197
di 0.215/0.60510204
gen z4e_unadj=0.35531197
*2 tailed p value=  0.7223559  
gen p4e_unadj=2*(1-normal(abs(z4e_unadj))) 
tab p4e_unadj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.21467
di 3.035554-1.143042-2.677842+1

**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: poisson ecig_rBcc smscq_r5Ccc##hied_COBcc , irr baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: poisson ecig_rBcc c.smscq_r5Ccc##hied_COBcc , irr baselevel
* coeff (RR) = 1.288431, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 29%. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: poisson ecig_rBcc smscq_r5Ccc##hied_COBcc , irr baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of e-cigaratte use in high parental education group increases as time spent on SM increases.
*1_low parentel ed = 0.0713 - no significant linear relationship - risk of e-cigarette use in low parental education group does not increases as time spent on SM increases. Non significant test could be a result of low sample size in low parental education group.

*******************************************************************************

*#Pairwise comparison A1-A4: additive measure of effect modification (RERI)- adjusted 

*******************************************************************************

*#1st command: risk ratios (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education 
*#2nd command: probabilities (95% CI; P-value) for SM use [A1-A4 vs no sm use (rc)], within strata of parental education)
**low parental education 
*A1: 
svy: poisson ecig_rBcc A1smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.092219
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-30 mins low par ed = 0.2347891 
*Pr = no sm use low par ed = 0.1122201
di 0.2347891/0.1122201 
*RR = 2.0922197

*A2: 
svy: poisson ecig_rBcc A2smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.700912
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr low par ed = 0.2602423 
*Pr = no sm use low par ed = 0.0963535
di 0.2602423/0.0963535
*RR = 2.7009117 

*A3: 
svy: poisson ecig_rBcc A3smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.811341
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs low par ed = 0.1986997 
*Pr = no sm use low par ed = 0.1096976 
di 0.1986997 /0.1096976  
*RR = 1.8113404

*A4: 
svy: poisson ecig_rBcc A4smscq#ib1.hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  2.876172 
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs low par ed = 0.2985284 
*Pr = no sm use low par ed = 0.1037937 
di 0.2985284 /0.1037937
*RR = 2.8761707

**high parental education
*A1: 
svy: poisson ecig_rBcc A1smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR =  1.044892
margins A1smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<30min high par ed = 0.1091212   
*Pr = no sm use high par ed = 0.104433
di 0.1091212 /0.104433
*RR = 1.0448919

*A2: 
svy: poisson ecig_rBcc A2smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.221359
margins A2smscq##hied_COBcc, vce(unconditional)
*Pr = 30min-<1hr high par ed = 0.2171834
*Pr = no sm use high par ed = 0.0977705 
di 0.2171834/0.0977705 
*RR = 2.2213592

*A3: 
svy: poisson ecig_rBcc A3smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 2.120262
margins A3smscq##hied_COBcc, vce(unconditional)
*Pr = 1-<2hrs high par ed = 0.202598
*Pr = no sm use high par ed = 0.0955533 
di 0.202598/0.0955533 
*RR =2.1202617

*A4: 
svy: poisson ecig_rBcc A4smscq#hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel 
*RR = 3.073097 
margins A4smscq##hied_COBcc, vce(unconditional)
*Pr = ≥2hrs high par ed = 0.285707
*Pr = no sm use high par ed = 0.0929704
di 0.285707/0.0929704
*RR = 3.073097 

*#Risk ratios (95% CI; P-values) for SM use and parental education (rc: high parental education & no SM use)
*#Measure of additive effect modification (RERI; 95% CI; P-value)
*as above

*A1 
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A1ind01 A1ind10 A1ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 1.129 (-0.229-2.486)
*SE = (u − l)/(2×1.96) = 0.69260204
di (2.486-(-0.229))/(2*1.96)
*z score = Est/SE = 1.6300847
di 1.129/0.69260204
gen z1e_adj=1.6300847
*2 tailed p value =   0.1030836 
gen p1e_adj=2*(1-normal(abs(z1e_adj))) 
tab p1e_adj
*Checks: RERI= RR11-RR01 -RR10 +1 =1.128769
di   2.248226-1.074565- 1.044892+1

*A2 
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A2ind01 A2ind10 A2ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 0.455 (-0.859-1.769)
*SE = (u − l)/(2×1.96) = 0.67040816
di (1.769-(-0.859))/(2*1.96)
*z score = Est/SE = 0.67869102
di 0.455/0.670408165
gen z2e_adj=0.67869102
*2 tailed p value =  0.4973336 
gen p2e_adj=2*(1-normal(abs(z2e_adj))) 
tab p2e_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.4549012
di 2.661767-0.9855068-2.221359+1

*A3 
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A3ind01 A3ind10 A3ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: -0.189 (-1.499-1.121)
*SE = (u − l)/(2×1.96) = 0.66836735
di (1.121-(-1.499))/(2*1.96)
*z score = Est/SE = -0.28277862
di -0.189 /0.66836735
gen z3e_adj=-0.28277862
*2 tailed p value = 0.7773466  
gen p3e_adj=2*(1-normal(abs(z3e_adj))) 
tab p3e_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = -0.188822
di  2.079465 -1.148025-2.120262+1

*A4 
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr
svy: poisson ecig_rBcc A4ind01 A4ind10 A4ind11 i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc
estat vce
*RERI and 95% CI as per excel: 0.021 (-1.122-1.165)
*SE = (u − l)/(2×1.96) =0.58341837
di (1.165-(-1.122))/(2*1.96)
*z score = Est/SE = 0.03599475
di 0.021 /0.58341837
gen z4e_adj=0.03599475
*2 tailed p value = 0.9712865 
gen p4e_adj=2*(1-normal(abs(z4e_adj))) 
tab p4e_adj
*Checks: RERI= RR11-RR01 -RR10 +1 = 0.021492
di 3.211005-1.116416-3.073097+1


**DO NOT REPORT TEST FOR LINEAR TREND- ONLY USE TO AID INTERPRETATION**

*#Test for linear trend using ordinal SM variable as cant check for linearity using binary SM variables. p<0.05 indicates significant linear trend and shows if the effect of SM use is linear whilst controlling for parental education.
svy: poisson ecig_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc , irr baselevel
contrast p.smscq_r5Ccc, noeffects
*p = 0.0000 - indicating significant linear trend

*Treat SM use as linear/continuous variable
svy: poisson ecig_rBcc c.smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
* coeff (RR) = 1.327282, as we move from no SM use through each of the SM time categories (one step increase in category) our risk of outcome increases by 33%. Thus a one step increase in SM category has a linear relationship with increased smoking, whilst controlling for the effect of parental education

*Test to see if linear effect of SM exists within the individual strata of parental education 
svy: poisson ecig_rBcc smscq_r5Ccc##hied_COBcc i.eth_r6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc, irr baselevel
contrast p.smscq_r5Ccc@hied_COBcc, noeffects 
*0_high parental ed = 0.0000 - significant linear relationship - risk of e-cigarette use in high parental education group increases as time spent on SM increases
*1_low parentel ed = 0.0298 - significant linear relationship - risk of e-cigarette use in low parental education group increases as time spent on SM increases

*******************************************************************************



*******************************************************************************