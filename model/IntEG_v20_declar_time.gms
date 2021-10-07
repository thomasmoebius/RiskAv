*###############################################################################
*                               DECLARING TIME SETS
*###############################################################################
$Setglobal  YEARS_inc  y2020, y2025, y2030


SETS
    t_all               all hours of a year                /t1*t8760/
    t(t_all)            all hours to be solved (in data upload)
;

SETS
    Year_all            all possible years              /y2020*y2030/
    Year(Year_all)      year modelled                   /%YEARS_inc%/
    month               set of month                    /m1*m12/
    day                 days in a year                  /day1*day365/
    hourD               hours of a day                  /hour1*hour24/

    time(month,day,t_all,hourD)     aggregated time set for 1 year
    Year_T(Year,t_all)              Mapping
    Month_T(Month,t_all)            mapping
    hour_T(hourD,t_all)             mapping

    Day_T(Day,t_all)                mapping
    Year_M (year, month)            mapping


    ;

    alias (t_all,tt_all)
    alias (t,tt)


*###############################################################################
*                               READING and MAPPING
*###############################################################################

*Don't write comments inside onecho file!
$onecho > Import_time.txt
        set=time rng=time!C1      rdim=4
        set=t    rng=time!I2      rdim=1
$offecho

$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%Time.gdx cmerge=1 @Import_time.txt
$gdxin %datadir%Time.gdx
$LOAD time, t
$gdxin

*                               MAPPING TIME

loop(year,
    Loop(time(month,day,t_all,hourD),
        Month_T(Month,t_all)    = yes;
        Day_T(Day,t_all)        = yes;
        hour_T(hourD,t_all)     = yes;
        );
    Year_T(Year,t_all)      = yes;
    Year_M(year, month)     = yes;

    );



*                               CHECK TIME INPUT
*execute_unload '%datadir%1_check_timeinput.gdx'
