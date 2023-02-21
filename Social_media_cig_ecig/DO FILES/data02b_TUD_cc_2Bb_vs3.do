********************************************************************************
//Time use diary complete case analysis: social media > e-cigarette use SAP 2Bb
********************************************************************************

/*
AK Purba [last updated 21.02.2023]
Do file: data02b_TUD_cc_2Bb_vs3.do
Dataset: data01_TUD_cc_vs3.dta

Syntax:
Social media and e-cigarette use - logistic regression
 
 */


********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "CIG_ECIG\DATASETS\data01_TUD_cc_vs3.dta", clear
set seed 9260478

* Should say (data unchanged since 18jan2023 14:42)
datasignature confirm

********************************************************************************

// Relevant weight 

*TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
*svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Prevalences 

* Unweighted
tab avgsm_tud_r5Ccc ecig_rBcc, row col

* Weighted (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: tab avgsm_tud_r5Ccc ecig_rBcc, row per ci
svy: tab avgsm_tud_r5Ccc ecig_rBcc, count

* Additional: Weighted (only survey design weights)
svyset, strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: tab avgsm_tud_r5Ccc ecig_rBcc, row per ci
svy: tab avgsm_tud_r5Ccc ecig_rBcc, count

********************************************************************************

// Unadjusted models - 1-<30 mins SM as ref cat 

* Weighted model (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit ecig_rBcc ib2.avgsm_tud_r5Ccc, or baselevel


********************************************************************************

// Adjusted models - 1-<30 mins SM as ref cat 
* ni_D used as reference category for country indicators
* Requirement to dichotomise eth_r6Ccc due to small cell counts
* eth_rBcc var used instead of eth_r6Ccc due to small cell counts


* Weighted model (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit ecig_rBcc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel



********************************************************************************



