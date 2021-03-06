global fin_controls "SIZE MTB LEV"
global lit_controls "LNASSETS SG SKEW_DRET STD_DRET TURNOVER"
global abt_controls "EARN STD_EARN BUSSEG GEOSEG AF AFE"
global axy_controls "C_SCORE SEO_HIGH BLKSHVALSUM_HIGH LIT_HIGH"

*************************************************************************************
*************** Table 6: Voluntary v.s. Mandatory Disclosure Items ******************
*************************************************************************************

**** read crsp_comp_edgar_8-K.csv
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

**** VD: items 2.02 and 12 (results of operations and financial condition）, 7.01 and 9 (regulation FD disclosure) and 8.01 and 5 (other events)
gen vd = item_202 + item_12 + item_701 + item_9 + item_801 + item_5
gen VD = 0
replace VD = 1 if vd >= 1
drop vd

**** Table 6： Voluntary v.s. Mandatory Disclosure Items
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", replace excel ctitle(TLAG_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TLAG_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// reghdfe TLAG (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
// test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(TONE_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// reghdfe TONE (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
// test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NW_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NW_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// reghdfe NW (i.cmonth c.DRET c.BN c.DRET_BN)#i.VD, a(cik#i.VD) cluster(cik)
// test 1.VD#c.DRET_BN = 0.VD#c.DRET_BN

quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NITEM_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NITEM_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(N8K_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(N8K_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NEXHIBIT_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NEXHIBIT_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NGRAPH_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_6.xml", append excel ctitle(NGRAPH_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

*************************************************************************
****************** UT_5: 8-K Reg FD and Time Trend **********************
*************************************************************************
import delimited "..\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen POST_FD = 1 if fyearq == 2001 | fyearq == 2002 | fyearq == 2003
replace POST_FD = 0 if fyearq == 1997 | fyearq == 1998 | fyearq == 1999

// winsor2 DRET, cuts(1 99)
**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

**** Time Trend Regressions
levelsof fyearq, local(levels) 
areg NW DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_8-K.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg NW DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NW_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg N8K DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_N8K_8-K.xml", replace excel ctitle(N8K) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
foreach l of local levels {
capture noisily quiet areg N8K DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_N8K_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
}

levelsof fyearq, local(levels) 
areg NITEM DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NITEM_8-K.xml", replace excel ctitle(NITEM) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
foreach l of local levels {
capture noisily quiet areg NITEM DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NITEM_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
}

levelsof fyearq, local(levels) 
areg NEXHIBIT DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NEXHIBIT_8-K.xml", replace excel ctitle(NEXHIBIT) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg NEXHIBIT DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NEXHIBIT_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg NGRAPH DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NGRAPH_8-K.xml", replace excel ctitle(NGRAPH) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
foreach l of local levels {
capture noisily quiet areg NGRAPH DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_NGRAPH_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat)
}

levelsof fyearq, local(levels) 
areg TONE DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_8-K.xml", replace excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TONE DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TONE_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TLAG DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_8-K.xml", replace excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TLAG DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_5_TLAG_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
}

*************************************************************************
********************* UT_4: A priori bad news  **************************
*************************************************************************
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear

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

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

****************************** Regressions ****************************
areg TLAG i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", replace excel ctitle(TLAG_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TLAG i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TLAG_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
// ** Test RET_BN diff.
// reghdfe TLAG (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
// test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg TONE i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TONE_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TONE i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(TONE_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
// ** Test RET_BN diff.
// reghdfe TONE (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
// test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg NW i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NW_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NW i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NW_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
// ** Test RET_BN diff.
// reghdfe NW (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
// test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg N8K i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(N8K_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg N8K i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(N8K_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)

areg NITEM i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NITEM_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NITEM i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NITEM_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)

areg NEXHIBIT i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NEXHIBIT_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NEXHIBIT i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NEXHIBIT_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)

areg NGRAPH i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NGRAPH_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NGRAPH i.fyearq DRET BN DRET_BN $fin_controls $abt_controls if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\UT_4.xml", append excel ctitle(NGRAPH_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)

****************************************************************************************
********************* TABLE 7: Intangible Assets and R&D ******************************
****************************************************************************************
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

drop if intanq < 0
gen lintanq = log(1+intanq)
// summarize intanq, detail
// keep if inrange(intanq, r(p1), r(p99))
// winsor2 intanq, cuts(5 95) replace
xtile INTANQ = lintanq, n(2)
*replace INTANQ = 1 if missing(INTANQ)

drop if xrdq < 0
gen lxrdq = log(1+xrdq)
// summarize xrdq, detail
// keep if inrange(xrdq, r(p1), r(p99))
// winsor2 xrdq, cuts(5 95) replace
xtile XRDQ = lxrdq, n(2)
*replace XRDQ = 1 if missing(XRDQ)

**** Regressions: intangible assets
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", replace excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe TLAG (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
// test 1.INTAN#c.RET_BN = 2.INTAN#c.RET_BN

quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe TONE (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
// test 1.INTAN#c.RET_BN = 2.INTAN#c.RET_BN

quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe NW (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.INTAN, a(gvkey#i.INTAN) cluster(gvkey)
// test 1.INTAN#c.RET_BN = 2.INTAN#c.RET_BN

quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(N8K_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(N8K_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NITEM_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NITEM_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if INTANQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

**** Regressions: R&D expenses
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe TLAG (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
// test 1.XRDQ#c.RET_BN = 2.XRDQ#c.RET_BN

quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe TONE (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
// test 1.XRDQ#c.RET_BN = 2.XRDQ#c.RET_BN

quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test RET_BN diff.
// quiet reghdfe NW (i.cmonth c.RET c.BN c.RET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_RET c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.XRDQ, a(gvkey#i.XRDQ) cluster(gvkey)
// test 1.XRDQ#c.RET_BN = 2.XRDQ#c.RET_BN

quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(N8K_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(N8K_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NITEM_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NITEM_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
quiet areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if XRDQ==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_7.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

***********************************************************************************************************************
************************************* TABLE 8 & 9 & 11：Firm Characteristics - dataset ********************************
***********************************************************************************************************************

**************** Khan and Watts 2009 ***************************

import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear

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

****regress Fama-MacBeth and capture MUs and LAMBDAs
** by year
quiet statsby _b _se, by(fyearq) saving(F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_8-K.dta, replace) : reg EARN BN DRET DRET_SIZE DRET_MTB DRET_LEV DRET_BN DRET_BN_SIZE DRET_BN_MTB DRET_BN_LEV SIZE MTB LEV BN_SIZE BN_MTB BN_LEV

use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear
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
tabstat _se_cons _se_BN _se_DRET _se_DRET_SIZE _se_DRET_MTB _se_DRET_LEV _se_DRET_BN _se_DRET_BN_SIZE _se_DRET_BN_MTB _se_DRET_BN_LEV _se_SIZE _se_MTB _se_LEV _se_BN_SIZE _se_BN_MTB _se_BN_LEV, statistics(mean) format(%9.4f)

save "..\filings\crsp_comp_edgar_ibes_seg_8-k.dta", replace

****merge MUs and LAMBDAs to COMP_CRSP.dta
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-k.csv", case(preserve) stringcols(2) clear

merge m:m fyearq using "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", keepusing(mu0 mu1 mu2 mu3 lambda0 lambda1 lambda2 lambda3)
drop _merge

****gen C_score and G_score
gen C_SCORE=lambda0+lambda1*SIZE+lambda2*MTB+lambda3*LEV
gen G_SCORE=mu0+mu1*SIZE+mu2*MTB+mu3*LEV
gen SUMCG=G_SCORE+C_SCORE
************************************************************************** Online Appendix. T2PB: summary statistics for C_SCORE and G_SCORE
tabstat C_SCORE G_SCORE EARN RET SIZE MTB LEV, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)

save "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", replace

gen rdate = substr(rp, 1, 7)
gen date_key = date(rdate, "YM")
drop rdate
save "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", replace

************************************************************************** Construct dataset for institutional ownership (IO)
import delimited "..\filings\tr13f.csv", case(preserve) stringcols(2) clear
keep rdate cusip InstOwn InstOwn_HHI InstOwn_Perc
tostring rdate, replace
replace rdate = substr(rdate, 1, 6)
gen date_key = date(rdate, "YM")
rename InstOwn instown
rename InstOwn_HHI HHI
rename InstOwn_Perc instown_perc

merge 1:m cusip date_key using "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta"
drop if _merge == 1

replace instown_perc = instown/(lag_cshoq*10^6) if instown_perc==.
*drop if instown_perc==.
replace instown_perc = 1 if (instown_perc>1) & (_merge == 3)
drop _merge

save "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", replace

************************************************************************** Construct dataset for stock option grants
import delimited "..\filings\execucomp.csv", case(preserve) stringcols(2) clear

rename GVKEY gvkey
rename YEAR fyearq

bysort gvkey fyearq: egen BLKSHVALSUM = sum(BLKSHVAL)
duplicates drop gvkey fyearq, force
keep gvkey fyearq BLKSHVAL BLKSHVALSUM
drop if BLKSHVALSUM <= 0

merge 1:m gvkey fyearq using "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta"
drop if _merge == 1

*********************************** Creat high litigation industry dummy *******************************
gen LNASSETS=log(lag_atq)
destring LAG_SG, replace force

gen LIT_HIGH = 0
replace LIT_HIGH = 1 if 2833 <= SIC & 2836 >= SIC | 8731 <= SIC & 8734 >= SIC | 3570 <= SIC & 3577 >= SIC | 7370 <= SIC & 7374 >= SIC | 3600 <= SIC & 3674 >= SIC | 5200 <= SIC & 5961 >= SIC
*bysort LIT_HIGH: summarize LIT_HIGH n_lit EARN RET SIZE MTB LEV

**** prob(LIT) following Kim and Skinner 2012 Model (2) p. 302
*gen LIT = -7.718 + 0.18*LIT_HIGH + 0.463*LNASSETS + 0.553*LAG_SG - 0.498*RET - 0.359*SKEW_RET - 14.437*STD_RET + 0.0004*TURNOVER
gen LIT = -7.718 + 0.18*LIT_HIGH + 0.463*LNASSETS + 0.553*LAG_SG - 0.498*RET

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

save "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", replace

*****************************************************************************************************************
******************************** TABLE 11: Conditional Conservatism *********************************************
*****************************************************************************************************************
use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear

**** Variable Creation: high low CONS
xtile C_PCT = C_SCORE, n(2)

* bysort C_PCT: summarize C_SCORE EARN DRET SIZE MTB LEV

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

**** Regressions: high low CONS using 10-Q without controls
// reghdfe TLAG DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", replace excel ctitle(TLAG_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", replace excel ctitle(TLAG_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe TLAG DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe TONE DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe TONE DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe NW DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NW_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NW_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe NW DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NW_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NW_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe N8K DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(N8K_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe N8K DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(N8K_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe N8K DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(N8K_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe N8K DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(N8K_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe NITEM DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NITEM_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NITEM DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NITEM_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe NITEM DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NITEM_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NITEM DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NITEM_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe NEXHIBIT DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NEXHIBIT DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe NEXHIBIT DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NEXHIBIT DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// reghdfe NGRAPH DRET BN DRET_BN if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NGRAPH DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe NGRAPH DRET BN DRET_BN if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NGRAPH DRET BN DRET_BN $fin_controls $abt_controls if C_PCT == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

// **** Variable Creation: Triple Interactions with C_SCORE
// gen DRET_CSCORE=DRET*C_SCORE
// gen BN_CSCORE = BN*C_SCORE
// gen DRET_BN_CSCORE=DRET*BN*C_SCORE
//
// **** Regressions 10-Q: Triple Interactions with C_SCORE
// reghdfe NW DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", replace excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe NW DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE $fin_controls $abt_controls, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(NW) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
//
// reghdfe TONE DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe TONE DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE $fin_controls $abt_controls, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
//
// reghdfe TLAG DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
// reghdfe TLAG DRET BN C_SCORE DRET_CSCORE BN_CSCORE DRET_BN DRET_BN_CSCORE $fin_controls $abt_controls, a(gvkey i.cmonth) cluster(SIC)
// outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

*************************************************************************
********** TABLE 8: Firm Characteristics - regression *******************
*************************************************************************
use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear

**** Variable Creation
xtile C_PCT = C_SCORE, n(5)
xtile SIZE_PCT = SIZE, n(5)
xtile MTB_PCT = MTB, n(5)
xtile MTB_PCT = LEV, n(5)
xtile HHI_PCT = HHI, n(5)
xtile SG_PCT = SG, n(5)
xtile LIT_PCT = LIT, n(5)
xtile INST_PCT = instown_perc, n(5)

// bysort C_PCT: summarize C_SCORE EARN RET SIZE MTB LEV

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

**** Regressions 8-K: change to MTB_PCT, MTB_PCT, MTB_PCT, HHI_PCT, SG_PCT and LIT_PCT to see level of NC across quantiles of different fundamental characteristics.
areg NW i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", replace excel ctitle(NW_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NW_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg N8K i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(N8K_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(N8K_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(N8K_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(N8K_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(N8K_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg NITEM i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NITEM_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NITEM_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NITEM_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NITEM_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NITEM_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg NEXHIBIT i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NEXHIBIT_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NEXHIBIT_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NEXHIBIT_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NEXHIBIT_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NEXHIBIT_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg NGRAPH i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NGRAPH_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NGRAPH_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NGRAPH_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NGRAPH_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(NGRAPH_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TONE_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN if C_PCT==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if C_PCT==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if C_PCT==3, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if C_PCT==4, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN if C_PCT==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_8.xml", append excel ctitle(TLAG_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

****************************************************************************************
*********** TABLE 9: SEO, stock option grant and litigation ****************************
****************************************************************************************

****************************** SEO **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear
drop SEO_HIGH

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

drop if sstky < 0
drop if sstky == .

xtile SEO_HIGH = sstky, n(5)
bysort SEO_HIGH: summarize sstky EARN DRET SIZE MTB LEV

drop if SEO_HIGH == 2 | SEO_HIGH == 3 | SEO_HIGH == 4 | SEO_HIGH == .

**** Regressions
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", replace excel ctitle(NW_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NW_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe NW (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
* outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", replace excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(N8K_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(N8K_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe N8K (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NITEM_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NITEM_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe NITEM (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NEXHIBIT_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NEXHIBIT_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe NEXHIBIT (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NGRAPH_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(NGRAPH_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe NGRAPH (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TONE_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TONE_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe TONE (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TLAG_NO) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if SEO_HIGH==5, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_A.xml", append excel ctitle(TLAG_YES) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
** Test DRET_BN diff.
// reghdfe TLAG (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.SEO_HIGH, a(gvkey#i.SEO_HIGH) cluster(SIC)
// test 1.SEO_HIGH#c.DRET_BN = 5.SEO_HIGH#c.DRET_BN
*outreg2 using "..\output\Table_8-Panel_A_reghdfe.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth#i.SEO_HIGH) stats(coef tstat) adjr2

****************************** ST0CK OPTION GRANT **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear
drop BLKSHVALSUM_HIGH
*** compare option grants with high value with option grants with low value as benchmarked by the median of BLKSHVALSUM
**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

drop if _merge != 3
xtile BLKSHVALSUM_HIGH = BLKSHVALSUM, n(2)
bysort BLKSHVALSUM_HIGH: summarize BLKSHVALSUM EARN DRET SIZE MTB LEV
drop _merge

****** Regressions
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NW (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(N8K_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(N8K_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe N8K (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NITEM_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NITEM_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NITEM (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NEXHIBIT (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NGRAPH (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe TONE (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if BLKSHVALSUM_HIGH==2, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_B.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe TLAG (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.BLKSHVALSUM_HIGH, a(gvkey#i.BLKSHVALSUM_HIGH) cluster(SIC)
// test 1.BLKSHVALSUM_HIGH#c.DRET_BN = 2.BLKSHVALSUM_HIGH#c.DRET_BN

****************************** LITIGATION **************************************
use "..\filings\crsp_comp_edgar_ibes_seg_8-K.dta", clear

**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
replace NEXHIBIT = NEXHIBIT*-1
replace NGRAPH = NGRAPH*-1
replace NW = NW*-1
replace NITEM = NITEM*-1
replace N8K = N8K*-1
replace TLAG = TLAG*-1

**** Regressions
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NW (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(N8K_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg N8K i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(N8K_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe N8K (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NITEM_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NITEM i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NITEM_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NITEM (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NEXHIBIT i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NEXHIBIT (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NGRAPH i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe NGRAPH (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe TONE (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth DRET BN DRET_BN $fin_controls $abt_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9-Panel_C.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// ** Test DRET_BN diff.
// reghdfe TLAG (i.cmonth c.DRET c.BN c.DRET_BN c.SIZE c.MTB c.LEV c.EARN c.STD_EARN c.AGE c.BUSSEG c.GEOSEG c.AF c.AFE)#i.LIT_HIGH, a(gvkey#i.LIT_HIGH) cluster(gvkey)
// test 1.LIT_HIGH#c.DRET_BN = 0.LIT_HIGH#c.DRET_BN

// areg LITIGATION i.cmonth DRET BN DRET_BN $fin_controls if LIT_HIGH==0, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_8-Panel_C.xml", append excel ctitle(LITIGATION_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
// areg LITIGATION i.cmonth DRET BN DRET_BN $fin_controls if LIT_HIGH==1, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_8-Panel_C.xml", append excel ctitle(LITIGATION_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2