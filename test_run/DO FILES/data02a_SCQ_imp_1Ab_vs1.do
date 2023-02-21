

********************************************************************************
//SCQ imputed analysis: SAP 1Ab, 1Cb, 1Db, 1Eb, 1Fb, 1Gb analyses
********************************************************************************

// data02a_SCQ_imp_1Ab_vs1.do
// Amrit Purba 17.1.23
*Syntax for SAP 1Ab, 1Cb, 1Db, 1Eb, 1Fb, 1Gb analyses
	*1Ab: main analysis
	*1Cb: additional adjustment for ecig use age 14 
	*1Db: additional adjustment for prev SM use age 11
	*1Eb: use of 4-category SCQ + 3-category outcome var
	*1Fb: change to SCQ 5-category ref cat 
	*1Gb: main analysis by sex
// Dataset used: data01_master_vs3_SCQ_imp_4_1.dta

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "test_run/DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear


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
tab ecig_rB_imp smscq_r5C_imp if _mi_m >0
tab smscq_r4C_imp ecig_r3Ccc  if _mi_m >0

* by sex
tab ecig_rB_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==0 
//male
tab ecig_rB_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==1 //female


** Weighted prevalences
* whole sample
mi estimate: svy: proportion ecig_rB_imp
mi estimate: svy: proportion ecig_rB_imp, over (smscq_r5C_imp)
mi estimate: svy: proportion ecig_r3Ccc, over (smscq_r4C_imp)


* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion ecig_rB_imp, over (smscq_r5C_imp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion ecig_rB_imp, over (smscq_r5C_imp) // female 

********************************************************************************

// RUN MODELS 

**Declare survey design 
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2)


** 1A- main analysis

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp, or baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel




** 1C -additional adjustment for ecigarette use age 14 (ecig6_r4Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp, or baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.ecig6_r4Ccc, or baselevel




** 1D - additional adjustment for previous SM use age 11 (i.prvsm_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp, or baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit ecig_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.prvsm_r5Ccc, or baselevel




** 1E - use of SCQ 4-category variable (B1-B3-smscq_r4C_imp) and e-cigarette use (3-category variable- ecig_r3Ccc) 

* Run the weighted model using the logit command (obtaining ORs)- 1 min to < 1hr SM use as ref cat- unadjusted 
mi est, rrr: svy: mlogit ecig_r3Ccc ib2.smscq_r4C_imp, rrr baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1 min to < 1hr SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit ecig_r3Ccc ib2.smscq_r4C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, rrr baselevel





** 1F - change of ref cat to no sm use 

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- unadjusted 
mi est, or: svy: logit ecig_rB_imp ib1.smscq_r5C_imp, baselevel

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- adjustment 
mi est, or: svy: logit ecig_rB_imp ib1.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc,  baselevel





** 1G - main analysis by sex 

* Run weighted unadjusted model by sex: males=0 females=1
mi est, or: svy,  subpop (if sex_rBcc==0): logit ecig_rB_imp ib2.smscq_r5C_imp, or baselevel // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit ecig_rB_imp ib2.smscq_r5C_imp, or baselevel // females 

* Run weighted adjusted model by sex: males=0 females=1
mi est, or: svy, subpop (if sex_rBcc==0): logit ecig_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit ecig_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel // females





********************************************************************************



