
********************************************************************************
// DESCRIPTIVES
********************************************************************************

/*Do file: data01_descriptives_vs3.do: syntax for descriptives to be reported in manuscript 

SELF-REPORT COMPLETE CASE: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n= 6234)
TIME USE DIARY COMPLETE CASE: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=2109) 
SELF-REPORT IMPUTED: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=8987)
TIME USE DIARY IMPUTED: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=2772) 
SELF-REPORT COMPLETE CASE: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=5317)
TIME USE DIARY COMPLETE CASE: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=1826) 
SELF-REPORT IMPUTED: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=8987)
TIME USE DIARY IMPUTED: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=2520) 


For descriptives single country weights used*/

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


********************************************************************************
*# SELF-REPORT COMPLETE CASE: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n= 6234)
********************************************************************************

// Dataset: data01_SCQ_cc_vs1.dta

use "CIG_ECIG\DATASETS\data01_SCQ_cc_vs1.dta", clear

set seed 91703423

//  (data unchanged since 18jan2023 14:22)
datasignature confirm

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
*# TIME USE DIARY COMPLETE CASE: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=2109) 
********************************************************************************

// Dataset: data01_TUD_cc_vs3.dta

use "CIG_ECIG\DATASETS\data01_TUD_cc_vs3.dta", clear
set seed 91703467

// Should say (data unchanged since 18jan2023 14:42)

datasignature confirm

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


// Continuous variables 
* Unweighted 
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc"
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



// Categorical variables 
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
*# SELF-REPORT IMPUTED: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=8987)
********************************************************************************

// Dataset: data01_master_vs3_SCQ_imp_4_1.dta

use "CIG_ECIG\DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear
set seed 91703423

// Should say (data unchanged since 18jan2023 13:47)
datasignature confirm


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

// Continuous variables 
* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc

* Weighted (refs for obtaining SD: https://stats.stackexchange.com/questions/120097/is-it-possible-to-manually-calculate-standard-deviation-for-a-multiply-imputed-s to identify SD 
https://www.stata.com/support/faqs/statistics/weights-and-summary-statistics)

mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
mi estimate: svy: mean mag12_rcc
mi xeq: generate mag12_rcc_sq = mag12_rcc * mag12_rcc
mi estimate (sd : sqrt(_b[mag12_rcc_sq] - _b[mag12_rcc] * _b[mag12_rcc]) ) : svy : mean mag12_rcc mag12_rcc_sq
misum mag12_rcc [aweight = GOVWT1]

mi estimate: svy: mean avg_inpact_COcc
mi xeq: generate avg_inpact_COcc_sq = avg_inpact_COcc * avg_inpact_COcc
mi estimate (sd : sqrt(_b[avg_inpact_COcc_sq] - _b[avg_inpact_COcc] * _b[avg_inpact_COcc]) ) : svy : mean avg_inpact_COcc avg_inpact_COcc_sq
misum avg_inpact_COcc [aweight = GOVWT1]

mi estimate: svy: mean cogab_rcc
mi xeq: generate cogab_rcc_sq = cogab_rcc * cogab_rcc
mi estimate (sd : sqrt(_b[cogab_rcc_sq] - _b[cogab_rcc] * _b[cogab_rcc]) ) : svy : mean cogab_rcc cogab_rcc_sq
misum cogab_rcc [aweight = GOVWT1]

mi estimate: svy: mean sdqtotal_rnimpcc
mi xeq: generate sdqtotal_rnimpcc_sq = sdqtotal_rnimpcc * sdqtotal_rnimpcc
mi estimate (sd : sqrt(_b[sdqtotal_rnimpcc_sq] - _b[sdqtotal_rnimpcc] * _b[sdqtotal_rnimpcc]) ) : svy : mean sdqtotal_rnimpcc sdqtotal_rnimpcc_sq
misum sdqtotal_rnimpcc [aweight = GOVWT1]

mi estimate: svy: mean risk_rcc
mi xeq: generate risk_rcc_sq = risk_rcc * risk_rcc
mi estimate (sd : sqrt(_b[risk_rcc_sq] - _b[risk_rcc] * _b[risk_rcc]) ) : svy : mean risk_rcc risk_rcc_sq
misum risk_rcc [aweight = GOVWT1]


// Categorical variables (divide all Ns by 20)

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


* Weighted
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
local cat_imp_vars " eth_rBcc  famstr_r3Ccc cmage6_3Ccc  hhinc_r5Ccc sibshh_5Ccc  anti_COccim parcursmk_CO2Ccc parstyCOcc prvalc_rBcc prvcig_rBcc   urb_COcc   hiocc_CO6Ccc imd_COcc  smscq_r5C_imp sex_rBcc smok_rB_imp ecig_rB_imp cigecig_CO_imp hied_COB_imp"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}


********************************************************************************
*# TIME USE DIARY IMPUTED: SOCIAL MEDIA > CIGARETTE & E-CIGARETTE USE (n=2772) 
********************************************************************************

// Dataset: data01_master_vs3_TUD_imp_3_1.dta
use "CIG_ECIG\DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear
set seed 91705423

// Should say (data unchanged since 19jan2023 12:47)
datasignature confirm


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

// Continuous variables 
* Unweighted  
misum mag12_rcc
misum avg_inpact_COcc
misum cogab_rcc
misum sdqtotal_rnimpcc
misum risk_rcc


* Weighted
mi estimate: svy: mean mag12_rcc
mi xeq: generate mag12_rcc_sq = mag12_rcc * mag12_rcc
mi estimate (sd : sqrt(_b[mag12_rcc_sq] - _b[mag12_rcc] * _b[mag12_rcc]) ) : svy : mean mag12_rcc mag12_rcc_sq
misum mag12_rcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean avg_inpact_COcc
mi xeq: generate avg_inpact_COcc_sq = avg_inpact_COcc * avg_inpact_COcc
mi estimate (sd : sqrt(_b[avg_inpact_COcc_sq] - _b[avg_inpact_COcc] * _b[avg_inpact_COcc]) ) : svy : mean avg_inpact_COcc avg_inpact_COcc_sq
misum avg_inpact_COcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean cogab_rcc
mi xeq: generate cogab_rcc_sq = cogab_rcc * cogab_rcc
mi estimate (sd : sqrt(_b[cogab_rcc_sq] - _b[cogab_rcc] * _b[cogab_rcc]) ) : svy : mean cogab_rcc cogab_rcc_sq
misum cogab_rcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean sdqtotal_rnimpcc
mi xeq: generate sdqtotal_rnimpcc_sq = sdqtotal_rnimpcc * sdqtotal_rnimpcc
mi estimate (sd : sqrt(_b[sdqtotal_rnimpcc_sq] - _b[sdqtotal_rnimpcc] * _b[sdqtotal_rnimpcc]) ) : svy : mean sdqtotal_rnimpcc sdqtotal_rnimpcc_sq
misum sdqtotal_rnimpcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean risk_rcc
mi xeq: generate risk_rcc_sq = risk_rcc * risk_rcc
mi estimate (sd : sqrt(_b[risk_rcc_sq] - _b[risk_rcc] * _b[risk_rcc]) ) : svy : mean risk_rcc risk_rcc_sq
misum risk_rcc [aweight = TUD_WT_RO1_imp]


// Categorical variables (divide all Ns by 20)

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


* Weighted
local cat_imp_vars " eth_rBcc  famstr_r3Ccc cmage6_3Ccc  hhinc_r5Ccc sibshh_4Cimp  anti_COccim parcursmk_CO2Ccc parstyCOcc prvalc_rBcc prvcig_rBcc   urb_COcc   hiocc_CO6Ccc imd_COcc   avgsm_tud_5Cimp sex_rBcc smok_rB_imp ecig_rB_imp cigecig_CO_imp hied_COB_imp smwkdaytud_r5Ccc"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}


********************************************************************************
*# SELF-REPORT COMPLETE CASE: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n= 5317)
********************************************************************************

// Dataset: data01_SCQ_cc_alc.dta

use "ALC\DATASETS\data01_SCQ_cc_alc.dta", clear
set seed 91705423

* Should say (data unchanged since 25jan2023 09:43)
datasignature confirm


********************************************************************************

// Relevant weights: 

*  Single country analyses non-response weight and sample design weights for use in RO1 SCQ complete case
*svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Number of CM SCQ complete case sample 

* 5317 total and distinct records 
unique MCSID


// Continuous variables  

* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* Weighted 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}


// Categorical variables 

* Unweighted 
local cat_cc_vars "alcfreqlastmnth_r4Ccc everbingedrink_rBcc smscq_r5Ccc      eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc "
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}

* Weighted 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "alcfreqlastmnth_r4Ccc everbingedrink_rBcc smscq_r5Ccc      eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}



********************************************************************************
*# TIME USE DIARY COMPLETE CASE: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=1826) 
********************************************************************************

// Dataset: data01_TUD_cc_alc.dta

use "ALC\DATASETS\data01_TUD_cc_alc.dta", clear
set seed 9260678

* Should say (data unchanged since 25jan2023 09:42)
datasignature confirm


********************************************************************************

// Relevant weights

* TUD non-response weight for single country analyses and sample design weights to be used for RO1 TUD complete case
*svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)

********************************************************************************

// Number of CM TUD complete case sample 

* 1826 total and distinct records 
unique MCSID


// Continuous variables 

* Unweighted 
local cont_cc_vars " avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
summarize `cont_cc_vars', detail
foreach varname of varlist `cont_cc_vars'{ 
tab `varname', mi
}

* Weighted
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cont_cc_vars "avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc mag12_rcc"
display "`cont_cc_vars'"
svy: mean `cont_cc_vars'
estat sd 
foreach varname of varlist `cont_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
}


// Categorical variables 

* Unweighted 
local cat_cc_vars "avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc everbingedrink_rBcc   eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc smwkdaytud_r5Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
tab `varname'

}

* Weighted
svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc (NH2)
local cat_cc_vars "avgsm_tud_r5Ccc alcfreqlastmnth_r4Ccc everbingedrink_rBcc  eth_rBcc cmage6_3Ccc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc  parcursmk_CO2Ccc hied_CO7Ccc parstyCOcc hiocc_CO6Ccc prvcig_rBcc anti_COccim   prvalc_rBcc urb_COcc   peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc  smwkdaytud_r5Ccc"
display "`cat_cc_vars'"
foreach varname of varlist `cat_cc_vars'{ 
svy: tab `varname', percent obs format(%9.3g)
svy: tab `varname',obs count
svy: proportion `varname'
}

********************************************************************************
*# SELF-REPORT IMPUTED: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=8987)
********************************************************************************

// Dataset: data01_master_vs3_SCQ_imp_4_1.dta

use "ALC\DATASETS\data01_master_vs3_SCQ_imp_4_1.dta", clear
set seed 91703423

// Should say  (data unchanged since 18jan2023 13:47)
datasignature confirm

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

* Weighted

mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
mi estimate: svy: mean mag12_rcc
mi xeq: generate mag12_rcc_sq = mag12_rcc * mag12_rcc
mi estimate (sd : sqrt(_b[mag12_rcc_sq] - _b[mag12_rcc] * _b[mag12_rcc]) ) : svy : mean mag12_rcc mag12_rcc_sq
misum mag12_rcc [aweight = GOVWT1]

mi estimate: svy: mean avg_inpact_COcc
mi xeq: generate avg_inpact_COcc_sq = avg_inpact_COcc * avg_inpact_COcc
mi estimate (sd : sqrt(_b[avg_inpact_COcc_sq] - _b[avg_inpact_COcc] * _b[avg_inpact_COcc]) ) : svy : mean avg_inpact_COcc avg_inpact_COcc_sq
misum avg_inpact_COcc [aweight = GOVWT1]

mi estimate: svy: mean cogab_rcc
mi xeq: generate cogab_rcc_sq = cogab_rcc * cogab_rcc
mi estimate (sd : sqrt(_b[cogab_rcc_sq] - _b[cogab_rcc] * _b[cogab_rcc]) ) : svy : mean cogab_rcc cogab_rcc_sq
misum cogab_rcc [aweight = GOVWT1]

mi estimate: svy: mean sdqtotal_rnimpcc
mi xeq: generate risk_rcc_sq = risk_rcc * risk_rcc
mi estimate (sd : sqrt(_b[risk_rcc_sq] - _b[risk_rcc] * _b[risk_rcc]) ) : svy : mean risk_rcc risk_rcc_sq
misum risk_rcc [aweight = GOVWT1]

mi estimate: svy: mean risk_rcc
mi xeq: generate risk_rcc_sq = risk_rcc * risk_rcc
mi estimate (sd : sqrt(_b[risk_rcc_sq] - _b[risk_rcc] * _b[risk_rcc]) ) : svy : mean risk_rcc risk_rcc_sq
misum risk_rcc [aweight = GOVWT1]


// Categorical variables (divide all Ns by 20)

* Create alcohol frequency post imputation variable
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

* Weighted
mi svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00ds) fpc (NH2)
local cat_imp_vars " smscq_r5C_imp eth_rBcc famstr_r3Ccc hhinc_r5Ccc hied_COB_imp hiocc_CO6Ccc sex_rBcc parcursmk_CO2Ccc parstyCOcc prvcig_rBcc anti_COccim prvalc_rBcc urb_COcc cmage6_3Ccc sibshh_5Ccc imd_COcc peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc alcfreqlastmnth_r4Ccc_imp everbingedrink_rBcc_imp"
display "`cat_imp_vars'"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}

********************************************************************************
*# TIME USE DIARY IMPUTED: SOCIAL MEDIA > ALCOHOL FREQ & BINGE DRINKING (n=2520) 
********************************************************************************

// Dataset: data01_master_vs3_TUD_imp_3_1.dta

use "ALC\DATASETS\data01_master_vs3_TUD_imp_3_1.dta", clear
set seed 91705423

// Should say  (data unchanged since 19jan2023 12:47)
datasignature confirm

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

* Weighted
mi estimate: svy: mean mag12_rcc
mi xeq: generate mag12_rcc_sq = mag12_rcc * mag12_rcc
mi estimate (sd : sqrt(_b[mag12_rcc_sq] - _b[mag12_rcc] * _b[mag12_rcc]) ) : svy : mean mag12_rcc mag12_rcc_sq
misum mag12_rcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean avg_inpact_COcc
mi xeq: generate avg_inpact_COcc_sq = avg_inpact_COcc * avg_inpact_COcc
mi estimate (sd : sqrt(_b[avg_inpact_COcc_sq] - _b[avg_inpact_COcc] * _b[avg_inpact_COcc]) ) : svy : mean avg_inpact_COcc avg_inpact_COcc_sq
misum avg_inpact_COcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean cogab_rcc
mi xeq: generate cogab_rcc_sq = cogab_rcc * cogab_rcc
mi estimate (sd : sqrt(_b[cogab_rcc_sq] - _b[cogab_rcc] * _b[cogab_rcc]) ) : svy : mean cogab_rcc cogab_rcc_sq
misum cogab_rcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean sdqtotal_rnimpcc
mi xeq: generate sdqtotal_rnimpcc_sq = sdqtotal_rnimpcc * sdqtotal_rnimpcc
mi estimate (sd : sqrt(_b[sdqtotal_rnimpcc_sq] - _b[sdqtotal_rnimpcc] * _b[sdqtotal_rnimpcc]) ) : svy : mean sdqtotal_rnimpcc sdqtotal_rnimpcc_sq
misum sdqtotal_rnimpcc [aweight = TUD_WT_RO1_imp]

mi estimate: svy: mean risk_rcc
mi xeq: generate risk_rcc_sq = risk_rcc * risk_rcc
mi estimate (sd : sqrt(_b[risk_rcc_sq] - _b[risk_rcc] * _b[risk_rcc]) ) : svy : mean risk_rcc risk_rcc_sq
misum risk_rcc [aweight = TUD_WT_RO1_imp]


* Create alcohol frequency post imputation variable
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


// Categorical variables (divide all Ns by 20)

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


* Weighted
local cat_imp_vars " avgsm_tud_5Cimp smwkdaytud_r5Ccc eth_rBcc famstr_r3Ccc hhinc_r5Ccc hied_COB_imp hiocc_CO6Ccc sex_rBcc parcursmk_CO2Ccc parstyCOcc prvcig_rBcc anti_COccim prvalc_rBcc urb_COcc cmage6_3Ccc sibshh_4Cimp imd_COcc peeralc_r4Ccc paralcfreq_r5Ccc cmrelig_rBcc alcfreqlastmnth_r4Ccc_imp everbingedrink_rBcc_imp"
display "`cat_imp_vars"
foreach varname of varlist `cat_imp_vars'{ 
mi estimate: svy: proportion `varname'
}


********************************************************************************
















