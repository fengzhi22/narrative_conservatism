**** read id_crsp_comp_text_10-Q.csv
. import delimited "F:\github\narrative_conservatism\filings\id_crsp_comp_text_10-Q.csv", case(preserve) stringcols(2) clear

**** Variable Definition
global fin_controls "SIZE MTB LEV"
gen RET_NEG = RET*NEG

**** Main regressions
regress NW RET NEG RET_NEG $fin_controls
estimates store NW
areg NW i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
estimates store NW_FE

regress TONE RET NEG RET_NEG $fin_controls
estimates store TONE
areg TONE i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
estimates store TONE_FE

regress TLAG RET NEG RET_NEG $fin_controls
estimates store TLAG
areg TLAG i.cquarter RET NEG RET_NEG $fin_controls, absorb(gvkey) cluster(SIC)
estimates store TLAG_FE

**** TABLE 2. Main results
estimates table NW NW_FE TONE TONE_FE TLAG TLAG_FE, drop(i.cquarter) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table NW NW_FE TONE TONE_FE TLAG TLAG_FE, drop(i.cquarter) b(%9.4f) stats(N r2_a) star

