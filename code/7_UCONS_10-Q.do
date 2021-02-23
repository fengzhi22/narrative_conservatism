global fin_controls "SIZE MTB LEV"
global lit_controls "LNASSETS SG SKEW_RET STD_RET TURNOVER"
global abt_controls "EARN STD_EARN BUSSEG GEOSEG AF AFE"
global axy_controls "C_SCORE SEO_HIGH BLKSHVALSUM_HIGH LIT_HIGH"

*****************************************************************
********** Merge splticrm with comp_y; Predict S&P rating *******
*****************************************************************

******** Prepare merge splticrm
import delimited "..\filings\splticrm.csv", clear
tostring datadate, replace
gen cdate = substr(datadate,1,6)
drop tic
sort splticrm
gen rating = 1 if splticrm == "AAA"
replace rating = 2 if splticrm == "AA+"
replace rating = 3 if splticrm == "AA"
replace rating = 4 if splticrm == "AA-"
replace rating = 5 if splticrm == "A+"
replace rating = 6 if splticrm == "A"
replace rating = 7 if splticrm == "A-"
replace rating = 8 if splticrm == "BBB+"
replace rating = 9 if splticrm == "BBB"
replace rating = 10 if splticrm == "BBB-"
replace rating = 11 if splticrm == "BB+"
replace rating = 12 if splticrm == "BB"
replace rating = 13 if splticrm == "BB-"
replace rating = 14 if splticrm == "B+"
replace rating = 15 if splticrm == "B"
replace rating = 16 if splticrm == "B-"
replace rating = 17 if splticrm == "CCC+"
replace rating = 18 if splticrm == "CCC"
replace rating = 19 if splticrm == "CCC-"
replace rating = 20 if splticrm == "CC+"
replace rating = 21 if splticrm == "CC"
replace rating = 22 if splticrm == "CC-"
replace rating = 23 if splticrm == "C+"
replace rating = 24 if splticrm == "C"
replace rating = 25 if splticrm == "C-"
replace rating = 26 if splticrm == "D"
drop if (missing(splticrm) | missing(rating))
bysort rating: count

save "..\filings\splticrm.dta", replace

******** Prepare merge comp_y
import delimited "..\filings\compustat_y.csv", clear
tostring datadate, replace
gen cdate = substr(datadate,1,6)
// tostring cdate, replace
// replace cdate = date(datadate, "YM")

sort gvkey cdate
quietly bysort gvkey cdate:  gen dup = cond(_N==1,0,_n)
egen rowmiss = rowmiss(act-ipodate)
bysort dup: summarize rowmiss
drop if dup>1
drop dup rowmiss

** merge splticrm and comp_y
merge 1:1 gvkey cdate using "..\filings\splticrm.dta"
erase "..\filings\splticrm.dta"

drop if _merge == 2
drop cdate _merge

******** Variable Creation
drop if (missing(dvc) | missing(ds) | missing(ib))
gen lat = log(at)
gen roa = ib/at
gen lev = (dlc+dltt)/at
gen div = (dvc>0)
gen subdebt = (ds>0)
gen loss = (ib<0)

winsor2 roa lev, cuts(1 99) replace

******** Regression and Prediction
xtset gvkey fyear
xtreg rating i.fyear i.sic lat roa lev div subdebt loss
*areg rating i.fyear lat roa lev div subdebt loss, absorb(sic)
predict rating_fit, xb
replace rating_fit = round(rating_fit)
replace rating_fit = 1 if rating_fit < 1
replace rating_fit = 26 if rating_fit > 26

replace rating = rating_fit if rating == .

save "..\filings\rating.dta", replace

******** Merge: TNIC3HHI + rating (Yearly)
import delimited "..\filings\TNIC3HHIdata.txt", encoding(Big5) clear 
rename year fyear
save "..\filings\TNIC3HHIdata.dta", replace

use "..\filings\rating.dta", clear
merge 1:1 gvkey fyear using "..\filings\TNIC3HHIdata.dta"
drop if _merge == 2
drop _merge

rename fyear fyearq
keep gvkey fyearq rating tnic3hhi
save "..\filings\RATE+TNIC3HHI.dta", replace
erase "..\filings\TNIC3HHIdata.dta"
erase "..\filings\rating.dta"

*****************************************************************
****************** Merge macroeconomic variables ****************
*****************************************************************

******** Merge: CSI + Inflation + S&P index (Monthly)
*** CSI
import delimited "..\filings\tbmics.csv", clear 
tostring yyyy, replace
gen date = yyyy + month
gen date_ym = date(date, "YM")
format date_ym %td
rename ics_all CSI
keep CSI date_ym
save "..\filings\CSI.dta", replace

*** INFLATION
import delimited "..\filings\cpi.csv", encoding(ISO-8859-2) clear 
replace date = substr(date,1,7)
tostring date, replace
gen date_ym = date(date, "YM")
format date_ym %td
rename cpiaucsl CPI
gen lCPI = CPI[_n-1]
gen inflation = (CPI-lCPI)/lCPI
drop if missing(inflation)
egen med_inf = median(inflation)
gen high_inf = (inflation > med_inf)
keep high_inf date_ym

merge 1:1 date_ym using "..\filings\CSI.dta"
erase "..\filings\CSI.dta"
drop if _merge != 3
drop _merge

save "..\filings\CSI+INF.dta", replace

*** S&P index
import delimited "..\filings\spidx.csv", encoding(ISO-8859-2) clear 
tostring date, replace
replace date = substr(date,1,6)
gen date_ym = date(date, "YM")
format date_ym %td
rename spindx spidx
keep date_ym spidx

merge 1:1 date_ym using "..\filings\CSI+INF.dta"
erase "..\filings\CSI+INF.dta"
drop if _merge != 3
drop _merge

save "..\filings\CSI+INF+SPIDX.dta", replace

*****************************************************************
******************* Merge all at quarterly level ****************
*****************************************************************
import delimited "..\filings\crsp_comp_edgar_ibes_seg_8-K.csv", case(preserve) stringcols(2) clear
tostring cmonth, replace
gen date_ym = date(cmonth, "YM")
format date_ym %td
destring cmonth, replace

merge m:1 date_ym using "..\filings\CSI+INF+SPIDX.dta"
erase "..\filings\CSI+INF+SPIDX.dta"
drop if _merge == 2
drop _merge

merge m:1 gvkey fyearq using "..\filings\RATE+TNIC3HHI.dta"
drop if _merge == 2
erase "..\filings\RATE+TNIC3HHI.dta"
drop _merge

gen inv_CSI = 1/CSI
gen inv_spidx = 1/spidx
gen BTM = 1/MTB
*destring SalesGrowth, replace force

areg BTM i.fyearq LT_growth SG tnic3hhi inv_CSI inv_spidx rating STD_DRET high_inf, absorb(SIC)
*CFO AOCI
predict ME, xbd
predict UCONS, residuals
* winsor2 UCONS, cuts(1 99) replace

replace ME = ME*-1
replace UCONS = UCONS*-1
******************************************************************************************
******************* Unconditional conservatism and Narrative conservatism ****************
******************************************************************************************
**** Variable Creation
// winsor2 DRET, cuts(1 99)
gen DRET_BN = DRET*BN
gen NEXHIBIT = -log(1+nexhibit)
gen NGRAPH = -log(1+ngraph)
replace NW = NW*-1
replace nitem = -log(1+nitem)
replace n8k = -log(1+n8k)
replace TLAG = -log(1+TLAG)

xtile UCONS_HIGH = UCONS, n(2)

**** Regressions: high low UCONS using 10-Q
reghdfe NW DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", replace excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe n8k DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(n8k_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe n8k DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(n8k_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe n8k DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(n8k_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe n8k DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(n8k_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe nitem DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(nitem_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe nitem DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(nitem_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe nitem DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(nitem_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe nitem DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(nitem_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe NEXHIBIT DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NEXHIBIT DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NEXHIBIT_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NEXHIBIT DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NEXHIBIT DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NEXHIBIT_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe NGRAPH DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NGRAPH DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NGRAPH_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NGRAPH DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NGRAPH DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NGRAPH_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe TONE DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe TLAG DRET BN DRET_BN if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 1, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_LOW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG DRET BN DRET_BN if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG DRET BN DRET_BN $fin_controls $abt_controls if UCONS_HIGH == 2, a(gvkey i.cmonth) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_HIGH) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

**** Variable Creation
xtile UCONS_PCT = UCONS, n(5)
xtile SIZE_PCT = SIZE, n(5)
// bysort UCONS_PCT: summarize EARN RET SIZE MTB LEV

**** Regressions 10-Q: change to SIZE_PCT, MTB_PCT, LEV_PCT, HHI_PCT, SG_PCT and LIT_PCT to see level of NC across quantiles of different fundamental characteristics.
reghdfe NW RET NEG RET_NEG if UCONS_PCT == 1, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", replace excel ctitle(NW_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW RET NEG RET_NEG if UCONS_PCT == 2, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW RET NEG RET_NEG if UCONS_PCT == 3, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW RET NEG RET_NEG if UCONS_PCT == 4, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe NW RET NEG RET_NEG if UCONS_PCT == 5, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(NW_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe TONE RET NEG RET_NEG if UCONS_PCT == 1, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE RET NEG RET_NEG if UCONS_PCT == 2, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE RET NEG RET_NEG if UCONS_PCT == 3, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE RET NEG RET_NEG if UCONS_PCT == 4, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TONE RET NEG RET_NEG if UCONS_PCT == 5, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TONE_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2

reghdfe TLAG RET NEG RET_NEG if UCONS_PCT == 1, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_1) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG RET NEG RET_NEG if UCONS_PCT == 2, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_2) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG RET NEG RET_NEG if UCONS_PCT == 3, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_3) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG RET NEG RET_NEG if UCONS_PCT == 4, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_4) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2
reghdfe TLAG RET NEG RET_NEG if UCONS_PCT == 5, a(gvkey i.cquarter) cluster(SIC)
outreg2 using "..\output\Table_12.xml", append excel ctitle(TLAG_5) addtext(Year-quarter FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) stats(coef tstat) adjr2