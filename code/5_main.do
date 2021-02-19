**** Variable Creation
global fin_controls "SIZE MTB LEV"
global lit_controls "LNASSETS SG SKEW_RET STD_RET TURNOVER"
global abt_controls_8k "EARN STD_EARN BUSSEG GEOSEG AF AFE"
global abt_controls "EARN STD_RET STD_EARN AGE BUSSEG GEOSEG AF AFE"

*****************************************************
**************** TABLE 3 - Panel A ******************
*****************************************************

**** TABLE 3 - Panel A: 10-Q main results

**** read id_crsp_comp_text_10-Q.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
* winsor2 RET, cuts(1 99) replace
gen RET_NEG = RET*NEG
replace NW = NW*-1
**** Table 3 - Panel A: Main regressions

// regress NW RET NEG RET_NEG
// outreg2 using "..\output\Table_3-Panel_A.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// regress NW RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

// regress TONE RET NEG RET_NEG
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// regress TONE RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

******************************************************* GI and Henry dictionaries *****************************************
// regress TONE_GI RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE_GI i.cquarter RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE_GI i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_GI) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

// regress TONE_HE RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE_HE i.cquarter RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE_HE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TONE_HE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
******************************************************* GI and Henry dictionaries *****************************************

// regress TLAG RET NEG RET_NEG
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
// regress TLAG RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

********************************** UT_6: ASYMMETRIC PERSISTENCE RESULTS: CHANGE RET TO LAGN_RET AND NEG TO LAGN_NEG, OR ADD $LAG_CONTROLS*********************

**** read id_crsp_comp_text_10-Q.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
* winsor2 RET, cuts(1 99) replace
gen RET_NEG = RET*NEG
replace NW = NW*-1
replace LAG1_NW = LAG1_NW*-1
replace LAG2_NW = LAG2_NW*-1
replace LAG3_NW = LAG3_NW*-1

gen LAG1_NW_NEG = LAG1_NW*NEG
gen LAG1_TONE_NEG = LAG1_TONE*NEG
gen LAG1_TLAG_NEG = LAG1_TLAG*NEG

gen LAG2_NW_NEG = LAG2_NW*NEG
gen LAG2_TONE_NEG = LAG2_TONE*NEG
gen LAG2_TLAG_NEG = LAG2_TLAG*NEG

gen LAG3_NW_NEG = LAG3_NW*NEG
gen LAG3_TONE_NEG = LAG3_TONE*NEG
gen LAG3_TLAG_NEG = LAG3_TLAG*NEG

** LAG1
areg NW i.cquarter LAG1_NW NEG LAG1_NW_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter LAG1_TONE NEG LAG1_TONE_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter LAG1_TLAG NEG LAG1_TLAG_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** LA2
areg NW i.cquarter LAG2_NW NEG LAG2_NW_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter LAG2_TONE NEG LAG2_TONE_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter LAG2_TLAG NEG LAG2_TLAG_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
** LAG3
areg NW i.cquarter LAG3_NW NEG LAG3_NW_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TONE i.cquarter LAG3_TONE NEG LAG3_TONE_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
areg TLAG i.cquarter LAG3_TLAG NEG LAG3_TLAG_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_6.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

correlate NW LAG1_NW LAG2_NW LAG3_NW
correlate TONE LAG1_TONE LAG2_TONE LAG3_TONE
correlate TLAG LAG1_TLAG LAG2_TLAG LAG3_TLAG

***********************************************************************
********************* Readability *************************************
***********************************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG = RET*NEG
gen RET_NW = RET*NW
gen NW_NEG = NW*NEG
gen RET_NEG_NW = RET*NEG*NW
replace NW = NW*-1

*****************************************************
**************** TABLE 3 - Panel B ******************
*****************************************************

**** TABLE 3 - Panel B: ABTONE main results

// areg ABTONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_3-Panel_B.xml", replace excel ctitle(ABTONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
//
// areg TONE i.cquarter RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_3-Panel_B.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg READ i.cquarter NW RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_B.xml", replace excel ctitle(READ) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg READ i.cquarter NW RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_B.xml", append excel ctitle(READ) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg READ i.cquarter NW RET NEG RET_NEG NW_NEG RET_NW RET_NEG_NW, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_B.xml", append excel ctitle(READ) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

areg READ i.cquarter NW RET NEG RET_NEG NW_NEG RET_NW RET_NEG_NW $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_3-Panel_B.xml", append excel ctitle(READ) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
**************** TABLE 4 - Panel A ******************
*****************************************************

**** TABLE 4 - Panel A: 8-K main results

**** read crsp_comp_edgar_8-K.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear
// import delimited "..\filings\crsp_comp_edgar_8-K4.csv", case(preserve) stringcols(2) clear
// import delimited "..\filings\crsp_comp_edgar_8-K2.csv", case(preserve) stringcols(2) clear

// **** Robustness: excluding results of operations
// drop if item_12 >= 1
// drop if item_202 >= 1

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
gen NEXHIBIT = -log(1+nexhibit)
gen NGRAPH = -log(1+ngraph)
replace NW = NW*-1
replace nitem = -log(1+nitem)
replace n8k = -log(1+n8k)
replace TLAG = -log(1+TLAG)

***** adjust for outliers
drop if nexhibit == 149

**** Table 4: DRET main results
// regress NW DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress NW DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress n8k DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(N8K) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg n8k i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(N8K) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress n8k DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(N8K) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg n8k i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(N8K) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress nitem DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NITEM) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg nitem i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NITEM) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress nitem DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NITEM) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg nitem i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NITEM) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress NEXHIBIT DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NEXHIBIT) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress NEXHIBIT DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress NGRAPH DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NGRAPH) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress NGRAPH DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress TONE DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress TONE DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress TLAG DRET BN DRET_BN
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// regress TLAG DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

********************************** limit to 8-Ks with only 1 or 2 items
areg NW i.cmonth DRET BN DRET_BN if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", replace excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if nitem <= 2, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A_2items.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

*****************************************************
************ Online Appendix: Table 2 ***************
*****************************************************

**** OAT_2: 8-K main results (TABLE 4) in restricted sample (TLAG <= 4 after 2004 or TLAG <= 5 before 2004)

**** read crsp_comp_edgar_8-K_restricted.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear
// import delimited "..\filings\crsp_comp_edgar_8-K4.csv", case(preserve) stringcols(2) clear
// import delimited "..\filings\crsp_comp_edgar_8-K2.csv", case(preserve) stringcols(2) clear

// **** Drop obs. if is TLAG > 4 (after 20040823) or TLAG > 5 (before 20040823)
gen rp1 = date(rp,"YMD")
gen before2004=(rp1<date("August 23 2004","MDY"))
drop if before2004 == 1 & TLAG > 5
drop if before2004 == 0 & TLAG > 4
drop rp1

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
gen NEXHIBIT = -log(1+nexhibit)
gen NGRAPH = -log(1+ngraph)
replace NW = NW*-1
replace nitem = -log(1+nitem)
replace n8k = -log(1+n8k)
replace TLAG = -log(1+TLAG)

// regress NW DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", replace excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress n8k DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(n8k) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg n8k i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(n8k) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg n8k i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(n8k) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress nitem DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(nitem) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg nitem i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(nitem) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg nitem i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(nitem) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress NEXHIBIT DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NEXHIBIT) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress NGRAPH DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NGRAPH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress TONE DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

// regress TLAG DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls_8k, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2