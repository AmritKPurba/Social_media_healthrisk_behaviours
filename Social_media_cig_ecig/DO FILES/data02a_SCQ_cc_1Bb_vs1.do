********************************************************************************
////Self-report complete case analysis: social media > e-cigarette use SAP 1Bb
********************************************************************************

/*
AK Purba [last updated 21.02.2023
Do file: data02a_SCQ_cc_1Bb_vs1.do
Dataset:  data01_SCQ_cc_vs1.dta

Syntax:
Social media and e-cigarette use - logistic regression
 */


********************************************************************************

clear all
version 17
macro drop _all
set linesize 80
set maxvar 100000
set scheme sj

use "Social_media_cig_ecig\DATASETS\data01_SCQ_cc_vs1.dta", clear
set seed 598370894

*Should say (data unchanged since 18jan2023 14:22)
datasignature confirm

/* Guidance documents 

https://www.youtube.com/watch?v=zTCd68CA6o8&ab_channel=MikeCrowson
https://www.stata.com/manuals/svy.pdf
https://www3.nd.edu/~rwilliam/stats/Margins01.pdf
https://www.sagepub.com/sites/default/files/upm-binaries/6428_Chapter_6_Lee_(Analyzing)_I_PDF_7.pdf
https://cls.ucl.ac.uk/wp-content/uploads/2017/07/User-Guide-to-Analysing-MCS-Data-using-Stata.pdf 
https://www.researchgate.net/post/Trend_tests_for_continuous_variable_in_conditional_logistic_regression_which_one_is_appropriate_Likelihood_ratio_test_or_Ward_test
https://www.stata.com/statalist/archive/2006-05/msg00813.html
https://www.researchgate.net/post/Which-trend-test-for-continuous-and-categorical-variables
https://www.statalist.org/forums/forum/general-stata-discussion/general/1511914-using-contrast-post-logistic-to-assess-linear-trend-response-to-a-reviewer
https://www.stata.com/statalist/archive/2006-05/msg00813.html
http://www.baileydebarmore.com/epicode/p-for-trend
*/
********************************************************************************

*# Check weights 

/*

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

The primary sampling unit (psu) variable is SPTN00
The weight (pweight) variables are GOVWT2 (whole UK analyses) and GOVWT1 (single country analysis)
The strata (strata) variable is PTTYPE2 
This dataset also has a finite population correction variable called fpc which is NH2


summarize GOVWT2

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      GOVWT2 |      6,234    .7781918    .6581029   .1369173   13.95083


summarize GOVWT1

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      GOVWT1 |      6,234    .7193276    .4387166    .140388   10.67736


summarize PTTYPE2

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
     PTTYPE2 |      6,234    3.516041    2.604495          1          9


summarize SPTN00 ***should this be 0??

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
      SPTN00 |          0


summarize NH2

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
         NH2 |      6,234    2186.804    2163.631        169       5289



*declare the survey design (using whole country analysis weight)

svyset [pweight=GOVWT2], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

Sampling weights: GOVWT2
             VCE: linearized
     Single unit: missing
        Strata 1: PTTYPE2
 Sampling unit 1: SPTN00
           FPC 1: NH2

svydescribe

Survey: Describing stage 1 sampling units

Sampling weights: GOVWT2
             VCE: linearized
     Single unit: missing
        Strata 1: PTTYPE2
 Sampling unit 1: SPTN00
           FPC 1: NH2

                                    Number of obs per unit
 Stratum   # units     # obs       Min      Mean       Max
----------------------------------------------------------
       1       110     1,936         2      17.6        72
       2        67     1,284         1      19.2        75
       3        19       500         2      26.3        64
       4        23       342         4      14.9        57
       5        50       676         3      13.5        94
       6        32       430         4      13.4        36
       7        30       349         4      11.6        34
       8        23       309         5      13.4        31
       9        40       408         2      10.2        20
----------------------------------------------------------
       9       394     6,234         1      15.8        94

9 strata, with 19 to 110 units in each strata, 394 in total


*declare the survey design (using single country analysis weight)

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

Sampling weights: GOVWT1
             VCE: linearized
     Single unit: missing
        Strata 1: PTTYPE2
 Sampling unit 1: SPTN00
           FPC 1: NH2

svydescribe

Survey: Describing stage 1 sampling units

Sampling weights: GOVWT1
             VCE: linearized
     Single unit: missing
        Strata 1: PTTYPE2
 Sampling unit 1: SPTN00
           FPC 1: NH2

                                    Number of obs per unit
 Stratum   # units     # obs       Min      Mean       Max
----------------------------------------------------------
       1       110     1,936         2      17.6        72
       2        67     1,284         1      19.2        75
       3        19       500         2      26.3        64
       4        23       342         4      14.9        57
       5        50       676         3      13.5        94
       6        32       430         4      13.4        36
       7        30       349         4      11.6        34
       8        23       309         5      13.4        31
       9        40       408         2      10.2        20
----------------------------------------------------------
       9       394     6,234         1      15.8        94

9 strata, with 19 to 110 units in each strata, 394 in total */


********************************************************************************

*# Vars used in analysis 

**/survey weight [C] majority of weights <1 thus sum of weights will be less than count of participants
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2) 
hist GOVWT1, bin(10)

**/outcome (0= never use or tried once/ 1= current or former user)
codebook ecig_rBcc
tab ecig_rBcc, mi
summarize ecig_rBcc
ci means ecig_rBcc
svy: mean ecig_rBcc
estat sd 
svy, over(sex_rBcc): mean ecig_rBcc

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

codebook famstr_r3Ccc 
tab famstr_r3Ccc, mi
summarize famstr_r3Ccc
ci means famstr_r3Ccc
svy: mean famstr_r3Ccc
estat sd 

*ordered categorical
codebook hhinc_r5Ccc 
tab hhinc_r5Ccc, mi
summarize hhinc_r5Ccc
ci means hhinc_r5Ccc
svy: mean hhinc_r5Ccc
estat sd 

codebook imd_COcc 
tab imd_COcc, mi
summarize imd_COcc
ci means imd_COcc
svy: mean imd_COcc
estat sd 

codebook hied_CO7Ccc 
tab hied_CO7Ccc,mi
summarize hied_CO7Ccc
ci means hied_CO7Ccc
svy: mean hied_CO7Ccc
estat sd 

codebook hiocc_CO6Ccc 
tab hiocc_CO6Ccc, mi
summarize hiocc_CO6Ccc
ci means hiocc_CO6Ccc
svy: mean hiocc_CO6Ccc
estat sd 

codebook cmage6_3Ccc 
tab cmage6_3Ccc, mi
summarize cmage6_3Ccc
ci means cmage6_3Ccc
svy: mean cmage6_3Ccc
estat sd 

codebook mag12_r4Ccc 
tab mag12_r4Ccc, mi
summarize mag12_r4Ccc
ci means mag12_r4Ccc
svy: mean mag12_r4Ccc
estat sd 

codebook sibshh_5Ccc
tab sibshh_5Ccc, mi
summarize sibshh_5Ccc
ci means sibshh_5Ccc
svy: mean sibshh_5Ccc
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

*continuous [C] freq weight (only integer values) created from sampling weight to generate histograms, for boxplots line represents median not the mean
gen int_GOVWT1 =int(GOVWT1)

codebook avg_inpact_COcc 
tab avg_inpact_COcc, mi
summarize avg_inpact_COcc
ci means avg_inpact_COcc
svy: mean avg_inpact_COcc 
estat sd
estat sd, var
histogram avg_inpact_COcc [fw= int_GOVWT1], bin(20) normal
graph box avg_inpact_COcc [pw=GOVWT1]

codebook cogab_rcc
tab  cogab_rcc, mi
summarize cogab_rcc
ci means cogab_rcc
svy: mean cogab_rcc
estat sd
estat sd, var
histogram cogab_rcc [fw= int_GOVWT1], bin(20) normal
graph box cogab_rcc [pw=GOVWT1]

codebook sdqtotal_rnimpcc 
tab sdqtotal_rnimpcc, mi 
summarize sdqtotal_rnimpcc
ci means sdqtotal_rnimpcc
svy: mean sdqtotal_rnimpcc
estat sd
estat sd, var
histogram sdqtotal_rnimpcc [fw= int_GOVWT1], bin(20) normal
graph box sdqtotal_rnimpcc [pw=GOVWT1]

codebook risk_rcc  
tab risk_rcc, mi
summarize risk_rcc
ci means risk_rcc
svy: mean risk_rcc
estat sd
estat sd, var
histogram risk_rcc [fw= int_GOVWT1], bin(20) normal
graph box risk_rcc [pw=GOVWT1]

**/dummy vars for IMD (all binary) [C] dummy vars and imd_COcc use single country weight 
codebook eng_D
tab eng_D, mi
summarize eng_D
ci means eng_D
svy: mean eng_D
estat sd 

codebook wales_D
tab wales_D, mi 
summarize wales_D
ci means wales_D
svy: mean wales_D
estat sd 

codebook scot_D
tab scot_D, mi
summarize scot_D
ci means scot_D
svy: mean scot_D
estat sd 

*reference cat
codebook ni_D 
tab ni_D, mi
summarize ni_D
ci means ni_D
svy: mean ni_D
estat sd 

********************************************************************************

svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

svy: tab smscq_r5Ccc ecig_rBcc, row per ci
tab smscq_r5Ccc ecig_rBcc
svy: tab smscq_r5Ccc ecig_rBcc, count

svy: tab eth_r6Ccc ecig_rBcc, row per ci
tab eth_r6Ccc ecig_rBcc
svy: tab eth_r6Ccc ecig_rBcc, count

svy: tab famstr_r3Ccc ecig_rBcc, row per ci
tab famstr_r3Ccc ecig_rBcc
svy: tab famstr_r3Ccc ecig_rBcc, count

svy: tab hhinc_r5Ccc ecig_rBcc, row per ci
tab hhinc_r5Ccc ecig_rBcc
svy: tab hhinc_r5Ccc ecig_rBcc, count

svy: tab imd_COcc ecig_rBcc, row per ci
tab imd_COcc ecig_rBcc
svy: tab imd_COcc ecig_rBcc, count

svy: tab hied_CO7Ccc ecig_rBcc, row per ci
tab hied_CO7Ccc ecig_rBcc
svy: tab hied_CO7Ccc ecig_rBcc, count 

svy: tab hiocc_CO6Ccc ecig_rBcc, row per ci
tab hiocc_CO6Ccc ecig_rBcc
svy: tab hiocc_CO6Ccc ecig_rBcc, count

svy: tab sex_rBcc ecig_rBcc, row per ci
tab sex_rBcc ecig_rBcc
svy: tab sex_rBcc ecig_rBcc, count

svy: tab parcursmk_CO2Ccc ecig_rBcc, row per ci
tab parcursmk_CO2Ccc ecig_rBcc
svy: tab parcursmk_CO2Ccc ecig_rBcc, count

svy: tab parstyCOcc ecig_rBcc, row per ci
tab parstyCOcc ecig_rBcc
svy: tab parstyCOcc ecig_rBcc, count

svy: tab prvcig_rBcc ecig_rBcc, row per ci
tab prvcig_rBcc ecig_rBcc
svy: tab prvcig_rBcc ecig_rBcc, count

svy: tab anti_COccim ecig_rBcc, row per ci
tab anti_COccim ecig_rBcc
svy: tab anti_COccim ecig_rBcc, count

svy: tab prvalc_rBcc ecig_rBcc, row per ci
tab prvalc_rBcc ecig_rBcc
svy: tab prvalc_rBcc ecig_rBcc, count

svy: tab urb_COcc ecig_rBcc, row per ci
tab urb_COcc ecig_rBcc
svy: tab urb_COcc ecig_rBcc, count

svy: tab cmage6_3Ccc smok_rBcc, row per ci
tab cmage6_3Ccc smok_rBcc
svy: tab cmage6_3Ccc smok_rBcc, count

svy: tab sibshh_5Ccc smok_rBcc, row per ci
tab sibshh_5Ccc smok_rBcc
svy: tab sibshh_5Ccc smok_rBcc, count

svy: tab mag12_r4Ccc smok_rBcc, row per ci
tab mag12_r4Ccc smok_rBcc
svy: tab mag12_r4Ccc smok_rBcc, count 

svy: tab avg_inpact_COcc ecig_rBcc, row per ci
tab avg_inpact_COcc ecig_rBcc
svy: tab avg_inpact_COcc ecig_rBcc, count 

svy: tab cogab_rcc ecig_rBcc, row per ci
tab cogab_rcc ecig_rBcc
svy: tab cogab_rcc ecig_rBcc, count 

svy: tab sdqtotal_rnimpcc ecig_rBcc, row per ci
tab sdqtotal_rnimpcc ecig_rBcc
svy: tab sdqtotal_rnimpcc ecig_rBcc, count

svy: tab risk_rcc ecig_rBcc, row per ci
tab risk_rcc ecig_rBcc
svy: tab risk_rcc ecig_rBcc, count 

svy: tab eng_D ecig_rBcc, row per ci
tab eng_D ecig_rBcc
svy: tab eng_D ecig_rBcc, count 

svy: tab wales_D ecig_rBcc, row per ci
tab wales_D ecig_rBcc
svy: tab wales_D ecig_rBcc, count 

svy: tab scot_D ecig_rBcc, row per ci
tab scot_D ecig_rBcc
svy: tab scot_D ecig_rBcc, count 

svy: tab ni_D ecig_rBcc, row per ci
tab ni_D ecig_rBcc
svy: tab ni_D ecig_rBcc, count 

********************************************************************************

//Initial test of model and troubleshooting 

********************************************************************************

/*  Declare survey design (single country analysis weight) */
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)

*# Run unweighted model (beta coefficients) using the logit command -1-<30 mins SM use as ref cat - top (hhinc_r5Ccc) used as ref cat - manag and profl (hied_CO7Ccc) used as ref cat - least deprived ( imd_COcc) used as ref cat : trouble shoot problems. [C] From the output we can see that ni_D is ommitted due to perfect collinearity. Dummy variables are variables that divide a categorical variable into all its values, minus one. One value is always left out in a regression analysis, as a reference category.
logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc  i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D i.ni_D ib10.imd_COcc, baselevel

*# ni_D used as reference category, remove this var and rerun analysis
logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, baselevel

*# We use dummy variables for country in our model to account for any variance in the measures used to assess IMD which may affect our estimates (remember we created a combined measure for IMD which combines all 4 IMD vars from each country). However we want to check if there is actually any variance between these countries which may affect our estimates. Multilevel model created, using country as a level. From the output we can see the variance is tiny, which suggests we dont even really need indicators for country, however will retain for now
use "Social_media_cig_ecig\DATASETS\data01_SCQ_cc_vs1.dta", clear
melogit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc ib10.imd_COcc || EACTRY00:

********************************************************************************

//Model testing 

********************************************************************************

*# Declare survey design 
svyset [pweight=GOVWT1], strata(PTTYPE2) psu(SPTN00) fpc(NH2)
svydescribe

*# Run the unweighted model using the logit command (obtaining ORs) -1-<30 mins SM as ref cat- no adjustment 
logit ecig_rBcc ib2.smscq_r5Ccc, or baselevels

*# Run the unweighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment [C] SM ORs increase following adjustment
logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel


*# Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment [C] SM ORs increase following adjustment
svy: logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

*# Run the weighted model (by sex subgroup) using the logit command (obtaining ORs)- 1-30 mins SM use as ref cat- adjustment -  sex_rBcc ommitted from the model. [C] From the outputs for females SM ORs appear smaller than for males, and are only significant for 2 hrs or more and 30min-<1hr vs 1-<30 mins whilst for males, all ORs are significant excluding No SM use vs 1-<30 mins.
*male=0 female=1
codebook sex_rBcc
svy, subpop (if sex_rBcc==1): logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

svy, subpop (if sex_rBcc==0): logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

********************************************************************************
//Post estimation commands for weighted adjusted model
********************************************************************************

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- unadjusted 
svy: logit ecig_rBcc ib2.smscq_r5Ccc, or baselevel

* Run the weighted model using the logit command (obtaining ORs)- 1-<30 mins SM use as ref cat- adjustment 
svy: logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

*Categorical vars overall significance in the model 
testparm i.smscq_r5Ccc
testparm i.eth_r6Ccc
testparm i.famstr_r3Ccc
testparm i.hhinc_r5Ccc
testparm i.hied_CO7Ccc
testparm i.hiocc_CO6Ccc
testparm i.imd_COcc
testparm i.cmage6_3Ccc
testparm i.sibshh_5Ccc 
testparm i.mag12_r4Ccc

*#Mean estimation
svy: mean ecig_rBcc i.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc i.hhinc_r5Ccc i.hied_CO7Ccc i.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D i.imd_COcc

*#SD estimation
estat sd

*#Generating Archer-Lemeshow test (goodness of fit test) which is a modification of the Hosmer-Lemeshow test that can be used with survey data.  non sig p value provides evidence of an adequately specified model 
svy: logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel
estat gof

*# Predictive margins 
margins i.smscq_r5Ccc, vce(unconditional)

*# Average marginal effects of these marginal probabilities
margins, vce(unconditional) dydx(i.smscq_r5Ccc)

*# Average adjusted predictions 
margins i.smscq_r5Ccc
marginsplot 
marginsplot , recast(line) recastci(rarea)

*# Check to see if SM should be treated as continuous or categorical and test for linear trend (1) using the log likelihood test and (2) using the contrast command

*(1)

*Treat SM as continuous 
logit ecig_rBcc c.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, nolog
est store m1

*Treat SM as categorical
logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, nolog
est store m2 

*LR/BIC/AIC tests 
lrtest m1 m2, stats

*# Eyeball results for weighted model using categorical SM use and continuous SM use and see how much results are affected
logit ecig_rBcc c.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel
logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

*(2) Test for linear trend 
svy: logit ecig_rBcc ib2.smscq_r5Ccc i.eth_r6Ccc i.famstr_r3Ccc ib5.hhinc_r5Ccc i.hied_CO7Ccc ib6.hiocc_CO6Ccc i.sex_rBcc i.parcursmk_CO2Ccc i.parstyCOcc i.prvcig_rBcc i.anti_COccim i.prvalc_rBcc i.urb_COcc  i.cmage6_3Ccc i.mag12_r4Ccc i.sibshh_5Ccc avg_inpact_COcc cogab_rcc sdqtotal_rnimpcc risk_rcc i.eng_D i.wales_D i.scot_D ib10.imd_COcc, or baselevel

contrast p.smscq_r5Ccc, noeffects

********************************************************************************



