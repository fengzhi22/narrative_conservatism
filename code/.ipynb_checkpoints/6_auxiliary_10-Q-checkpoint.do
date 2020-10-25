**************************************************************************************************************
************************************ Khan & Watts (2009) *****************************************************
**************************************************************************************************************

import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

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
quiet statsby _b _se, by(fyq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta,replace) : reg EARN NEG RET RET_SIZE RET_MTB RET_LEV RET_NEG RET_NEG_SIZE RET_NEG_MTB RET_NEG_LEV SIZE MTB LEV NEG_SIZE NEG_MTB NEG_LEV

****change names for MUs and LAMBDAs
use "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta", clear
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

save "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta", replace

****merge MUs and LAMBDAs to COMP_CRSP.dta
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.csv", case(preserve) stringcols(2) clear

** gen year-quarter indicator
drop if fqtr == "nan"
gen fyq = string(fyearq,"%02.0f") + fqtr

merge m:m fyq using "F:\github\narrative_conservatism\filings\crsp_comp_edgar_10-Q.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
drop _merge

****gen C_score and G_score
gen C_SCORE=lambda0+lambda1*SIZE+lambda2*MTB+lambda3*LEV
gen G_SCORE=mu0+mu1*SIZE+mu2*MTB+mu3*LEV
gen SUMCG=G_SCORE+C_SCORE

************************************************************************** Online Appendix. T3PB: summary statistics for C_SCORE and G_SCORE
tabstat C_SCORE G_SCORE EARN RET SIZE MTB LEV, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)

*****************************************************
********** TABLE 5: NC v.s. CCONS *******************
*****************************************************

**** TABLE 5: 10-Q NC for high v.s. low conditional conservatism obs.

**** Variable Creation
gen RET_NEG=RET*NEG
gen RET_CSCORE=RET*C_SCORE
gen NEG_CSCORE=NEG*C_SCORE
gen RET_NEG_CSCORE=RET*NEG*C_SCORE
gen SIZE_CSCORE=SIZE*C_SCORE
gen MTB_CSCORE=MTB*C_SCORE
gen LEV_CSCORE=LEV*C_SCORE

global fin_controls "SIZE MTB LEV SIZE_CSCORE MTB_CSCORE LEV_CSCORE"

**** Regressions

areg NW i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG RET_CSCORE NEG_CSCORE RET_NEG_CSCORE $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

****************************************************************************************
*********** TABLE 6: litigation, stock option grant and compensation *******************
****************************************************************************************

************************************************************************** Group observations according to their C_SCORE into 5 groups
xtile C_PCT = C_SCORE, n(5)