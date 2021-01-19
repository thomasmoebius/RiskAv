$Title IntEG version 20 (09 March 2020)

$ontext
Integrated energy dispatch & investment model
LSEW BTU

    UPPERCASE      - parameter
    lowercase      - variable
$offtext


*###############################################################################
*                                  DEFAULT OPTIONS
*###############################################################################

file fx2;
put fx2;

$eolcom #

*###############################################################################
*                            DIRECTORIRY and FILE MANAGEMENT
*###############################################################################

*Location of input files
$set datadir    data\

*  Currently all data is in one file
$Set DataIn     Input_v2

* version
$setglobal GlobalSCEN v20

*Assigning to output file a model's version
$set       result     Integ_%GlobalSCEN%

*   Choose time resolution of GAS model [year, month, day]
*   $setglobal Month

*###############################################################################
*                                MODEL SPECIFICATIONS
*###############################################################################

                        #SELECT "" TO ACTIVATE / '*' TO DISACTIVATE

$setglobal only_report      ""  # if '*' report not active, if '' report and stop after report active

                                #RELATED TO PARAMETRIC UNCERTAINTY

$setglobal Inc_Det          ""
$setglobal Inc_Stoch        "*"
$setglobal Inc_StochFI      "*"
$setglobal Inc_ECIUvalues   "*"

$ifthen "%Inc_Stoch%" ==    ""   $set Exc_Stoch ""
                                 set  allscen       /EUCO, ST, DG/
                                      scen(allscen) /EUCO, ST, DG/;
$else                            $set Exc_Stoch "*"
                                 set  allscen /EVP, EUCO, ST, DG/
                                      scen(allscen);
$endif

set UncPar /GasDem, ElDem, RESCap, FuelPrice, CO2Price, AllPar/;

                                #RELATED TO GAS MODEL

$setglobal Inc_LTC      "*"
$ifthen "%Inc_LTC%" ==  ""   $setglobal Exc_LTC "*"
$else                        $setglobal Exc_LTC ""
$endif

$setglobal Invest_gas_grid   "*"  #Investments in gas infrastructure
$setglobal Invest_gas_LNG    "*"  #Investments in LNG infrastructure

                              #RELATED TO ELECTRICITY  MODEL

$setglobal Store        ""         #Storage
$setglobal Shed         ""         #Load shedding
$setglobal Trade        "*"         #Trade between markets
$setglobal Startup      "*"        #Startups
$setglobal Invest_gen   ""         #Investment in generation capacity
$setglobal Invest_NTC   "*"        #Investment in NTC capacity
$setglobal CHP          ""         #considering minim production due to CHP

$ifthen "%Startup%" == ""   $setglobal Exc_startup "*"
$else                       $setglobal Exc_startup ""
$endif


*###############################################################################
*                               DECLARING & MAPPING TIME
*###############################################################################

$include IntEG_v20_declar_time.gms

*###############################################################################
*                               DECLARING & MAPPING TOPOLOGY
*###############################################################################

********************************  Global MODEL TOPOLOGY ***************************
SETS
    n                all nodes
    co(n)            consumption nodes for gas and all nodes for electricity
    coo(co)          co without Norway
    ;


    alias(n,m);
    alias(n,nn);
    alias(co,coco);

*****************************  ELECTRICITY MODEL TOPOLOGY *********************

SETS
    i                      all electricity generation technologiess
        ResT(i)            only RES generation technologies
        ConvT(i)           only conventional technologies
        StorT(i)           only storage technologies
        GasT(i)            only gas fuel technologies
        ReservT(i)         only Reservoirs

    scen_up         scenarios which are used to upload all scenario data
                    /EUCO_up, ST_up, DG_up/
    ;

*###############################################################################
*                               DECLARING PARAMETERS
*###############################################################################


*********************************  ELECTRICITY  MODEL  *************************

    Parameters
* Generation Cost Parameters

        vc_f(i,co,year,allscen)             unit cost (€ per MWhel) at minimum load level
        vc_m(i,co,year,allscen)             unit cost (€ per MWhel) at minimum load level
        co2_price_upload(scen_up,year)      co2_price EUR per ton to upload data set for all scenarios
        co2_price(allscen,year)             co2_price EUR per ton
        fc_upload(i,n,year,scen_up)         fuel costs [€ per MWhth] to upload data set for all scenarios
        fc(i,co,year,allscen)               fuel costs [€ per MWhth]

        sc(i)            startup costs (€ per MW)
        ic(i)            annualized investment costs

        discountfactor    discount factor to discount cash flows

*Capacity Parameters

        cap_max(i,n)                                maximum potential of installed capacity for each technology
        cap_existing_upload(i,n,year,scen_up)       already fixed capacities for each year to upload data set for all scenarios
        cap_existing(i,n,year,allscen)              already fixed capacities for each year
        g_min(i)                                    minimum generation

        eta_f(i,n,year)                         efficiency at full load
        eta_m(i,n,year)                         efficiency at min load
        carb_cont(i)                            carbon content of a fossil fuel (thermal)
        af(i,n)                                 availability factor for conv. technologies
        co_af(i,n)                              country specific availabilities
        CHP_factor(n,year)                      factor to scale the CHP production by gas power plants

*Time Varying load and RES parameters
        pf(i,n,t_all)                       hourly production factor for RES
        demand(co,t,year,allscen)           electricity demand per year
        demand_upload(n,t_all,year,scen_up) electricity demand per year (scenario dependent upload)
        all_dem(n,year,scen_up)             overall consumption within one year for each country
        VoLa(co)                            value of lost adequacy
        heat_factor(t_all,n)                  hourly degree day


*Electricity Transfer Parameters
        ntc(co,year,coco)                   Net Transfer Capacities between two nodes
        ntc_dist(co,coco)                   distance between two electricity nodes [km]

*Data Upload Parameters
        techup           technology Upload
        genup            generation capacity upload
        timeup           upload of time data (Demand)
        nodeup           upload of country specific data
        RESup            upload for RES production factors

*EVP Values
    EVP_demand(co,t,year)
    EVP_cap_existing(i,co,year)
    EVP_fc(i,co,year)
    EVP_co2_price(year)
    EVP_vc_f(i,co,year)
    EVP_vc_m(i,co,year)

        ;

    Scalars
        cpf              capacity power factor for storages                                      /9/
        flh_Reservoir    full load hours reservoir                                               /6100/
        volg             dummy value for gas shedding (for INFES checks)                         /1000000/
        ic_ntc           specific investment costs for NTC in EUR per MW and km                  /81/
        ic_gas_grid      specific investment costs for gas infrastructure in EUR per MWh*km      /0.000437/
        ic_LNG           specific investment costs LNG regasification in EUR per MWh             /0.246298/
        discount_rate    discount rate to discount cash flows                                    /0.06/
        inf_rate         average annual inflation rate to convert cost data y2015 to y2020       /0.013/
        inf_factor       converting cost from y2015 to y2020
        ;

* if 2015: discountfactor(year) = 1/((1+discount_rate)**((ord(year)-1)*5));
        discountfactor(year) = 1/((1+discount_rate)**((ord(year)-1)*5));
        inf_factor           = 1 * (1+inf_rate)**5;

*Don't write comments inside onecho file!
$onecho > ImportINTEG.txt

        set=N               rng=nodemaps!B2       rdim=1
        set=P               rng=nodemaps!D60      rdim=1
        set=W               rng=nodemaps!D37:D57  rdim=1

        set=co              rng=nodemaps!F37:F57  rdim=1
        set=coo             rng=nodemaps!F37:F56  rdim=1

        set=i               Rng=Technology!A4    Cdim=0 Rdim=1
        Par=techup          Rng=Technology!A1    Cdim=3 Rdim=1
        Par=genup           Rng=Capacity!A1      Cdim=3 Rdim=2
        Par=timeup          Rng=ElDemTS!A1      Cdim=3 Rdim=1
        Par=RESup           Rng=RESdata!A1       Cdim=2 Rdim=1
        Par=nodeup          Rng=Country!A1       Cdim=3 Rdim=1
        Par=co2_price_upload Rng=Technology!L23   Cdim=1 Rdim=1
        Par=ntc             Rng=NTC!A1           Cdim=2 Rdim=1
        Par=ntc_dist        Rng=NTC!A48:T69      Cdim=1 Rdim=1
        Par=heat_factor     Rng=time!H2          Cdim=1 Rdim=1

$offecho

*$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%%DataIn%.gdx cmerge=1 @ImportINTEG.txt
$gdxin %datadir%%DataIn%.gdx

$LOAD N, CO, COO,
$LOAD i
$LOAD techup, genup, timeup, nodeup, RESup
$LOAD co2_price_upload
$LOAD ntc, ntc_dist, heat_factor

$gdxin

scalars
        hour_scaling            scaling investment costs to representitive hours
        t_number                number of representitive hours
        conversion_factor_gas   conversion from MWhth to BCM

        number_scenarios        number of scenarios
        RHS                     it is 1 div conversion_factor_gas
        scaling                 scales objective
        ;

        t_number              = card(t);
        hour_scaling          = t_number/8760;
        RHS                   = 8760/t_number;
        conversion_factor_gas = 1/(10.76*1000000);
        scaling               = 1;


*###############################################################################
*                               PREPARING SETS AND DATA
*###############################################################################

    ConvT(i)   = NO;
    StorT(i)   = NO;
    ResT(i)    = NO;
    GasT(i)    = NO;
    ReservT(i) = NO;

    ConvT(i)  = techup(i,'Tech classification','','')= 1 OR techup(i,'Tech classification','','')= 4 ;
    StorT(i)  = techup(i,'Tech classification','','')= 2 ;
    ResT(i)   = techup(i,'Tech classification','','')= 3 ;
    GasT(i)   = techup(i,'Tech classification','','')= 4 ;
    ReservT(i)= techup(i,'Tech classification','','')= 5 ;

    Parameter GasTech(i);
    GasTech(i)$(techup(i,'Tech classification','','') eq 4) = yes;

*Define parameters from  'techup'
        ic (i)                               =techup(i,'annual investment costs','','');
        fc_upload(i,co,year,scen_up)         =techup(i,'fuel_cost',scen_up,year);
        fc_upload(GasT,'cn_NO',year,scen_up) = 10;
        carb_cont(i)                         = techup(i,'carbon content','','');
        eta_f(i,co,year)                     =techup(i,'efficiency_full_load','',year);
        eta_m(i,co,year)                     =eta_f(i,co,year) - techup(i,'efficiency_loss','','');
        sc(i)                                =techup(i,'sc','','');
        g_min(i)                             =techup(i,'g_min','','');
        co_af(i,co)                          =nodeup(co,i,'allyears','') ;
        af(i,co)                             =techup(i,'af','','') ;
        af(i,co)$co_af(i,co)                 =techup(i,'af','','')*co_af(i,co);

*Define parameters from  'genup'
        cap_max(i,co)= genup('EUCO_up',co,'max added capacity [MW]', '', i);
        cap_existing_upload(i,co,year,scen_up)=genup(scen_up,co,'installed Capacity [MW]',year,i);

*Define parameters from  'timeup'
        pf(ResT,co,t)=RESup(t,ResT,co);
*        all_dem(co,'y2015',scen_up) = nodeup(co,'overall demand','y2015','') ;
*        all_dem(co,'y2020',scen_up) = nodeup(co,'overall demand','y2020','')    ;
*        all_dem(co,'y2025',scen_up) = nodeup(co,'overall demand','y2025','')   ;
        all_dem(co,'y2030',scen_up) = nodeup(co,'overall demand','y2030',scen_up)  ;

*        demand_upload(co,t,'y2015',scen_up) = timeup(t,'y2015','real',co);
*        demand_upload(co,t,'y2020',scen_up) = timeup(t,'y2020','best estimate',co) ;
        demand_upload(co,t,'y2030',scen_up) = timeup(t,'y2030',scen_up,co);
*        demand_upload(co,t,'y2025',scen_up) = demand_upload(co,t,'y2020',scen_up)+(demand_upload(co,t,'y2030',scen_up)-demand_upload(co,t,'y2020',scen_up))/2;

        VoLa(co) = nodeup(co,'VoLA','','') ;

*Define parameters from 'countryup'
        CHP_factor(n,year)= nodeup(n,'CHP_production_gas',year,'') ;


*###############################################################################
*                        MODEL (variables, equations, model form)
*###############################################################################

$include IntEG_v20_model.gms

*###############################################################################
*                        FIXING VARIABLES & SOLVE OPTIONS
*###############################################################################

$include IntEG_v20_SolveOptions.gms


*#################################################################################################################################
*                                                       Test of representative hours
*#################################################################################################################################

$include IntEG_V20_test.gms

*#################################################################################################################################
*                                                       SCENARIO 1: ECIU - EVP
*#################################################################################################################################

*$include IntEG_V20_S1(ECIU_EVP).gms

*#################################################################################################################################
*                                                       SCENARIO 2: ECIU - EUCO
*#################################################################################################################################

*$include IntEG_V20_S2(ECIU_EUCO).gms

*#################################################################################################################################
*                                                       SCENARIO 3: ECIU - ST
*#################################################################################################################################

*$include IntEG_V20_S3(ECIU_ST).gms

*#################################################################################################################################
*                                                       SCENARIO 4: ECIU - DG
*#################################################################################################################################

*$include IntEG_V20_S4(ECIU_DG).gms
