// clear
// clear matrix
set maxvar 80000
global fin_controls "SIZE MTB LEV"

*****************************************************
**************** TABLE 4 - Panel A ******************
*****************************************************

**** TABLE 4 - Panel A: 8-K main results

**** read crsp_comp_edgar_8-K.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K_no_match.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen DRET_BN = DRET*BN
// winsor2 DRET, cuts(1 99)

**** Table 4: DRET main results
regress NW DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_4-Panel_A.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg NW i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

regress TONE DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg TONE i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

regress TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg TLAG i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_A.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

*****************************************************
************ Online Appendix: Table 2 ***************
*****************************************************

**** OAT_2: 8-K main results (TABLE 4) in restricted sample (TLAG <= 4 or item = 7.01 or 8.01)

**** read crsp_comp_edgar_8-K_restricted.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K_no_match.csv", case(preserve) stringcols(2) clear

// **** Drop obs. if is TLAG > 4 (after 20040823) or TLAG > 5 (before 20040823)
gen rp1 = date(rp,"YMD")
gen before2004=(rp1<date("August 23 2004","MDY"))
drop if before2004 == 1 & TLAG > 5
drop if before2004 == 0 & TLAG > 4

**** Variable Creation
gen DRET_BN = DRET*BN

regress NW DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_1.xml", replace excel ctitle(NW) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg NW i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

regress TONE DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg TONE i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

regress TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.fyearq DRET BN DRET_BN, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2
areg TLAG i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\OAT_1.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

*****************************************************
**************** TABLE 4 - Panel B ******************
*****************************************************

**** TABLE 4 - Panel B: nitem OLS; n8k, TLAG ordered logistics model 8-K_restricted

**** read crsp_comp_edgar_8-K.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K_no_match.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen DRET_BN = DRET*BN

**** TABLE 4 - Panel B: nitem OLS
// regress nitem DRET BN DRET_BN $fin_controls
// outreg2 using "..\output\Table_3-Panel_B.xml", replace excel ctitle(NITEM) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg nitem i.fyearq DRET BN DRET_BN $fin_controls, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_4-Panel_B.xml", replace excel ctitle(NITEM) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyearq) stats(coef tstat) adjr2

**** TABLE 4 - Panel B: n8k ordered logistics model 
ologit n8k DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_4-Panel_B.xml", append excel ctitle(N8K_OL) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) addstat(Pseudo R2, e(r2_p))

// **** Drop obs. if is TLAG > 4 (after 20040823) or TLAG > 5 (before 20040823)
gen rp1 = date(rp,"YMD")
gen before2004=(rp1<date("August 23 2004","MDY"))
drop if before2004 == 1 & TLAG > 5
drop if before2004 == 0 & TLAG > 4

**** TABLE 4 - Panel B: TLAG ordered logistics model 8-K_restricted

**** TLAG ordered logistic model
ologit TLAG DRET BN DRET_BN $fin_controls
outreg2 using "..\output\Table_4-Panel_B.xml", append excel ctitle(TLAG_OL) addtext(Year-month FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) addstat(Pseudo R2, e(r2_p))
