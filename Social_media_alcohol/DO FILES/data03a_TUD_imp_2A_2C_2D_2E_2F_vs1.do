********************************************************************************
// Time use diary imputed analysis: social media > alcohol freq and binge drinking SAP 2Aa, 2Ab, 2Ca, 2Cb, 2Da, 2Db, 2Ea, 2Eb, 2Fa, 2Fb
********************************************************************************

/*
AK Purba [last updated: 21.02.2023]
Do file: data03a_TUD_imp_2A_2C_2D_2E_2F_vs1.do
Dataset: data01_master_vs3_TUD_imp_3_1.dta 

Syntax:
2Aa: TUD and binge drinking – logistic regression- imputed
2Ab: TUD and alc. freq. last month – multinomial regression- imputed
2Ea: TUD weekday and binge drinking – logistic regression- imputed
2Eb: TUD weekday  and alc. freq. last month – multinomial regression- imputed
2Fa: TUD and binge drinking – logistic regression- imputed – by sex
2Fb: TUD and alc. freq. last month – multinomial regression- imputed – by sex
2Ca: TUD and binge drinking – logistic regression- imputed – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
2Cb: TUD and alc. freq. last month – multinomial regression- imputed – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
2Da: TUD and binge drinking – logistic regression- imputed – additional adjustment for previous SM use (age 11)
2Db: TUD and alc. freq. last month – multinomial regression- imputed – additional adjustment for previous SM use (age 11)
 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "ALC\DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear
set seed 9260589

* Should say  (data unchanged since 19jan2023 12:47)
datasignature confirm

mi convert flong
mi set flong

********************************************************************************
*# SET WEIGHT
********************************************************************************

*survey weight [C] majority of weights <1 thus sum of weights will be less than count of participants
mi svyset [pweight=TUD_WT_RO1_imp], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************
// CREATE 4-CAT FREQ ALC USE IN LAST MONTH OUTCOME VARIABLE
********************************************************************************
codebook alcfreqlastmnth_r6Ccc_imp

mi xeq: tab alcfreqlastmnth_r6Ccc_imp
mi passive: gen alcfreqlastmnth_r4Ccc_imp =1 if alcfreqlastmnth_r6Ccc_imp==1
mi passive: replace alcfreqlastmnth_r4Ccc_imp =2 if alcfreqlastmnth_r6Ccc_imp==2
mi passive: replace alcfreqlastmnth_r4Ccc_imp=3 if alcfreqlastmnth_r6Ccc_imp==3
mi passive: replace alcfreqlastmnth_r4Ccc_imp=4 if alcfreqlastmnth_r6Ccc_imp==4 |alcfreqlastmnth_r6Ccc_imp==5 | alcfreqlastmnth_r6Ccc_imp==6
label define alcfreqlastmnth_r4Ccc_imp 1"1_never" 2"2_1-2 times" 3"3_3-5 times" 4"4_6+ times"
label values alcfreqlastmnth_r4Ccc_imp alcfreqlastmnth_r4Ccc_imp
label variable alcfreqlastmnth_r4Ccc_imp "M7: CM freq drinking last mnth-4C-cc-imp"
notes alcfreqlastmnth_r4Ccc_imp: rcc- orig var GCALCN00 used to create  alcfreqlastmnth_r7Ccc where do not know , I do not wish to answer and no answer replaced with stata missing values. As per questionnaire, alcfreqlastmnth_r7Ccc only asked if CM responded 2-7 to alcfreqlastyr_r7Ccc and previously responded 1_yes to everalc_rBcc. For all CM values of everalc_rBcc==0 coded as . for alcfreqlastmnth_r7Ccc recoded to 1_never for alcfreqlastmnth_r7Ccc_imp. We then cloned alcfreqlastmnth_r7Ccc_imp however categories 4_6-9 times, 5_10-19 times,  6_20-39 times, and 7_40+ times combined to give 4_6+ times 
mi xeq: tab  alcfreqlastmnth_r6Ccc_imp alcfreqlastmnth_r4Ccc_imp


********************************************************************************
// PREVALENCES
********************************************************************************

/// Unweighted N (to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below


* whole sample
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0
tab alcfreqlastmnth_r4Ccc_imp avgsm_tud_5Cimp if _mi_m >0
tab everbingedrink_rBcc_imp smwkdaytud_r5Ccc if _mi_m >0
tab alcfreqlastmnth_r4Ccc_imp smwkdaytud_r5Ccc if _mi_m >0

* by sex
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==0  // male 
tab alcfreqlastmnth_r4Ccc_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==0  // male   
tab everbingedrink_rBcc_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==1 // female
tab alcfreqlastmnth_r4Ccc_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==1 // female


/// Weighted prevalences
* whole sample
mi estimate: svy: proportion everbingedrink_rBcc_imp
mi estimate: svy: proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp)
mi estimate: svy: proportion everbingedrink_rBcc_imp, over (smwkdaytud_r5Ccc)

mi estimate: svy: proportion alcfreqlastmnth_r4Ccc_imp
mi estimate: svy: proportion alcfreqlastmnth_r4Ccc_imp, over (avgsm_tud_5Cimp)
mi estimate: svy: proportion alcfreqlastmnth_r4Ccc_imp, over (smwkdaytud_r5Ccc)

* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion everbingedrink_rBcc_imp, over (avgsm_tud_5Cimp) // female 
mi estimate: svy, subpop(if sex_rBcc==0) : proportion alcfreqlastmnth_r4Ccc_imp, over (avgsm_tud_5Cimp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion alcfreqlastmnth_r4Ccc_imp, over (avgsm_tud_5Cimp) // female 

********************************************************************************
/// 2Aa: TUD and binge drinking – logistic regression- imputed
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel


********************************************************************************
/// 2Ab: TUD and alc. freq. last month – multinomial regression- imputed
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp, baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)


********************************************************************************
// 2Ea: TUD weekday and binge drinking – logistic regression- imputed
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smwkdaytud_r5Ccc, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smwkdaytud_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

********************************************************************************
// 2Eb: TUD weekday  and alc. freq. last month – multinomial regression- imputed
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smwkdaytud_r5Ccc, baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smwkdaytud_r5Ccc i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)

********************************************************************************
// 2Fa: TUD and binge drinking – logistic regression- imputed – by sex
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy, subpop (if sex_rBcc==0): logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp, or baselevels // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp, or baselevels // females


// Adjusted weighted model [1-<30 mins SM use ref cat]
*note use of peeralc_r4Ccc does not facilitate convergence for male model so categorised into peeralc_r3Ccc. I used peeralc_r3Ccc in other TUD imputed analysis and compared findings with peeralc_r4Ccc and no differences in estimates so ok to continue to only use peeralc_r3Ccc in this sex stratified model only.

mi xeq: tab peeralc_r4Ccc
mi passive: gen peeralc_r3Ccc =1 if peeralc_r4Ccc==1
mi passive: replace peeralc_r3Ccc =2 if peeralc_r4Ccc==2
mi passive: replace peeralc_r3Ccc=3 if peeralc_r4Ccc==3 |peeralc_r4Ccc==4 
label define peeralc_r3Ccc 1"1_none of them" 2"2_some of them" 3"3_most or all of them"
label values peeralc_r3Ccc peeralc_r3Ccc
label variable peeralc_r3Ccc "M5: CM friends drinking-3C-cc"
notes peeralc_r3Cc: peeralc_r4Ccc categorised into 3 category variable for one analysis (TUD avg SM use-ever binge drinking-imputed- male stratified model)
mi xeq: tab peeralc_r4Ccc peeralc_r3Ccc


mi est,  or: svy, subpop (if sex_rBcc==0):  logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r3Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

mi est, or: svy, subpop (if sex_rBcc==1):  logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel


********************************************************************************
// 2Fb: TUD and alc. freq. last month – multinomial regression- imputed – by sex
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy, subpop (if sex_rBcc==0): mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp, baselevels baseoutcome(1) // males 
mi est, rrr: svy, subpop (if sex_rBcc==1): mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp, baselevels baseoutcome(1) //females

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy, subpop (if sex_rBcc==0):  mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)
mi est, rrr: svy, subpop (if sex_rBcc==1):  mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)


********************************************************************************
//  2Ca: TUD and binge drinking – logistic regression- imputed – additional additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
********************************************************************************


// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.base_everbingeBcc i.base_alcfreqlastyr_4Ccc, or baselevel


*******************************************************************************
// 2Cb: TUD and alc. freq. last month – multinomial regression- imputed – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
********************************************************************************


// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp, baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.base_everbingeBcc i.base_alcfreqlastyr_4Ccc, baselevel baseoutcome(1)


********************************************************************************
// 2Da: TUD and binge drinking – logistic regression- imputed  – additional adjustment for previous SM use (age 11)
********************************************************************************


// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp, or baselevels


// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.prvsm_r4Cimp, or baselevel


********************************************************************************
// 2Db: TUD and alc. freq. last month – multinomial regression- imputed  – additional adjustment for previous SM use (age 11)
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp, baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.avgsm_tud_5Cimp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.prvsm_r4Cimp, baselevel baseoutcome(1)


********************************************************************************



