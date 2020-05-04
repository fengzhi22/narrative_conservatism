*****************************************************
******************** TABLE 2 ************************
*****************************************************

**** read id_crsp_comp_text_10-Q.csv
// import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG

**** Table 2: Main regressions
regress NW RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TLAG RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

***********************************************************************
********************* ABTONE ******************************************
***********************************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG = RET*NEG

*****************************************************
********************* TABLE 4 ***********************
*****************************************************

**** Table 4: TONE regressions (REPLICATION Huang et al. 2014 TABLE 1)
regress tone EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_4.xml", replace excel ctitle(tone) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2

areg tone i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_4.xml", append excel ctitle(tone) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

// regress TONE EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
// outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2
//
// areg TONE i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
********************* TABLE 5 ***********************
*****************************************************

**** Table 5: ABTONE main results (mine)

regress ABTONE RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_5.xml", replace excel ctitle(ABTONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg ABTONE i.cquarter RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(ABTONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
********************* TABLE 6 ***********************
*****************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_DA_10-Q.csv", case(preserve) stringcols(2) clear

**** Table 6: ABTONE main results (REPLICATION Huang et al. 2014 TABLE 4) NO DA
** ssc install reghdfe

reghdfe leap1_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", replace excel ctitle(EARN_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(EARN_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_EARN abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(EARN_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap1_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_CFO abtone DA EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Year-quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
********************* TABLE 8 ***********************
*****************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_BN = RET*BN
gen DRET_BN = DRET*BN

**** Table 8: DRET main results
regress NW DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_8.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TONE DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

regress TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2