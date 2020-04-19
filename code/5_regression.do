*****************************************************
******************** TABLE 2 ************************
*****************************************************

**** read id_crsp_comp_text_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Definition
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG
gen TLAG_INV = -1*TLAG

**** Table 2: Main regressions
regress NW RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", replace excel ctitle(NW) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(NW) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TLAG_INV RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG_INV i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
********************* ABTONE ************************
*****************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Table 4: TONE regressions
regress tone EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_4.xml", replace excel ctitle(tone) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2

areg tone i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_4.xml", append excel ctitle(tone) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2