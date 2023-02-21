

********************************************************************************
// TUD complete case analysis descriptives
********************************************************************************

// data02b_TUD_cc_desc_vs1.do: descriptives for TUD cc analysis
// Amrit Purba 13.09.2022

********************************************************************************

version 17
clear all
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj


use "test_run/DATASETS\data01_TUD_cc_vs1.dta", clear

set seed 568303859

*should say (data unchanged since 13sep2022 13:58)
datasignature confirm

********************************************************************************

*/*Vars used in analysis

i.eng_D
i.wales_D
i.scot_D
i.ni_D
i.eth_r6Ccc
i.cmage6_cc 
i.sex_rBcc
i.sibshh_5Ccc
ib5.hhinc_r5Ccc
i.famstr_r3Ccc
i.imd_COcc
i.mag12_r4Ccc 
i.parcursmk_CO2Ccc 
i.hied_CO7Ccc RO1
i.hied_COBcc RO2
i.parstyCOcc
avg_inpact_COcc
i.avgsm_tud_r5Ccc 
cogab_rcc
ib6.hiocc_CO6Ccc
i.smok_rBcc
i.ecig_rBcc
i.cigecig_COcc
i.prvcig_rBcc  
i.anti_COccim
sdqtotal_rnimpcc 
i.prvalc_rBcc
risk_rcc
i.urb_COcc */

********************************************************************************
// Descriptive statistics for above variables 

********************************************************************************

// Final TUD non-response weights and survey design weights to declare in TUD complete case analysis

svyset [pw = TUD_WT_RO1] , strata(PTTYPE2) psu(SPTN00) fpc(NH2)
noi svydes 
svyset [pw = TUD_WT_RO2] , strata(PTTYPE2) psu(SPTN00) fpc(NH2) 
noi svydes

local tud_cc "eng_D wales_D scot_D ni_D eth_r6Ccc cmage6_cc sex_rBcc sibshh_5Ccc hhinc_r5Ccc famstr_r3Ccc imd_COcc mag12_r4Ccc parcursmk_CO2Ccc hied_CO7Ccc hied_COBcc parstyCOcc avg_inpact_COcc avgsm_tud_r5Ccc cogab_rcc hiocc_CO6Ccc smok_rBcc ecig_rBcc cigecig_COcc prvcig_rBcc anti_COccim sdqtotal_rnimpcc prvalc_rBcc risk_rcc urb_COcc"
display "`tud_cc'"
summarize `tud_cc'
describe `tud_cc'
codebook `tud_cc'


*all variable descriptives unweighted 

*dummy var descriptives 
tabulate eng_D, mi
tab eng_D, plot
tabulate wales_D, mi
tab wales_D, plot
tabulate scot_D, mi
tab scot_D, plot
tabulate ni_D, mi
tab ni_D, plot


*GOVWT2 MCS 7 whole UK level analysis weight used 
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
noi svydes

tabulate eth_r6Ccc, mi
summarize eth_r6Ccc
tab eth_r6Ccc, plot
svy: tab eth_r6Ccc, percent obs format(%9.3g)
svy: tab eth_r6Ccc, obs count
svy: mean eth_r6Ccc

tabulate i.cmage6_cc, mi
summarize i.cmage6_cc
tab i.cmage6_cc, plot
svy: tab i.cmage6_cc, percent obs format(%9.3g)
svy: tab i.cmage6_cc, obs count
svy: mean i.cmage6_cc

tabulate sex_rBcc, mi
tab sex_rBcc, plot
summarize sex_rBcc
svy: tab sex_rBcc, percent obs format(%9.3g)
svy: tab sex_rBcc, obs count
svy: mean sex_rBcc

tabulate sibshh_cc, mi
tab sibshh_cc, plot
summarize sibshh_cc
svy: tab sibshh_cc, percent obs format(%9.3g)
svy: tab sibshh_cc, obs count
svy: mean sibshh_cc

tabulate hhinc_r5Ccc, mi
tab hhinc_r5Ccc, plot
summarize hhinc_r5Ccc 
svy: tab hhinc_r5Ccc, percent obs format(%9.3g)
svy: tab hhinc_r5Ccc, obs count
svy: mean hhinc_r5Ccc

tabulate famstr_r3Ccc, mi
tab famstr_r3Ccc, plot
summarize famstr_r3Ccc
svy: tab famstr_r3Ccc, percent obs format(%9.3g)
svy: tab famstr_r3Ccc, obs count
svy: mean famstr_r3Ccc

tabulate mag12_r4Ccc, mi
tab mag12_r4Ccc, plot
summarize mag12_r4Ccc
svy: tab mag12_r4Ccc, percent obs format(%9.3g)
svy: tab mag12_r4Ccc, obs count
svy: mean mag12_r4Ccc

tabulate parcursmk_CO2Ccc, mi
tab parcursmk_CO2Ccc, plot
summarize parcursmk_CO2Ccc
svy: tab parcursmk_CO2Ccc, percent obs format(%9.3g)
svy: tab parcursmk_CO2Ccc, obs count
svy: mean parcursmk_CO2Ccc

tabulate hied_CO7Ccc, mi
tab hied_CO7Ccc, plot
summarize  hied_CO7Ccc
svy: tab hied_CO7Ccc, percent obs format(%9.3g)
svy: tab hied_CO7Ccc, obs count
svy: mean hied_CO7Ccc

tabulate hied_COBcc, mi
tab hied_COBcc, plot
summarize hied_COBcc
svy: tab hied_COBcc, percent obs format(%9.3g)
svy: tab hied_COBcc, obs count
svy: mean hied_COBcc

tabulate parstyCOcc, mi
tab parstyCOcc, plot
summarize parstyCOcc
svy: tab parstyCOcc, percent obs format(%9.3g)
svy: tab parstyCOcc, obs count
svy: mean parstyCOcc

tabulate avg_inpact_COcc, mi
tab avg_inpact_COcc, plot
summarize  avg_inpact_COcc
svy: tab avg_inpact_COcc, percent obs format(%9.3g)
svy: tab avg_inpact_COcc, obs count
svy: mean avg_inpact_COcc

tabulate smscq_r5Ccc, mi
tab smscq_r5Ccc, plot
summarize  smscq_r5Ccc
svy: tab smscq_r5Ccc, percent obs format(%9.3g)
svy: tab smscq_r5Ccc, obs count
svy: mean smscq_r5Ccc

tabulate cogab_rcc, mi
tab cogab_rcc, plot
summarize cogab_rcc
svy: tab cogab_rcc, percent obs format(%9.3g)
svy: tab cogab_rcc, obs count
svy: mean cogab_rcc

tabulate hiocc_CO6Ccc, mi
tab hiocc_CO6Ccc, plot
summarize hiocc_CO6Ccc
svy: tab hiocc_CO6Ccc, percent obs format(%9.3g)
svy: tab hiocc_CO6Ccc, obs count
svy: mean hiocc_CO6Ccc
 
tabulate smok_rBcc, mi
tab smok_rBcc, plot
summarize smok_rBcc
svy: tab smok_rBcc, percent obs format(%9.3g)
svy: tab smok_rBcc, obs count
svy: mean smok_rBcc

tabulate ecig_rBcc, mi
tab ecig_rBcc, plot
summarize ecig_rBcc
svy: tab ecig_rBcc, percent obs format(%9.3g)
svy: tab ecig_rBcc, obs count
svy: mean ecig_rBcc

tabulate cigecig_COcc, mi
tab cigecig_COcc, plot
summarize  cigecig_COcc
svy: tab cigecig_COcc, percent obs format(%9.3g)
svy: tab cigecig_COcc, obs count
svy: mean cigecig_COcc

tabulate prvcig_rBcc, mi
tab prvcig_rBcc, plot
summarize prvcig_rBcc
svy: tab prvcig_rBcc, percent obs format(%9.3g)
svy: tab prvcig_rBcc, obs count
svy: mean prvcig_rBcc

tabulate anti_COccim, mi
tab anti_COccim, plot
summarize anti_COccim
svy: tab anti_COccim, percent obs format(%9.3g)
svy: tab anti_COccim, obs count
svy: mean  anti_COccim

tabulate sdqtotal_rnimpcc, mi
tab sdqtotal_rnimpcc, plot
summarize sdqtotal_rnimpcc
svy: tab sdqtotal_rnimpcc, percent obs format(%9.3g)
svy: tab sdqtotal_rnimpcc, obs count
svy: mean sdqtotal_rnimpcc

tabulate prvalc_rBcc, mi
tab prvalc_rBcc, plot
summarize prvalc_rBcc
svy: tab prvalc_rBcc, percent obs format(%9.3g)
svy: tab prvalc_rBcc, obs count
svy: mean prvalc_rBcc

tabulate risk_rcc, mi
tab risk_rcc, plot
summarize risk_rcc
svy: tab risk_rcc, percent obs format(%9.3g)
svy: tab risk_rcc, obs count
svy: mean risk_rcc

tabulate urb_COcc, mi
tab urb_COcc, plot
summarize urb_COcc
svy: tab urb_COcc, percent obs format(%9.3g)
svy: tab urb_COcc, obs count
svy: mean urb_COcc

tabulate imd_COcc, mi
tabulate imd_COcc if eng_D==1
tabulate imd_COcc if wales_D==1
tabulate imd_COcc if scot_D==1
tabulate imd_COcc if ni_D==1

tab imd_COcc if eng_D==1, plot
tabulate imd_COcc if wales_D==1 , plot
tabulate imd_COcc if scot_D==1 , plot
tabulate imd_COcc if ni_D==1 , plot

svy: tab imd_COcc if eng_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if eng_D==1, obs count
svy: mean imd_COcc if eng_D==1
svy: tab imd_COcc if wales_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if wales_D==1, obs count
svy: mean imd_COcc if wales_D==1
svy: tab imd_COcc if scot_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if scot_D==1, obs count
svy: mean imd_COcc if scot_D==1
svy: tab imd_COcc if ni_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if ni_D==1, obs count
svy: mean imd_COcc if ni_D==1

*GOVWT1 MCS 7 UK country specific weight used 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

tabulate imd_COcc, mi
tabulate imd_COcc if eng_D==1
tabulate imd_COcc if wales_D==1
tabulate imd_COcc if scot_D==1
tabulate imd_COcc if ni_D==1

tab imd_COcc if eng_D==1, plot
tabulate imd_COcc if wales_D==1 , plot
tabulate imd_COcc if scot_D==1 , plot
tabulate imd_COcc if ni_D==1 , plot

svy: tab imd_COcc if eng_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if eng_D==1, obs count
svy: mean imd_COcc if eng_D==1
svy: tab imd_COcc if wales_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if wales_D==1, obs count
svy: mean imd_COcc if wales_D==1
svy: tab imd_COcc if scot_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if scot_D==1, obs count
svy: mean imd_COcc if scot_D==1
svy: tab imd_COcc if ni_D==1, percent obs format(%9.3g)
svy: tab imd_COcc if ni_D==1, obs count
svy: mean imd_COcc if ni_D==1

********************************************************************************

*continuous variables descriptives 
tabstat mag12_rcc cmage6_cc sdqtotal_rnimpcc avg_inpact_COcc cogab_rcc risk_rcc sibshh_cc, s(mean median sd var count range min max)
svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
svy: mean sdqtotal_rnimpcc avg_inpact_COcc cogab_rcc risk_rcc sibshh_cc

*continous variables descriptives by gender 
tabstat  sdqtotal_rnimpcc avg_inpact_COcc cogab_rcc risk_rcc sibshh_cc, s(mean median sd var count range min max) by (sex_rBcc)

*continous variables descriptives by age
tabstat   sdqtotal_rnimpcc avg_inpact_COcc cogab_rcc risk_rcc sibshh_cc, s(mean median sd var count range min max) by (cmage6_cc)

********************************************************************************

*confounders: 
/*eth_r6Ccc
cmage6_cc
sex_rBcc
sibshh_cc
hhinc_r5Ccc
famstr_r3Ccc
imd_COcc
mag12_rcc
parcursmk_CO2Ccc 
hied_CO7Ccc 
parstyCOcc
avg_inpact_COcc
cogab_rcc
hiocc_CO6Ccc
prvcig_rBcc  
anti_COccim
sdqtotal_rnimpcc 
prvalc_rBcc
risk_rcc
urb_COcc

*effect modifier: 
hied_COBcc

*exposure: 
smscq_r5Ccc 

*outcomes: 
smok_rBcc
ecig_rBcc
cigecig_COcc */

********************************************************************************
*# Total no of observations used

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

*obs weighted= all vars have 4484 weighted observations
di 4484*27
*total obs weighted= 121068
svy: tabulate eth_r6Ccc, count format(%14.3gc)
svy: tabulate cmage6_cc, count format(%14.3gc)
svy: tabulate sex_rBcc, count format(%14.3gc)
svy: tabulate sibshh_cc, count format(%14.3gc)
svy: tabulate hhinc_r5Ccc, count format(%14.3gc)
svy: tabulate famstr_r3Ccc, count format(%14.3gc)
svy: tabulate imd_COcc, count format(%14.3gc)
svy: tabulate mag12_r4Ccc, count format(%14.3gc)
svy: tabulate parcursmk_CO2Ccc, count format(%14.3gc)
svy: tabulate hied_CO7Ccc, count format(%14.3gc)
svy: tabulate parstyCOcc, count format(%14.3gc)
svy: tabulate avg_inpact_COcc, count format(%14.3gc)
svy: tabulate cogab_rcc, count format(%14.3gc)
svy: tabulate hiocc_CO6Ccc, count format(%14.3gc)
svy: tabulate prvcig_rBcc, count format(%14.3gc)
svy: tabulate anti_COccim, count format(%14.3gc)
svy: tabulate sdqtotal_rnimpcc, count format(%14.3gc)
svy: tabulate prvalc_rBcc, count format(%14.3gc)
svy: tabulate urb_COcc, count format(%14.3gc)
svy: tabulate eng_D, count format(%14.3gc)
svy: tabulate wales_D, count format(%14.3gc)
svy: tabulate scot_D, count format(%14.3gc)
svy: tabulate risk_rcc, count format(%14.3gc)
svy: tabulate smscq_r5Ccc, count format(%14.3gc)
svy: tabulate smok_rBcc, count format(%14.3gc)
svy: tabulate ecig_rBcc, count format(%14.3gc)
svy: tabulate cigecig_COcc, count format(%14.3gc)

*obs unweighted= all vars have 6234 unweighted observations
di 6234*27
*total obs unweighted= 168318
distinct eth_r6Ccc
distinct cmage6_cc 
distinct sex_rBcc 
distinct sibshh_cc 
distinct hhinc_r5Ccc 
distinct famstr_r3Ccc 
distinct imd_COcc 
distinct mag12_r4Ccc
distinct parcursmk_CO2Ccc 
distinct hied_CO7Ccc 
distinct parstyCOcc 
distinct avg_inpact_COcc 
distinct cogab_rcc 
distinct hiocc_CO6Ccc 
distinct prvcig_rBcc 
distinct anti_COccim 
distinct sdqtotal_rnimpcc 
distinct prvalc_rBcc
distinct urb_COcc 
distinct eng_D
distinct wales_D
distinct scot_D
distinct  risk_rcc
distinct smscq_r5Ccc
distinct smok_rBcc 
distinct ecig_rBcc 
distinct cigecig_COcc 

*#percents of exposure and outcome variables (weighted)

svy: tab smscq_r5Ccc, percent obs format(%9.3g)
svy: tab smscq_r5Ccc, obs count

svy: tab smok_rBcc, percent obs format(%9.3g)
svy: tab smok_rBcc, obs count

svy: tab ecig_rBcc, percent obs format(%9.3g)
svy: tab ecig_rBcc, obs count

svy: tab cigecig_COcc, percent obs format(%9.3g)
svy: tab cigecig_COcc, obs count
********************************************************************************
*cross tabs & tests of association
********************************************************************************

*for ordinal vars use gamma and taub (Gamma and taub are measures of association between two ordinal variables (both have to be in the same direction, i.e. negative to positive, low to high). Both go from ‐1 to 1. Negative shows inverse relationship, closer to 1 a strong relationship. Gamma is recommended when there are lots of ties in the data. Taub is recommended for square tables)
*for nominal vars: chi2, lrchi2, V
*note percents for graph bars stacked shows the within group %

********************************************************************************

*# Exposures and outcomes

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

tab smscq_r5Ccc smok_rBcc, mi colum row
tab smscq_r5Ccc smok_rBcc, colum row gamma taub
graph bar, over (smscq_r5Ccc) over (smok_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("CM smoking") ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc smok_rBcc, obs count colum row percent

tab smscq_r5Ccc ecig_rBcc, mi colum row
tab smscq_r5Ccc ecig_rBcc, colum row gamma taub
graph bar, over (smscq_r5Ccc) over (ecig_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("CM ecig use") ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc ecig_rBcc, obs count colum row percent

tab smscq_r5Ccc cigecig_COcc, mi colum row
tab smscq_r5Ccc cigecig_COcc, colum row gamma taub
graph bar, over (smscq_r5Ccc) over (cigecig_COcc) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("CM ecig and cig use") ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc cigecig_COcc, obs count colum row percent

********************************************************************************

*# Exposures and confounders 

tab smscq_r5Ccc eth_r6Ccc, mi colum row
tab smscq_r5Ccc eth_r6Ccc, colum row chi2
graph bar, over (smscq_r5Ccc) over (eth_r6Ccc) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Ethnicity")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc eth_r6Ccc, obs count colum row percent

tab smscq_r5Ccc sex_rBcc, mi colum row
tab smscq_r5Ccc sex_rBcc, colum row chi2
graph bar, over (smscq_r5Ccc) over (sex_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Sex")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc sex_rBcc, obs count colum row percent

tab smscq_r5Ccc hhinc_r5Ccc, mi colum row
tab smscq_r5Ccc hhinc_r5Ccc, colum row gamma taub
graph bar, over (smscq_r5Ccc) over (hhinc_r5Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("HH income")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc hhinc_r5Ccc, obs count colum row percent

tab smscq_r5Ccc famstr_r3Ccc, mi colum row
tab smscq_r5Ccc famstr_r3Ccc, colum row chi2
graph bar, over (smscq_r5Ccc) over (famstr_r3Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Family structure")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc famstr_r3Ccc, obs count colum row percent

tab smscq_r5Ccc parcursmk_CO2Ccc, mi colum row
tab smscq_r5Ccc parcursmk_CO2Ccc, colum row chi2
graph bar, over (smscq_r5Ccc) over (parcursmk_CO2Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental smoking")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc parcursmk_CO2Ccc, obs count colum row percent

tab smscq_r5Ccc hied_CO7Ccc, mi colum row
tab smscq_r5Ccc hied_CO7Ccc, colum row chi2
graph bar, over (smscq_r5Ccc) over (hied_CO7Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc hied_CO7Ccc, obs count colum row percent

tab smscq_r5Ccc parstyCOcc, mi colum row
tab smscq_r5Ccc parstyCOcc, colum row chi2
graph bar, over (smscq_r5Ccc) over (parstyCOcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*this was a funny finding so check with original variables 
notes parstyCOcc
graph bar, over (smscq_r5Ccc) over (EPCTRC001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
graph bar, over (smscq_r5Ccc) over (EPCTRL001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*appears correct, remember our parent has rules was rules for either variable, whilst parent has no rules, was no rules for both
svy: tab smscq_r5Ccc parstyCOcc, obs count colum row percent

tab smscq_r5Ccc hiocc_CO6Ccc, mi colum row
tab smscq_r5Ccc hiocc_CO6Ccc, colum row chi2
graph bar, over (smscq_r5Ccc) over (hiocc_CO6Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental occupation")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc hiocc_CO6Ccc, obs count colum row percent

tab smscq_r5Ccc prvcig_rBcc, mi colum row
tab smscq_r5Ccc prvcig_rBcc, colum row chi2
graph bar, over (smscq_r5Ccc) over (prvcig_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev cig use")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc prvcig_rBcc, obs count colum row percent

tab smscq_r5Ccc anti_COccim, mi colum row
tab smscq_r5Ccc anti_COccim, colum row chi2
graph bar, over (smscq_r5Ccc) over (anti_COccim) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Antisocial behaviour")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc anti_COccim, obs count colum row percent
 
tab smscq_r5Ccc prvalc_rBcc, mi colum row
tab smscq_r5Ccc prvalc_rBcc, colum row chi2
graph bar, over (smscq_r5Ccc) over (prvalc_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev alcohol use")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc prvalc_rBcc, obs count colum row percent

tab smscq_r5Ccc urb_COcc, mi colum row
tab smscq_r5Ccc urb_COcc, colum row chi2
graph bar, over (smscq_r5Ccc) over (urb_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Urbanicity")  ytitle("Percent") scale(*.5)
*interesting finding 
svy: tab smscq_r5Ccc urb_COcc, obs count colum row percent

*tab smscq_r5Ccc risk_rcc, mi colum row (too many vals)
graph hbox risk_rcc, over(smscq_r5Ccc) ytitle("Risk taking")
*svy: tab smscq_r5Ccc risk_rcc, obs count colum row percent (too many vals)

tab smscq_r5Ccc avg_inpact_COcc, mi colum row
graph hbox risk_rcc, over(smscq_r5Ccc) ytitle("Avg in person activities days/wk")
svy: tab smscq_r5Ccc avg_inpact_COcc, obs count colum row percent

tab smscq_r5Ccc cogab_rcc, mi colum row
graph hbox cogab_rcc, over(smscq_r5Ccc) ytitle("Cog ability")
svy: tab smscq_r5Ccc cogab_rcc, obs count colum row percent

tab smscq_r5Ccc sdqtotal_rnimpcc, mi colum row
graph hbox sdqtotal_rnimpcc, over(smscq_r5Ccc) ytitle("Mental health problems")
svy: tab smscq_r5Ccc sdqtotal_rnimpcc, obs count colum row percent

tab smscq_r5Ccc cmage6_cc, mi colum row
graph hbox cmage6_cc, over(smscq_r5Ccc) ytitle("CM age")
svy: tab smscq_r5Ccc cmage6_cc, obs count colum row percent

tab smscq_r5Ccc sibshh_cc, mi colum row
graph hbox sibshh_cc, over(smscq_r5Ccc) ytitle("Siblings in HH")
svy: tab smscq_r5Ccc sibshh_cc, obs count colum row percent

tab smscq_r5Ccc mag12_r4Ccc, mi colum row
graph hbox mag12_r4Ccc, over(smscq_r5Ccc) ytitle("Mat age cm birth")
svy: tab smscq_r5Ccc mag12_r4Ccc, obs count colum row percent

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab smscq_r5Ccc imd_COcc, mi colum row
graph bar, over (smscq_r5Ccc) over (imd_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Area level deprivation")  ytitle("Percent") scale(*.5)
svy: tab smscq_r5Ccc imd_COcc, obs count colum row percent

********************************************************************************

*Exposure and effect modifier 

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab smscq_r5Ccc hied_COBcc, mi colum row
graph bar, over (smscq_r5Ccc) over (hied_COBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
tab smscq_r5Ccc hied_COBcc, colum row chi2
svy: tab smscq_r5Ccc hied_COBcc, obs count colum row percent

********************************************************************************

*Outcomes and confounders 

*smok_rBcc and confounders 

tab smok_rBcc eth_r6Ccc, mi colum row
tab smok_rBcc eth_r6Ccc, colum row chi2
graph bar, over (smok_rBcc) over (eth_r6Ccc) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Ethnicity")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc eth_r6Ccc, obs count colum row percent

tab smok_rBcc sex_rBcc, mi colum row
tab smok_rBcc sex_rBcc, colum row chi2
graph bar, over (smok_rBcc) over (sex_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Sex")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc sex_rBcc, obs count colum row percent

tab smok_rBcc hhinc_r5Ccc, mi colum row
tab smok_rBcc hhinc_r5Ccc, colum row gamma taub
graph bar, over (smok_rBcc) over (hhinc_r5Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("HH income")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc hhinc_r5Ccc, obs count colum row percent

tab smok_rBcc famstr_r3Ccc, mi colum row
tab smok_rBcc famstr_r3Ccc, colum row chi2
graph bar, over (smok_rBcc) over (famstr_r3Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Family structure")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc famstr_r3Ccc, obs count colum row percent

tab smok_rBcc parcursmk_CO2Ccc, mi colum row
tab smok_rBcc parcursmk_CO2Ccc, colum row chi2
graph bar, over (smok_rBcc) over (parcursmk_CO2Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental smoking")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc parcursmk_CO2Ccc, obs count colum row percent

tab smok_rBcc hied_CO7Ccc, mi colum row
tab smok_rBcc hied_CO7Ccc, colum row chi2
graph bar, over (smok_rBcc) over (hied_CO7Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc hied_CO7Ccc, obs count colum row percent

tab smok_rBcc parstyCOcc, mi colum row
tab smok_rBcc parstyCOcc, colum row chi2
graph bar, over (smok_rBcc) over (parstyCOcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*this was a funny finding so check with original variables 
notes parstyCOcc
graph bar, over (smok_rBcc) over (EPCTRC001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
graph bar, over (smok_rBcc) over (EPCTRL001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*appears correct, remember our parent has rules was rules for either variable, whilst parent has no rules, was no rules for both
svy: tab smok_rBcc parstyCOcc, obs count colum row percent

tab smok_rBcc hiocc_CO6Ccc, mi colum row
tab smok_rBcc hiocc_CO6Ccc, colum row chi2
graph bar, over (smok_rBcc) over (hiocc_CO6Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental occupation")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc hiocc_CO6Ccc, obs count colum row percent

tab smok_rBcc prvcig_rBcc, mi colum row
tab smok_rBcc prvcig_rBcc, colum row chi2
graph bar, over (smok_rBcc) over (prvcig_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev cig use")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc prvcig_rBcc, obs count colum row percent

tab smok_rBcc anti_COccim, mi colum row
tab smok_rBcc anti_COccim, colum row chi2
graph bar, over (smok_rBcc) over (anti_COccim) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Antisocial behaviour")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc anti_COccim, obs count colum row percent
 
tab smok_rBcc prvalc_rBcc, mi colum row
tab smok_rBcc prvalc_rBcc, colum row chi2
graph bar, over (smok_rBcc) over (prvalc_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev alcohol use")  ytitle("Percent") scale(*.5)
svy: tab smok_rBcc prvalc_rBcc, obs count colum row percent

tab smok_rBcc urb_COcc, mi colum row
tab smok_rBcc urb_COcc, colum row chi2
graph bar, over (smok_rBcc) over (urb_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Urbanicity")  ytitle("Percent") scale(*.5)
*interesting finding 
svy: tab smok_rBcc urb_COcc, obs count colum row percent

*tab smok_rBcc risk_rcc, mi colum row (too many vals)
graph hbox risk_rcc, over(smok_rBcc) ytitle("Risk taking")
graph hbar (mean) risk_rcc, over(smok_rBcc)
*svy: tab smok_rBcc risk_rcc, obs count colum row percent (too many vals)

tab smok_rBcc avg_inpact_COcc, mi colum row
graph hbox avg_inpact_COcc, over(smok_rBcc) ytitle("Avg in person activities days/wk")
graph hbar (mean) avg_inpact_COcc, over(smok_rBcc)
svy: tab smok_rBcc avg_inpact_COcc, obs count colum row percent

tab smok_rBcc cogab_rcc, mi colum row
graph hbox cogab_rcc, over(smok_rBcc) ytitle("Cog ability")
graph hbar (mean) cogab_rcc, over(smok_rBcc)
svy: tab smok_rBcc cogab_rcc, obs count colum row percent

tab smok_rBcc sdqtotal_rnimpcc, mi colum row
graph hbox sdqtotal_rnimpcc, over(smok_rBcc) ytitle("Mental health problems")
graph hbar (mean) sdqtotal_rnimpcc, over(smok_rBcc)
svy: tab smok_rBcc sdqtotal_rnimpcc, obs count colum row percent

tab smok_rBcc cmage6_cc, mi colum row
graph hbox cmage6_cc, over(smok_rBcc) ytitle("CM age")
graph hbar (mean) cmage6_cc, over(smok_rBcc)
svy: tab smok_rBcc cmage6_cc, obs count colum row percent

tab smok_rBcc sibshh_cc, mi colum row
graph hbox sibshh_cc, over(smok_rBcc) ytitle("Siblings in HH")
graph hbar (mean) sibshh_cc, over(smok_rBcc)
svy: tab smok_rBcc sibshh_cc, obs count colum row percent

tab smok_rBcc mag12_r4Ccc, mi colum row
graph hbox mag12_r4Ccc, over(smok_rBcc) ytitle("Mat age cm birth")
graph hbar (mean) mag12_r4Ccc, over(smok_rBcc)
svy: tab smok_rBcc mag12_r4Ccc, obs count colum row percent

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab smok_rBcc imd_COcc, mi colum row
graph bar, over (smok_rBcc) over (imd_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Area level deprivation")  ytitle("Percent") scale(*.5)
graph hbar (mean) imd_COcc, over(smok_rBcc)
svy: tab smok_rBcc imd_COcc, obs count colum row percent

*ecig_rBcc and confounders 

tab ecig_rBcc eth_r6Ccc, mi colum row
tab ecig_rBcc eth_r6Ccc, colum row chi2
graph bar, over (ecig_rBcc) over (eth_r6Ccc) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Ethnicity")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc eth_r6Ccc, obs count colum row percent

tab ecig_rBcc sex_rBcc, mi colum row
tab ecig_rBcc sex_rBcc, colum row chi2
graph bar, over (ecig_rBcc) over (sex_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Sex")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc sex_rBcc, obs count colum row percent

tab ecig_rBcc hhinc_r5Ccc, mi colum row
tab ecig_rBcc hhinc_r5Ccc, colum row gamma taub
graph bar, over (ecig_rBcc) over (hhinc_r5Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("HH income")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc hhinc_r5Ccc, obs count colum row percent

tab ecig_rBcc famstr_r3Ccc, mi colum row
tab ecig_rBcc famstr_r3Ccc, colum row chi2
graph bar, over (ecig_rBcc) over (famstr_r3Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Family structure")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc famstr_r3Ccc, obs count colum row percent

tab ecig_rBcc parcursmk_CO2Ccc, mi colum row
tab ecig_rBcc parcursmk_CO2Ccc, colum row chi2
graph bar, over (ecig_rBcc) over (parcursmk_CO2Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental smoking")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc parcursmk_CO2Ccc, obs count colum row percent

tab ecig_rBcc hied_CO7Ccc, mi colum row
tab ecig_rBcc hied_CO7Ccc, colum row chi2
graph bar, over (ecig_rBcc) over (hied_CO7Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc hied_CO7Ccc, obs count colum row percent

tab ecig_rBcc parstyCOcc, mi colum row
tab ecig_rBcc parstyCOcc, colum row chi2
graph bar, over (ecig_rBcc) over (parstyCOcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*this was a funny finding so check with original variables 
notes parstyCOcc
graph bar, over (ecig_rBcc) over (EPCTRC001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
graph bar, over (ecig_rBcc) over (EPCTRL001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*appears correct, remember our parent has rules was rules for either variable, whilst parent has no rules, was no rules for both
svy: tab ecig_rBcc parstyCOcc, obs count colum row percent

tab ecig_rBcc hiocc_CO6Ccc, mi colum row
tab ecig_rBcc hiocc_CO6Ccc, colum row chi2
graph bar, over (ecig_rBcc) over (hiocc_CO6Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental occupation")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc hiocc_CO6Ccc, obs count colum row percent

tab ecig_rBcc prvcig_rBcc, mi colum row
tab ecig_rBcc prvcig_rBcc, colum row chi2
graph bar, over (ecig_rBcc) over (prvcig_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev cig use")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc prvcig_rBcc, obs count colum row percent

tab ecig_rBcc anti_COccim, mi colum row
tab ecig_rBcc anti_COccim, colum row chi2
graph bar, over (ecig_rBcc) over (anti_COccim) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Antisocial behaviour")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc anti_COccim, obs count colum row percent
 
tab ecig_rBcc prvalc_rBcc, mi colum row
tab ecig_rBcc prvalc_rBcc, colum row chi2
graph bar, over (ecig_rBcc) over (prvalc_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev alcohol use")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc prvalc_rBcc, obs count colum row percent

tab ecig_rBcc urb_COcc, mi colum row
tab ecig_rBcc urb_COcc, colum row chi2
graph bar, over (ecig_rBcc) over (urb_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Urbanicity")  ytitle("Percent") scale(*.5)
*interesting finding 
svy: tab ecig_rBcc urb_COcc, obs count colum row percent

*tab ecig_rBcc risk_rcc, mi colum row (too many vals)
graph hbox risk_rcc, over(ecig_rBcc) ytitle("Risk taking")
graph hbar (mean) risk_rcc, over(ecig_rBcc)
*svy: tab ecig_rBcc risk_rcc, obs count colum row percent (too many vals)

tab ecig_rBcc avg_inpact_COcc, mi colum row
graph hbox avg_inpact_COcc, over(ecig_rBcc) ytitle("Avg in person activities days/wk")
graph hbar (mean) avg_inpact_COcc, over(ecig_rBcc)
svy: tab ecig_rBcc avg_inpact_COcc, obs count colum row percent

tab ecig_rBcc cogab_rcc, mi colum row
graph hbox cogab_rcc, over(ecig_rBcc) ytitle("Cog ability")
graph hbar (mean) cogab_rcc, over(ecig_rBcc)
svy: tab ecig_rBcc cogab_rcc, obs count colum row percent

tab ecig_rBcc sdqtotal_rnimpcc, mi colum row
graph hbox sdqtotal_rnimpcc, over(ecig_rBcc) ytitle("Mental health problems")
graph hbar (mean) sdqtotal_rnimpcc, over(ecig_rBcc)
svy: tab ecig_rBcc sdqtotal_rnimpcc, obs count colum row percent

tab ecig_rBcc cmage6_cc, mi colum row
graph hbox cmage6_cc, over(ecig_rBcc) ytitle("CM age")
graph hbar (mean) cmage6_cc, over(ecig_rBcc)
svy: tab ecig_rBcc cmage6_cc, obs count colum row percent

tab ecig_rBcc sibshh_cc, mi colum row
graph hbox sibshh_cc, over(ecig_rBcc) ytitle("Siblings in HH")
graph hbar (mean) sibshh_cc, over(ecig_rBcc)
svy: tab ecig_rBcc sibshh_cc, obs count colum row percent

tab ecig_rBcc mag12_r4Ccc, mi colum row
graph hbox mag12_r4Ccc, over(ecig_rBcc) ytitle("Mat age cm birth")
graph hbar (mean) mag12_r4Ccc, over(ecig_rBcc)
svy: tab ecig_rBcc mag12_r4Ccc, obs count colum row percent

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab ecig_rBcc imd_COcc, mi colum row
graph bar, over (ecig_rBcc) over (imd_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Area level deprivation")  ytitle("Percent") scale(*.5)
svy: tab ecig_rBcc imd_COcc, obs count colum row percent

*cigecig_COcc and confounders 

tab cigecig_COcc eth_r6Ccc, mi colum row
tab cigecig_COcc eth_r6Ccc, colum row chi2
graph bar, over (cigecig_COcc) over (eth_r6Ccc) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Ethnicity")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc eth_r6Ccc, obs count colum row percent

tab cigecig_COcc sex_rBcc, mi colum row
tab cigecig_COcc sex_rBcc, colum row chi2
graph bar, over (cigecig_COcc) over (sex_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Sex")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc sex_rBcc, obs count colum row percent

tab cigecig_COcc hhinc_r5Ccc, mi colum row
tab cigecig_COcc hhinc_r5Ccc, colum row gamma taub
graph bar, over (cigecig_COcc) over (hhinc_r5Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("HH income")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc hhinc_r5Ccc, obs count colum row percent

tab cigecig_COcc famstr_r3Ccc, mi colum row
tab cigecig_COcc famstr_r3Ccc, colum row chi2
graph bar, over (cigecig_COcc) over (famstr_r3Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Family structure")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc famstr_r3Ccc, obs count colum row percent

tab cigecig_COcc parcursmk_CO2Ccc, mi colum row
tab cigecig_COcc parcursmk_CO2Ccc, colum row chi2
graph bar, over (cigecig_COcc) over (parcursmk_CO2Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental smoking")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc parcursmk_CO2Ccc, obs count colum row percent

tab cigecig_COcc hied_CO7Ccc, mi colum row
tab cigecig_COcc hied_CO7Ccc, colum row chi2
graph bar, over (cigecig_COcc) over (hied_CO7Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc hied_CO7Ccc, obs count colum row percent

tab cigecig_COcc parstyCOcc, mi colum row
tab cigecig_COcc parstyCOcc, colum row chi2
graph bar, over (cigecig_COcc) over (parstyCOcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*this was a funny finding so check with original variables 
notes parstyCOcc
graph bar, over (cigecig_COcc) over (EPCTRC001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
graph bar, over (cigecig_COcc) over (EPCTRL001) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parenting style")  ytitle("Percent") scale(*.5)
*appears correct, remember our parent has rules was rules for either variable, whilst parent has no rules, was no rules for both
svy: tab cigecig_COcc parstyCOcc, obs count colum row percent

tab cigecig_COcc hiocc_CO6Ccc, mi colum row
tab cigecig_COcc hiocc_CO6Ccc, colum row chi2
graph bar, over (cigecig_COcc) over (hiocc_CO6Ccc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental occupation")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc hiocc_CO6Ccc, obs count colum row percent

tab cigecig_COcc prvcig_rBcc, mi colum row
tab cigecig_COcc prvcig_rBcc, colum row chi2
graph bar, over (cigecig_COcc) over (prvcig_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev cig use")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc prvcig_rBcc, obs count colum row percent

tab cigecig_COcc anti_COccim, mi colum row
tab ecig_rBcc cigecig_COcc, colum row chi2
graph bar, over (cigecig_COcc) over (anti_COccim) stack asyvars percentage  blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Antisocial behaviour")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc anti_COccim, obs count colum row percent
 
tab cigecig_COcc prvalc_rBcc, mi colum row
tab cigecig_COcc prvalc_rBcc, colum row chi2
graph bar, over (cigecig_COcc) over (prvalc_rBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Prev alcohol use")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc prvalc_rBcc, obs count colum row percent

tab cigecig_COcc urb_COcc, mi colum row
tab cigecig_COcc urb_COcc, colum row chi2
graph bar, over (cigecig_COcc) over (urb_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Urbanicity")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc urb_COcc, obs count colum row percent

*tab cigecig_COcc risk_rcc, mi colum row (too many vals)
graph hbox risk_rcc, over(cigecig_COcc) ytitle("Risk taking")
graph hbar (mean) risk_rcc, over(cigecig_COcc)
*svy: tab cigecig_COcc risk_rcc, obs count colum row percent (too many vals)

tab cigecig_COcc avg_inpact_COcc, mi colum row
graph hbox avg_inpact_COcc, over(cigecig_COcc) ytitle("Avg in person activities days/wk")
graph hbar (mean) avg_inpact_COcc, over(cigecig_COcc)
svy: tab cigecig_COcc avg_inpact_COcc, obs count colum row percent

tab cigecig_COcc cogab_rcc, mi colum row
graph hbox cogab_rcc, over(cigecig_COcc) ytitle("Cog ability")
graph hbar (mean) cogab_rcc, over(cigecig_COcc)
svy: tab cigecig_COcc cogab_rcc, obs count colum row percent

tab cigecig_COcc sdqtotal_rnimpcc, mi colum row
graph hbox sdqtotal_rnimpcc, over(cigecig_COcc) ytitle("Mental health problems")
graph hbar (mean) sdqtotal_rnimpcc, over(cigecig_COcc)
svy: tab cigecig_COcc sdqtotal_rnimpcc, obs count colum row percent

tab cigecig_COcc cmage6_cc, mi colum row
graph hbox cmage6_cc, over(cigecig_COcc) ytitle("CM age")
graph hbar (mean) cmage6_cc, over(cigecig_COcc)
svy: tab cigecig_COcc cmage6_cc, obs count colum row percent

tab cigecig_COcc sibshh_cc, mi colum row
graph hbox sibshh_cc, over(cigecig_COcc) ytitle("Siblings in HH")
graph hbar (mean) sibshh_cc, over(cigecig_COcc)
svy: tab cigecig_COcc sibshh_cc, obs count colum row percent

tab cigecig_COcc mag12_r4Ccc, mi colum row
graph hbox mag12_r4Ccc, over(cigecig_COcc) ytitle("Mat age cm birth")
graph hbar (mean) mag12_r4Ccc, over(cigecig_COcc)
svy: tab cigecig_COcc mag12_r4Ccc, obs count colum row percent

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab cigecig_COcc imd_COcc, mi colum row
graph bar, over (cigecig_COcc) over (imd_COcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Area level deprivation")  ytitle("Percent") scale(*.5)
svy: tab cigecig_COcc imd_COcc, obs count colum row percent

********************************************************************************

*Outcomes and effect modifier 

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
tab smok_rBcc hied_COBcc, mi colum row
graph bar, over (smok_rBcc) over (hied_COBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
tab smok_rBcc hied_COBcc, colum row chi2
svy: tab smok_rBcc hied_COBcc, obs count colum row percent

tab ecig_rBcc hied_COBcc, mi colum row
graph bar, over (ecig_rBcc) over (hied_COBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
tab ecig_rBcc hied_COBcc, colum row chi2
svy: tab ecig_rBcc hied_COBcc, obs count colum row percent

tab cigecig_COcc hied_COBcc, mi colum row
graph bar, over (cigecig_COcc) over (hied_COBcc) stack asyvars percentage blabel(bar, color(white) position(inside) format(%4.2f)) bar(1, fcolor("106 208 200") lwidth(none)) bar(2, fcolor("118 152 160") lwidth(none)) b1title("Parental education")  ytitle("Percent") scale(*.5)
tab cigecig_COcc hied_COBcc, colum row chi2
svy: tab cigecig_COcc hied_COBcc, obs count colum row percent

********************************************************************************


********************************************************************************

*# Descriptives EM and interaction analysis (RO2)


********************************************************************************

**/survey weight: majority of weights <1 thus sum of weights will be less than count of participants. Weight 2 (UK whole country analysis) used as area level deprivation (IMD) not included in the model

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 
hist GOVWT2, bin(10)

**/outcome (0= never use or tried once/ 1= current or former user)
codebook smok_rBcc
tab smok_rBcc, mi
summarize smok_rBcc
ci means smok_rBcc
svy: mean smok_rBcc
estat sd 
svy, over(sex_rBcc): mean smok_rBcc

**/exposure - categorical
codebook smscq_r5Ccc
tab smscq_r5Ccc, mi 
summarize smscq_r5Ccc
ci means smscq_r5Ccc
svy: mean smscq_r5Ccc
estat sd 

**/confounders 
*unordered categorical
codebook eth_r6Ccc 
tab eth_r6Ccc, mi
summarize eth_r6Ccc
ci means eth_r6Ccc
svy: mean eth_r6Ccc
estat sd 

*ordered categorical- effect modifier (0= high parental ed/1= low parental ed)
codebook hied_COBcc 
tab hied_COBcc,mi
summarize hied_COBcc
ci means hied_COBcc
svy: mean hied_COBcc
estat sd 

*binary 
codebook sex_rBcc 
tab sex_rBcc, mi
summarize sex_rBcc
ci means sex_rBcc
svy: mean sex_rBcc
estat sd 

codebook parcursmk_CO2Ccc 
tab parcursmk_CO2Ccc, mi
summarize parcursmk_CO2Ccc
ci means parcursmk_CO2Ccc
svy: mean parcursmk_CO2Ccc
estat sd 

codebook parstyCOcc 
tab parstyCOcc, mi
summarize parstyCOcc
ci means parstyCOcc
svy: mean parstyCOcc
estat sd 

codebook prvcig_rBcc 
tab prvcig_rBcc, mi
summarize prvcig_rBcc
ci means prvcig_rBcc
svy: mean prvcig_rBcc
estat sd 

codebook anti_COccim 
tab anti_COccim, mi
summarize anti_COccim
ci means anti_COccim
svy: mean anti_COccim
estat sd 

codebook prvalc_rBcc 
tab prvalc_rBcc, mi
summarize prvalc_rBcc
ci means prvalc_rBcc
svy: mean prvalc_rBcc
estat sd 

codebook urb_COcc 
tab urb_COcc, mi
summarize urb_COcc
ci means urb_COcc
svy: mean urb_COcc
estat sd 

codebook cmage6_cc 
tab cmage6_cc, mi 
summarize cmage6_cc
ci means cmage6_cc
svy: mean cmage6_cc
estat sd
estat sd, var
histogram cmage6_cc [fw= int_GOVWT2], bin(20) normal
graph box cmage6_cc [pw=GOVWT2]

codebook mag12_r4Ccc
tab mag12_r4Ccc, mi 
summarize mag12_r4Ccc
ci means mag12_r4Ccc
svy: mean mag12_r4Ccc
estat sd
estat sd, var
histogram mag12_r4Ccc [fw= int_GOVWT2], bin(20) normal
graph box mag12_r4Ccc [pw=GOVWT2]

*continuous (freq weight (only integer values) created from sampling weight to generate histograms) for boxplots line represents median not the mean
gen int_GOVWT2 =int(GOVWT2)


codebook sibshh_cc 
tab sibshh_cc, mi
summarize sibshh_cc
ci means sibshh_cc
svy: mean sibshh_cc 
estat sd
estat sd, var
histogram sibshh_cc [fw= int_GOVWT2], bin(20) normal
graph box sibshh_cc [pw=GOVWT2]


codebook avg_inpact_COcc 
tab avg_inpact_COcc, mi
summarize avg_inpact_COcc
ci means avg_inpact_COcc
svy: mean avg_inpact_COcc 
estat sd
estat sd, var
histogram avg_inpact_COcc [fw= int_GOVWT2], bin(20) normal
graph box avg_inpact_COcc [pw=GOVWT2]

codebook cogab_rcc
tab  cogab_rcc, mi
summarize cogab_rcc
ci means cogab_rcc
svy: mean cogab_rcc
estat sd
estat sd, var
histogram cogab_rcc [fw= int_GOVWT2], bin(20) normal
graph box cogab_rcc [pw=GOVWT2]

codebook sdqtotal_rnimpcc 
tab sdqtotal_rnimpcc, mi 
summarize sdqtotal_rnimpcc
ci means sdqtotal_rnimpcc
svy: mean sdqtotal_rnimpcc
estat sd
estat sd, var
histogram sdqtotal_rnimpcc [fw= int_GOVWT2], bin(20) normal
graph box sdqtotal_rnimpcc [pw=GOVWT2]

codebook risk_rcc  
tab risk_rcc, mi
summarize risk_rcc
ci means risk_rcc
svy: mean risk_rcc
estat sd
estat sd, var
histogram risk_rcc [fw= int_GOVWT2], bin(20) normal
graph box risk_rcc [pw=GOVWT2]

********************************************************************************

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

svy: tab smscq_r5Ccc smok_rBcc, row per ci
tab smscq_r5Ccc smok_rBcc
svy: tab smscq_r5Ccc smok_rBcc, count

bysort hied_COBcc: tab smscq_r5Ccc smok_rBcc 
svy, subpop (if hied_COBcc==0):tab smscq_r5Ccc smok_rBcc, row per ci
svy, subpop (if hied_COBcc==1):tab smscq_r5Ccc smok_rBcc, row per ci
svy: mean smok_rBcc, over (smscq_r5Ccc hied_COBcc)

svy: tab eth_r6Ccc smok_rBcc, row per ci
tab eth_r6Ccc smok_rBcc
svy: tab eth_r6Ccc smok_rBcc, count

svy: tab hied_COBcc smok_rBcc, row per ci
tab hied_COBcc smok_rBcc
svy: tab hied_COBcc smok_rBcc, count 

svy: tab sex_rBcc smok_rBcc, row per ci
tab sex_rBcc smok_rBcc
svy: tab sex_rBcc smok_rBcc, count

svy: tab parcursmk_CO2Ccc smok_rBcc, row per ci
tab parcursmk_CO2Ccc smok_rBcc
svy: tab parcursmk_CO2Ccc smok_rBcc, count

svy: tab parstyCOcc smok_rBcc, row per ci
tab parstyCOcc smok_rBcc
svy: tab parstyCOcc smok_rBcc, count

svy: tab prvcig_rBcc smok_rBcc, row per ci
tab prvcig_rBcc smok_rBcc
svy: tab prvcig_rBcc smok_rBcc, count

svy: tab anti_COccim smok_rBcc, row per ci
tab anti_COccim smok_rBcc
svy: tab anti_COccim smok_rBcc, count

svy: tab prvalc_rBcc smok_rBcc, row per ci
tab prvalc_rBcc smok_rBcc
svy: tab prvalc_rBcc smok_rBcc, count

svy: tab urb_COcc smok_rBcc, row per ci
tab urb_COcc smok_rBcc
svy: tab urb_COcc smok_rBcc, count

svy: tab cmage6_cc smok_rBcc, row per ci
tab cmage6_cc smok_rBcc
svy: tab cmage6_cc smok_rBcc, count

svy: tab sibshh_cc smok_rBcc, row per ci
tab sibshh_cc smok_rBcc
svy: tab sibshh_cc smok_rBcc, count

svy: tab mag12_r4Ccc smok_rBcc, row per ci
tab mag12_r4Ccc smok_rBcc
svy: tab mag12_r4Ccc smok_rBcc, count 

svy: tab avg_inpact_COcc smok_rBcc, row per ci
tab avg_inpact_COcc smok_rBcc
svy: tab avg_inpact_COcc smok_rBcc, count 

svy: tab cogab_rcc smok_rBcc, row per ci
tab cogab_rcc smok_rBcc
svy: tab cogab_rcc smok_rBcc, count 

svy: tab sdqtotal_rnimpcc smok_rBcc, row per ci
tab sdqtotal_rnimpcc smok_rBcc
svy: tab sdqtotal_rnimpcc smok_rBcc, count

svy: tab risk_rcc smok_rBcc, row per ci
tab risk_rcc smok_rBcc
svy: tab risk_rcc smok_rBcc, count 


********************************************************************************

*do not save dataset


********************************************************************************