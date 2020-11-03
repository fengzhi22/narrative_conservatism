*****************************************************
**************** TABLE 7 - Panel A ******************
*****************************************************

**** Table 7 - Panel_A: Voluntary v.s. Mandatory Disclosure Items

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

**** Table 7 - Panel_A: Voluntary v.s. Mandatory Disclosure Items
areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", replace excel ctitle(NW_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", append excel ctitle(NW_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", append excel ctitle(TONE_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", append excel ctitle(TONE_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", append excel ctitle(TLAG_VD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_A.xml", append excel ctitle(TLAG_MD) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

quietly areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik)
est store R_NW_VD

quietly areg NW i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik)
est store R_NW_MD

quietly areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik)
est store R_TONE_VD

areg TONE i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik)
est store R_TONE_MD

quietly areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 1, absorb(cik) 
est store R_TLAG_VD

quietly areg TLAG i.cmonth DRET BN DRET_BN $fin_controls if VD == 0, absorb(cik)
est store R_TLAG_MD

hausman R_NW_MD R_NW_VD
hausman R_TONE_MD R_TONE_VD
hausman R_TLAG_MD R_TLAG_VD

*****************************************************
**************** TABLE 7 - Panel B ******************
*****************************************************

**** Table 7 - Panel_B: Disclosure features by items

**** Variable Creation for items before and after 2004
gen rp1 = date(rp,"YMD")
gen before2004=(rp1<date("August 23 2004","MDY"))
drop rp1

gen item_after_1 = item_101 + item_102 + item_103 + item_104
gen item_after_2 = item_201 + item_202 + item_203 + item_204 + item_205 + item_206
gen item_after_3 = item_301 + item_302 + item_303
gen item_after_4 = item_401 + item_402
gen item_after_5 = item_501 + item_502 + item_503 + item_504 + item_505 + item_506 + item_507 + item_508
gen item_after_6 = item_601 + item_602 + item_603 + item_604 + item_605
rename item_701 item_after_7
rename item_801 item_after_8
rename item_901 item_after_9

**** Triple interaction gets weird results, only adding item dummy as controls
// gen DRET_BN_item_1 = DRET_BN*item_1
// gen DRET_BN_item_2 = DRET_BN*item_2
// gen DRET_BN_item_3 = DRET_BN*item_3
// gen DRET_BN_item_4 = DRET_BN*item_4
// gen DRET_BN_item_5 = DRET_BN*item_5
// gen DRET_BN_item_6 = DRET_BN*item_6
// gen DRET_BN_item_7 = DRET_BN*item_7
// gen DRET_BN_item_8 = DRET_BN*item_8
// gen DRET_BN_item_9 = DRET_BN*item_9
// gen DRET_BN_item_10 = DRET_BN*item_10
// gen DRET_BN_item_11 = DRET_BN*item_11
// gen DRET_BN_item_12 = DRET_BN*item_12
//
// gen DRET_BN_item_after_1 = DRET_BN*item_after_1
// gen DRET_BN_item_after_2 = DRET_BN*item_after_2
// gen DRET_BN_item_after_3 = DRET_BN*item_after_3
// gen DRET_BN_item_after_4 = DRET_BN*item_after_4
// gen DRET_BN_item_after_5 = DRET_BN*item_after_5
// gen DRET_BN_item_after_6 = DRET_BN*item_after_6
// gen DRET_BN_item_after_7 = DRET_BN*item_after_7
// gen DRET_BN_item_after_8 = DRET_BN*item_after_8
// gen DRET_BN_item_after_9 = DRET_BN*item_after_9
//
// gen SIZE_item_1 = SIZE*item_1
// gen MTB_item_1 = MTB*item_1
// gen LEV_item_1 = LEV*item_1
// gen BN_item_1 = BN*item_1
// gen DRET_item_1 = DRET*item_1
// gen SIZE_item_2 = SIZE*item_2
// gen MTB_item_2 = MTB*item_2
// gen LEV_item_2 = LEV*item_2
// gen BN_item_2 = BN*item_2
// gen DRET_item_2 = DRET*item_2
// gen SIZE_item_3 = SIZE*item_3
// gen MTB_item_3 = MTB*item_3
// gen LEV_item_3 = LEV*item_3
// gen BN_item_3 = BN*item_3
// gen DRET_item_3 = DRET*item_3
// gen SIZE_item_4 = SIZE*item_4
// gen MTB_item_4 = MTB*item_4
// gen LEV_item_4 = LEV*item_4
// gen BN_item_4 = BN*item_4
// gen DRET_item_4 = DRET*item_4
// gen SIZE_item_5 = SIZE*item_5
// gen MTB_item_5 = MTB*item_5
// gen LEV_item_5 = LEV*item_5
// gen BN_item_5 = BN*item_5
// gen DRET_item_5 = DRET*item_5
// gen SIZE_item_6 = SIZE*item_6
// gen MTB_item_6 = MTB*item_6
// gen LEV_item_6 = LEV*item_6
// gen BN_item_6 = BN*item_6
// gen DRET_item_6 = DRET*item_6
// gen SIZE_item_7 = SIZE*item_7
// gen MTB_item_7 = MTB*item_7
// gen LEV_item_7 = LEV*item_7
// gen BN_item_7 = BN*item_7
// gen DRET_item_7 = DRET*item_7
// gen SIZE_item_8 = SIZE*item_8
// gen MTB_item_8 = MTB*item_8
// gen LEV_item_8 = LEV*item_8
// gen BN_item_8 = BN*item_8
// gen DRET_item_8 = DRET*item_8
// gen SIZE_item_9 = SIZE*item_9
// gen MTB_item_9 = MTB*item_9
// gen LEV_item_9 = LEV*item_9
// gen BN_item_9 = BN*item_9
// gen DRET_item_9 = DRET*item_9
// gen SIZE_item_10 = SIZE*item_10
// gen MTB_item_10 = MTB*item_10
// gen LEV_item_10 = LEV*item_10
// gen BN_item_10 = BN*item_10
// gen DRET_item_10 = DRET*item_10
// gen SIZE_item_11 = SIZE*item_11
// gen MTB_item_11 = MTB*item_11
// gen LEV_item_11 = LEV*item_11
// gen BN_item_11 = BN*item_11
// gen DRET_item_11 = DRET*item_11
// gen SIZE_item_12 = SIZE*item_12
// gen MTB_item_12 = MTB*item_12
// gen LEV_item_12 = LEV*item_12
// gen BN_item_12 = BN*item_12
// gen DRET_item_12 = DRET*item_12
//
// gen SIZE_item_after_1 = SIZE*item_after_1
// gen MTB_item_after_1 = MTB*item_after_1
// gen LEV_item_after_1 = LEV*item_after_1
// gen BN_item_after_1 = BN*item_after_1
// gen DRET_item_after_1 = DRET*item_after_1
// gen SIZE_item_after_2 = SIZE*item_after_2
// gen MTB_item_after_2 = MTB*item_after_2
// gen LEV_item_after_2 = LEV*item_after_2
// gen BN_item_after_2 = BN*item_after_2
// gen DRET_item_after_2 = DRET*item_after_2
// gen SIZE_item_after_3 = SIZE*item_after_3
// gen MTB_item_after_3 = MTB*item_after_3
// gen LEV_item_after_3 = LEV*item_after_3
// gen BN_item_after_3 = BN*item_after_3
// gen DRET_item_after_3 = DRET*item_after_3
// gen SIZE_item_after_4 = SIZE*item_after_4
// gen MTB_item_after_4 = MTB*item_after_4
// gen LEV_item_after_4 = LEV*item_after_4
// gen BN_item_after_4 = BN*item_after_4
// gen DRET_item_after_4 = DRET*item_after_4
// gen SIZE_item_after_5 = SIZE*item_after_5
// gen MTB_item_after_5 = MTB*item_after_5
// gen LEV_item_after_5 = LEV*item_after_5
// gen BN_item_after_5 = BN*item_after_5
// gen DRET_item_after_5 = DRET*item_after_5
// gen SIZE_item_after_6 = SIZE*item_after_6
// gen MTB_item_after_6 = MTB*item_after_6
// gen LEV_item_after_6 = LEV*item_after_6
// gen BN_item_after_6 = BN*item_after_6
// gen DRET_item_after_6 = DRET*item_after_6
// gen SIZE_item_after_7 = SIZE*item_after_7
// gen MTB_item_after_7 = MTB*item_after_7
// gen LEV_item_after_7 = LEV*item_after_7
// gen BN_item_after_7 = BN*item_after_7
// gen DRET_item_after_7 = DRET*item_after_7
// gen SIZE_item_after_8 = SIZE*item_after_8
// gen MTB_item_after_8 = MTB*item_after_8
// gen LEV_item_after_8 = LEV*item_after_8
// gen BN_item_after_8 = BN*item_after_8
// gen DRET_item_after_8 = DRET*item_after_8
// gen SIZE_item_after_9 = SIZE*item_after_9
// gen MTB_item_after_9 = MTB*item_after_9
// gen LEV_item_after_9 = LEV*item_after_9
// gen BN_item_after_9 = BN*item_after_9
// gen DRET_item_after_9 = DRET*item_after_9

global item_before "item_1 item_2 item_3 item_4 item_5 item_6 item_7 item_8 item_9 item_10 item_11 item_12"
global item_after "item_after_1 item_after_2 item_after_3 item_after_4 item_after_5 item_after_6 item_after_7 item_after_8 item_after_9"

// global DRET_BN_item_before "DRET_BN_item_1 DRET_BN_item_2 DRET_BN_item_3 DRET_BN_item_4 DRET_BN_item_5 DRET_BN_item_6 DRET_BN_item_7 DRET_BN_item_8 DRET_BN_item_9 DRET_BN_item_10 DRET_BN_item_11 DRET_BN_item_12"
// global DRET_BN_item_after "DRET_BN_item_after_1 DRET_BN_item_after_2 DRET_BN_item_after_3 DRET_BN_item_after_4 DRET_BN_item_after_5 DRET_BN_item_after_6 DRET_BN_item_after_7 DRET_BN_item_after_8 DRET_BN_item_after_9"
// global item_before_controls "SIZE_item_1 MTB_item_1 LEV_item_1 BN_item_1 DRET_item_1 SIZE_item_2 MTB_item_2 LEV_item_2 BN_item_2 DRET_item_2 SIZE_item_3 MTB_item_3 LEV_item_3 BN_item_3 DRET_item_3 SIZE_item_4 MTB_item_4 LEV_item_4 BN_item_4 DRET_item_4 SIZE_item_5 MTB_item_5 LEV_item_5 BN_item_5 DRET_item_5 SIZE_item_6 MTB_item_6 LEV_item_6 BN_item_6 DRET_item_6 SIZE_item_7 MTB_item_7 LEV_item_7 BN_item_7 DRET_item_7 SIZE_item_8 MTB_item_8 LEV_item_8 BN_item_8 DRET_item_8 SIZE_item_9 MTB_item_9 LEV_item_9 BN_item_9 DRET_item_9 SIZE_item_10 MTB_item_10 LEV_item_10 BN_item_10 DRET_item_10 SIZE_item_11 MTB_item_11 LEV_item_11 BN_item_11 DRET_item_11 SIZE_item_12 MTB_item_12 LEV_item_12 BN_item_12 DRET_item_12"
// global item_after_controls "SIZE_item_after_1 MTB_item_after_1 LEV_item_after_1 BN_item_after_1 DRET_item_after_1 SIZE_item_after_2 MTB_item_after_2 LEV_item_after_2 BN_item_after_2 DRET_item_after_2 SIZE_item_after_3 MTB_item_after_3 LEV_item_after_3 BN_item_after_3 DRET_item_after_3 SIZE_item_after_4 MTB_item_after_4 LEV_item_after_4 BN_item_after_4 DRET_item_after_4 SIZE_item_after_5 MTB_item_after_5 LEV_item_after_5 BN_item_after_5 DRET_item_after_5 SIZE_item_after_6 MTB_item_after_6 LEV_item_after_6 BN_item_after_6 DRET_item_after_6 SIZE_item_after_7 MTB_item_after_7 LEV_item_after_7 BN_item_after_7 DRET_item_after_7 SIZE_item_after_8 MTB_item_after_8 LEV_item_after_8 BN_item_after_8 DRET_item_after_8 SIZE_item_after_9 MTB_item_after_9 LEV_item_after_9 BN_item_after_9 DRET_item_after_9"

// areg NW i.cmonth DRET BN DRET_BN $DRET_BN_item_before $item_before $fin_controls $item_before_controls if before2004 == 1, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_B.xml", replace excel ctitle(NW_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_before_controls) stats(coef tstat) adjr2
// areg NW i.cmonth DRET BN DRET_BN $DRET_BN_item_after $item_after $fin_controls $item_after_controls if before2004 == 0, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_C.xml", replace excel ctitle(NW_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_after_controls) stats(coef tstat) adjr2
// areg TONE i.cmonth DRET BN DRET_BN $DRET_BN_item_before $item_before $fin_controls $item_before_controls if before2004 == 1, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TONE_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_before_controls) stats(coef tstat) adjr2
// areg TONE i.cmonth DRET BN DRET_BN $DRET_BN_item_after $item_after $fin_controls $item_after_controls if before2004 == 0, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_C.xml", append excel ctitle(TONE_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_after_controls) stats(coef tstat) adjr2
// areg TLAG i.cmonth DRET BN DRET_BN $DRET_BN_item_before $item_before $fin_controls $item_before_controls if before2004 == 1, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TLAG_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_before_controls) stats(coef tstat) adjr2
// areg TLAG i.cmonth DRET BN DRET_BN $DRET_BN_item_after $item_after $fin_controls $item_after_controls if before2004 == 0, absorb(cik) cluster(SIC)
// outreg2 using "..\output\Table_7-Panel_C.xml", append excel ctitle(TLAG_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth $fin_controls $item_after_controls) stats(coef tstat) adjr2

areg NW i.cmonth $item_before DRET $fin_controls if before2004 == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", replace excel ctitle(NW_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg NW i.cmonth $item_after DRET $fin_controls if before2004 == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(NW_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth $item_before DRET $fin_controls if before2004 == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TONE_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TONE i.cmonth $item_after DRET $fin_controls if before2004 == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TONE_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth $item_before DRET $fin_controls if before2004 == 1, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TLAG_BEFORE) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2
areg TLAG i.cmonth $item_after DRET $fin_controls if before2004 == 0, absorb(cik) cluster(SIC)
outreg2 using "..\output\Table_7-Panel_B.xml", append excel ctitle(TLAG_AFTER) addtext(Year-month FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cmonth) stats(coef tstat) adjr2

*************************************************************************
********************** 8-K Reg FD and Time Trend ************************
*************************************************************************
import delimited "..\filings\crsp_comp_edgar_8-K.csv", case(preserve) stringcols(2) clear

**** variable creation ******
gen POST_FD = 1 if fyearq == 2001 | fyearq == 2002 | fyearq == 2003
replace POST_FD = 0 if fyearq == 1997 | fyearq == 1998 | fyearq == 1999

gen DRET_BN=DRET*BN

**** Time Trend Regressions
levelsof fyearq, local(levels) 
areg NW DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_NW_8-K.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg NW DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_NW_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TONE DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_TONE_8-K.xml", replace excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TONE DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_TONE_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

levelsof fyearq, local(levels) 
areg TLAG DRET BN DRET_BN if fyearq == 1994, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_TLAG_8-K.xml", replace excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
foreach l of local levels {
capture noisily quiet areg TLAG DRET BN DRET_BN if fyearq == `l', absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_9_TLAG_8-K.xml", append excel ctitle(`l') addtext(Year-quarter FE, NO, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2
}

****************************** REG FD ****************************
areg NW i.fyearq DRET BN DRET_BN if POST_FD==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", replace excel ctitle(NW_BEFORE) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NW i.fyearq DRET BN DRET_BN if POST_FD==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", append excel ctitle(NW_AFTER) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe NW (i.fyearq c.DRET c.BN c.DRET_BN)#i.POST_FD, a(gvkey#i.POST_FD) cluster(gvkey)
test 1.POST_FD#c.DRET_BN = 0.POST_FD#c.DRET_BN

areg TONE i.fyearq DRET BN DRET_BN if POST_FD==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", append excel ctitle(TONE_BEFORE) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TONE i.fyearq DRET BN DRET_BN if POST_FD==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", append excel ctitle(TONE_AFTER) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TONE (i.fyearq c.DRET c.BN c.DRET_BN)#i.POST_FD, a(gvkey#i.POST_FD) cluster(gvkey)
test 1.POST_FD#c.DRET_BN = 0.POST_FD#c.DRET_BN

areg TLAG i.fyearq DRET BN DRET_BN if POST_FD==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", append excel ctitle(TLAG_BEFORE) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TLAG i.fyearq DRET BN DRET_BN if POST_FD==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10_8-K.xml", append excel ctitle(TLAG_AFTER) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TLAG (i.fyearq c.DRET c.BN c.DRET_BN)#i.POST_FD, a(gvkey#i.POST_FD) cluster(gvkey)
test 1.POST_FD#c.DRET_BN = 0.POST_FD#c.DRET_BN

*************************************************************************
************************* A priori bad news  ****************************
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
outreg2 using "..\output\Table_11.xml", replace excel ctitle(NW_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg NW i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(NW_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe NW (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg TONE i.fyearq DRET BN DRET_BN if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TONE i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TONE_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TONE (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN

areg TLAG i.fyearq DRET BN DRET_BN if BN_ITEMS==0, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG_NO) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
areg TLAG i.fyearq DRET BN DRET_BN if BN_ITEMS==1, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_11.xml", append excel ctitle(TLAG_YES) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2 drop(i.fyearq)
** Test RET_NEG diff.
reghdfe TLAG (i.fyearq c.DRET c.BN c.DRET_BN)#i.BN_ITEMS, a(gvkey#i.BN_ITEMS) cluster(gvkey)
test 1.BN_ITEMS#c.DRET_BN = 0.BN_ITEMS#c.DRET_BN
