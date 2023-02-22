# Social media and health-risk behaviours analytical code

## Summary
This README file describes the do files for:  
(1) The relationship between time spent on social media and adolescent use of cigarettes, e-cigarettes and dual-use: a longitudinal analysis of the UK Millennium Cohort Study  
(2) The relationship between time spent on social media and adolescent alcohol use : a longitudinal analysis of the UK Millennium Cohort Study

## Abbreviations
PE - Parental education  
RD - Risk difference  
Ref - Reference category
RERI - Relative excess risk due to interaction  
RR - Relative risk  
SCQ - Self-report     
SM - Social media  
TUD - Time use diary  

## The relationship between time spent on social media and adolescent use of cigarettes, e-cigarettes and dual-use: a longitudinal analysis of the UK Millennium Cohort Study

### Self-report complete case analyses

**Do file:** data02a_SCQ_cc_1Ba_vs1.do  
**Description:**   
Social media and cigarette use - logistic regression  

**Do file:** data02a_SCQ_cc_1Bb_vs1.do  
**Description:**   
Social media and e-cigarette use - logistic regression  

**Do file:** data02a_SCQ_cc_1Bc_vs1.do  
**Description:**   
Social media use and dual-use - multinomial logistic regression   

**Do file:** data02a_SCQ_cc_EMtable1a_vs1.do  
**Description:**   
Additive measures of effect modification (cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  

**Do file:** data02a_SCQ_cc_INtable4a_vs1.do  
**Description:**   
Additive measures of interaction (cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:** data02a_SCQ_cc_EMtable3a_vs1.do  
**Description:**   
Multiplicative measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  

**Do file:**  data02a_SCQ_cc_INtable6a_vs1.do  
**Description:**   
Multiplicative measures of interaction (cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:** data02a_SCQ_cc_EMtable7a_vs1.do  
**Description:**   
Additive measures of effect modification (e-cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  

**Do file:** data02a_SCQ_cc_INtable10a_vs1.do  
**Description:**   
Additive measures of interaction (e-cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:** data02a_SCQ_cc_EMtable9a_vs1.do   
**Description:**   
Multiplicative measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  

**Do file:** data02a_SCQ_cc_INtable12a_vs1.do  
**Description:**   
Multiplicative measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

### Self-report imputed analyses

**Do file:** data02a_SCQ_imp_1Aa_vs1.do  
**Description:**   
Social media and cigarette use - logistic regression   
Social media and cigarette use - logistic regression - additional adjustment for cigarette use (age 14)  
Social media and cigarette use - logistic regression - additional adjustment for previous social media use (age 11)  
Social media and cigarette use - logistic regression - use of 4-category social media variable + 3-category outcome variable  
Social media and cigarette use - logistic regression - change of ref cat to 'no social media use'   
Social media and cigarette use - logistic regression - by sex  

**Do file:**  data02a_SCQ_imp_1Ab_vs1.do  
**Description:**    
Social media and e-cigarette use - logistic regression   
Social media and e-cigarette use - logistic regression - additional adjustment for e-cigarette use (age 14)   
Social media and e-cigarette use - logistic regression - additional adjustment for previous social media use (age 11)  
Social media and e-cigarette use - logistic regression - use of 4-category social media variable + 3-category outcome variable  
Social media and e-cigarette use - logistic regression - change of ref cat to 'no social media use'   
Social media and e-cigarette use - logistic regression - by sex  

**Do file:**  data02a_SCQ_imp_1Ac_vs1.do   
**Description:**   
Social media and dual-use - multinomial logistic regression  
Social media and dual-use - multinomial logistic regression - additional adjustment for cigarette & e-cigarette use (age 14)  
Social media and dual-use - multinomial logistic regression - additional adjustment for previous social media use (age 11)  
Social media and dual-use - multinomial logistic regression - change of ref cat to 'no social media use'   
Social media and dual-use - multinomial logistic regression - by sex  

**Do file:**  data02a_SCQ_imp_EMtable1a4a_vs1.do   
**Description:**    
Additive measures of effect modification (cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:**   data02a_SCQ_imp_EMtable2a3a5a6a_vs1.do  
**Description:**   
Additive measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  
Additive measures of interaction (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:**   data02a_SCQ_imp_EMtable7a10a_vs1.do   
**Description:**   
Additive measures of effect modification (e-cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (e-cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:**  data02a_SCQ_imp_EMtable8a9a11a12a_vs1.do  
**Description:**  
Additive measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  
Additive measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  


### Time use diary complete case analyses

**Do file:** data02b_TUD_cc_2Ba_vs3.do  
**Description:**    
Social media and cigarette use - logistic regression   

**Do file:**  data02b_TUD_cc_2Bb_vs3.do  
**Description:**   
Social media and e-cigarette use - logistic regression  

**Do file:**  data02b_TUD_cc_2Bc_vs3.do  
**Description:**    
Social media and dual-use - multinomial logistic regression   

**Do file:**   data02b_TUD_cc_EMtable1a4a_vs3.do  
**Description:**  
Additive measures of effect modification (cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:**  data02b_TUD_cc_EMtable2a3a5a6a_vs3.do  
**Description:**   
Additive measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  
Additive measures of interaction (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:** data02b_TUD_cc_EMtable7a10a_vs3.do  
**Description:**   
Additive measures of effect modification (e-cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (e-cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:** data02b_TUD_cc_EMtable8a9a11a12a_vs3.do  
**Description:**   
Additive measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  
Additive measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  
  
### Time use diary imputed analyses

**Do file:**  data02b_TUD_imp_2Aa_vs1.do  
**Description:**      
Social media and cigarette use - logistic regression  
Social media and cigarette use - logistic regression - additional adjustment for cigarette use (age 14)  
Social media and cigarette use - logistic regression - additional adjustment for previous social media use (age 11)   
Social media and cigarette use - logistic regression - replacement of avg social media use with weekday social media use exposure variable  
Social media and cigarette use - logistic regression - by sex   

**Do file:**  data02b_TUD_imp_2Ab_vs1.do
**Description:**    
Social media and e-cigarette use - logistic regression
Social media and e-cigarette use - logistic regression - additional adjustment for e-cigarette use (age 14)   
Social media and e-cigarette use - logistic regression - additional adjustment for previous social media use (age 11)   
Social media and e-cigarette use - logistic regression - replacement of avg social media use with weekday social media use exposure variable  
Social media and e-cigarette use - logistic regression - by sex   

**Do file:**  data02b_TUD_imp_2Ac_vs1.do
**Description:**    
Social media and dual-use - multinomial logistic regression 
Social media and dual-use - multinomial logistic regression - additional adjustment for cigarette and e-cigarette use (age 14)   
Social media and dual-use - multinomial logistic regression - additional adjustment for previous social media use (age 11)   
Social media and dual-use - multinomial logistic regression - replacement of avg social media use with weekday social media use exposure variable
Social media and dual-use - multinomial logistic regression - by sex   

**Do file:**  data02b_TUD_imp_EMtable1a4a_vs1    
**Description:**     
Additive measures of effect modification (cigarette use) - Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (cigarette use) - Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:**  data02b_TUD_imp_EMtable2a3a5a6a_vs1.do    
**Description:**     
Additive measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)   
Additive measures of interaction (cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:**  data02b_TUD_imp_EMtable7a10a_vs1.do  
**Description:**     
Additive measures of effect modification (e-cigarette use)- Linear regression with robust standard errors (RD low PE-high PE)  
Additive measures of interaction (e-cigarette use)- Linear regression with robust standard errors (RD11-(RD10+RD01))  

**Do file:**  data02b_TUD_imp_EMtable8a9a11a12a_vs1.do  
**Description:**      
Additive measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of effect modification (e-cigarette use) - Poisson regression with robust standard errors (RR low PE/RR high PE)  
Additive measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Multiplicative measures of interaction (e-cigarette use) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

## The relationship between time spent on social media and adolescent alcohol use : a longitudinal analysis of the UK Millennium Cohort Study

### Self-report complete case analyses

**Do file:**  data03a_SCQ_cc_1B_vs1.do       
**Description:**     
Social media and binge drinking - logistic regression    
Social media and alc. freq. last month – multinomial regression    

**Do file:** data03a_SCQ_cc_EMtable3Ca3Da_vs1.do     
**Description:**   
Additive measure of effect modification (binge drinking) - Linear regression with robust standard errors (RD high PE-low PE)     
Additive measure of interaction (binge drinking) - Linear regression with robust standard errors (RD11-(RD10+RD01))    

**Do file:** data03a_SCQ_cc_EMtable3Cb3Db_vs1.do      
**Description:**    
Multiplicative measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RR high PE/RR low PE)     
Multiplicative measures of interaction (binge drinking) - Poisson regression with robust standard errors (RR11/RR10*RR01)     

**Do file:** data03a_SCQ_cc_EMtable3Cc3Dc_vs1.do      
**Description:**    
Additive measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)    
Additive measures of interaction (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)       

### Self-report imputed analyses

**Do file:**  data03a_SCQ_imp_1A_1C_1D_1F_1G_vs1.do      
**Description:**    
Social media and binge drinking – logistic regression    
Social media and alc. freq. last month – multinomial regression  
Social media and binge drinking – logistic regression –  change of ref cat to 'no social media use'   
Social media and alc. freq. last month – multinomial regression –  change of ref cat to 'no social media use'   
Social media and binge drinking – logistic regression – by sex    
Social media and alc. freq. last month – multinomial regression – by sex    
Social media and binge drinking – logistic regression – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)    
Social media and alc. freq. last month – multinomial regression – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)     
Social media and binge drinking – logistic regression – additional adjustment for previous social media use (age 11)    
Social media and alc. freq. last month – multinomial regression  – additional adjustment for social media use (age 11)     

**Do file:** data03a_SCQ_imp_EMtable3Aa3Ba_vs1.do    
**Description:**  
Additive measures of effect modification (binge drinking) - Linear regression with robust standard errors (RD high PE-low PE)  
Additive measures of interaction (binge drinking) - Linear regression with robust standard errors (RD11-(RD10+RD01))   

**Do file:** data03a_SCQ_imp_EMtable3Ab3Bb_vs1.do    
**Description:**  
Multiplicative measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RR high PE/RR low PE)   
Multiplicative measures of interaction (binge drinking) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:** data03a_SCQ_imp_EMtable3Ac3Bc.do    
**Description:**  
Additive measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Additive measures of interaction (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  

### Time use diary complete case analyses

**Do file:** data03b_TUD_cc_2B_vs1.do    
**Description:**   
Social media and binge drinking - logistic regression  
Social media and alc. freq. last month – multinomial regression  

**Do file:** data03b_TUD_cc_EMtable4Ca4Da_vs1.do    
**Description:**   
Additive measures of effect modification (binge drinking) - Linear regression with robust standard errors (RD high PE-low PE)   
Additive measures of interaction (binge drinking) - Linear regression with robust standard errors (RD11-(RD10+RD01))   

**Do file:** data03b_TUD_cc_EMtable4Cb4Db_vs1.do    
**Description:**   
Multiplicative measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RR high PE/RR low PE)  
Multiplicative measures of interaction (binge drinking) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:** data03b_TUD_cc_EMtable4Cc4Dc_vs1.do      
**Description:**   
Additive measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Additive measures of interaction (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  

### Time use diary imputed analyses

**Do file:** data03a_TUD_imp_2A_2C_2D_2E_2F_vs1.do    
**Description:**   
Social media and binge drinking – logistic regression   
Social media and alc. freq. last month – multinomial regression  
Social media weekday and binge drinking – logistic regression  
Social media weekday and alc. freq. last month – multinomial regression  
Social media and binge drinking – logistic regression – by sex  
Social media and alc. freq. last month – multinomial regression – by sex  
Social media and binge drinking – logistic regression – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)  
Social media and alc. freq. last month – multinomial regression – additional adjustment for ever binge drinking (age 14) and alc. freq. last year (age 14)  
Social media and binge drinking – logistic regression – additional adjustment for previous social media use (age 11)  
Social media and alc. freq. last month – multinomial regression – additional adjustment for previous social media use (age 11)     

**Do file:** data03a_data03a_TUD_imp_EMtable4Aa4Ba_vs1.do    
**Description:**   
Additive measures of effect modification (binge drinking) - Linear regression with robust standard errors (RD high PE-low PE)   
Additive measures of interaction (binge drinking) - Linear regression with robust standard errors (RD11-(RD10+RD01))   

**Do file:** data03a_TUD_imp_EMtable4Ab4Bb_vs1.do  
**Description:**   
Multiplicative measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RR high PE/RR low PE)   
Multiplicative measures of interaction (binge drinking) - Poisson regression with robust standard errors (RR11/RR10*RR01)  

**Do file:** data03a_TUD_imp_EMtable4Ac4Bc.do  
**Description:**  
Additive measures of effect modification (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)  
Additive measures of interaction (binge drinking) - Poisson regression with robust standard errors (RERI=RR11-RR01-RR10+1)   






