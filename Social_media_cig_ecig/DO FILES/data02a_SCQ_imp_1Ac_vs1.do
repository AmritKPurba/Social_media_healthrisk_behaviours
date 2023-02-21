********************************************************************************
//Self-report imputed analysis: social media > dual-use SAP 1Ac, 1Cc, 1Dc, 1Fc, 1Gc 
********************************************************************************

/*
AK Purba [last updated 21.02.2023]
Do file: data02a_SCQ_imp_1Ac_vs1.do 
Dataset: data01_master_vs3_SCQ_imp_4_1.dta 

Syntax:
Social media and dual-use - multinomial logistic regression
Social media and dual-use - multinomial logistic regression additional adjustment for cigarette & e-cigarette use (age 14)
Social media and dual-use - multinomial logistic regression additional adjustment for previous social media (age 11)
Social media and dual-use - change of ref cat to 'no social media use'    
Social media and dual-use - by sex

*/

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "CIG_ECIG\DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear
set seed 9260589

* Should say (data unchanged since 18jan2023 13:47)
datasignature confirm

********************************************************************************
*# SET WEIGHT
********************************************************************************

**survey weight [C] majority of weights <1 thus sum of weights will be less than count of participants
mi svyset  [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************

// PREVALENCES


** Unweighted N (to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong

* whole sample
tab cigecig_CO_imp smscq_r5C_imp if _mi_m >0

* by sex
tab cigecig_CO_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==0 
//male
tab cigecig_CO_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==1 //female


** Weighted prevalences
* whole sample
mi estimate: svy: proportion cigecig_CO_imp
mi estimate: svy: proportion cigecig_CO_imp, over (smscq_r5C_imp)


* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion cigecig_CO_imp, over (smscq_r5C_imp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion cigecig_CO_imp, over (smscq_r5C_imp) // female 


********************************************************************************

// Run models


**Declare survey design
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2)


** 1A- main analysis

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, rrr: svy:  mlogit cigecig_CO_imp ib2.smscq_r5C_imp, rrr baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit cigecig_CO_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, rrr baselevel




** 1C -additional adjustment for cigarette & ecigarette use age 14 (ecig6_r4Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, rrr: svy:  mlogit cigecig_CO_imp ib2.smscq_r5C_imp, rrr baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit cigecig_CO_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc  i.ecig6_r4Ccc i.smok6_r5Ccc, rrr baselevel




** 1D - additional adjustment for previous SM use age 11 (i.prvsm_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, rrr: svy:  mlogit cigecig_CO_imp ib2.smscq_r5C_imp, rrr baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit cigecig_CO_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.prvsm_r5Ccc, rrr baselevel





** 1F - change of ref cat to no sm use 

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- unadjusted 
mi est, rrr: svy:  mlogit cigecig_CO_imp ib1.smscq_r5C_imp, rrr baselevel

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit cigecig_CO_imp ib1.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, rrr baselevel





** 1G - main analysis by sex

* Run weighted unadjusted model by sex: males=0 females=1
mi est, rrr: svy, subpop (if sex_rBcc==0): mlogit cigecig_CO_imp ib2.smscq_r5C_imp, rrr baselevel // males 
mi est, rrr: svy, subpop (if sex_rBcc==1): mlogit cigecig_CO_imp ib2.smscq_r5C_imp, rrr baselevel // females

* Run weighted adjusted model by sex: males=0 females=1
mi est, rrr: svy, subpop (if sex_rBcc==0): mlogit cigecig_CO_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, rrr baselevel // males 

mi est, rrr: svy, subpop (if sex_rBcc==1): mlogit cigecig_CO_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, rrr baselevel // females



********************************************************************************



