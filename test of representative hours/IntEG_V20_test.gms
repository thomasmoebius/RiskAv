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
    j   /j1*j8/
    k   /k1*k13/;

parameter
    report(j,*), report2(j,*), report3(k,*),report4(k,*);


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
report(j,'Inv-CCGT ')       =  sum(n, new_cap(n,'CCGT','y2030'))       ;
report(j,'Inv-OCGT ')       =  sum(n, new_cap(n,'OCGT','y2030'))       ;
report(j,'curt_RES[TWh]')   =  sum(n, curt_RES(n,'y2030'))             ;

report2(j,'OBJ %')            =  (report(j,'OBJ') / report('j1','OBJ'))                      - 1  +EPS;
report2(j,'Inv-CCGT %')       =  (report(j,'Inv-CCGT ') / report('j1','Inv-CCGT '))          - 1  +EPS;
report2(j,'Inv-OCGT %')       =  (report(j,'Inv-OCGT ') / report('j1','Inv-OCGT '))          - 1  +EPS;
report2(j,'curt_RES %')       =  (report(j,'curt_RES[TWh]')  / report('j1','curt_RES[TWh]')) - 1  +EPS;

    );

loop (k,

t(t_all) $ (ord(k) = 1) = h25_1(t_all) ;
t(t_all) $ (ord(k) = 2) = h25_3(t_all) ;
t(t_all) $ (ord(k) = 3) = h25_5(t_all) ;
t(t_all) $ (ord(k) = 4) = h25_7(t_all) ;
t(t_all) $ (ord(k) = 5) = h25_9(t_all) ;
t(t_all) $ (ord(k) = 6) = h25_11(t_all) ;
t(t_all) $ (ord(k) = 7) = h25_13(t_all) ;
t(t_all) $ (ord(k) = 8) = h25_15(t_all) ;
t(t_all) $ (ord(k) = 9) = h25_17(t_all) ;
t(t_all) $ (ord(k) = 10) = h25_19(t_all) ;
t(t_all) $ (ord(k) = 11) = h25_21(t_all) ;
t(t_all) $ (ord(k) = 12) = h25_23(t_all) ;
t(t_all) $ (ord(k) = 13) = h25_25(t_all) ;

        t_number              = card(t);
        hour_scaling          = t_number/8760;
        RHS                   = 8760/t_number;

    SOLVE LSEWglobal using lp minimizing Cost_GLobal;

$include IntEG_v20_resprocess.gms

report3(k,'OBJ')             =  Cost_GLobal.l;
report3(k,'Inv-CCGT ')       =  sum(n, new_cap(n,'CCGT','y2030'))       ;
report3(k,'Inv-OCGT ')       =  sum(n, new_cap(n,'OCGT','y2030'))       ;
report3(k,'curt_RES[TWh]')   =  sum(n, curt_RES(n,'y2030'))             ;

report4(k,'OBJ %')            =  report3(k,'OBJ')       / report('j1','OBJ') - 1        +EPS;
report4(k,'Inv-CCGT %')       =  report3(k,'Inv-CCGT ') / report('j1','Inv-CCGT ') - 1  +EPS;
report4(k,'Inv-OCGT %')       =  report3(k,'Inv-OCGT ') / report('j1','Inv-OCGT ') - 1  +EPS;
report4(k,'curt_RES %')       =  report3(k,'curt_RES[TWh]')  / report('j1','curt_RES[TWh]') - 1  +EPS;

    );


display report, report2;
display report3, report4;

execute_unload '%resultdir%%GlobalSCEN%_DET_Scen.gdx';

