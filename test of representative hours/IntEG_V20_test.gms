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
    it iterations /i0/;

parameter
    report (it,*);

*#############################        STEP 2: SOLVING DP        #################################
loop (it,

t /t25, t50/;

    SOLVE LSEWglobal using lp minimizing Cost_GLobal;

$include IntEG_v20_resprocess.gms

report(it,'OBJ')  =  Cost_GLobal.l;
report(it,'Inv-CCGT')  =  new_cap('cn_DE','CCGT','y2030')         ;
report(it,'Inv-OCGT')  =  new_cap('cn_DE','OCGT','y2030')         ;
report(it,'FLH-CCGT')  =  FullLoadHours('cn_DE','y2030','CCGT')   ;
report(it,'FLH-OCGT')  =  FullLoadHours('cn_DE','y2030','OCGT')   ;
report(it,'curt_RES')  =  curt_RES('cn_DE','y2030')               ;

    );

display report;

execute_unload '%resultdir%%GlobalSCEN%_DET_Scen.gdx';

