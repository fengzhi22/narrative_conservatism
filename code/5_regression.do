**** read id_crsp_comp_text_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Definition
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG

**** Table 2: Main regressions
regress NW RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", replace excel ctitle(NW) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) stats(coef tstat)

areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(NW) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) drop(i.cquarter) stats(coef tstat)

regress TONE RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) stats(coef tstat)

areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) drop(i.cquarter) stats(coef tstat)

regress TLAG RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) stats(coef tstat)

areg TLAG i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) drop(i.cquarter) stats(coef tstat)



