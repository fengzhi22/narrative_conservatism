*****************************************************
**************** TABLE 2 - Panel A ******************
*****************************************************

**** TABLE 2 - Panel A: 10-Q main results

**** read id_crsp_comp_text_10-Q.csv
// import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG

**** Table 2 - Panel A: Main regressions
regress NW RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2-Panel_A.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2-Panel_A.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TLAG RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

***********************************************************************
********************* ABTONE ******************************************
***********************************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG = RET*NEG

*****************************************************
*********** Online Appendix: Table 1 ****************
*****************************************************

**** OAT_1: TONE regressions (REPLICATION Huang et al. 2014 TABLE 1)
regress tone EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\OAT_1.xml", replace excel ctitle(tone) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2

areg tone i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(tone) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

// regress TONE EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
// outreg2 using "..\output\Table_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2
//
// areg TONE i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_3.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
**************** TABLE 2 - Panel B ******************
*****************************************************

**** TABLE 2 - Panel B: ABTONE main results

regress ABTONE RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_2-Panel_B.xml", replace excel ctitle(ABTONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg ABTONE i.cquarter RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2-Panel_B.xml", append excel ctitle(ABTONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_2-Panel_B.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2-Panel_B.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
************ Online Appendix: Table 2 ***************
*****************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_DA_10-Q.csv", case(preserve) stringcols(2) clear

**** OAT_2: REPLICATION Huang et al. 2014 TABLE 4
** ssc install reghdfe

reghdfe leap1_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", replace excel ctitle(EARN_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", append excel ctitle(EARN_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", append excel ctitle(EARN_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap1_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", append excel ctitle(CFO_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", append excel ctitle(CFO_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\OAT_2.xml", append excel ctitle(CFO_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
**************** TABLE 3 - Panel A ******************
*****************************************************

**** TABLE 3 - Panel A: 8-K main results

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_BN = RET*BN
gen DRET_BN = DRET*BN

**** Table 4: DRET main results
regress NW DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_3-Panel_A.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TONE DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

*****************************************************
************ Online Appendix: Table 3 ***************
*****************************************************

**** OAT_3: 8-K main results (TABLE 4) in restricted sample (TLAG <= 4 or item = 7.01 or 8.01)

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K_restricted.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_BN = RET*BN
gen DRET_BN = DRET*BN

regress NW DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_3.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_3.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TONE DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_3.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_3.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_3.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_3.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

*****************************************************
**************** TABLE 3 - Panel B ******************
*****************************************************

**** TABLE 3 - Panel B: 8-K TLAG in ordered logistics model

**** Drop obs. with TLAG > 4
drop if TLAG > 4

**** ordered logistic model
ologit TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_3-Panel_B.xml", append excel ctitle(TLAG_OL) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) addstat(Pseudo R2, e(r2_p))



**** ordered logistic with firm fixed effects; BSW 2011 (NECESSARY?)
// capture program drop feologit_buc
// program feologit_buc, eclass
// version 10
// gettoken gid 0: 0
// gettoken y x: 0
// tempvar iid id cid gidcid dk
// qui sum `y'
// local lk= r(min)
// local hk= r(max)
// bys `gid': gen `iid'=_n
// gen long `id'=`gid'*100+`iid'
// expand `=`hk'-`lk''
// bys `id': gen `cid'=_n
// qui gen long `gidcid'= `gid'*100+`cid'
// qui gen `dk'= `y'>=`cid'+1
// clogit `dk' `x', group(`gidcid') cluster(`gid')
// end
//
// feologit_buc cik TLAG DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_5.xml", append excel ctitle(TLAG_OL) addtext(Year-month FE, NO, Firm FE, YES, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) addstat(Pseudo R2, e(r2_p))