********************************************************************************
//Time use diary complete case analysis:  social media > alcohol freq and binge drinking SAP 2Ba,2Bb
********************************************************************************

/*
AK Purba [last updated: 21.02.2023]
Do file: data03b_TUD_cc_2B_vs1.do
Dataset: data01_TUD_cc_alc.dta

Syntax:
2Ba: TUD and binge drinking- logistic regression- complete case
2Bb: TUD and alc. freq. last month – multinomial regression- complete case 

*/

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "ALC\DATASETS\data01_TUD_cc_alc.dta", clear
set seed 9260678

* Should say (data unchanged since 25jan2023 09:42)
datasignature confirm

********************************************************************************
// Declare survey design 
********************************************************************************

*TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Prevalences 

* Unweighted
tab avgsm_tud_r5Ccc everbingedrink_rBcc, row col
tab avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc, row col

* Weighted (TUD non response and survey design weights)
svy: tab avgsm_tud_r5Ccc everbingedrink_rBcc, row per ci
svy: tab avgsm_tud_r5Ccc everbingedrink_rBcc, count
svy: tab avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc, row per ci
svy: tab avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc, count

********************************************************************************
// 2Ba: TUD and binge drinking- logistic regression- complete case
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
svy: logit everbingedrink_rBcc ib2.avgsm_tud_r5Ccc, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
svy: logit everbingedrink_rBcc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

********************************************************************************
// 2Bb: TUD and alc. freq. last month – multinomial regression- complete case 
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
svy: mlogit alcfreqlastmnth_r4Ccc ib2.avgsm_tud_r5Ccc, rrr baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
*svy: mlogit alcfreqlastmnth_r4Ccc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D  ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , rrr baselevel baseoutcome(1)

*above model does not converge, problem with paralcfreq_r5Ccc, collapsed further for this single analyses
codebook paralcfreq_r5Ccc
recode paralcfreq_r5Ccc 1=1 2=2 3=3 4 5=4
label define paralcfreq_r5Cccx 1"1_never" 2"2_monthly or less" 3"3_2-4 times/month" 4"4_2 or more times/week"
label values paralcfreq_r5Ccc paralcfreq_r5Cccx
notes paralcfreq_r5Ccc: recoded into 4 cat var for TUD complete case alcohol analyses
tab paralcfreq_r5Ccc

svy: mlogit alcfreqlastmnth_r4Ccc ib2.avgsm_tud_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D  ib10.imd_COcc i.peeralc_r4Ccc i.cmrelig_rBcc i.paralcfreq_r5Ccc , rrr baselevel baseoutcome(1)


********************************************************************************





