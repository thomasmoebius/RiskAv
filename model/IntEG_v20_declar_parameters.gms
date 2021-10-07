


*********************************  ELECTRICITY  MODEL  *************************

    Parameters

        probability(scen)       probability factor for each scenario


* Generation Cost Parameters

        vc_f(i,n,year,scen)             unit cost (Euro per MWhel) at minimum load level
        vc_m(i,n,year,scen)             unit cost (Euro per MWhel) at minimum load level
        co2_price_upload(scen_up,year)      co2_price EUR per ton to upload data set for all scenarios
        co2_price(scen,year)             co2_price EUR per ton
        fc_upload(i,n,year,scen_up)         fuel costs [Euro per MWhth] to upload data set for all scenarios
        fc(i,n,year,scen)               fuel costs [Euro per MWhth]
        varOM(i)                        variable O&M costs

        sc(i)            startup costs (Euro per MW)
        ic(i)            annualized investment costs

        discountfactor    discount factor to discount cash flows

*Capacity Parameters

        cap_max(i,n)                                maximum potential of installed capacity for each technology
        cap_existing_upload(i,n,year,scen_up)       already fixed capacities for each year to upload data set for all scenarios
        cap_existing(i,n,year,scen)              already fixed capacities for each year
        g_min(i)                                    minimum generation

        eta_f(i,n,year)                         efficiency at full load
        eta_m(i,n,year)                         efficiency at min load
        carb_cont(i)                            carbon content of a fossil fuel (thermal)
        af(i,n)                                 availability factor for conv. technologies
        af_reservoir_upload(month,n)                availability hydro reservoir capacities [MW]
        af_reservoir(n,t)                       availability hydro reservoir capacities [MW]

        budget_reservoir_upload(month,n)        upload of water budget for hydro reservoirs as share installed capacity running at full load
        budget_reservoir(n,t)                   water budget for hydro reservoirs as share installed capacity running at full load

*Time Varying load and RES parameters
        pf(i,n,t_all)                       hourly production factor for RES
        demand(n,t,year,scen)           electricity demand per year
        demand_upload(n,t_all,year,scen_up) electricity demand per year (scenario dependent upload)


        VoLA(sector,n)                      value of lost adequacy
        av_VoLA(sector)                     EU average  value of lost adequacy
        sector_share(sector,n)              share of a sector at the electricity consumption
        av_sector_share(sector)             EU average share of a sector at the electricity consumption



*Electricity Transfer Parameters
        ntc(n,year,nn)                   Net Transfer Capacities between two nodes
        ntc_dist(n,nn)                   distance between two electricity nodes [km]

*Data Upload Parameters
        techup           technology Upload
        genup            generation capacity upload
        timeup           upload of time data (Demand)
        nodeup           upload of country specific data
        nodeup_2         upload of country specific data (for VoLA)
        RESup            upload for RES production factors

*EVP Values
    EVP_demand(n,t,year)
    EVP_cap_existing(i,n,year)
    EVP_fc(i,n,year)
    EVP_co2_price(year)
    EVP_vc_f(i,n,year)
    EVP_vc_m(i,n,year)

        ;

    probability(scen) = 1/card(scen)    ;



    Scalars
        cpf              capacity power factor for storages                                      /9/
        flh_Reservoir    full load hours reservoir                                               /4000/

        ic_ntc           specific investment costs for NTC in EUR per MW and km                  /63/

        discount_rate    discount rate to discount cash flows                                    /0.06/
        inf_rate         average annual inflation rate to convert cost data y2015 to y2020       /0.013/

        ;

        discountfactor(year) = 1/((1+discount_rate)**((ord(year)-1)*5));



*###############################################################################
*                               READING OF SETS & DATA
*###############################################################################

$onecho > ImportINTEG.txt

        set=n               rng=nodemaps!B2       rdim=1

        set=i               Rng=Technology!A4    Cdim=0 Rdim=1
        Par=techup          Rng=Technology!A1    Cdim=3 Rdim=1
        Par=genup           Rng=Capacity!A1      Cdim=3 Rdim=2
        Par=timeup          Rng=ElDemTS!A1       Cdim=3 Rdim=1
        Par=RESup           Rng=RESdata!A1       Cdim=2 Rdim=1
        Par=nodeup          Rng=Country!A3       Cdim=2 Rdim=1
        Par=af_reservoir_upload          Rng=Country!A31:L44      Cdim=1 Rdim=1
        Par=budget_reservoir_upload      Rng=Country!A47:L60      Cdim=1 Rdim=1
        Par=co2_price_upload Rng=Technology!L23   Cdim=1 Rdim=1
        Par=ntc             Rng=NTC!A1           Cdim=2 Rdim=1
        Par=ntc_dist        Rng=NTC!A33:V55      Cdim=1 Rdim=1


        Par=av_VoLA             Rng=Country!Q58:AE59    Cdim=1 Rdim=0
        Par=av_sector_share     Rng=Country!Q61:AE62    Cdim=1 Rdim=0


$offecho

$call GDXXRW I=%datadir%%DataIn%.xlsx O=%datadir%%DataIn%.gdx cmerge=1 @ImportINTEG.txt
$gdxin %datadir%%DataIn%.gdx

$LOAD n, i
$LOAD techup, genup, timeup, nodeup, RESup
$LOAD co2_price_upload, af_reservoir_upload, budget_reservoir_upload
$LOAD ntc, ntc_dist,
$LOAD av_VoLA, av_sector_share
$gdxin


scalars
        hour_scaling            scaling investment costs to representitive hours
        t_number                number of representitive hours


        number_scenarios        number of scenarios
        RHS                     it is 8760 div by amount of hours
        scaling                 scales objective
;

        t_number              = card(t);
        hour_scaling          = t_number/8760;
        RHS                   = 8760/t_number;

        scaling               = 1;


number_scenarios   = card(scen);

*###############################################################################
*                               PREPARING SETS AND DATA
*###############################################################################


    ConvT(i)   = NO;
    noGas(i)   = NO;
    StorT(i)   = NO;
    ResT(i)    = NO;
    GasT(i)    = NO;
    ReservT(i) = NO;

    ConvT(i)  = techup(i,'Tech classification','','')= 1 OR techup(i,'Tech classification','','')= 4 ;
    StorT(i)  = techup(i,'Tech classification','','')= 2 ;
    ResT(i)   = techup(i,'Tech classification','','')= 3 ;
    GasT(i)   = techup(i,'Tech classification','','')= 4 ;
    noGas(i)  = techup(i,'Tech classification','','')= 1 ;
    ReservT(i)= techup(i,'Tech classification','','')= 5 ;

    Parameter GasTech(i);
    GasTech(i)$(techup(i,'Tech classification','','') eq 4) = yes;

display ConvT, StorT, noGas, ResT, GasT, ReservT;

*Define parameters from  'techup'
        ic (i)                              = techup(i,'annual investment costs','','') +techup(i,'Fixed O&M cost','','');

        fc_upload(i,n,year,scen_up)         = techup(i,'fuel_cost',scen_up,year);
        varOM(i)                            = techup(i,'Variable O&M cost','','');

        carb_cont(i)                        = techup(i,'carbon content','','');
        eta_f(i,n,year)                     = techup(i,'efficiency_full_load','',year);
        eta_m(i,n,year)                     = eta_f(i,n,year) - techup(i,'efficiency_loss','','');
        sc(i)                               = techup(i,'sc','','');
        g_min(i)                            = techup(i,'g_min','','');

        af(i,n)                             = techup(i,'af','','') ;
        af_reservoir(n,t)                   = sum(month$Month_T(Month,t),  af_reservoir_upload(month,n) )   ;

        budget_reservoir(n,t)               = sum(month$Month_T(Month,t),  budget_reservoir_upload(month,n) )   ;



*Define parameters from  'genup'
        cap_max(i,n)= genup('EUCO_up',n,'max added capacity [MW]', '', i);
        cap_existing_upload(i,n,year,scen_up)=genup(scen_up,n,'installed Capacity [MW]',year,i);

*Define parameters from  'timeup'
        pf(ResT,n,t)=RESup(t,ResT,n);

        demand_upload(n,t,'y2020',scen_up) = timeup(t,'y2020','best estimate',n) ;
        demand_upload(n,t,'y2030',scen_up) = timeup(t,'y2030',scen_up,n);
        demand_upload(n,t,'y2025',scen_up) = demand_upload(n,t,'y2020',scen_up)+(demand_upload(n,t,'y2030',scen_up)-demand_upload(n,t,'y2020',scen_up))/2;


*Load shedding costs VoLA
        VoLA(sector,n)          = nodeup(n,'VoLA_MeritOrder_costs',sector) ;
        sector_share(sector,n)  = nodeup(n,'VoLA_MeritOrder_sectorshare',sector) ;

%Vola_const%        VoLa(sector,n) = av_VoLA(sector)   ;
%Vola_const%        sector_share(sector,n) =  av_sector_share(sector)   ;









