*#################################################################################################################################
*                                                       Testing Nth hour issue
*#################################################################################################################################

*Location of output files for this scenario
$set resultdir  output_v20_test\

$include IntEG_v20_clear.gms

$if "%Inc_Stoch%" ==  "" $goto ScenMatrixEnd

    scen('EVP')  = no;
    scen('EUCO') = yes;
    scen('ST')   = no;
    scen('DG')   = no;

$Label ScenMatrixEnd

display scen;

number_scenarios   = card(scen);

###############################################################################
*                               Defining RESULTS parameters
*###############################################################################

$include IntEG_v20_declar_results.gms

*#############################        STEP 1:  DECLARING PARAMETERS         ####################

        demand(co,t,year,scen)              = demand_upload(co,t,year,"EUCO_up");
        cap_existing(i,n,year,scen)         = cap_existing_upload(i,n,year,"EUCO_up");
        fc(i,co,year,scen)                  = fc_upload(i,co,year,"EUCO_up") ;
        co2_price(scen,year)                = co2_price_upload("EUCO_up", year);
        vc_f(i,co,year,scen)                = (fc_upload(i,co,year,"EUCO_up")+ carb_cont(i)*co2_price_upload('EUCO_up',year))/ eta_f(i,co,year);
        vc_m(i,co,year,scen)                = (fc_upload(i,co,year,"EUCO_up")+ carb_cont(i)*co2_price_upload('EUCO_up',year))/ eta_m(i,co,year);

*#############################        STEP 2: SOLVING DP        #################################

    SOLVE LSEWglobal using lp minimizing Cost_GLobal;

execute_unload '%resultdir%%GlobalSCEN%_DET_Scen.gdx';

