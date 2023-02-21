********************************************************************************
*# Self-report imputed analysis: social media > alcohol freq and binge drinking
********************************************************************************

/* 
AK Purba [last updated: 21.02.2023]
Do file: data03a_SCQ_imp_1A_1C_1D_1F_1G_vs1.do
Dataset: data01_master_vs3_SCQ_imp_4_1.dta

Syntax:
1Aa: SCQ and binge drinking – logistic regression- imputed
1Ab: SCQ and alc. freq. last month – multinomial regression- imputed
1Fa: SCQ and binge drinking – logistic regression- imputed – ref cat no sm use
1Fb: SCQ and alc. freq. last month – multinomial regression- imputed – ref cat no sm use
1Ga: SCQ and binge drinking – logistic regression- imputed – by sex
1Gb: SCQ and alc. freq. last month – multinomial regression- imputed – by sex
1Ca: SCQ and binge drinking – logistic regression- imputed – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
1Cb: SCQ and alc. freq. last month – multinomial regression- imputed  – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
1Da: SCQ and binge drinking – logistic regression- imputed – additional adjustment for previous SM use (age 11)
1Db: SCQ and alc. freq. last month – multinomial regression- imputed  – additional adjustment for previous SM use (age 11) 

 */

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "ALC\DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear
set seed 9260589

* Should say  (data unchanged since 18jan2023 13:47)
datasignature confirm

mi convert flong
mi set flong

********************************************************************************
*# CREATE 4-CAT FREQ ALCOHOL USE IN PAST MONTH OUTCOME VARIABLE
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
*# SET WEIGHT
********************************************************************************

/// survey weight [C] majority of weights <1 thus sum of weights will be less than count of participants
mi svyset  [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************
*# PREVALENCES
********************************************************************************

// Unweighted (to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
*mi convert flong
*mi set flong

* whole sample
tab everbingedrink_rBcc_imp smscq_r5C_imp if _mi_m >0
tab alcfreqlastmnth_r4Ccc_imp smscq_r5C_imp if _mi_m >0

* by sex
tab everbingedrink_rBcc_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==0  // male 
tab alcfreqlastmnth_r4Ccc_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==0  // male   
tab everbingedrink_rBcc_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==1 // female
tab alcfreqlastmnth_r4Ccc_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==1 // female

// Weighted 
* whole sample
mi estimate: svy: proportion everbingedrink_rBcc_imp
mi estimate: svy: proportion everbingedrink_rBcc_imp, over (smscq_r5C_imp)
mi estimate: svy: proportion alcfreqlastmnth_r4Ccc_imp
mi estimate: svy: proportion alcfreqlastmnth_r4Ccc_imp, over (smscq_r5C_imp)

* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion everbingedrink_rBcc_imp, over (smscq_r5C_imp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion everbingedrink_rBcc_imp, over (smscq_r5C_imp) // female 
mi estimate: svy, subpop(if sex_rBcc==0) : proportion alcfreqlastmnth_r4Ccc_imp, over (smscq_r5C_imp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion alcfreqlastmnth_r4Ccc_imp, over (smscq_r5C_imp) // female 

********************************************************************************
*# 1Aa: SCQ and binge drinking – logistic regression- imputed
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel


********************************************************************************
*# 1Ab: SCQ and alc. freq. last month – multinomial regression- imputed
********************************************************************************


// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp, baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)

********************************************************************************
*# 1Fa: SCQ and binge drinking – logistic regression- imputed – ref cat no sm use
********************************************************************************

// Unadjusted weighted model [no SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib1.smscq_r5C_imp, or baselevels

// Adjusted weighted model [no SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib1.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

********************************************************************************
*# 1Fb: SCQ and alc. freq. last month – multinomial regression- imputed – ref cat no sm use
********************************************************************************

// Unadjusted weighted model [no SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib1.smscq_r5C_imp,  baselevels baseoutcome(1)

// Adjusted weighted model [no SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib1.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc,  baselevel baseoutcome(1)

********************************************************************************
*# 1Ga: SCQ and binge drinking – logistic regression- imputed – by sex
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat] males=0 females=1
mi est, or: svy, subpop (if sex_rBcc==0): logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp, or baselevels
mi est, or: svy, subpop (if sex_rBcc==1): logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat] males=0 females=1
mi est, or: svy, subpop (if sex_rBcc==0): logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel
mi est, or: svy, subpop (if sex_rBcc==1): logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc , or baselevel

********************************************************************************
*# 1Gb: SCQ and alc. freq. last month – multinomial regression- imputed - by sex
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat] males=0 females=1
mi est, rrr: svy, subpop (if sex_rBcc==0): mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp, baselevels baseoutcome(1)
mi est, rrr: svy, subpop (if sex_rBcc==1): mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp,  baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy, subpop (if sex_rBcc==0): mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc,  baselevel baseoutcome(1)
mi est, rrr: svy, subpop (if sex_rBcc==1): mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc, baselevel baseoutcome(1)

********************************************************************************
*#  1Ca: SCQ and binge drinking – logistic regression- complete case – additional additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.base_everbingeBcc i.base_alcfreqlastyr_4Ccc , or baselevel

*******************************************************************************
*# 1Cb: SCQ and alc. freq. last month – multinomial regression- complete case  – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp, rrr baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D  ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.base_everbingeBcc i.base_alcfreqlastyr_4Ccc, rrr baselevel baseoutcome(1)

********************************************************************************
*# 1Da: SCQ and binge drinking – logistic regression- complete case – additional adjustment for previous SM use (age 11)
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp, or baselevels

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, or: svy: logit everbingedrink_rBcc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc  i.prvsm_r5Ccc, or baselevel 

********************************************************************************
*# 1Db: SCQ and alc. freq. last month – multinomial regression- complete case  – additional adjustment for previous SM use (age 11)
********************************************************************************

// Unadjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp, rrr baselevels baseoutcome(1)

// Adjusted weighted model [1-<30 mins SM use ref cat]
mi est, rrr: svy: mlogit alcfreqlastmnth_r4Ccc_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D  ib10.imd_COcc i.peeralc_r4Ccc i.paralcfreq_r5Ccc i.cmrelig_rBcc i.prvsm_r5Ccc, rrr baselevel baseoutcome(1)

********************************************************************************



