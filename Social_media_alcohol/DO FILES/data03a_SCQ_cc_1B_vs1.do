
********************************************************************************
*# Self-report complete case analysis: social media > alcohol freq and binge drinking SAP 1Ba, 1Bb
********************************************************************************

/* 
AK Purba [last updated 21.02.2023]
Dataset: data01_master_vs3_SCQ_imp_4_1.dta
Do file: data03a_SCQ_cc_1B_vs1.do 
Syntax for: 
1Ba: SCQ and binge drinking- logistic regression- complete case
1Bb: SCQ and alc. freq. last month – multinomial regression- complete case 

 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "Social_media_alcohol\DATASETS\data01_SCQ_cc_alc.dta", clear
set seed 57522 

* Should say (data unchanged since 25jan2023 09:43)
datasignature confirm

********************************************************************************
*#  Declare survey design 
********************************************************************************

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
svydescribe

********************************************************************************
*#  Prevalences 
********************************************************************************

* Unweighted
tab smscq_r5Ccc everbingedrink_rBcc, row col
tab smscq_r5Ccc alcfreqlastmnth_r4Ccc, row col

* Weighted (TUD non response and survey design weights)
svy: tab smscq_r5Ccc everbingedrink_rBcc, row per ci
svy: tab smscq_r5Ccc everbingedrink_rBcc, count
svy: tab smscq_r5Ccc alcfreqlastmnth_r4Ccc, row per ci
svy: tab smscq_r5Ccc alcfreqlastmnth_r4Ccc, count

********************************************************************************
*# 1Ba: SCQ and binge drinking- logistic regression- complete case
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
svy: logit everbingedrink_rBcc ib2.smscq_r5Ccc, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
svy: logit everbingedrink_rBcc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

// Unadjusted weighted model [1-<30 mins SM use ref cat] (by sex subgroup) males=0 females=1
svy, subpop (if sex_rBcc==1): logit everbingedrink_rBcc ib2.smscq_r5Ccc, or baselevel
svy, subpop (if sex_rBcc==0): logit everbingedrink_rBcc ib2.smscq_r5Ccc, or baselevel

// Adjusted weighted model [1-<30 mins SM use ref cat] (by sex subgroup) males=0 females=1
svy, subpop (if sex_rBcc==1): logit everbingedrink_rBcc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel
svy, subpop (if sex_rBcc==0): logit everbingedrink_rBcc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

********************************************************************************
*# 1Bb: SCQ and alc. freq. last month – multinomial regression- complete case 
********************************************************************************

// Check of proportional odds assumption via test of parallel lines using omodel package
*ssc install omodel
omodel logit alcfreqlastmnth_r4Ccc smscq_r5Ccc //Prob>chi2= 0.0520
omodel logit alcfreqlastmnth_r4Ccc smscq_r5Ccc eth_rBcc famstr_r3Ccc  hhinc_r5Ccc hied_CO7Ccc hiocc_CO6Ccc sex_rBcc parcursmk_CO2Ccc parstyCOcc prvcig_rBcc anti_COccim prvalc_rBcc urb_COcc  cmage6_3Ccc sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc eng_D wales_D scot_D imd_COcc peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc
//Prob>chi2 =0.0000
* P value for model with all confounders is <0.05 so our slopes are different, indicating proportional odds assumption is not met so multinomial model should be used.

// Unadjusted weighted model [1-<30 mins SM use ref cat]
svy: mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc, rrr baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
svy: mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D  ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , rrr baselevel baseoutcome(1)

// Unadjusted weighted model [1-<30 mins SM use ref cat] (by sex subgroup) males=0 females=1
svy, subpop (if sex_rBcc==1): mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc, rrr baselevel baseoutcome(1)
svy, subpop (if sex_rBcc==0): mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc, rrr baselevel baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat] (by sex subgroup) males=0 females=1
svy, subpop (if sex_rBcc==1): mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , rrr baselevel baseoutcome(1)
svy, subpop (if sex_rBcc==0): mlogit alcfreqlastmnth_r4Ccc ib2.smscq_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , rrr baselevel baseoutcome(1)


********************************************************************************




