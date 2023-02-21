

********************************************************************************
//TUD imputed analysis: SAP SAP 2Aa, 2Ca, 2Da, 2Ea, 2Fa analyses
********************************************************************************

// data02b_TUD_imp_2Aa_vs1.do
// Amrit Purba 19.01.2023
*Syntax for SAP 2Aa, 2Ca, 2Da, 2Ea, 2Fa, analyses
	*2Aa: main analysis
	*2Ca: additional adjustment for cig use age 14 
	*2Da: additional adjustment for prev SM use age 11
	*2Ea: use of TUD weekday var 
	*2Fa: main analysis by sex 
	
// Dataset used: data01_master_vs3_TUD_imp_3_1.dta

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "test_run/DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear

set seed 9260589

* Should say (data unchanged since 19jan2023 12:47)
datasignature confirm


********************************************************************************
*# SET WEIGHT
********************************************************************************

**survey weight 
mi svyset [pweight=TUD_WT_RO1_imp], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************

// PREVALENCES

** Unweighted N (to divide by number of imputations-20)
* Convert to flong to generate _mi_m  (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong

* whole sample
tab smok_rB_imp avgsm_tud_5Cimp if _mi_m >0
tab smok_rB_imp smwkdaytud_r5Ccc if _mi_m >0


* by sex
tab smok_rB_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==0 //male
tab smok_rB_imp avgsm_tud_5Cimp if _mi_m >0 & sex_rBcc==1 //female


** Weighted prevalences
* whole sample
mi estimate: svy: proportion smok_rB_imp
mi estimate: svy: proportion smok_rB_imp, over (avgsm_tud_5Cimp)
mi estimate: svy: proportion smok_rB_imp, over (smwkdaytud_r5Ccc)


* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion smok_rB_imp, over (avgsm_tud_5Cimp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion smok_rB_imp, over (avgsm_tud_5Cimp) // female 

********************************************************************************

// RUN MODELS 

** 2A- main analysis

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp, or baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc,  baselevel 


** 2C -additional adjustment for cigarette use age 14 (smok6_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp, or baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc i.smok6_r5Ccc,  baselevel 




** 2D - additional adjustment for previous SM use age 11 (i.prvsm_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp, or baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.avgsm_tud_5Cimp i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc i.prvsm_r4Cimp,  baselevel 





** 2E - use of TUD SM weekday exposure  

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.smwkdaytud_r5Ccc,  baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.smwkdaytud_r5Ccc i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc,  baselevel 


** 2F - main analysis by sex 

* Run weighted unadjusted model by sex: males=0 females=1
mi est, or: svy,  subpop (if sex_rBcc==0): logit smok_rB_imp ib2.avgsm_tud_5Cimp,  baselevel // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit smok_rB_imp ib2.avgsm_tud_5Cimp,  baselevel // females 

* Run weighted adjusted model by sex: males=0 females=1
mi est, or: svy, subpop (if sex_rBcc==0): logit smok_rB_imp ib2.avgsm_tud_5Cimp i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc,  baselevel  // males 

mi est, or: svy, subpop (if sex_rBcc==1): logit smok_rB_imp ib2.avgsm_tud_5Cimp i.eth_rBcc  i.famstr_r3Ccc  ib5.hhinc_r5Ccc i.hied_COB_imp  ib6.hiocc_CO6Ccc i.sex_rBcc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc  i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.sibshh_4Cimp mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp  ib10.imd_COcc, or baselevel  // females



********************************************************************************



