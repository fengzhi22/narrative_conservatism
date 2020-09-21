**************************************************************************************************************
************************************ Khan & Watts (2009) *****************************************************
**************************************************************************************************************

import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

** gen year-quarter indicator
drop if fqtr == "nan"
gen fyq = string(fyearq,"%02.0f") + fqtr

** gen KW:SIZE MTB LEV interactions
gen RET_NEG=RET*NEG
gen RET_SIZE=RET*SIZE
gen RET_MTB=RET*MTB
gen RET_LEV=RET*LEV
gen NEG_SIZE=NEG*SIZE
gen NEG_MTB=NEG*MTB
gen NEG_LEV=NEG*LEV
gen RET_NEG_SIZE=RET*NEG*SIZE
gen RET_NEG_MTB=RET*NEG*MTB
gen RET_NEG_LEV=RET*NEG*LEV

*bysort sic fyear: reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV, vce(robust)
*no sufficient observations per (sic_fyear) for regressions

****regress Fama-MacBeth and capture MUs and LAMBDAs
// quiet statsby _b _se, by(fyq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta, replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV

quiet statsby _b _se, by(fyearq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta, replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV

****change names for MUs and LAMBDAs
use "..\filings\crsp_comp_edgar_10-Q.dta", clear
rename _b_cons beta0
rename _b_NEG beta2
rename _b_RET mu0
rename _b_RET_SIZE mu1
rename _b_RET_MTB mu2
rename _b_RET_LEV mu3
rename _b_RET_NEG lambda0
rename _b_RET_NEG_SIZE lambda1
rename _b_RET_NEG_MTB lambda2
rename _b_RET_NEG_LEV lambda3
rename _b_SIZE gamma1
rename _b_MTB gamma2
rename _b_LEV gamma3
rename _b_NEG_SIZE gamma4
rename _b_NEG_MTB gamma5
rename _b_NEG_LEV gamma6
*************************************************************************************** Online Appendix. T3PA: Mean Coefficients from Fiscal Year-Quarterly Regressions
tabstat beta0 beta2 mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3 gamma1 gamma2 gamma3 gamma4 gamma5 gamma6, statistics(mean) format(%9.4f)
tabstat _se_cons _se_NEG _se_RET _se_RET_SIZE _se_RET_MTB _se_RET_LEV _se_RET_NEG _se_RET_NEG_SIZE _se_RET_NEG_MTB _se_RET_NEG_LEV _se_SIZE _se_MTB _se_LEV _se_NEG_SIZE _se_NEG_MTB _se_NEG_LEV, statistics(mean) format(%9.4f)

save "..\filings\crsp_comp_edgar_10-Q.dta", replace

****merge MUs and LAMBDAs to COMP_CRSP.dta
import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

** gen year-quarter indicator
drop if fqtr == "nan"
gen fyq = string(fyearq,"%02.0f") + fqtr

// merge m:m fyq using "..\filings\crsp_comp_edgar_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)

merge m:m fyearq using "..\filings\crsp_comp_edgar_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
drop _merge

erase "..\filings\crsp_comp_edgar_10-Q.dta"
****gen C_score and G_score
gen C_SCORE=lambda0+lambda1*SIZE+lambda2*MTB+lambda3*LEV
gen G_SCORE=mu0+mu1*SIZE+mu2*MTB+mu3*LEV
gen SUMCG=G_SCORE+C_SCORE

************************************************************************** Online Appendix. T3PB: summary statistics for C_SCORE and G_SCORE
tabstat C_SCORE G_SCORE EARN RET SIZE MTB LEV, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)

*****************************************************
********** TABLE 5: NC v.s. CCONS *******************
*****************************************************

**** TABLE 5: 10-Q NC for high v.s. low conditional conservatism groups (20% and 80%)

**** Variable Creation
xtile C_PCT = C_SCORE, n(5)
* sort C_PCT
* by C_PCT: summarize C_SCORE EARN RET SIZE MTB LEV
gen RET_NEG=RET*NEG
global fin_controls "SIZE MTB LEV"

areg NW i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==1, absorb(gvkey)
est store R_NW_PCT1
outreg2 using "..\output\Table_5.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==5, absorb(gvkey)
est store R_NW_PCT5
outreg2 using "..\output\Table_5.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==1, absorb(gvkey)
est store R_TONE_PCT1
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==5, absorb(gvkey)
est store R_TONE_PCT5
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==1, absorb(gvkey)
est store R_TLAG_PCT1
outreg2 using "..\output\Table_5.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if C_PCT==5, absorb(gvkey)
est store R_TLAG_PCT5
outreg2 using "..\output\Table_5.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

hausman R_NW_PCT1 R_NW_PCT5
hausman R_TONE_PCT1 R_TONE_PCT5
hausman R_TLAG_PCT1 R_TLAG_PCT5

// **** TABLE 5: 10-Q NC - triple interactions
//
// **** Variable Creation
// gen RET_NEG=RET*NEG
// gen RET_CSCORE=RET*C_SCORE
// gen NEG_CSCORE=NEG*C_SCORE
// gen RET_NEG_CSCORE=RET*NEG*C_SCORE
// gen SIZE_CSCORE=SIZE*C_SCORE
// gen MTB_CSCORE=MTB*C_SCORE
// gen LEV_CSCORE=LEV*C_SCORE
//
// global fin_controls "SIZE MTB LEV SIZE_CSCORE MTB_CSCORE LEV_CSCORE"
//
// **** Regressions
//
// areg NW i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_5.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// areg TONE i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// areg TLAG i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_5.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

****************************************************************************************
************************ TABLE 6: MDA v.s. NOTES ***************************************
****************************************************************************************

import delimited "..\filings\crsp_comp_edgar_section.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG=RET*NEG

global fin_controls "SIZE MTB LEV"

**** Regressions

areg NW_MDA i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
est store R_NW_MDA
outreg2 using "..\output\Table_6.xml", replace excel ctitle(NW_MDA) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg NW_NOTE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
est store R_NW_NOTE
outreg2 using "..\output\Table_6.xml", append excel ctitle(NW_NOTE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE_MDA i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
est store R_TONE_MDA
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_MDA) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE_NOTE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
est store R_TONE_NOTE
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_NOTE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** HAUSMAN TEST FOR COEFFICIENTS

areg NW_MDA i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey)
est store R_NW_MDA

areg NW_NOTE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey)
est store R_NW_NOTE

areg TONE_MDA i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey)
est store R_TONE_MDA

areg TONE_NOTE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey)
est store R_TONE_NOTE

hausman R_NW_NOTE R_NW_MDA
hausman R_TONE_NOTE R_TONE_MDA

****************************************************************************************
*********** TABLE 7: litigation, stock option grant and corporate transaction **********
****************************************************************************************

****************************** ST0CK OPTION GRANT **************************************

import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear
save "..\filings\crsp_comp_edgar_10-Q.dta"

import delimited "..\filings\execucomp.csv", case(preserve) stringcols(2) clear

rename GVKEY gvkey
rename YEAR fyearq

bysort gvkey fyearq: egen BLKSHVALSUM = sum(BLKSHVAL)
duplicates drop gvkey fyearq, force
keep gvkey fyearq BLKSHVAL BLKSHVALSUM
drop if BLKSHVALSUM <= 0

merge 1:m gvkey fyearq using "..\filings\crsp_comp_edgar_10-Q.dta"
erase "..\filings\crsp_comp_edgar_10-Q.dta"

**** Variable Creation
gen RET_NEG=RET*NEG
global fin_controls "SIZE MTB LEV"

// *** compare optgrant == 0 with optgrant == 1
// drop if _merge == 1
// gen OPTGRANT = 0
// replace OPTGRANT = 1 if _merge == 3
// bysort OPTGRANT: summarize BLKSHVALSUM EARN RET SIZE MTB LEV
//
// areg NW i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==1, absorb(gvkey)
// est store R_NW_YES
// outreg2 using "..\output\Table_8.xml", replace excel ctitle(NW_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg NW i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==0, absorb(gvkey)
// est store R_NW_NO
// outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// areg TONE i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==1, absorb(gvkey)
// est store R_TONE_YES
// outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg TONE i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==0, absorb(gvkey)
// est store R_TONE_NO
// outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==1, absorb(gvkey)
// est store R_TLAG_YES
// outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if OPTGRANT==0, absorb(gvkey)
// est store R_TLAG_NO
// outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// hausman R_NW_YES R_NW_NO
// hausman R_TONE_YES R_TONE_NO
// hausman R_TLAG_YES R_TLAG_NO

*** compare option grants with high value with option grants with low value as benchmarked by the median of BLKSHVALSUM
drop if _merge != 3
xtile BLKSHVALSUM_HIGH = BLKSHVALSUM, n(2)
bysort BLKSHVALSUM_HIGH: summarize BLKSHVALSUM EARN RET SIZE MTB LEV
drop _merge

areg NW i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_A.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** HAUSMAN TEST FOR COEFFICIENTS
quiet areg NW i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey)
est store R_NW_LOW
quiet areg NW i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey)
est store R_NW_HIGH
quiet areg TONE i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey)
est store R_TONE_LOW
quiet areg TONE i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey)
est store R_TONE_HIGH
quiet areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey)
est store R_TLAG_LOW
quiet areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey)
est store R_TLAG_HIGH

hausman R_NW_LOW R_NW_HIGH
hausman R_TONE_LOW R_TONE_HIGH
hausman R_TLAG_LOW R_TLAG_HIGH

****************************** SEO **************************************
import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG=RET*NEG
global fin_controls "SIZE MTB LEV"

drop if sstky < 0
drop if sstky == .

xtile SEO_HIGH = sstky, n(5)
bysort SEO_HIGH: summarize sstky EARN RET SIZE MTB LEV

**** Regressions
areg NW i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8-Panel_B.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** HAUSMAN TEST FOR COEFFICIENTS
quiet areg NW i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey)
est store R_NW_LOW
quiet areg NW i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey)
est store R_NW_HIGH
quiet areg TONE i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey)
est store R_TONE_LOW
quiet areg TONE i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey)
est store R_TONE_HIGH
quiet areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==1, absorb(gvkey)
est store R_TLAG_LOW
quiet areg TLAG i.cquarter RET NEG RET_NEG $fin_controls if SEO_HIGH==5, absorb(gvkey)
est store R_TLAG_HIGH

hausman R_NW_HIGH R_NW_LOW
hausman R_TONE_HIGH R_TONE_LOW
hausman R_TLAG_HIGH R_TLAG_LOW

