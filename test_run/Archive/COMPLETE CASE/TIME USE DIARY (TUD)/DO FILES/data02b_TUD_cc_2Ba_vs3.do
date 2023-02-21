


********************************************************************************
//TUD complete case analysis: SAP 2Ba
********************************************************************************

// data02b_TUD_cc_2Ba_vs3.do: Syntax for SAP 2Ba analysis (using updated weight)
// Amrit Purba 29.11.22

*Syntax for SAP 2Ba 
*Exposure- avgsm_tud_r5Ccc  
*Outcome- Cigarette use (binary) 
*Analysis- Binary log. regression 
*Dataset used- data01_TUD_cc_vs3

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



use "COMPLETE CASE\TIME USE DIARY (TUD)\DATASETS\data01_TUD_cc_vs3.dta", clear

set seed 9260678

* Should say   (data unchanged since 01dec2022 11:49)
datasignature confirm
*Binary ethnicity var used due to collinearity

********************************************************************************

// Relevant weight 

*TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
*svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Prevalences 

* Unweighted
tab avgsm_tud_r5Ccc smok_rBcc, row col

* Weighted (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: tab avgsm_tud_r5Ccc smok_rBcc, row per ci
svy: tab avgsm_tud_r5Ccc smok_rBcc, count

* Additional: Weighted (only survey design weights)
svyset, strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: tab avgsm_tud_r5Ccc smok_rBcc, row per ci
svy: tab avgsm_tud_r5Ccc smok_rBcc, count

********************************************************************************

// Unadjusted models - 1-<30 mins SM as ref cat 

* Unweighted
logit smok_rBcc ib2.avgsm_tud_r5Ccc, or baselevel

* Weighted model (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc, or baselevel

* Additional: Weighted model (only survey design weights)
svyset, strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc, or baselevel

********************************************************************************

// Adjusted models - 1-<30 mins SM as ref cat 
* ni_D used as reference category for country indicators
* Requirement to dichotomise eth_r6Ccc due to small cell counts
* eth_rBcc var used instead of eth_r6Ccc due to small cell counts

* Unweighted


logit smok_rBcc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

* Weighted model (TUD non response and survey design weights)
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

* Additional: Weighted model (only survey design weights)
svyset, strata(PTTYPE2) psu(SPTN00) fpc (NH2)
svy: logit smok_rBcc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc i.mag12_r4Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

********************************************************************************




