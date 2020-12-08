clear

**************************************************** prepare merge: EDGAR - merge BOG and LM_10X_Summaries_2018 *******************************************
import delimited "F:\github\narrative_conservatism\filings\LM_10X_Summaries_2018.csv", clear 
keep if form_type == "10-K"
gen filename = substr(file_name,-26,.)
replace filename = substr(filename,1,20) + substr(filename,-4,.)
duplicates drop filename, force
save "..\filings\edgar_10-K.dta", replace

import delimited "F:\github\narrative_conservatism\filings\BOG_INDEX_DATA_1994_2018.csv", clear
*merge 1:1 cik fd using "..\filings\10-K.dta"
merge 1:1 filename using "..\filings\edgar_10-K.dta"
drop if _merge !=3

rename bogindex BOG
tostring filing_date fye, replace
gen fd = date(filing_date, "YMD")
gen rp = date(fye, "YMD")
format fd rp %td
keep filename gvkey cik BOG fd rp n_words n_negative n_positive n_negation
gen fyear = year(fd)
gen TLAG = fd - rp

*** drop files that contain negative or larger than 99% TLAG, and drop files that contain less than 1% nw
drop if TLAG < 0
summarize TLAG, detail
keep if TLAG <= r(p99)
// summarize n_words, detail
// keep if n_words >= r(p1)

duplicates drop gvkey fyear, force
duplicates drop cik fyear, force

save "..\filings\edgar_10-K.dta", replace

**************************************************** prepare merge: IBES *********************************************
import delimited "F:\github\narrative_conservatism\filings\ibes.csv", encoding(ISO-8859-9) clear
drop if missing(cusip) | missing(fpedats) | missing(actual) | missing(value)

keep if fpi == 1
collapse (median) actual value, by (cusip fpedats)
rename value vlmedian
gen afe = actual - vlmedian
save "..\filings\ibes_10-K.dta", replace

import delimited "F:\github\narrative_conservatism\filings\ibes.csv", encoding(ISO-8859-9) clear
drop if missing(cusip) | missing(fpedats) | missing(actual) | missing(value)

keep if fpi == 2
collapse (mean) value, by (cusip fpedats)
rename value consensus

merge 1:1 cusip fpedats using "..\filings\ibes_10-K.dta", keepusing(afe)
drop if _merge !=3
drop _merge
gen fyear = year(date(fpedats, "DMY"))
duplicates drop cusip fyear, force
save "..\filings\ibes_10-K.dta", replace

**************************************************** prepare merge: SEG *********************************************
import delimited "F:\github\narrative_conservatism\filings\compustat_seg.csv", clear
collapse (count) sid, by (gvkey datadate stype)
keep if stype == "BUSSEG"
rename sid n_busseg
save "..\filings\busseg_10-K.dta", replace

import delimited "F:\github\narrative_conservatism\filings\compustat_seg.csv", clear
collapse (count) sid, by (gvkey datadate stype)
keep if stype == "GEOSEG"
rename sid n_geoseg

merge 1:1 gvkey datadate using "..\filings\busseg_10-K.dta", keepusing(n_busseg)
erase "..\filings\busseg_10-K.dta"

replace n_busseg = 1 if missing(n_busseg)
replace n_geoseg = 1 if missing(n_geoseg)
tostring datadate, replace
gen fyear = year(date(datadate, "YMD"))
drop _merge stype datadate
duplicates drop gvkey fyear, force
save "..\filings\seg_10-K.dta", replace
**************************************************** prepare merge: COMP - generate cusip8 in COMP *********************************************
import delimited "..\filings\compustat_y.csv", case(preserve) stringcols(2) clear
replace cusip = substr(cusip,1,8)
rename sic SIC

gen cdate = date(datadate, "YMD")
gen cyear = year(cdate)
gen difyear = cyear - fyear
duplicates drop cusip fyear, force

*** gen EARN
xtset gvkey fyear
gen lag_prcc_f=l.prcc_f
gen lag_at=l.at
gen lag_csho=l.csho
gen lag_ceq=l.ceq
gen lag_dlc=l.dlc
gen lag_dltt=l.dltt

gen EARN = ib/lag_at

*** gen STD_EARN: TAKES 2 HOURS
// rolling STD_EARN = r(sd), clear window(5) step(1) : summarize EARN
// rename end fyear
// save "..\filings\compustat_y_stdearn.dta", replace

merge 1:1 gvkey fyear using "..\filings\compustat_y_stdearn.dta"
keep if _merge == 3
drop _merge
save "..\filings\compustat_y.dta", replace

**************************************************** prepare merge: CRSP - constructing RET, age and STD_RET **************************************
***merging fiscal month-end info from compustat
import delimited "..\filings\crsp.csv", case(preserve) stringcols(2) clear
gen cdate = date(date, "YMD")
gen cyear = year(cdate)

***generate age
egen birth = min(cdate), by(PERMCO)
format cdate birth %td
rename CUSIP cusip
rename RET ret
drop if (ret == "B") | (ret == "C")
drop if missing(ret) | missing(vwretd)
destring ret, replace
gen RET = ret-vwretd
merge m:m cusip cyear using "..\filings\compustat_y.dta", keepusing(fyr difyear fyear datadate)
gen fisendate = date(datadate, "YMD")
gen age = fisendate - birth
drop if _merge !=3
drop _merge

***translating calandar year to fiscal year
rename fyear fyear_original
gen cmonth=month(cdate)
gen fyear=cyear-1 if (cmonth <= fyr) & (difyear == 1)
replace fyear=cyear+1 if (cmonth > fyr) & (difyear == 0)
replace fyear=cyear if (cmonth <= fyr) & (difyear == 0)
replace fyear=cyear if (cmonth > fyr) & (difyear == 1)

***generate sd of monthly returns throughout fiscal year
egen STD_RET = sd(RET), by(PERMCO fyear)
save "..\filings\crsp_10-K.dta", replace

***deleting 3 months after fy-end
// drop if cmonth==fyr
// drop if cmonth==fyr+1
// drop if cmonth==fyr+2
// drop if cmonth==1 & fyr==11
// drop if cmonth==1 & fyr==12
// drop if cmonth==2 & fyr==12

***suming up monthly return to fiscal annual return
use "..\filings\crsp_10-K.dta", clear
collapse (sum) RET, by (cusip fyear)
merge 1:m cusip fyear using "..\filings\crsp_10-K.dta", keepusing(age STD_RET)
drop _merge
duplicates drop cusip fyear, force
erase "..\filings\crsp_10-K.dta"

******************************************************merge CRSP_COMP
merge 1:1 cusip fyear using "..\filings\compustat_y.dta"
drop if _merge !=3
keep cusip fyear RET age STD_RET EARN STD_EARN gvkey conm act at lag_at ceq lag_ceq che csho lag_csho dlc lag_dlc dltt lag_dltt dp ib oancf sstk xidoc cik prcc_f lag_prcc_f SIC
erase "..\filings\compustat_y.dta"

******************************************************merge CRSP_COMP_EDGAR
merge 1:1 gvkey fyear using "..\filings\edgar_10-K.dta"
drop if _merge !=3
drop _merge
erase "..\filings\edgar_10-K.dta"

******************************************************merge CRSP_COMP_EDGAR_IBES
merge 1:1 cusip fyear using "..\filings\ibes_10-K.dta"
drop if _merge !=3
drop _merge
erase "..\filings\ibes_10-K.dta"

******************************************************merge CRSP_COMP_EDGAR_IBES_SEG
merge 1:1 gvkey fyear using "..\filings\seg_10-K.dta"
drop if _merge == 2
replace n_busseg = 1 if missing(n_busseg)
replace n_geoseg = 1 if missing(n_geoseg)
drop _merge
erase "..\filings\seg_10-K.dta"
save "..\filings\crsp_comp_edgar_ibes_seg_10-K.dta", replace

****************************************************** VARIABLE CREATION AND SCREENING ********************************************************************
use "..\filings\crsp_comp_edgar_ibes_seg_10-K.dta", clear
***drop abnormal observations with missing or negative values in key variables
* drop if missing(prcc_f, at, csho, dlc, dltt, ib, ceq)
drop if lag_prcc_f<1 | at<=0 | ceq<=0 | age<=0

***drop financial firms
drop if 6000<=SIC & SIC<=6999

***drop utility firms
drop if 4900<=SIC & SIC<=4999

***gen NW, TONE and TLAG
gen NW = log(1+n_words)
gen TONE = (n_positive-n_negative-n_negation)/n_words*1000
* TLAG = fd - rp

***gen NEG, RET*NEG
gen NEG = (RET<0)
gen RET_NEG = RET*NEG

**gen controls: SIZE MTB LEV EARN AF AFE BUSSEG GEOSSEG AGE STD_EARN STD_RET
gen SIZE = log(lag_prcc*lag_csho)
gen MTB = lag_prcc*lag_csho/lag_ceq
gen LEV = (lag_dlc+lag_dltt)/lag_at
gen AF = consensus/prcc_f
gen AFE = afe/prcc_f
gen BUSSEG = log(1+n_busseg)
gen GEOSEG = log(1+n_geoseg)
gen AGE = log(1+age)

***winsorize
drop if missing(NW) | missing(TONE) | missing(TLAG) | missing(RET) | missing(NEG) | missing(EARN) | missing(SIZE) | missing(MTB) | missing(LEV) | missing(AF) | missing(AFE) | missing(BUSSEG) | missing(GEOSEG) | missing(AGE) | missing(STD_RET) | missing(STD_EARN)
winsor2 EARN SIZE MTB LEV AF AFE BUSSEG GEOSEG AGE STD_RET STD_EARN, cuts(1 99) replace

univar NW n_words TONE TLAG RET NEG EARN SIZE MTB LEV AF AFE BUSSEG GEOSEG AGE STD_RET STD_EARN

save "..\filings\crsp_comp_edgar_ibes_seg_10-K.dta", replace

****************************************************************************
************************************ REGRESSIONS ***************************
****************************************************************************
**** Variable grouping
global fin_controls "SIZE MTB LEV"
global lit_controls "LNASSETS SG SKEW_RET STD_RET TURNOVER"
global abt_controls "EARN STD_RET STD_EARN AGE BUSSEG GEOSEG AF AFE"

****************************************************************
**************** TABLE 10 - 10-K results ***********************
****************************************************************

**** TABLE 10 - Panel A: 10-K main results

**** read id_crsp_comp_text_10-Q.csv
use "..\filings\crsp_comp_edgar_ibes_seg_10-K.dta", clear

**** Table 10 - Panel A: Main regressions

// regress NW RET NEG RET_NEG
// outreg2 using "..\output\Table_3-Panel_A.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.fyear RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", replace excel ctitle(NW) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2
// regress NW RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(NW) addtext(Year FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg NW i.fyear RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(NW) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

// regress TONE RET NEG RET_NEG
// outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TONE) addtext(Year FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.fyear RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TONE) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2
// regress TONE RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TONE) addtext(Year FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TONE i.fyear RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TONE) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

// regress TLAG RET NEG RET_NEG
// outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TLAG) addtext(Year FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.fyear RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TLAG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2
// regress TLAG RET NEG RET_NEG $fin_controls $abt_controls
// outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TLAG) addtext(Year FE, NO, Firm FE, NO, Industry clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2
areg TLAG i.fyear RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_A.xml", append excel ctitle(TLAG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

**** Table 10 - Panel B: Readability using BOG index
**** Variable Creation
gen RET_NW = RET*NW
gen NW_NEG = NW*NEG
gen RET_NEG_NW = RET*NEG*NW

areg BOG i.fyear NW RET NEG RET_NEG, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_B.xml", replace excel ctitle(BOG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

areg BOG i.fyear NW RET NEG RET_NEG $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_B.xml", append excel ctitle(BOG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

areg BOG i.fyear NW RET NEG RET_NEG NW_NEG RET_NW RET_NEG_NW, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_B.xml", append excel ctitle(BOG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2

areg BOG i.fyear NW RET NEG RET_NEG NW_NEG RET_NW RET_NEG_NW $fin_controls $abt_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_10-Panel_B.xml", append excel ctitle(BOG) addtext(Year FE, YES, Firm FE, YES, Industry clustered SE, YES) dec(3) tdec(2) drop(i.fyear) stats(coef tstat) adjr2