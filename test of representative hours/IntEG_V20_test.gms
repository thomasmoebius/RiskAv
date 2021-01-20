*#################################################################################################################################
*                                                       Testing Nth hour issue
*#################################################################################################################################

*Location of output files for this scenario
$set resultdir  output_v20_test\

    scen('EVP')  = no;
    scen('EUCO') = yes;
    scen('ST')   = no;
    scen('DG')   = no;

number_scenarios   = card(scen);

###############################################################################
*                               Defining RESULTS parameters
*###############################################################################

  PARAMETERS

  production_GasT_el(n,year)
  production_GasT_th(n,year)
  invest_gen(n,i,year)
  new_cap(n,i,year)
  curt_RES(n,year)
  FullLoadHours(n,year,i)
;

*#############################        STEP 1:  Assigning PARAMETERS         ####################

        demand(co,t,year,scen)              = demand_upload(co,t,year,"EUCO_up");
        cap_existing(i,n,year,scen)         = cap_existing_upload(i,n,year,"EUCO_up");
        fc(i,co,year,scen)                  = fc_upload(i,co,year,"EUCO_up") ;
        co2_price(scen,year)                = co2_price_upload("EUCO_up", year);
        vc_f(i,co,year,scen)                = (fc_upload(i,co,year,"EUCO_up")+ carb_cont(i)*co2_price_upload('EUCO_up',year))/ eta_f(i,co,year);
        vc_m(i,co,year,scen)                = (fc_upload(i,co,year,"EUCO_up")+ carb_cont(i)*co2_price_upload('EUCO_up',year))/ eta_m(i,co,year);


set
    j   /j1*j8/;

parameter
    report (j,*);


*#############################        STEP 2: SOLVING DP        #################################
loop (j,

t(t_all) $ (ord(j) = 1) = h1(t_all) ;
t(t_all) $ (ord(j) = 2) = h2(t_all) ;
t(t_all) $ (ord(j) = 3) = h4(t_all) ;
t(t_all) $ (ord(j) = 4) = h10(t_all) ;
t(t_all) $ (ord(j) = 5) = h25(t_all) ;
t(t_all) $ (ord(j) = 6) = h50(t_all) ;
t(t_all) $ (ord(j) = 7) = h100(t_all) ;
t(t_all) $ (ord(j) = 8) = h200(t_all) ;

        t_number              = card(t);
        hour_scaling          = t_number/8760;
        RHS                   = 8760/t_number;

    SOLVE LSEWglobal using lp minimizing Cost_GLobal;

$include IntEG_v20_resprocess.gms

report(j,'OBJ')             =  Cost_GLobal.l;
report(j,'Inv-CCGT ')       =  new_cap('cn_DE','CCGT','y2030')         ;
report(j,'Inv-OCGT ')       =  new_cap('cn_DE','OCGT','y2030')         ;
report(j,'FLH-CCGT ')       =  FullLoadHours('cn_DE','y2030','CCGT')   ;
report(j,'FLH-OCGT')        =  FullLoadHours('cn_DE','y2030','OCGT')   ;
report(j,'curt_RES[TWh]')   =  curt_RES('cn_DE','y2030') / 1e6             ;

    );

display report;

execute_unload '%resultdir%%GlobalSCEN%_DET_Scen.gdx';

