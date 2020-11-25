global fin_controls "SIZE MTB LEV"
global lit_controls "LNASSETS SG SKEW_RET STD_RET TURNOVER"
global abt_controls "EARN STD_RET STD_EARN AGE BUSSEG GEOSEG AF AFE"
global axy_controls "C_SCORE SEO_HIGH BLKSHVALSUM_HIGH LIT_HIGH"

**************************************************************************************************************
************************************ Khan & Watts (2009) *****************************************************
**************************************************************************************************************

* import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear
* import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear
import delimited "..\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

** gen year-quarter indicator
// tostring fqtr, replace
// drop if fqtr == "nan"
// gen fyq = string(fyearq,"%02.0f") + fqtr

** gen KW:SIZE MTB LEV interactions
// gen RET_NEG=RET*NEG
// gen RET_SIZE=RET*SIZE
// gen RET_MTB=RET*MTB
// gen RET_LEV=RET*LEV
// gen NEG_SIZE=NEG*SIZE
// gen NEG_MTB=NEG*MTB
// gen NEG_LEV=NEG*LEV
// gen RET_NEG_SIZE=RET*NEG*SIZE
// gen RET_NEG_MTB=RET*NEG*MTB
// gen RET_NEG_LEV=RET*NEG*LEV

** gen KW:SIZE MTB LEV interactions
gen DRET_BN=DRET*BN
gen DRET_SIZE=DRET*SIZE
gen DRET_MTB=DRET*MTB
gen DRET_LEV=DRET*LEV
gen BN_SIZE=BN*SIZE
gen BN_MTB=BN*MTB
gen BN_LEV=BN*LEV
gen DRET_BN_SIZE=DRET*BN*SIZE
gen DRET_BN_MTB=DRET*BN*MTB
gen DRET_BN_LEV=DRET*BN*LEV

*bysort sic fyearq: reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV, vce(robust)
*no sufficient observations per (sic_fyear) for regressions

****regress Fama-MacBeth and capture MUs and LAMBDAs
** by year-quarter
// quiet statsby _b _se, by(fyq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.dta, replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV

** by year
*quiet statsby _b _se, by(fyearq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.dta, replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV
*quiet statsby _b _se, by(fyearq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta, replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV
quiet statsby _b _se, by(fyearq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K.dta, replace) : reg EARN BN DRET DRET_SIZE DRET_MTB DRET_LEV DRET_BN DRET_BN_SIZE DRET_BN_MTB DRET_BN_LEV SIZE MTB LEV BN_SIZE BN_MTB BN_LEV

****change names for MUs and LAMBDAs
*use "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", clear
// use "..\filings\crsp_comp_edgar_10-Q.dta", clear
// rename _b_cons beta0
// rename _b_NEG beta2
// rename _b_RET mu0
// rename _b_RET_SIZE mu1
// rename _b_RET_MTB mu2
// rename _b_RET_LEV mu3
// rename _b_RET_NEG lambda0
// rename _b_RET_NEG_SIZE lambda1
// rename _b_RET_NEG_MTB lambda2
// rename _b_RET_NEG_LEV lambda3
// rename _b_SIZE gamma1
// rename _b_MTB gamma2
// rename _b_LEV gamma3
// rename _b_NEG_SIZE gamma4
// rename _b_NEG_MTB gamma5
// rename _b_NEG_LEV gamma6

use "..\filings\crsp_comp_edgar_8-K.dta", clear
rename _b_cons beta0
rename _b_BN beta2
rename _b_DRET mu0
rename _b_DRET_SIZE mu1
rename _b_DRET_MTB mu2
rename _b_DRET_LEV mu3
rename _b_DRET_BN lambda0
rename _b_DRET_BN_SIZE lambda1
rename _b_DRET_BN_MTB lambda2
rename _b_DRET_BN_LEV lambda3
rename _b_SIZE gamma1
rename _b_MTB gamma2
rename _b_LEV gamma3
rename _b_BN_SIZE gamma4
rename _b_BN_MTB gamma5
rename _b_BN_LEV gamma6
*************************************************************************************** Online Appendix. T2PA: Mean Coefficients from Fiscal Year-Quarterly Regressions
tabstat beta0 beta2 mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3 gamma1 gamma2 gamma3 gamma4 gamma5 gamma6, statistics(mean) format(%9.4f)
// tabstat _se_cons _se_NEG _se_RET _se_RET_SIZE _se_RET_MTB _se_RET_LEV _se_RET_NEG _se_RET_NEG_SIZE _se_RET_NEG_MTB _se_RET_NEG_LEV _se_SIZE _se_MTB _se_LEV _se_NEG_SIZE _se_NEG_MTB _se_NEG_LEV, statistics(mean) format(%9.4f)
tabstat _se_cons _se_BN _se_DRET _se_DRET_SIZE _se_DRET_MTB _se_DRET_LEV _se_DRET_BN _se_DRET_BN_SIZE _se_DRET_BN_MTB _se_DRET_BN_LEV _se_SIZE _se_MTB _se_LEV _se_BN_SIZE _se_BN_MTB _se_BN_LEV, statistics(mean) format(%9.4f)

*save "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", replace
*save "..\filings\crsp_comp_edgar_10-Q.dta", replace
save "..\filings\crsp_comp_edgar_8-k.dta", replace

****merge MUs and LAMBDAs to COMP_CRSP.dta
*import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear
*import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear
import delimited "..\filings\crsp_comp_edgar_8-k.csv", case(preserve) stringcols(2) clear

** gen year-quarter indicator
// tostring fqtr, replace
// drop if fqtr == "nan"
// gen fyq = string(fyearq,"%02.0f") + fqtr

// merge m:m fyq using "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)

*merge m:m fyearq using "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
*merge m:m fyearq using "..\filings\crsp_comp_edgar_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
merge m:m fyearq using "..\filings\crsp_comp_edgar_8-K.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
drop _merge

****gen C_score and G_score
gen C_SCORE=lambda0+lambda1*SIZE+lambda2*MTB+lambda3*LEV
gen G_SCORE=mu0+mu1*SIZE+mu2*MTB+mu3*LEV
gen SUMCG=G_SCORE+C_SCORE
************************************************************************** Online Appendix. T2PB: summary statistics for C_SCORE and G_SCORE
tabstat C_SCORE G_SCORE EARN RET SIZE MTB LEV, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)

*save "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", replace
*save "..\filings\crsp_comp_edgar_10-Q.dta", replace
save "..\filings\crsp_comp_edgar_8-K.dta", replace

************************************************************************** Construct dataset for stock option grants
import delimited "..\filings\execucomp.csv", case(preserve) stringcols(2) clear

rename GVKEY gvkey
rename YEAR fyearq

bysort gvkey fyearq: egen BLKSHVALSUM = sum(BLKSHVAL)
duplicates drop gvkey fyearq, force
keep gvkey fyearq BLKSHVAL BLKSHVALSUM
drop if BLKSHVALSUM <= 0

*merge 1:m gvkey fyearq using "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta"
*merge 1:m gvkey fyearq using "..\filings\crsp_comp_edgar_10-Q.dta"
merge 1:m gvkey fyearq using "..\filings\crsp_comp_edgar_8-K.dta"
drop if _merge == 1

*********************************** Creat high litigation industry dummy *******************************
gen LNASSETS=log(lag_atq)

gen LIT_HIGH = 0
replace LIT_HIGH = 1 if 2833 <= SIC & 2836 >= SIC | 8731 <= SIC & 8734 >= SIC | 3570 <= SIC & 3577 >= SIC | 7370 <= SIC & 7374 >= SIC | 3600 <= SIC & 3674 >= SIC | 5200 <= SIC & 5961 >= SIC
*bysort LIT_HIGH: summarize LIT_HIGH n_lit EARN RET SIZE MTB LEV

**** prob(LIT) following Kim and Skinner 2012 Model (2) p. 302
gen LIT = -7.718 + 0.18*LIT_HIGH + 0.463*LNASSETS + 0.553*LAG_SG - 0.498*RET - 0.359*SKEW_RET - 14.437*STD_RET + 0.0004*TURNOVER

*********************************** Create higher than 80% sstky dummy SEO_HIGH ************************
winsor2 sstky, cuts(1 99) replace
xtile SEO_HIGH = sstky, n(5)
replace SEO_HIGH = 0 if SEO_HIGH != 5
replace SEO_HIGH = 1 if SEO_HIGH == 5
 
************************************ Create higher than median BLKSHVALSUM dummy BLKSHVALSUM_HIGH ************************
winsor2 BLKSHVALSUM, cuts(1 99) replace
xtile BLKSHVALSUM_HIGH = BLKSHVALSUM, n(2)
replace BLKSHVALSUM_HIGH = 0 if  BLKSHVALSUM_HIGH == 1
replace BLKSHVALSUM_HIGH = 1 if  BLKSHVALSUM_HIGH == 2

*save "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", replace
*save "..\filings\crsp_comp_edgar_10-Q.dta", replace
save "..\filings\crsp_comp_edgar_8-K.dta", replace

*****************************************************
********** TABLE 5: NC v.s. CCONS *******************
*****************************************************

**** TABLE 5: 10-Q NC for high v.s. low conditional conservatism groups (below and above median)

**** Variable Creation
xtile C_PCT = C_SCORE, n(5)
xtile SIZE_PCT = SIZE, n(5)
xtile MTB_PCT = MTB, n(5)
xtile LEV_PCT = LEV, n(5)
xtile HHI_PCT = HHI, n(5)
xtile SG_PCT = SG, n(5)
xtile LIT_PCT = LIT, n(5)

// bysort C_PCT: summarize C_SCORE EARN RET SIZE MTB LEV

gen RET_NEG=RET*NEG

gen DRET_BN=DRET*BN

**** Regressions 10-Q: change to SIZE_PCT, MTB_PCT, LEV_PCT, HHI_PCT, SG_PCT and LIT_PCT to see level of NC across quantiles of different fundamental characteristics.
areg NW i.cquarter RET NEG RET_NEG if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", replace excel ctitle(NW_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** Regressions 8-K: change to SIZE_PCT, MTB_PCT, LEV_PCT, HHI_PCT, SG_PCT and LIT_PCT to see level of NC across quantiles of different fundamental characteristics.
areg NW i.cmonth DRET BN DRET_BN if SIZE_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", replace excel ctitle(NW_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if SIZE_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if SIZE_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if SIZE_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if SIZE_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN if SIZE_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if SIZE_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if SIZE_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if SIZE_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if SIZE_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN if SIZE_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if SIZE_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if SIZE_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if SIZE_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if SIZE_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

****************************************************************************************
************************ TABLE 6: MDA v.s. NOTES ***************************************
****************************************************************************************

import delimited "..\filings\crsp_comp_edgar_section.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG=RET*NEG

**** Regressions

areg NW_MDA i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", replace excel ctitle(NW_MDA) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW_NOTE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(NW_NOTE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE_MDA i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE_MDA) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE_NOTE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE_NOTE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

****************************************************************************************
*********** TABLE 8: SEO, stock option grant and litigation ****************************
****************************************************************************************

****************************** SEO **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", clear
drop SEO_HIGH
**** Variable Creation
gen RET_NEG=RET*NEG

drop if sstky < 0
drop if sstky == .

xtile SEO_HIGH = sstky, n(5)
bysort SEO_HIGH: summarize sstky EARN RET SIZE MTB LEV

drop if SEO_HIGH == 2 | SEO_HIGH == 3 | SEO_HIGH == 4 | SEO_HIGH == .

**** Regressions
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", replace excel ctitle(NW_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NW_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
test 1.SEO_HIGH#c.RET_NEG = 5.SEO_HIGH#c.RET_NEG
* outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter#i.SEO_HIGH) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TONE_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TONE_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
test 1.SEO_HIGH#c.RET_NEG = 5.SEO_HIGH#c.RET_NEG
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter#i.SEO_HIGH) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TLAG_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TLAG_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
test 1.SEO_HIGH#c.RET_NEG = 5.SEO_HIGH#c.RET_NEG
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter#i.SEO_HIGH) stats(coef tstat) adjr2

****************************** ST0CK OPTION GRANT **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", clear
drop BLKSHVALSUM_HIGH
*** compare option grants with high value with option grants with low value as benchmarked by the median of BLKSHVALSUM
gen RET_NEG=RET*NEG

drop if _merge != 3
xtile BLKSHVALSUM_HIGH = BLKSHVALSUM, n(2)
bysort BLKSHVALSUM_HIGH: summarize BLKSHVALSUM EARN RET SIZE MTB LEV
drop _merge

****** Regressions
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
test 1.BLKSHVALSUM_HIGH#c.RET_NEG = 2.BLKSHVALSUM_HIGH#c.RET_NEG

areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
test 1.BLKSHVALSUM_HIGH#c.RET_NEG = 2.BLKSHVALSUM_HIGH#c.RET_NEG

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
test 1.BLKSHVALSUM_HIGH#c.RET_NEG = 2.BLKSHVALSUM_HIGH#c.RET_NEG

****************************** LITIGATION **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", clear

**** Variable Creation
gen RET_NEG=RET*NEG
gen LITIGATION = n_lit/nw*1000

**** Regressions
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
test 1.LIT_HIGH#c.RET_NEG = 0.LIT_HIGH#c.RET_NEG

areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
test 1.LIT_HIGH#c.RET_NEG = 0.LIT_HIGH#c.RET_NEG

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
test 1.LIT_HIGH#c.RET_NEG = 0.LIT_HIGH#c.RET_NEG

// areg LITIGATION i.cquarter RET NEG RET_NEG $fin_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_8-Panel_C.xml", append excel ctitle(LITIGATION_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg LITIGATION i.cquarter RET NEG RET_NEG $fin_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_8-Panel_C.xml", append excel ctitle(LITIGATION_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

****************************************************************************************
**************************** TABLE 9: Time Trend ***************************************
****************************************************************************************
********************** 10-Q ************************
import delimited "..\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

**** variable creation ******
gen POST_FD = 1 if fyearq == 2001 | fyearq == 2002 | fyearq == 2003
replace POST_FD = 0 if fyearq == 1997 | fyearq == 1998 | fyearq == 1999

gen RET_NEG=RET*NEG

**** Time Trend Regressions
levelsof fyearq, local(levels) 
areg NW RET NEG RET_NEG if fyearq == 1993, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_10-Q.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
quiet areg NW RET NEG RET_NEG if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_10-Q.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TONE RET NEG RET_NEG if fyearq == 1993, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_10-Q.xml", replace excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
quiet areg TONE RET NEG RET_NEG if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_10-Q.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TLAG RET NEG RET_NEG if fyearq == 1993, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_10-Q.xml", replace excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
quiet areg TLAG RET NEG RET_NEG if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_10-Q.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

****************************************************************************************
********************* TABLE 9: Intangible Assets and R&D ******************************
****************************************************************************************
import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG=RET*NEG
* gen lintanq = log(intanq)
winsor2 intanq, cuts(1 99) replace
drop if intanq < 0
xtile INTAN = intanq, n(2)

winsor2 xrdq, cuts(1 99) replace
drop if xrdq < 0
xtile XRDQ = xrdq, n(2)

**** Regressions: intangible assets
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
test 1.INTAN#c.RET_NEG = 2.INTAN#c.RET_NEG

areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
test 1.INTAN#c.RET_NEG = 2.INTAN#c.RET_NEG

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if INTAN==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
test 1.INTAN#c.RET_NEG = 2.INTAN#c.RET_NEG

**** Regressions: R&D expenses
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
test 1.XRDQ#c.RET_NEG = 2.XRDQ#c.RET_NEG

areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
test 1.XRDQ#c.RET_NEG = 2.XRDQ#c.RET_NEG

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cquarter c.RET c.NEG c.RET_NEG c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
test 1.XRDQ#c.RET_NEG = 2.XRDQ#c.RET_NEG

****************************************************************************************
*********** Untabulated Robustness checks 10-Q *****************************************
****************************************************************************************

************************* Adding controls **********************************************
use "..\filings\crsp_comp_edgar_ibes_seg_10-Q.dta", clear

**** Variable Creation
gen LNASSETS=log(lag_atq)
gen RET_NEG=RET*NEG

**** UT_1
regress NW RET NEG RET_NEG $fin_controls $lit_controls $axy_controls
outreg2 using "..\output\UT_1.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $lit_controls $axy_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_1.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG $fin_controls $lit_controls $axy_controls
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $lit_controls $axy_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE_GI RET NEG RET_NEG $fin_controls $lit_controls $axy_controls
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE_GI i.cquarter RET NEG RET_NEG $fin_controls $lit_controls $axy_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE_HE RET NEG RET_NEG $fin_controls $lit_controls $axy_controls
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE_HE i.cquarter RET NEG RET_NEG $fin_controls $lit_controls $axy_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_1.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TLAG RET NEG RET_NEG $fin_controls $lit_controls $axy_controls
outreg2 using "..\output\UT_1.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $lit_controls $axy_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_1.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

************************* CFO: opposite results, even when using lag1_CFO, lag2_CFO and lag3_CFO **********************************************
// **** read id_crsp_comp_text_10-Q.csv
// import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear
//
// destring lag1_CFO lag2_CFO lag3_CFO, force replace
// **** Variable Creation
// * winsor2 RET, cuts(1 99) replace
// gen lag1_CFONEG = 0
// replace lag1_CFONEG = 1 if lag1_CFO < 0
// gen lag1_CFO_lag1_CFONEG = lag1_CFO*lag1_CFONEG
// * winsor2 lag1_CFO, cuts(1 99) replace
// summarize lag1_CFO, detail
// keep if inrange(lag1_CFO, r(p1), r(p99))
//
// **** UT_3
// // regress NW lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG
// // outreg2 using "..\output\UT_3", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg NW i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// // regress NW lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls $abt_controls
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg NW i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// // regress TONE lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TONE i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// // regress TONE lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls $abt_controls
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TONE i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// // regress TONE_GI lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls $abt_controls
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TONE_GI i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg TONE_GI i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// // regress TONE_HE lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls $abt_controls
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TONE_HE i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// areg TONE_HE i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// // regress TLAG lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TLAG i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// // regress TLAG lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls $abt_controls
// // outreg2 using "..\output\UT_3.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
// areg TLAG i.cquarter lag1_CFO lag1_CFONEG lag1_CFO_lag1_CFONEG $fin_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\UT_3.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2