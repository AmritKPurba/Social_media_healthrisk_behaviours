
********************************************************************************
// Descriptives for write up 
********************************************************************************

// data01_descriptives_vs2: Syntax for descriptives to be reported in manuscript including 1) missing values for all variables 2) unweighted no. of observations for all vars 3) cont vars (weighted and unweighted- mean, SD, median, IRQ, min and max) 4) categorical vars (weighted and unweighted- n and % in each category) for imputed and complete case sample. Replaces vs 2.

*Note: for descriptives we use weights used in main RO1 analyses 
 
*#Datasets used:
*Master dataset- data01_master_vs3
*SCQ complete case (cig ecig)- data01_SCQ_cc.vs1.dta
*TUD complete case (cig ecig)- data01_TUD_cc.vs3.dta
*SCQ complete case (alc)- data01_SCQ_cc_alc.dta
*TUD complete case (alc)- data01_TUD_cc_alc.dta
*SCQ imputed (cig ecig alc)- data01_master_vs3_SCQ_imp_4_1.dta
*TUD imputed (cig ecig alc)- data01_master_vs3_TUD_imp_3_1.dta

*Do file: data01_descriptives_vs3.do

********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj



********************************************************************************
********************************************************************************
////CIG/ECIG
********************************************************************************
********************************************************************************

********************************************************************************
*# SCQ COMPLETE CASE CIG/ECIG (n= 6234)
********************************************************************************

// Dataset: data01_SCQ_cc_vs1.dta

use "test_run/DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 91703423

//  (data unchanged since 18jan2023 14:22)
datasignature confirm


* All confounders included in RO1 are included in RO2 excluding SEP related variables eng_D, wales_D, scot_D, ni_D, hinc_r5Ccc, famstr_r3Ccc, imd_COcc, hied_CO7Ccc, hiocc_CO6Ccc & outcome cigecig_COcc. 
* RO2 includes hied_COBcc as the effect modifier which is not included in RO1

********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 SCQ complete case
*svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************


// Number of CM SCQ complete case sample 

* 6234 total and distinct records 
unique MCSID
* 1st CM= 6211/ 2nd CM= 13 / Total CM= 6234
tab CNUM, mi


// Continuous variables (unweighted: n. observations, mean, SD, median, inter-quartile range, minimum and maximum / weighted: mean and SD) 

* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* Weighted- single country analyses RO1 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}




// Categorical variables (number and percentage of total non-missing data falling into each category)

* Unweighted 
local cat_cc_vars "smscq_r5Ccc smok_rBcc ecig_rBcc cigecig_COcc eng_D wales_D scot_D ni_D eth_r6Ccc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc mag12_r4Ccc parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc smok6_r6Ccc ecig6_r4Ccc prvsm_r5Ccc sex6_rBcc sex7_rBcc smok_r3Ccc ecig_r3Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}


* Weighted- single country analyses RO1 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "smscq_r5Ccc smok_rBcc ecig_rBcc cigecig_COcc eng_D wales_D scot_D ni_D eth_r6Ccc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc mag12_r4Ccc parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc smok6_r6Ccc ecig6_r4Ccc prvsm_r5Ccc sex6_rBcc sex7_rBcc smok_r3Ccc ecig_r3Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}




********************************************************************************
*# TUD COMPLETE CASE CIG/ECIG (n=2109) 
********************************************************************************

// Dataset: data01_TUD_cc_vs3.dta

use "test_run/DATASETS\data01_TUD_cc_vs3.dta", clear

set seed 91703467

// Should say (data unchanged since 18jan2023 14:42)

datasignature confirm

* All confounders included in RO1 are included in RO2 excluding SEP related variables eng_D, wales_D, scot_D, ni_D, hinc_r5Ccc, famstr_r3Ccc, imd_COcc, hied_CO7Ccc, hiocc_CO6Ccc & outcome cigecig_COcc. 
* RO2 includes hied_COBcc as the effect modifier which is not included in RO1
* TUD complete case exposure variable (RO1 & RO2): avgsm_tud_r5Ccc
* TUD complete case outcome variables (RO1): smok_rBcc, ecig_rBcc, cigecig_COcc
* TUD complete case outcome variables (RO2): smok_rBcc, ecig_rBcc

********************************************************************************

// Relevant weights

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
*svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Number of CM SCQ complete case sample 

* 2109 total and distinct records 
unique MCSID
* 1st CM= 2102/ 2nd CM= 7 / Total CM= 2109
tab CNUM, mi


// Continuous variables (unweighted: n. observations, mean, SD, median, inter-quartile range, minimum and maximum / weighted: mean and SD) 

* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}



// Categorical variables (number and percentage of total non-missing data falling into each category)

* Unweighted 
local cat_cc_vars "avgsm_tud_r5Ccc smwkdaytud_r5Ccc smok_r3Ccc ecig_r3Ccc cigecig_COcc eng_D wales_D scot_D ni_D eth_r6Ccc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc mag12_r4Ccc parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc smok6_r6Ccc ecig6_r4Ccc prvsm_r5Ccc sex6_rBcc sex7_rBcc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "avgsm_tud_r5Ccc  smwkdaytud_r5Ccc smok_r3Ccc ecig_r3Ccc cigecig_COcc eng_D wales_D scot_D ni_D eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc mag12_r4Ccc parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc smok6_r6Ccc ecig6_r4Ccc prvsm_r5Ccc sex6_rBcc sex7_rBcc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}




********************************************************************************
*# SCQ IMPUTED CIG/ECIG (n=8987)- 
********************************************************************************

// Dataset: data01_master_vs3_SCQ_imp_4_1.dta

use "test_run/DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear

set seed 91703423

// Should say   (data unchanged since 18jan2023 13:47)
datasignature confirm


* All confounders included in RO1 are included in RO2 excluding SEP related variables eng_D_imp, wales_D_imp, scot_D_imp, ni_D_imp, hinc_r5Ccc, famstr_r3Ccc, imd_COcc, hied_COB_imp, hiocc_CO6Ccc & outcome cigecig_CO_imp (which are only included in RO1). 
* RO2 includes hied_COB_imp as the effect modifier which is not included in RO1

********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 SCQ imputed
mi svyset  [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************

// Number of CM SCQ imputed

* 8987 total and distinct records 
unique MCSID
* 1st CM= 8934/ 2nd CM= 53 / Total CM= 8987
tab CNUM, mi

// Convert to flong (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong


// Continuous variables (unweighted: mean and SD/ weighted: mean and SE) 
* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc

* Weighted- single country analyses RO1 - SDs cannot be computed for multiply imputed data when using svy command- relationship between SD and SE only stands for simple random samples: https://stats.stackexchange.com/questions/120097/is-it-possible-to-manually-calculate-standard-deviation-for-a-multiply-imputed-s

mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
mi estimate: svy: mean mag12_rcc
mi estimate: svy: mean avg_inpact_COcc
mi estimate: svy: mean cogab_rcc
mi estimate: svy: mean sdqtotal_rnimpcc
mi estimate: svy: mean risk_rcc






// Categorical variables (number and percentage of total non-missing data falling into each category, will need to divide all Ns by 20)

* Unweighted 
tab eth_rBcc if _mi_m >0
tab famstr_r3Ccc if _mi_m >0
tab cmage6_3Ccc if _mi_m >0
tab hhinc_r5Ccc  if _mi_m >0
tab sibshh_5Ccc  if _mi_m >0
tab anti_COccim  if _mi_m >0
tab parcursmk_CO2Ccc  if _mi_m >0
tab parstyCOcc  if _mi_m >0
tab prvalc_rBcc  if _mi_m >0
tab prvcig_rBcc  if _mi_m >0
tab urb_COcc  if _mi_m >0
tab hiocc_CO6Ccc  if _mi_m >0
tab imd_COcc  if _mi_m >0
tab smscq_r5C_imp  if _mi_m >0
tab sex_rBcc if _mi_m >0
tab smok_r3Ccc if _mi_m >0
tab ecig_r3Ccc if _mi_m >0
tab cigecig_CO_imp if _mi_m >0
tab hied_COB_imp if _mi_m >0



* Weighted- single country analyses RO1 (will need to divide all Ns by 20 [number of imputations]) 
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
local cat_imp_vars " eth_rBcc  famstr_r3Ccc cmage6_3Ccc  hhinc_r5Ccc sibshh_5Ccc  anti_COccim parcursmk_CO2Ccc parstyCOcc prvalc_rBcc prvcig_rBcc   urb_COcc   hiocc_CO6Ccc imd_COcc  smscq_r5C_imp sex_rBcc smok_rB_imp ecig_rB_imp cigecig_CO_imp hied_COB_imp"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}


********************************************************************************
*# TUD IMPUTED CIG/ECIG (n=2772) 
********************************************************************************

// Dataset: data01_master_vs3_TUD_imp_3_1.dta


use "test_run/DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear

set seed 91705423

// Should say  (data unchanged since 19jan2023 12:47)
datasignature confirm


* All confounders included in RO1 are included in RO2 excluding SEP related variables eng_D_imp, wales_D_imp, scot_D_imp, ni_D_imp, hinc_r5Ccc, famstr_r3Ccc, imd_COcc, hied_COB_imp, hiocc_CO6Ccc & outcome cigecig_CO_imp (which are only included in RO1). 
* RO2 includes hied_COB_imp as the effect modifier which is not included in RO1


********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 TUD imputed

mi svyset [pweight=TUD_WT_RO1_imp], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 


********************************************************************************

* 2520 distinct records 
distinct MCSID


// Convert to flong (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong



// Continuous variables (unweighted: mean and SD/ weighted: mean and SE) 
* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc


* Weighted- single country analyses RO1 - SDs cannot be computed for multiply imputed data when using svy command- relationship between SD and SE only stands for simple random samples: https://stats.stackexchange.com/questions/120097/is-it-possible-to-manually-calculate-standard-deviation-for-a-multiply-imputed-s

mi estimate: svy: mean mag12_rcc
mi estimate: svy: mean avg_inpact_COcc
mi estimate: svy: mean cogab_rcc
mi estimate: svy: mean sdqtotal_rnimpcc
mi estimate: svy: mean risk_rcc






// Categorical variables (number and percentage of total non-missing data falling into each category, will need to divide all Ns by 20)

* Unweighted 
tab eth_rBcc if _mi_m >0
tab famstr_r3Ccc if _mi_m >0
tab cmage6_3Ccc if _mi_m >0
tab hhinc_r5Ccc  if _mi_m >0
tab sibshh_4Cimp  if _mi_m >0
tab anti_COccim  if _mi_m >0
tab parcursmk_CO2Ccc  if _mi_m >0
tab parstyCOcc  if _mi_m >0
tab prvalc_rBcc  if _mi_m >0
tab prvcig_rBcc  if _mi_m >0
tab urb_COcc  if _mi_m >0
tab hiocc_CO6Ccc  if _mi_m >0
tab imd_COcc  if _mi_m >0
tab smwkdaytud_r5Ccc  if _mi_m >0
tab avgsm_tud_5Cimp  if _mi_m >0
tab sex_rBcc if _mi_m >0
tab smok_r3Ccc if _mi_m >0
tab ecig_r3Ccc if _mi_m >0
tab cigecig_CO_imp if _mi_m >0
tab hied_COB_imp if _mi_m >0


* Weighted- single country analyses RO1 
local cat_imp_vars " eth_rBcc  famstr_r3Ccc cmage6_3Ccc  hhinc_r5Ccc sibshh_4Cimp  anti_COccim parcursmk_CO2Ccc parstyCOcc prvalc_rBcc prvcig_rBcc   urb_COcc   hiocc_CO6Ccc imd_COcc   avgsm_tud_5Cimp sex_rBcc smok_rB_imp ecig_rB_imp cigecig_CO_imp hied_COB_imp smwkdaytud_r5Ccc"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}




********************************************************************************
********************************************************************************
////ALCOHOL
********************************************************************************
********************************************************************************

********************************************************************************
*# SCQ COMPLETE CASE ALCOHOL (n= 5317)
********************************************************************************

// Dataset: data01_SCQ_cc_alc.dta

use "test_run/DATASETS\data01_SCQ_cc_alc.dta", clear



* Should say   (data unchanged since 25jan2023 09:43)
datasignature confirm

set seed 91705423


* All confounders included in RO1 are included in RO2 excluding SEP related variables 

********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 SCQ complete case
*svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Number of CM SCQ complete case sample 

* 5317 total and distinct records 
unique MCSID


// Continuous variables (unweighted: n. observations, mean, SD, median, inter-quartile range, minimum and maximum / weighted: mean and SD) 

* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* Weighted- single country analyses RO1 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}







// Categorical variables (number and percentage of total non-missing data falling into each category)

* Unweighted 
local cat_cc_vars "alcfreqlastmnth_r4Ccc everbingedrink_rBcc smscq_r5Ccc      eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc "
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}

* Weighted- single country analyses RO1 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "alcfreqlastmnth_r4Ccc everbingedrink_rBcc smscq_r5Ccc      eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}



********************************************************************************
*# TUD COMPLETE CASE ALC (n=1826) 
********************************************************************************

// Dataset: data01_TUD_cc_alc.dta


 use "C:\___Amrit_local\MyOneDrive\OneDrive - University of Glasgow\PhD_MRC_SPSHU\Year_2\3_mcs_data\3. mcs_my_data_files\my_data_files\1_RO2_directory\2_dataset_var_construction_MI\2_derived_datasets\data01_TUD_cc_alc.dta", clear


set seed 9260678

* Should say (data unchanged since 25jan2023 09:42)
datasignature confirm

* All confounders included in RO1 are included in RO2 excluding SEP related variables 

********************************************************************************

// Relevant weights

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
*svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Number of CM TUD complete case sample 

* 1826 total and distinct records 
unique MCSID





// Continuous variables (unweighted: n. observations, mean, SD, median, inter-quartile range, minimum and maximum / weighted: mean and SD) 


* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}






// Categorical variables (number and percentage of total non-missing data falling into each category)

* Unweighted 
local cat_cc_vars "avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc everbingedrink_rBcc   eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc smwkdaytud_r5Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc everbingedrink_rBcc  eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc  smwkdaytud_r5Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}

********************************************************************************
*# SCQ IMPUTED ALC (n=8987)
********************************************************************************

// Dataset: data01_master_vs3_SCQ_imp_4_1.dta

use "test_run/DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear

set seed 91703423

// Should say  (data unchanged since 18jan2023 13:47)
datasignature confirm


* All confounders included in RO1 are included in RO2 excluding SEP related variables 

********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 SCQ imputed
mi svyset  [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************

// Number of CM SCQ imputed

* 8987 total and distinct records 
unique MCSID
* 1st CM= 8934/ 2nd CM= 53 / Total CM= 8987
tab CNUM, mi

// Convert to flong (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong


// Continuous variables (unweighted: mean and SD/ weighted: mean and SE) 

* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc

* Weighted- single country analyses RO1 - SDs cannot be computed for multiply imputed data when using svy command- relationship between SD and SE only stands for simple random samples: https://stats.stackexchange.com/questions/120097/is-it-possible-to-manually-calculate-standard-deviation-for-a-multiply-imputed-s

mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
mi estimate: svy: mean mag12_rcc
mi estimate: svy: mean avg_inpact_COcc
mi estimate: svy: mean cogab_rcc
mi estimate: svy: mean sdqtotal_rnimpcc
mi estimate: svy: mean risk_rcc



// Categorical variables (number and percentage of total non-missing data falling into each category, will need to divide all Ns by 20)

* Create alc freq post imp var
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


* Unweighted 
tab smscq_r5C_imp if _mi_m >0
tab eth_rBcc if _mi_m >0
tab famstr_r3Ccc if _mi_m >0
tab hhinc_r5Ccc if _mi_m >0
tab hied_COB_imp if _mi_m >0
tab hiocc_CO6Ccc if _mi_m >0
tab sex_rBcc if _mi_m >0
tab parcursmk_CO2Ccc if _mi_m >0
tab parstyCOcc  if _mi_m >0
tab prvcig_rBcc  if _mi_m >0
tab anti_COccim  if _mi_m >0
tab prvalc_rBcc  if _mi_m >0
tab urb_COcc  if _mi_m >0
tab cmage6_3Ccc  if _mi_m >0
tab sibshh_5Ccc  if _mi_m >0
tab imd_COcc  if _mi_m >0
tab peeralc_r4Ccc  if _mi_m >0
tab paralcfreq_r5Ccc  if _mi_m >0
tab cmrelig_rBcc  if _mi_m >0
tab alcfreqlastmnth_r4Ccc_imp if _mi_m >0
tab everbingedrink_rBcc_imp if _mi_m >0

* Weighted- single country analyses RO1 (will need to divide all Ns by 20 [number of imputations]) 
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
local cat_imp_vars " smscq_r5C_imp eth_rBcc famstr_r3Ccc hhinc_r5Ccc hied_COB_imp hiocc_CO6Ccc sex_rBcc parcursmk_CO2Ccc parstyCOcc prvcig_rBcc anti_COccim prvalc_rBcc urb_COcc cmage6_3Ccc sibshh_5Ccc imd_COcc peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc alcfreqlastmnth_r4Ccc_imp everbingedrink_rBcc_imp"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}

********************************************************************************
*# TUD IMPUTED ALCOHOL (n=2520) 
********************************************************************************

// Dataset: data01_master_vs3_TUD_imp_3_1.dta


use "test_run/DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear


set seed 91705423

// Should say  (data unchanged since 19jan2023 12:47)


datasignature confirm


* All confounders included in RO1 are included in RO2 excluding SEP related variables 


********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 TUD imputed

mi svyset [pweight=TUD_WT_RO1_imp], strata(PTTYPE2) psu(SPTN00ds) fpc(NH2) 

********************************************************************************


* 2520 distinct records 
distinct MCSID


// Convert to flong (https://www.statalist.org/forums/forum/general-stata-discussion/general/1584978-_mi_m-_mi_id-not-generated) required for calculations below
mi convert flong
mi set flong


// Continuous variables (unweighted: mean and SD/ weighted: mean and SE) 

* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc


* Weighted- single country analyses RO1 - SDs cannot be computed for multiply imputed data when using svy command- relationship between SD and SE only stands for simple random samples: https://stats.stackexchange.com/questions/120097/is-it-possible-to-manually-calculate-standard-deviation-for-a-multiply-imputed-s

mi estimate: svy: mean mag12_rcc
mi estimate: svy: mean avg_inpact_COcc
mi estimate: svy: mean cogab_rcc
mi estimate: svy: mean sdqtotal_rnimpcc
mi estimate: svy: mean risk_rcc




* Create alc freq post imp var
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


// Categorical variables (number and percentage of total non-missing data falling into each category, will need to divide all Ns by 20)

* Unweighted 
tab avgsm_tud_5Cimp if _mi_m >0
tab smwkdaytud_r5Ccc if _mi_m >0
tab eth_rBcc if _mi_m >0
tab famstr_r3Ccc if _mi_m >0
tab hhinc_r5Ccc if _mi_m >0
tab hied_COB_imp if _mi_m >0
tab hiocc_CO6Ccc if _mi_m >0
tab sex_rBcc if _mi_m >0
tab parcursmk_CO2Ccc if _mi_m >0
tab parstyCOcc  if _mi_m >0
tab prvcig_rBcc  if _mi_m >0
tab anti_COccim  if _mi_m >0
tab prvalc_rBcc  if _mi_m >0
tab urb_COcc  if _mi_m >0
tab cmage6_3Ccc  if _mi_m >0
tab sibshh_4Cimp  if _mi_m >0
tab imd_COcc  if _mi_m >0
tab peeralc_r4Ccc  if _mi_m >0
tab paralcfreq_r5Ccc  if _mi_m >0
tab cmrelig_rBcc  if _mi_m >0
tab alcfreqlastmnth_r4Ccc_imp if _mi_m >0
tab everbingedrink_rBcc_imp if _mi_m >0


* Weighted- single country analyses RO1 
local cat_imp_vars " avgsm_tud_5Cimp smwkdaytud_r5Ccc eth_rBcc famstr_r3Ccc hhinc_r5Ccc hied_COB_imp hiocc_CO6Ccc sex_rBcc parcursmk_CO2Ccc parstyCOcc prvcig_rBcc anti_COccim prvalc_rBcc urb_COcc cmage6_3Ccc sibshh_4Cimp imd_COcc peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc alcfreqlastmnth_r4Ccc_imp everbingedrink_rBcc_imp"
display "`cat_imp_vars"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}


********************************************************************************


********************************************************************************













