*###############################################################################
*                               DECLARING TIME SETS
*###############################################################################
$Setglobal  YEARS_inc  y2030

SETS
    t_all               all hours of a year                /t1*t8760/
    t(t_all)            all hours to be solved

    h1(t_all)
    h2(t_all)
    h4(t_all)
    h10(t_all)
    h25(t_all)
    h50(t_all)
    h100(t_all)
    h200(t_all)

    h25_1(t_all)
    h25_3(t_all)
    h25_5(t_all)
    h25_7(t_all)
    h25_9(t_all)
    h25_11(t_all)
    h25_13(t_all)
    h25_15(t_all)
    h25_17(t_all)
    h25_19(t_all)
    h25_21(t_all)
    h25_23(t_all)
    h25_25(t_all)
;

SETS
    Year_all            all possible years              /y2013*y2027,y2030/
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

    m_first(month)                   first month    in year
    m_last(month)                    last month     in year
    y_first(year)                    first year     in model
    y_last(year)                     last year      in model
    m_first_global(year, month)      first month    in model
    m_last_global(year, month)       last month     in model
    ;

    alias (t_all,tt_all)
    alias (t,tt)


*###############################################################################
*                               READING and MAPPING
*###############################################################################

*Don't write comments inside onecho file!
$onecho > Import_time.txt
        set=time    rng=time!C1          rdim=4
        set=t       rng=time_periods!B2  rdim=1

        set=h1      rng=time_periods!B2  rdim=1
        set=h2      rng=time_periods!D2  rdim=1
        set=h4      rng=time_periods!F2  rdim=1
        set=h10     rng=time_periods!H2  rdim=1
        set=h25     rng=time_periods!J2  rdim=1
        set=h50     rng=time_periods!L2  rdim=1
        set=h100    rng=time_periods!N2  rdim=1
        set=h200    rng=time_periods!P2  rdim=1

        set=h25_1    rng=time_periods_25!B2  rdim=1
        set=h25_3    rng=time_periods_25!D2  rdim=1
        set=h25_5    rng=time_periods_25!F2  rdim=1
        set=h25_7    rng=time_periods_25!H2  rdim=1
        set=h25_9    rng=time_periods_25!J2  rdim=1
        set=h25_11   rng=time_periods_25!L2  rdim=1
        set=h25_13   rng=time_periods_25!N2  rdim=1
        set=h25_15   rng=time_periods_25!P2  rdim=1
        set=h25_17   rng=time_periods_25!R2  rdim=1
        set=h25_19   rng=time_periods_25!T2  rdim=1
        set=h25_21   rng=time_periods_25!V2  rdim=1
        set=h25_23   rng=time_periods_25!X2  rdim=1
        set=h25_25   rng=time_periods_25!Z2  rdim=1

$offecho

$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%Time.gdx cmerge=1 @Import_time.txt
$gdxin %datadir%Time.gdx
$LOAD time, t, h1, h2, h4, h10, h25, h50, h100, h200
$LOAD h25_1, h25_3, h25_5, h25_7, h25_9, h25_11, h25_13, h25_15, h25_17, h25_19, h25_21, h25_23, h25_25
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

*                               TIME MANAGEMENT

    m_first(month) = yes$(ord(month) eq 1);
    m_last(month)  = yes$(ord(month) eq card(month));

    y_first(year) = yes$(ord(year) eq 1);
    y_last(year)  = yes$(ord(year) eq card(year));

    m_first_global(year, month) = yes$(m_first(month) and y_first(year));
    m_last_global(year, month) = yes$(m_last(month) and y_last(year));


*                               CHECK TIME INPUT
* execute_unload '%datadir%1_check_timeinput.gdx'
* $stop