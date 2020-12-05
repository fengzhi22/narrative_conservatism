clear
set matsize 11000

**************************************************** generate cusip8 in COMP *********************************************
import delimited "..\filings\compustat_y.csv", case(preserve) stringcols(2) clear
replace cusip = substr(cusip,1,8)

gen cdate = date(datadate, "YMD")
gen cyear = year(cdate)
gen difyear = cyear - fyear
save "..\filings\compustat_y.dta", replace
**************************************************** constructing RET from CRSP_raw **************************************
***merging fiscal month-end info from compustat
import delimited "..\filings\crsp.csv", case(preserve) stringcols(2) clear
gen cdate = date(date, "YMD")
gen cyear = year(cdate)
rename CUSIP cusip
rename RET ret
*****************************************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!destring ret, replace
merge m:m cusip cyear using "..\filings\compustat_y.dta", keepusing(fyr difyear fyear)
drop if _merge !=3
drop _merge

***translating calandar year to fiscal year
rename fyear fyear_original
gen cmonth=month(cdate)
gen fyear=cyear-1 if (cmonth <= fyr) & (difyear == 1)
replace fyear=cyear+1 if (cmonth > fyr) & (difyear == 0)
replace fyear=cyear if (cmonth <= fyr) & (difyear == 0)
replace fyear=cyear if (cmonth > fyr) & (difyear == 1)

***deleting 3 months after fy-end
// drop if cmonth==fyr
// drop if cmonth==fyr+1
// drop if cmonth==fyr+2
// drop if cmonth==1 & fyr==11
// drop if cmonth==1 & fyr==12
// drop if cmonth==2 & fyr==12

***suming up monthly return to fiscal annual return
collapse (sum) ret vwretd, by (cusip fyear)
gen RET=ret-vwretd
*gen RET=ret
save "..\filings\RET.dta", replace

******************************************************merge CRSP with COMP: data cleaning
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\COMP_raw.dta", clear
merge m:1 cusip fyear using "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\RET.dta", keepusing(RET)
drop if _merge !=3
drop _merge

***drop abnormal observations with missing or negative values in key variables: EXCLUDE FIRMS WITHOUT DEBT BECAUSE MY THEORY GOES THROUGH DEBT
destring gvkey, replace
destring sic, replace
xtset gvkey fyear
gen lprcc_f=l.prcc_f

drop if missing(incorp, prcc_f, at, csho, dlc, dltt, ib, ceq)
drop if lprcc_f<1 |at<=0
**|dlc<=0 |dltt<=0 |che<0

***drop financial firms
drop if 6000<=sic & sic<=6999

***drop foreign goverment firms (8888) and foreign operating establishments [9000,9999]
drop if 9000<=sic & sic<=9999
drop if sic==8888

***gen EARN, NEG, RET*NEG

gen MVE=prcc_f*csho
gen lMVE=l.MVE
gen EARN=ib/lMVE
gen NEG=1 if RET<0
replace NEG=0 if RET>=0
gen RET_NEG=RET*NEG

**gen SIZE BTM MTB LEV
gen SIZE=log(MVE)
gen BTM=ceq/MVE
gen MTB=MVE/ceq
gen LEV=(dlc+dltt)/MVE

***winsorize
drop if missing(EARN, RET, NEG, SIZE, MTB, BTM, LEV)
winsor2 RET EARN SIZE MTB BTM LEV, cuts(1 99) replace

save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\COMP_CRSP.dta", replace

******************************************************************************************
*******************************BASU & LIANG 2019******************************************
******************************************************************************************

***generate state and fyear dummy
quiet tabulate incorp, generate(incorp)
quiet tabulate fyear, generate(fyear)

***building fixed effects structure into beta1 beta2 and beta3
gen RET_incorp1=RET*incorp1
gen RET_incorp2=RET*incorp2
gen RET_incorp3=RET*incorp3
gen RET_incorp4=RET*incorp4
gen RET_incorp5=RET*incorp5
gen RET_incorp6=RET*incorp6
gen RET_incorp7=RET*incorp7
gen RET_incorp8=RET*incorp8
gen RET_incorp9=RET*incorp9
gen RET_incorp10=RET*incorp10
gen RET_incorp11=RET*incorp11
gen RET_incorp12=RET*incorp12
gen RET_incorp13=RET*incorp13
gen RET_incorp14=RET*incorp14
gen RET_incorp15=RET*incorp15
gen RET_incorp16=RET*incorp16
gen RET_incorp17=RET*incorp17
gen RET_incorp18=RET*incorp18
gen RET_incorp19=RET*incorp19
gen RET_incorp20=RET*incorp20
gen RET_incorp21=RET*incorp21
gen RET_incorp22=RET*incorp22
gen RET_incorp23=RET*incorp23
gen RET_incorp24=RET*incorp24
gen RET_incorp25=RET*incorp25
gen RET_incorp26=RET*incorp26
gen RET_incorp27=RET*incorp27
gen RET_incorp28=RET*incorp28
gen RET_incorp29=RET*incorp29
gen RET_incorp30=RET*incorp30
gen RET_incorp31=RET*incorp31
gen RET_incorp32=RET*incorp32
gen RET_incorp33=RET*incorp33
gen RET_incorp34=RET*incorp34
gen RET_incorp35=RET*incorp35
gen RET_incorp36=RET*incorp36
gen RET_incorp37=RET*incorp37
gen RET_incorp38=RET*incorp38
gen RET_incorp39=RET*incorp39
gen RET_incorp40=RET*incorp40
gen RET_incorp41=RET*incorp41
gen RET_incorp42=RET*incorp42
gen RET_incorp43=RET*incorp43
gen RET_incorp44=RET*incorp44
gen RET_incorp45=RET*incorp45
gen RET_incorp46=RET*incorp46
gen RET_incorp47=RET*incorp47
gen RET_incorp48=RET*incorp48
gen RET_incorp49=RET*incorp49
gen RET_incorp50=RET*incorp50

gen NEG_incorp1=NEG*incorp1
gen NEG_incorp2=NEG*incorp2
gen NEG_incorp3=NEG*incorp3
gen NEG_incorp4=NEG*incorp4
gen NEG_incorp5=NEG*incorp5
gen NEG_incorp6=NEG*incorp6
gen NEG_incorp7=NEG*incorp7
gen NEG_incorp8=NEG*incorp8
gen NEG_incorp9=NEG*incorp9
gen NEG_incorp10=NEG*incorp10
gen NEG_incorp11=NEG*incorp11
gen NEG_incorp12=NEG*incorp12
gen NEG_incorp13=NEG*incorp13
gen NEG_incorp14=NEG*incorp14
gen NEG_incorp15=NEG*incorp15
gen NEG_incorp16=NEG*incorp16
gen NEG_incorp17=NEG*incorp17
gen NEG_incorp18=NEG*incorp18
gen NEG_incorp19=NEG*incorp19
gen NEG_incorp20=NEG*incorp20
gen NEG_incorp21=NEG*incorp21
gen NEG_incorp22=NEG*incorp22
gen NEG_incorp23=NEG*incorp23
gen NEG_incorp24=NEG*incorp24
gen NEG_incorp25=NEG*incorp25
gen NEG_incorp26=NEG*incorp26
gen NEG_incorp27=NEG*incorp27
gen NEG_incorp28=NEG*incorp28
gen NEG_incorp29=NEG*incorp29
gen NEG_incorp30=NEG*incorp30
gen NEG_incorp31=NEG*incorp31
gen NEG_incorp32=NEG*incorp32
gen NEG_incorp33=NEG*incorp33
gen NEG_incorp34=NEG*incorp34
gen NEG_incorp35=NEG*incorp35
gen NEG_incorp36=NEG*incorp36
gen NEG_incorp37=NEG*incorp37
gen NEG_incorp38=NEG*incorp38
gen NEG_incorp39=NEG*incorp39
gen NEG_incorp40=NEG*incorp40
gen NEG_incorp41=NEG*incorp41
gen NEG_incorp42=NEG*incorp42
gen NEG_incorp43=NEG*incorp43
gen NEG_incorp44=NEG*incorp44
gen NEG_incorp45=NEG*incorp45
gen NEG_incorp46=NEG*incorp46
gen NEG_incorp47=NEG*incorp47
gen NEG_incorp48=NEG*incorp48
gen NEG_incorp49=NEG*incorp49
gen NEG_incorp50=NEG*incorp50

gen RET_NEG_incorp1=RET_NEG*incorp1
gen RET_NEG_incorp2=RET_NEG*incorp2
gen RET_NEG_incorp3=RET_NEG*incorp3
gen RET_NEG_incorp4=RET_NEG*incorp4
gen RET_NEG_incorp5=RET_NEG*incorp5
gen RET_NEG_incorp6=RET_NEG*incorp6
gen RET_NEG_incorp7=RET_NEG*incorp7
gen RET_NEG_incorp8=RET_NEG*incorp8
gen RET_NEG_incorp9=RET_NEG*incorp9
gen RET_NEG_incorp10=RET_NEG*incorp10
gen RET_NEG_incorp11=RET_NEG*incorp11
gen RET_NEG_incorp12=RET_NEG*incorp12
gen RET_NEG_incorp13=RET_NEG*incorp13
gen RET_NEG_incorp14=RET_NEG*incorp14
gen RET_NEG_incorp15=RET_NEG*incorp15
gen RET_NEG_incorp16=RET_NEG*incorp16
gen RET_NEG_incorp17=RET_NEG*incorp17
gen RET_NEG_incorp18=RET_NEG*incorp18
gen RET_NEG_incorp19=RET_NEG*incorp19
gen RET_NEG_incorp20=RET_NEG*incorp20
gen RET_NEG_incorp21=RET_NEG*incorp21
gen RET_NEG_incorp22=RET_NEG*incorp22
gen RET_NEG_incorp23=RET_NEG*incorp23
gen RET_NEG_incorp24=RET_NEG*incorp24
gen RET_NEG_incorp25=RET_NEG*incorp25
gen RET_NEG_incorp26=RET_NEG*incorp26
gen RET_NEG_incorp27=RET_NEG*incorp27
gen RET_NEG_incorp28=RET_NEG*incorp28
gen RET_NEG_incorp29=RET_NEG*incorp29
gen RET_NEG_incorp30=RET_NEG*incorp30
gen RET_NEG_incorp31=RET_NEG*incorp31
gen RET_NEG_incorp32=RET_NEG*incorp32
gen RET_NEG_incorp33=RET_NEG*incorp33
gen RET_NEG_incorp34=RET_NEG*incorp34
gen RET_NEG_incorp35=RET_NEG*incorp35
gen RET_NEG_incorp36=RET_NEG*incorp36
gen RET_NEG_incorp37=RET_NEG*incorp37
gen RET_NEG_incorp38=RET_NEG*incorp38
gen RET_NEG_incorp39=RET_NEG*incorp39
gen RET_NEG_incorp40=RET_NEG*incorp40
gen RET_NEG_incorp41=RET_NEG*incorp41
gen RET_NEG_incorp42=RET_NEG*incorp42
gen RET_NEG_incorp43=RET_NEG*incorp43
gen RET_NEG_incorp44=RET_NEG*incorp44
gen RET_NEG_incorp45=RET_NEG*incorp45
gen RET_NEG_incorp46=RET_NEG*incorp46
gen RET_NEG_incorp47=RET_NEG*incorp47
gen RET_NEG_incorp48=RET_NEG*incorp48
gen RET_NEG_incorp49=RET_NEG*incorp49
gen RET_NEG_incorp50=RET_NEG*incorp50

gen RET_fyear1=RET*fyear1
gen RET_fyear2=RET*fyear2
gen RET_fyear3=RET*fyear3
gen RET_fyear4=RET*fyear4
gen RET_fyear5=RET*fyear5
gen RET_fyear6=RET*fyear6
gen RET_fyear7=RET*fyear7
gen RET_fyear8=RET*fyear8
gen RET_fyear9=RET*fyear9
gen RET_fyear10=RET*fyear10
gen RET_fyear11=RET*fyear11
gen RET_fyear12=RET*fyear12
gen RET_fyear13=RET*fyear13
gen RET_fyear14=RET*fyear14
gen RET_fyear15=RET*fyear15
gen RET_fyear16=RET*fyear16
gen RET_fyear17=RET*fyear17
gen RET_fyear18=RET*fyear18
gen RET_fyear19=RET*fyear19
gen RET_fyear20=RET*fyear20
gen RET_fyear21=RET*fyear21
gen RET_fyear22=RET*fyear22
gen RET_fyear23=RET*fyear23
gen RET_fyear24=RET*fyear24
gen RET_fyear25=RET*fyear25
gen RET_fyear26=RET*fyear26
gen RET_fyear27=RET*fyear27
gen RET_fyear28=RET*fyear28
gen RET_fyear29=RET*fyear29
gen RET_fyear30=RET*fyear30
gen RET_fyear31=RET*fyear31
gen RET_fyear32=RET*fyear32
gen RET_fyear33=RET*fyear33
gen RET_fyear34=RET*fyear34
gen RET_fyear35=RET*fyear35
gen RET_fyear36=RET*fyear36
gen RET_fyear37=RET*fyear37
gen RET_fyear38=RET*fyear38


gen NEG_fyear1=NEG*fyear1
gen NEG_fyear2=NEG*fyear2
gen NEG_fyear3=NEG*fyear3
gen NEG_fyear4=NEG*fyear4
gen NEG_fyear5=NEG*fyear5
gen NEG_fyear6=NEG*fyear6
gen NEG_fyear7=NEG*fyear7
gen NEG_fyear8=NEG*fyear8
gen NEG_fyear9=NEG*fyear9
gen NEG_fyear10=NEG*fyear10
gen NEG_fyear11=NEG*fyear11
gen NEG_fyear12=NEG*fyear12
gen NEG_fyear13=NEG*fyear13
gen NEG_fyear14=NEG*fyear14
gen NEG_fyear15=NEG*fyear15
gen NEG_fyear16=NEG*fyear16
gen NEG_fyear17=NEG*fyear17
gen NEG_fyear18=NEG*fyear18
gen NEG_fyear19=NEG*fyear19
gen NEG_fyear20=NEG*fyear20
gen NEG_fyear21=NEG*fyear21
gen NEG_fyear22=NEG*fyear22
gen NEG_fyear23=NEG*fyear23
gen NEG_fyear24=NEG*fyear24
gen NEG_fyear25=NEG*fyear25
gen NEG_fyear26=NEG*fyear26
gen NEG_fyear27=NEG*fyear27
gen NEG_fyear28=NEG*fyear28
gen NEG_fyear29=NEG*fyear29
gen NEG_fyear30=NEG*fyear30
gen NEG_fyear31=NEG*fyear31
gen NEG_fyear32=NEG*fyear32
gen NEG_fyear33=NEG*fyear33
gen NEG_fyear34=NEG*fyear34
gen NEG_fyear35=NEG*fyear35
gen NEG_fyear36=NEG*fyear36
gen NEG_fyear37=NEG*fyear37
gen NEG_fyear38=NEG*fyear38


gen RET_NEG_fyear1=RET_NEG*fyear1
gen RET_NEG_fyear2=RET_NEG*fyear2
gen RET_NEG_fyear3=RET_NEG*fyear3
gen RET_NEG_fyear4=RET_NEG*fyear4
gen RET_NEG_fyear5=RET_NEG*fyear5
gen RET_NEG_fyear6=RET_NEG*fyear6
gen RET_NEG_fyear7=RET_NEG*fyear7
gen RET_NEG_fyear8=RET_NEG*fyear8
gen RET_NEG_fyear9=RET_NEG*fyear9
gen RET_NEG_fyear10=RET_NEG*fyear10
gen RET_NEG_fyear11=RET_NEG*fyear11
gen RET_NEG_fyear12=RET_NEG*fyear12
gen RET_NEG_fyear13=RET_NEG*fyear13
gen RET_NEG_fyear14=RET_NEG*fyear14
gen RET_NEG_fyear15=RET_NEG*fyear15
gen RET_NEG_fyear16=RET_NEG*fyear16
gen RET_NEG_fyear17=RET_NEG*fyear17
gen RET_NEG_fyear18=RET_NEG*fyear18
gen RET_NEG_fyear19=RET_NEG*fyear19
gen RET_NEG_fyear20=RET_NEG*fyear20
gen RET_NEG_fyear21=RET_NEG*fyear21
gen RET_NEG_fyear22=RET_NEG*fyear22
gen RET_NEG_fyear23=RET_NEG*fyear23
gen RET_NEG_fyear24=RET_NEG*fyear24
gen RET_NEG_fyear25=RET_NEG*fyear25
gen RET_NEG_fyear26=RET_NEG*fyear26
gen RET_NEG_fyear27=RET_NEG*fyear27
gen RET_NEG_fyear28=RET_NEG*fyear28
gen RET_NEG_fyear29=RET_NEG*fyear29
gen RET_NEG_fyear30=RET_NEG*fyear30
gen RET_NEG_fyear31=RET_NEG*fyear31
gen RET_NEG_fyear32=RET_NEG*fyear32
gen RET_NEG_fyear33=RET_NEG*fyear33
gen RET_NEG_fyear34=RET_NEG*fyear34
gen RET_NEG_fyear35=RET_NEG*fyear35
gen RET_NEG_fyear36=RET_NEG*fyear36
gen RET_NEG_fyear37=RET_NEG*fyear37
gen RET_NEG_fyear38=RET_NEG*fyear38


global inf "incorp1 incorp2 incorp3 incorp4 incorp5 incorp6 incorp7 incorp8 incorp9 incorp10 incorp11 incorp12 incorp13 incorp14 incorp15 incorp16 incorp17 incorp18 incorp19 incorp20 incorp21 incorp22 incorp23 incorp24 incorp25 incorp26 incorp27 incorp28 incorp29 incorp30 incorp31 incorp32 incorp33 incorp34 incorp35 incorp36 incorp37 incorp38 incorp39 incorp40 incorp41 incorp42 incorp43 incorp44 incorp45 incorp46 incorp47 incorp48 incorp49 incorp50 fyear1 fyear2 fyear3 fyear4 fyear5 fyear6 fyear7 fyear8 fyear9 fyear10 fyear11 fyear12 fyear13 fyear14 fyear15 fyear16 fyear17 fyear18 fyear19 fyear20 fyear21 fyear22 fyear23 fyear24 fyear25 fyear26 fyear27 fyear28 fyear29 fyear30 fyear31 fyear32 fyear33 fyear34 fyear35 fyear36 fyear37 fyear38"
global inf_RET "RET_incorp1 RET_incorp2 RET_incorp3 RET_incorp4 RET_incorp5 RET_incorp6 RET_incorp7 RET_incorp8 RET_incorp9 RET_incorp10 RET_incorp11 RET_incorp12 RET_incorp13 RET_incorp14 RET_incorp15 RET_incorp16 RET_incorp17 RET_incorp18 RET_incorp19 RET_incorp20 RET_incorp21 RET_incorp22 RET_incorp23 RET_incorp24 RET_incorp25 RET_incorp26 RET_incorp27 RET_incorp28 RET_incorp29 RET_incorp30 RET_incorp31 RET_incorp32 RET_incorp33 RET_incorp34 RET_incorp35 RET_incorp36 RET_incorp37 RET_incorp38 RET_incorp39 RET_incorp40 RET_incorp41 RET_incorp42 RET_incorp43 RET_incorp44 RET_incorp45 RET_incorp46 RET_incorp47 RET_incorp48 RET_incorp49 RET_incorp50 RET_fyear1 RET_fyear2 RET_fyear3 RET_fyear4 RET_fyear5 RET_fyear6 RET_fyear7 RET_fyear8 RET_fyear9 RET_fyear10 RET_fyear11 RET_fyear12 RET_fyear13 RET_fyear14 RET_fyear15 RET_fyear16 RET_fyear17 RET_fyear18 RET_fyear19 RET_fyear20 RET_fyear21 RET_fyear22 RET_fyear23 RET_fyear24 RET_fyear25 RET_fyear26 RET_fyear27 RET_fyear28 RET_fyear29 RET_fyear30 RET_fyear31 RET_fyear32 RET_fyear33 RET_fyear34 RET_fyear35 RET_fyear36 RET_fyear37 RET_fyear38"
global inf_NEG "NEG_incorp1 NEG_incorp2 NEG_incorp3 NEG_incorp4 NEG_incorp5 NEG_incorp6 NEG_incorp7 NEG_incorp8 NEG_incorp9 NEG_incorp10 NEG_incorp11 NEG_incorp12 NEG_incorp13 NEG_incorp14 NEG_incorp15 NEG_incorp16 NEG_incorp17 NEG_incorp18 NEG_incorp19 NEG_incorp20 NEG_incorp21 NEG_incorp22 NEG_incorp23 NEG_incorp24 NEG_incorp25 NEG_incorp26 NEG_incorp27 NEG_incorp28 NEG_incorp29 NEG_incorp30 NEG_incorp31 NEG_incorp32 NEG_incorp33 NEG_incorp34 NEG_incorp35 NEG_incorp36 NEG_incorp37 NEG_incorp38 NEG_incorp39 NEG_incorp40 NEG_incorp41 NEG_incorp42 NEG_incorp43 NEG_incorp44 NEG_incorp45 NEG_incorp46 NEG_incorp47 NEG_incorp48 NEG_incorp49 NEG_incorp50 NEG_fyear1 NEG_fyear2 NEG_fyear3 NEG_fyear4 NEG_fyear5 NEG_fyear6 NEG_fyear7 NEG_fyear8 NEG_fyear9 NEG_fyear10 NEG_fyear11 NEG_fyear12 NEG_fyear13 NEG_fyear14 NEG_fyear15 NEG_fyear16 NEG_fyear17 NEG_fyear18 NEG_fyear19 NEG_fyear20 NEG_fyear21 NEG_fyear22 NEG_fyear23 NEG_fyear24 NEG_fyear25 NEG_fyear26 NEG_fyear27 NEG_fyear28 NEG_fyear29 NEG_fyear30 NEG_fyear31 NEG_fyear32 NEG_fyear33 NEG_fyear34 NEG_fyear35 NEG_fyear36 NEG_fyear37 NEG_fyear38"
global inf_RET_NEG "RET_NEG_incorp1 RET_NEG_incorp2 RET_NEG_incorp3 RET_NEG_incorp4 RET_NEG_incorp5 RET_NEG_incorp6 RET_NEG_incorp7 RET_NEG_incorp8 RET_NEG_incorp9 RET_NEG_incorp10 RET_NEG_incorp11 RET_NEG_incorp12 RET_NEG_incorp13 RET_NEG_incorp14 RET_NEG_incorp15 RET_NEG_incorp16 RET_NEG_incorp17 RET_NEG_incorp18 RET_NEG_incorp19 RET_NEG_incorp20 RET_NEG_incorp21 RET_NEG_incorp22 RET_NEG_incorp23 RET_NEG_incorp24 RET_NEG_incorp25 RET_NEG_incorp26 RET_NEG_incorp27 RET_NEG_incorp28 RET_NEG_incorp29 RET_NEG_incorp30 RET_NEG_incorp31 RET_NEG_incorp32 RET_NEG_incorp33 RET_NEG_incorp34 RET_NEG_incorp35 RET_NEG_incorp36 RET_NEG_incorp37 RET_NEG_incorp38 RET_NEG_incorp39 RET_NEG_incorp40 RET_NEG_incorp41 RET_NEG_incorp42 RET_NEG_incorp43 RET_NEG_incorp44 RET_NEG_incorp45 RET_NEG_incorp46 RET_NEG_incorp47 RET_NEG_incorp48 RET_NEG_incorp49 RET_NEG_incorp50 RET_NEG_fyear1 RET_NEG_fyear2 RET_NEG_fyear3 RET_NEG_fyear4 RET_NEG_fyear5 RET_NEG_fyear6 RET_NEG_fyear7 RET_NEG_fyear8 RET_NEG_fyear9 RET_NEG_fyear10 RET_NEG_fyear11 RET_NEG_fyear12 RET_NEG_fyear13 RET_NEG_fyear14 RET_NEG_fyear15 RET_NEG_fyear16 RET_NEG_fyear17 RET_NEG_fyear18 RET_NEG_fyear19 RET_NEG_fyear20 RET_NEG_fyear21 RET_NEG_fyear22 RET_NEG_fyear23 RET_NEG_fyear24 RET_NEG_fyear25 RET_NEG_fyear26 RET_NEG_fyear27 RET_NEG_fyear28 RET_NEG_fyear29 RET_NEG_fyear30 RET_NEG_fyear31 RET_NEG_fyear32 RET_NEG_fyear33 RET_NEG_fyear34 RET_NEG_fyear35 RET_NEG_fyear36 RET_NEG_fyear37 RET_NEG_fyear38"

***generate enactment year(eny)
gen eny=1984 if incorp=="OH"
replace eny=1985 if incorp=="IL" |incorp=="ME"
replace eny=1986 if incorp=="MO" |incorp=="IN"
replace eny=1987 if incorp=="AZ" |incorp=="MN" |incorp=="NM"|incorp=="NY" |incorp=="WI"
replace eny=1988 if incorp=="NE" |incorp=="CT" |incorp=="ID"|incorp=="LA" |incorp=="TN" |incorp=="KY" |incorp=="VA"
replace eny=1989 if incorp=="FL" |incorp=="GA" |incorp=="HI"|incorp=="IA" |incorp=="MA" |incorp=="NJ" |incorp=="OR"
replace eny=1990 if incorp=="MS" |incorp=="PA" |incorp=="RI"|incorp=="SD" |incorp=="WY"
replace eny=1991 if incorp=="NV"
replace eny=1993 if incorp=="NC" |incorp=="ND"
replace eny=1998 if incorp=="VT"
replace eny=1999 if incorp=="MD"
replace eny=2006 if incorp=="TX"

***delete lobbying company
drop if tic=="AWI"

save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\BASU.dta", replace

*****rolling window: generate dummy1
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\BASU.dta", clear
gen enact=1 if eny==fyear
xtset gvkey fyear
gen l1=l1.enact
gen f1=f1.enact
gen l2=l2.enact
gen f2=f2.enact
gen l3=l3.enact
gen f3=f3.enact
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\merged.dta", replace

**-1/+1
quiet forvalues i=1975/2013 {
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\merged.dta", clear
gen post1=0 if fyear==`i'-1
replace post1=1 if fyear==`i'+1

gen treated=1  if fyear==`i'-1 & f1==1
replace treated=1 if fyear==`i'+1 & l1==1
replace treated=0 if fyear==`i'-1 & f1==0
replace treated=0 if fyear==`i'+1 & l1==0
gen dummy1=treated*post1
drop if dummy1==.
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample`i'",replace
}
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample1975", clear
quiet forvalues i=1976/2013 {
append using "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample`i'" 
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample1", replace
}
*
*
**-2/+2
quiet forvalues i=1976/2012 {
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\merged.dta", clear
gen post2=1 if fyear==`i'+1|fyear==`i'+2
replace post2=0 if fyear==`i'-1|fyear==`i'-2

gen treated=1 if fyear==`i'-1& f1==1
replace treated=1  if fyear==`i'-2& f2==1
replace treated=1  if fyear==`i'+1& l1==1
replace treated=1  if fyear==`i'+2& l2==1
replace treated=0 if fyear==`i'-1& f1==0
replace treated=0  if fyear==`i'-2& f2==0
replace treated=0  if fyear==`i'+1& l1==0
replace treated=0  if fyear==`i'+2& l2==0

gen dummy1=treated*post2
drop if dummy1==.
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\2\sample`i'",replace
}
*
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\2\sample1976", clear
quiet forvalues i=1977/2012 {
append using "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\2\sample`i'"
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\2\sample2", replace
}
*
*
**-3/+3
quiet forvalues i=1977/2011 {
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\merged.dta", clear
gen post3=1 if fyear==`i'+1|fyear==`i'+2|fyear==`i'+3
replace post3=0 if fyear==`i'-1|fyear==`i'-2|fyear==`i'-3

gen treated=1 if fyear==`i'-1& f1==1
replace treated=1  if fyear==`i'-2& f2==1
replace treated=1  if fyear==`i'-3& f3==1
replace treated=1  if fyear==`i'+1& l1==1
replace treated=1  if fyear==`i'+2& l2==1
replace treated=1  if fyear==`i'+3& l3==1
replace treated=0 if fyear==`i'-1& f1==0
replace treated=0  if fyear==`i'-2& f2==0
replace treated=0  if fyear==`i'-3& f3==0
replace treated=0  if fyear==`i'+1& l1==0
replace treated=0  if fyear==`i'+2& l2==0
replace treated=0  if fyear==`i'+3& l3==0

gen dummy1=treated*post3
drop if dummy1==.
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\3\sample`i'",replace
}
*
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\3\sample1977", clear
quiet forvalues i=1978/2011 {
append using "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\3\sample`i'"
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\3\sample3", replace
}
*

***
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample1", clear

********summary statistics of rolling window sample
tab1 dummy1

/***before-after comparison table
tabstat EARN RET NEG SIZE BTM LEV if dummy1==0, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)
tabstat EARN RET NEG SIZE BTM LEV if dummy1==1, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)

ttest EARN, by(dummy1) welch
ttest RET, by(dummy1) welch
ttest NEG, by(dummy1) welch
ttest SIZE, by(dummy1) welch
ttest BTM, by(dummy1) welch
ttest LEV, by(dummy1) welch
*/

**regression -1/+1
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\1\sample1", clear
gen dummy1_RET=dummy1*RET
gen dummy1_NEG=dummy1*NEG
gen dummy1_RET_NEG=dummy1*RET*NEG

quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store II

**regression -2/+2
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\2\sample2", clear
gen dummy1_RET=dummy1*RET
gen dummy1_NEG=dummy1*NEG
gen dummy1_RET_NEG=dummy1*RET*NEG

quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store III
quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store IV

**regression -3/+3
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\rolling windows\3\sample3", clear
gen dummy1_RET=dummy1*RET
gen dummy1_NEG=dummy1*NEG
gen dummy1_RET_NEG=dummy1*RET*NEG

quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store V
quiet areg EARN i.fyear RET NEG RET_NEG dummy1 dummy1_RET dummy1_NEG dummy1_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store VI

**********************************************************************************************TABLE 4. PANEL B. ROLLING WINDOWS
estimates table I II III IV V VI, drop(i.fyear) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II III IV V VI, drop(i.fyear) b(%9.4f) stats(N r2_a) star

*****************************************gen POST, interaction with POST; DROP year of enactment; adjustment for NE between 1995 and 2007
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\BASU.dta", clear
gen POST=1 if fyear>eny
replace POST=0 if fyear<eny
drop if fyear==eny
replace POST=0 if incorp=="NE" & fyear>=1995 & fyear<2007

gen POST_RET=POST*RET
gen POST_NEG=POST*NEG
gen POST_RET_NEG=POST*RET*NEG
tabulate incorp POST

***ensuring that each firm has at least one year observation before and after enactment, drop states that have never enacted CS
bysort gvkey: egen drop_firm= mean(POST)
drop if drop_firm==1 | drop_firm==0 
*& eny!=. :states that have never enacted are treated as controls

***generate debt contracting demand measure DCD
bysort gvkey POST: egen LEV_PRE= mean(LEV) if POST==0
bysort gvkey POST: egen LEV_POST= mean(LEV) if POST==1
by gvkey: replace LEV_PRE=LEV_PRE[_n-1] if LEV_PRE==.
gsort gvkey - POST
by gvkey: replace LEV_POST=LEV_POST[_n-1] if LEV_POST==.
gen DCD2=LEV_POST-LEV_PRE
gen DCD1=1 if DCD2>0
replace DCD1=. if DCD2==. 
replace DCD1=0 if DCD2<=0

gen DCD1_RET=DCD1*RET
gen DCD1_NEG=DCD1*NEG
gen DCD1_RET_NEG=DCD1*RET*NEG
gen DCD1_POST=DCD1*POST
gen DCD1_POST_RET=DCD1*POST*RET
gen DCD1_POST_NEG=DCD1*POST*NEG
gen DCD1_POST_RET_NEG=DCD1*POST*RET*NEG

gen DCD2_RET=DCD2*RET
gen DCD2_NEG=DCD2*NEG
gen DCD2_RET_NEG=DCD2*RET*NEG
gen DCD2_POST=DCD2*POST
gen DCD2_POST_RET=DCD2*POST*RET
gen DCD2_POST_NEG=DCD2*POST*NEG
gen DCD2_POST_RET_NEG=DCD2*POST*RET*NEG

*******************subsample analysis of LEV by MEDIAN, taken from TABLE 2-PANEL A
*bysort gvkey: gen LEVQ=1 if LEV_PRE>=0.348
*replace LEVQ=0 if LEV_PRE<0.348

*tabulate LEVQ
*******************PARALLEL TRENDS
gen PRE1=1 if fyear==eny-1
gen PRE2=1 if fyear==eny-2 | fyear==eny-1
gen PRE3=1 if fyear==eny-3 | fyear==eny-2 | fyear==eny-1
gen PRE4=1 if fyear==eny-4 | fyear==eny-3 | fyear==eny-2 | fyear==eny-1
gen PRE5=1 if fyear==eny-5 | fyear==eny-4 | fyear==eny-3 | fyear==eny-2 | fyear==eny-1
replace PRE1=0 if PRE1==.
replace PRE2=0 if PRE2==.
replace PRE3=0 if PRE3==.
replace PRE4=0 if PRE4==.
replace PRE5=0 if PRE5==.

gen PRE1_RET=PRE1*RET
gen PRE1_NEG=PRE1*NEG
gen PRE1_RET_NEG=PRE1*RET*NEG
gen PRE2_RET=PRE2*RET
gen PRE2_NEG=PRE2*NEG
gen PRE2_RET_NEG=PRE2*RET*NEG
gen PRE3_RET=PRE3*RET
gen PRE3_NEG=PRE4*NEG
gen PRE3_RET_NEG=PRE3*RET*NEG
gen PRE4_RET=PRE4*RET
gen PRE4_NEG=PRE4*NEG
gen PRE4_RET_NEG=PRE4*RET*NEG
gen PRE5_RET=PRE5*RET
gen PRE5_NEG=PRE5*NEG
gen PRE5_RET_NEG=PRE5*RET*NEG

****counting # of observations by incorp, POST. *********************************************************************TABLE 1
tab incorp POST
***counting number of firms
egen newid=group(gvkey)
summarize newid
drop newid

****summary statistics by POST **************************************************************************************TABLE2
bysort POST: tabstat EARN RET NEG SIZE BTM LEV, statistics(mean median sd max min p1 p25 p75 p99) format(%9.3f)
ttest EARN, by (POST)
ttest RET, by (POST)
ttest NEG, by (POST)
ttest SIZE, by (POST)
ttest BTM, by (POST)
ttest LEV, by (POST)

****percentage of firms affected by CS along time, in # and weighted by total assets
/*
sort incorp gvkey fyear
egen tag1 = tag(incorp gvkey)
sort fyear incorp
egen tag2 = tag(fyear incorp)
egen meanat= mean(at), by (gvkey)
egen infvalue = sum(tag1*meanat), by(incorp)
egen fvalue = sum(infvalue*tag2*POST), by(fyear)
summarize fvalue
egen max_fvalue=max(fvalue)
egen innfirms = total(tag1), by(incorp)
egen nfirms = sum(innfirms*tag2*POST), by(fyear)
summarize nfirms
egen max_nfirms=max(nfirms)
gen freq_fvalue=fvalue/max_fvalue
gen freq_nfirms=nfirms/max_nfirms

****Cain (2017) graph
keep if fyear>=1980 & fyear<=2010
twoway connected freq_nfirms freq_fvalue fyear
*/

********************************************baseline regressions of conditional conservatism
xtset gvkey fyear 
quiet areg EARN RET NEG RET_NEG i.fyear, absorb(gvkey) cluster(incorp)
estimates store baseline1
quiet areg EARN RET NEG RET_NEG i.fyear, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
estimates store baseline2
*******************************************************************************************************************************TABLE 3: BASU BASELINE RESULTS
estimates table baseline1 baseline2, drop(i.fyear) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table baseline1 baseline2, drop(i.fyear) b(%9.4f) stats(N r2_a) star

*******************************************DID regressions: CSR on conditional conservatism
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store II

quiet areg EARN i.fyear POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store III
quiet areg EARN i.fyear POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store IV

quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1984 & fyear<=1992
estimates store V
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1984 & fyear<=1992 & incorp==state
estimates store VI


*********************************************************************************************************************************************TABLE 4. PANEL A: BASU POST RESULTS
estimates table I II III IV V VI, drop($inf $inf_RET $inf_NEG $inf_RET_NEG i.fyear) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II III IV V VI, drop($inf $inf_RET $inf_NEG $inf_RET_NEG i.fyear) b(%9.4f) stats(N r2_a) star

***debtholder power: Positive DCD is reasonable because in order to obtain new loans, firms have incentive to increase conservatism
**DCD1
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG DCD1_RET DCD1_NEG DCD1_RET_NEG DCD1_POST DCD1_POST_RET DCD1_POST_NEG DCD1_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG DCD1_RET DCD1_NEG DCD1_RET_NEG DCD1_POST DCD1_POST_RET DCD1_POST_NEG DCD1_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
estimates store II
**DCD2
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG DCD2_RET DCD2_NEG DCD2_RET_NEG DCD2_POST DCD2_POST_RET DCD2_POST_NEG DCD2_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store III
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG DCD2_RET DCD2_NEG DCD2_RET_NEG DCD2_POST DCD2_POST_RET DCD2_POST_NEG DCD2_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
estimates store IV
*********************************************************************************************************************************************TABLE 7: debt mechanism
estimates table I II III IV, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II III IV, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) stats(N r2_a) star

*********************************************LEVQ

*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if LEVQ==0 
*estimates store I
*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG, absorb(gvkey) cluster(incorp), if LEVQ==1
*estimates store II

*estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) t(%9.2f) stats(N r2_a)
*estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) stats(N r2_a) star

****************************************************************
*******************PARALLEL TRENDS******************************
****************************************************************
global PRE_CONTROL "POST POST_RET POST_NEG PRE1 PRE1_RET PRE1_NEG PRE2 PRE2_RET PRE2_NEG PRE3 PRE3_RET PRE3_NEG"
*PRE5 PRE5_RET PRE5_NEG

quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL POST_RET_NEG PRE1_RET_NEG PRE2_RET_NEG PRE3_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL POST_RET_NEG PRE1_RET_NEG PRE2_RET_NEG PRE3_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store II
*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL POST_RET_NEG PRE1_RET_NEG PRE2_RET_NEG PRE3_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
*estimates store III
*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL POST_RET_NEG PRE1_RET_NEG PRE2_RET_NEG PRE3_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state & fyear>=1985 & fyear<=1990
*estimates store IV

*********************************************************************************************************************************************TABLE 9:PARALLEL TRENDS
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG $PRE_CONTROL) b(%9.4f) stats(N r2_a) star

****************************************************
**************Managerial ability********************
****************************************************
*****************************************gen POST, interaction with POST; DROP year of enactment; adjustment for NE between 1995 and 2007
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\MA_raw.dta", clear
duplicates tag gvkey fyear, gen(isdup) 
drop if isdup==1
save "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\MA.dta", replace

use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\BASU.dta", clear
merge m:1 gvkey fyear using "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\MA.dta", keepusing(MA MARANK)
drop if _merge !=3
drop _merge

gen POST=1 if fyear>eny
replace POST=0 if fyear<eny
drop if fyear==eny
replace POST=0 if incorp=="NE" & fyear>=1995 & fyear<2007

gen POST_RET=POST*RET
gen POST_NEG=POST*NEG
gen POST_RET_NEG=POST*RET*NEG
tabulate incorp POST

gen MA_RET=MA*RET
gen MA_NEG=MA*NEG
gen MA_RET_NEG=MA*RET*NEG
gen MA_POST=MA*POST
gen MA_POST_RET=MA*POST*RET
gen MA_POST_NEG=MA*POST*NEG
gen MA_POST_RET_NEG=MA*POST*RET*NEG

***ensuring that each firm has at least one year observation before and after enactment, drop states that have never enacted CS
bysort gvkey: egen drop_firm= mean(POST)
drop if drop_firm==1 | drop_firm==0 

**MA
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG MA_RET MA_NEG MA_RET_NEG MA_POST MA_POST_RET MA_POST_NEG MA_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN POST POST_RET POST_NEG POST_RET_NEG MA_RET MA_NEG MA_RET_NEG MA_POST MA_POST_RET MA_POST_NEG MA_POST_RET_NEG $inf $inf_RET $inf_NEG $inf_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
estimates store II

*********************************************************************************************************************************************TABLE 7: MA mechanism
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) stats(N r2_a) star


****************************************************
**********OTHER ANTITAKEOVER LAWS*******************
****************************************************
use "F:\Education\UC3M\Master\TFM\data\1975-2013cusip\BASU.dta", clear
gen POST=1 if fyear>eny
replace POST=0 if fyear<eny
drop if fyear==eny
replace POST=0 if incorp=="NE" & fyear>=1995 & fyear<2007

gen POST_RET=POST*RET
gen POST_NEG=POST*NEG
gen POST_RET_NEG=POST*RET*NEG
tabulate incorp POST

***ensuring that each firm has at least one year observation before and after enactment, drop states that have never enacted CS
bysort gvkey: egen drop_firm= mean(POST)
drop if drop_firm==1 | drop_firm==0 
*& eny!=. :states that have never enacted are treated as controls

***generate BUSINESS COMBINATION LAW enactment year(BCY)
gen BCY=1985 if incorp=="NY"
replace BCY=1986 if incorp=="NJ" |incorp=="IN"
replace BCY=1987 if incorp=="AZ" |incorp=="KY" |incorp=="MN" |incorp=="WI"
replace BCY=1988 if incorp=="VA" |incorp=="TN" |incorp=="NE"|incorp=="ID" |incorp=="GA" 
replace BCY=1989 if incorp=="IL" |incorp=="CT" |incorp=="MA"|incorp=="MD" |incorp=="PA" |incorp=="WY"
replace BCY=1990 if incorp=="SD" |incorp=="RI" |incorp=="OH"
replace BCY=1991 if incorp=="NV"

gen BC=1 if fyear>BCY
replace BC=0 if fyear<BCY
drop if fyear==BCY

gen BC_RET=BC*RET
gen BC_NEG=BC*NEG
gen BC_RET_NEG=BC*RET*NEG
tabulate incorp BC

*******************************************DID regressions: CSR on conditional conservatism + other antitakeover laws
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG BC BC_RET BC_NEG BC_RET_NEG, absorb(gvkey) cluster(incorp)
estimates store I
quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG BC BC_RET BC_NEG BC_RET_NEG, absorb(gvkey) cluster(incorp), if incorp==state
estimates store II

*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG BC BC_RET BC_NEG BC_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990
*estimates store III
*quiet areg EARN $inf $inf_RET $inf_NEG $inf_RET_NEG POST POST_RET POST_NEG POST_RET_NEG BC BC_RET BC_NEG BC_RET_NEG, absorb(gvkey) cluster(incorp), if fyear>=1985 & fyear<=1990 & incorp==state
*estimates store IV

*********************************************************************************************************************************************TABLE 4. PANEL A: BASU POST RESULTS
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) t(%9.2f) stats(N r2_a)
estimates table I II, drop($inf $inf_RET $inf_NEG $inf_RET_NEG) b(%9.4f) stats(N r2_a) star
