*************************************************************************************
*************** Table 6: Voluntary v.s. Mandatory Disclosure Items ******************
*************************************************************************************

**** read crsp_comp_edgar_8-K.csv
import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
// gen RET_BN = RET*BN
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN

**** VD: items 2.02 and 12 (results of operations and financial condition）, 7.01 and 9 (regulation FD disclosure) and 8.01 and 5 (other events)
gen vd = item_202 + item_12 + item_701 + item_9 + item_801 + item_5
gen VD = 0
replace VD = 1 if vd >= 1
drop vd

**** Table 6： Voluntary v.s. Mandatory Disclosure Items
quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", replace excel ctitle(NW_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NW_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe NW (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TONE (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TLAG_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TLAG_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test RET_NEG diff.
reghdfe TLAG (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

*************************************************************************
****************** UT_5: 8-K Reg FD and Time Trend *******************
*************************************************************************
import delimited "..\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** variable creation ******
gen POST_FD = 1 if fyearq == 2001 | fyearq == 2002 | fyearq == 2003
replace POST_FD = 0 if fyearq == 1997 | fyearq == 1998 | fyearq == 1999

gen DRET_BN=DRET*BN

**** Time Trend Regressions
levelsof fyearq, local(levels) 
areg NW DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_8-K.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg NW DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TONE DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_8-K.xml", replace excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TONE DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TLAG DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_8-K.xml", replace excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TLAG DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

*************************************************************************
********************* UT_4: A priori bad news  **************************
*************************************************************************
import delimited "..\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** variable creation ******
**** BN_ITEMS: items 1.02, 1.03, 2.04, 2.06, 3.01, 4.01, 4.02 (Segal and Segal 2016)
gen rp1 = date(rp,"YMD")
gen before2004=(rp1<date("August 23 2004","MDY"))
drop if before2004 == 1
gen bn = item_102 + item_103 + item_204 + item_206 + item_301 + item_401 + item_402
gen BN_ITEMS = 0
replace BN_ITEMS = 1 if bn >= 1
drop if bn == .
drop rp1 before2004 bn

gen DRET_BN=DRET*BN

****************************** Regressions ****************************
areg NW i.fyearq DRET BN DRET_BN if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", replace excel ctitle(NW_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NW i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NW_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe NW (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg TONE i.fyearq DRET BN DRET_BN if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TONE_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TONE i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TONE_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TONE (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg TLAG i.fyearq DRET BN DRET_BN if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TLAG_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TLAG i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TLAG_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TLAG (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN
