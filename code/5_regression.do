*****************************************************
******************** TABLE 2 ************************
*****************************************************

**** read id_crsp_comp_text_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG
gen TLAG_INV = -1*TLAG

**** Table 2: Main regressions
regress NW RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", replace excel ctitle(NW) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(NW) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TONE RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress TLAG_INV RET NEG RET_NEG $fin_controls
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg TLAG_INV i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_2.xml", append excel ctitle(TLAG) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

*****************************************************
********************* ABTONE ************************
*****************************************************

**** read crsp_comp_edgar_ibes_seg_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\crsp_comp_edgar_ibes_seg_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Creation
gen RET_NEG = RET*NEG

**** Table 4: TONE regressions (REPLICATION Huang et al. 2014 TABLE 1)
regress tone EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_4.xml", replace excel ctitle(tone) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2

areg tone i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_4.xml", append excel ctitle(tone) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

// regress TONE EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
// outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(4) tdec(2) stats(coef tstat) adjr2
//
// areg TONE i.cquarter EARN RET SIZE MTB STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
// outreg2 using "..\output\Table_4.xml", append excel ctitle(TONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(4) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** Table 5: ABTONE main results (mine)
regress ABTONE RET NEG RET_NEG SIZE MTB LEV
outreg2 using "..\output\Table_5.xml", replace excel ctitle(ABTONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg ABTONE i.cquarter RET NEG RET_NEG SIZE MTB LEV, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(ABTONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

regress ABTONE RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF
outreg2 using "..\output\Table_5.xml", append excel ctitle(ABTONE) addtext(Year-quarter FE, NO, Firm FE, NO, Industry-clustered SE, NO) dec(3) tdec(2) stats(coef tstat) adjr2

areg ABTONE i.cquarter RET NEG RET_NEG SIZE MTB LEV EARN STD_RET STD_EARN AGE BUSSEG GEOSEG LOSS DEARN AFE AF, absorb(gvkey) cluster(SIC)
outreg2 using "..\output\Table_5.xml", append excel ctitle(ABTONE) addtext(Year-quarter FE, YES, Firm FE, YES, Industry-clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

**** Table 6: ABTONE main results (REPLICATION Huang et al. 2014 TABLE 4) NO DA
** ssc install reghdfe

reghdfe leap1_EARN abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", replace excel ctitle(EARN_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_EARN abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(EARN_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_EARN abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(EARN_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap1_CFO abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+1) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap2_CFO abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+2) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2

reghdfe leap3_CFO abtone EARN SIZE MTB RET STD_RET STD_EARN,  absorb(SIC cquarter) vce(cluster gvkey cquarter)
outreg2 using "..\output\Table_6.xml", append excel ctitle(CFO_t+3) addtext(Industry FE, YES, Year-quarter FE, YES, Firm clustered SE, YES, Quarter clustered SE, YES) dec(3) tdec(2) drop(i.cquarter) stats(coef tstat) adjr2