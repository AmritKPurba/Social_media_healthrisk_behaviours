

********************************************************************************
//SCQ imputed analysis: SAP SAP 1Aa, 1Ca, 1Da, 1Ea, 1Fa, 1Ga analyses
********************************************************************************

// data02a_SCQ_imp_1Aa_vs1.do
// Amrit Purba 18.01.2023
*Syntax for SAP 1Aa, 1Ca, 1Da, 1Ea, 1Fa, 1Ga analyses
	*1Aa: main analysis
	*1Ca: additional adjustment for cig use age 14 
	*1Da: additional adjustment for prev SM use age 11
	*1Ea: use of 4-category SCQ + 3-category outcome var
	*1Fa: change to SCQ 5-category ref cat 
	*1Ga: main analysis by sex
// Dataset used: data01_master_vs3_SCQ_imp_4_1.dta

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
tab smok_rB_imp smscq_r5C_imp if _mi_m >0
tab smscq_r4C_imp smok_r3Ccc  if _mi_m >0

* by sex
tab smok_rB_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==0 
//male
tab smok_rB_imp smscq_r5C_imp if _mi_m >0 & sex_rBcc==1 //female


** Weighted prevalences
* whole sample
mi estimate: svy: proportion smok_rB_imp
mi estimate: svy: proportion smok_rB_imp, over (smscq_r5C_imp)
mi estimate: svy: proportion smok_r3Ccc, over (smscq_r4C_imp)


* by sex
mi estimate: svy, subpop(if sex_rBcc==0) : proportion smok_rB_imp, over (smscq_r5C_imp) // male 
mi estimate: svy, subpop(if sex_rBcc==1) : proportion smok_rB_imp, over (smscq_r5C_imp) // female 

********************************************************************************

// RUN MODELS 

**Declare survey design 
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2)


** 1A- main analysis

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp, or baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel




** 1C -additional adjustment for cigarette use age 14 (smok6_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp,  baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.smok6_r5Ccc, baselevel




** 1D - additional adjustment for previous SM use age 11 (i.prvsm_r5Ccc)

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp, baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc i.prvsm_r5Ccc,  baselevel




** 1E - use of SCQ 4-category variable (B1-B3-smscq_r4C_imp) and Cigarette use (3-category variable- smok_r3Ccc) 

* Run the weighted model using the logit command (obtaining ORs)- 1 min to < 1hr SM use as ref cat- unadjusted 
mi est, rrr: svy: mlogit smok_r3Ccc ib2.smscq_r4C_imp,  baselevel


* Run the weighted model using the logit command (obtaining ORs)- 1 min to < 1hr SM use as ref cat- adjustment 
mi est, rrr: svy: mlogit smok_r3Ccc ib2.smscq_r4C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc,  baselevel





** 1F - change of ref cat to no sm use 

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- unadjusted 
mi est, or: svy: logit smok_rB_imp ib1.smscq_r5C_imp,  baselevel

* Run the weighted model using the logit command (obtaining ORs)- no SM use as ref cat- adjustment 
mi est, or: svy: logit smok_rB_imp ib1.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc,  baselevel





** 1G - main analysis by sex 

* Run weighted unadjusted model by sex: males=0 females=1
mi est, or: svy,  subpop (if sex_rBcc==0): logit smok_rB_imp ib2.smscq_r5C_imp,  baselevel // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit smok_rB_imp ib2.smscq_r5C_imp, or baselevel // females 

* Run weighted adjusted model by sex: males=0 females=1
mi est, or: svy, subpop (if sex_rBcc==0): logit smok_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel // males 
mi est, or: svy, subpop (if sex_rBcc==1): logit smok_rB_imp ib2.smscq_r5C_imp i.eth_rBcc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_COB_imp ib6.hiocc_CO6Ccc  i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.sibshh_5Ccc mag12_rcc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D_imp i.wales_D_imp i.scot_D_imp ib10.imd_COcc, or baselevel // females





********************************************************************************



