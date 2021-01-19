*###############################################################################
*                                    VARIABLES
*###############################################################################

******************************** Global  MODEL  ********************************

*********************************  ELECTRICITY  MODEL  *************************

    POSITIVE VARIABLES

        OC(scen)                         2nd stage operational cost for each scenario
        G(i,n,t_all,year,scen)           generation of technology i at time t
        P_ON(i,n,t_all,year,scen)        online capacity of technology i at time t
        SU(i,n,t_all,year,scen)          start up variable
        CAP_new(i,n,year)                installed capacity
        SHED(sector,n,t_all,year,scen)          load sheding at a VoLA by an economic sector
        Xdem(n,t_all,year,scen)          increases demand at igh cost to test for infeasibility
        P_PSP(i,n,t_all,year,scen)       pumping of water back to the PSP reservoir
        StLevel(i,n,t_all,year,scen)     level of the PSP storage at time t

        NTC_new(n,year,nn)                  invested NTC capacity in MW
        FLOW(n,nn,t_all,year,scen)       transfered capacity in MW

        VAR                              Value at risk
        CVAR                             conditional value at risk
        A(scen)                          auxiliary for CVAR
        ;

    VARIABLES
        COST_EL            total cost of electricity production
        ;


*################################################################################################################
*                                                   EQUATIONS
*################################################################################################################



*################################# ELECTRICITY MODEL #################################

EQUATIONS

OBJECTIVE_EL                                      minimizing total costs
OC_cost
res_dem(t,n,year,scen)                        energy balance (supply=demand)
res_start(i,n,t,year,scen)                startup restriction
res_G_RES(i,n,t,year,scen)                 maximum for RES generation depends on hourly pf anc cap_RES
res_min_gen(i,n,t,year,scen)              minimum generation
res_max_gen(i,n,t,year,scen)              maximum generation
res_max_online(i,n,t,year,scen)           maximum online restriction
max_capacity(i,n,year)                           maximum potential capacity [MW]
storagelevel(t,i,n,year,scen)             level of the PSP storage
PSPmax(t,i,n,year,scen)                   PSP power limitation to installed turbine capacity
SHED_max(sector,n,t,scen,year)                       maximum shedding in a country
storagelevel(t,i,n,year,scen)             storage level at time t
storagelevel_max(t,i,n,year,scen)         max level of reservoir (upper basin)

reservoir_max_gen(i,n,t,year,scen)
reservoir_year_cap(i,n,year,scen)

Res_lineflow_1(n,nn,t,year,scen)
Res_lineflow_2(nn,n,t,year,scen)

res_new_cap(i,n,year)                   ensures that new cap has to be paid each year after construction
res_new_NTC(n,nn,year)                built connections exist for all following years (new cap has to be paid each year after construction )
RES_NTC_new_twoWay(n,nn,t,year)       the investment in a line affects both directions equally

CHP_restriction(n,t,year,scen)       minimum production due to CHP

res_cvar_1
res_cvar_2

PSP_new_max

;


OBJECTIVE_EL..  COST_EL =e= (1-w) * sum(scen,OC(scen)*probability(scen)) + w * CVAR
%Invest_gen%            + SUM( (i,n,year), ic(i) * CAP_new(i,n,year) * discountfactor(year))
%Invest_NTC%            + SUM( (n,nn,year), ic_ntc * ntc_dist(n,nn) * NTC_new(n,year,nn) * discountfactor(year) )
;

OC_cost(scen)..   OC(scen)    =E=
                  SUM( (convt,n,t,year), vc_f(convt,n,year,scen) * G(convt,n,t,year,scen)* discountfactor(year) ) *RHS

%startup%       + SUM( (convt,n,t,year), SU(convt,n,t,year,scen) * sc(convt) ) * discountfactor(year)  *RHS
%startup%       + SUM( (convt,n,t,year), (P_on(convt,n,t,year,scen)-G(convt,n,t,year,scen)) * (vc_f(convt,n,year,scen)- vc_f(convt,n,year,scen)) *g_min(convt) / (1-g_min(convt)) * discountfactor(year))  *RHS
%shed%          + SUM( (sector,n,t,year),  SHED(sector,n,t,year,scen)*vola(sector,n) * discountfactor(year)   )  *RHS
                + SUM( (n,t,year), Xdem(n,t,year,scen) * 9999 * discountfactor(year)   )  *RHS

 ;

res_dem(t,n,year,scen)..
            demand(n,t,year,scen) =E=
                  SUM( convt, G(convt,n,t,year,scen)) + SUM(rest, G(rest,n,t,year,scen) )
%store%         + SUM( stort,G(stort,n,t,year,scen) *eta_f(stort,n,year) - P_PSP(stort,n,t,year,scen) )
                + SUM( ReservT$cap_existing(ReservT,n,year,scen), G(ReservT,n,t,year,scen) )
%shed%          + SUM(sector, SHED(sector,n,t,year,scen))
%Trade%         + SUM( nn, FLOW(nn,n,t,year,scen) - FLOW(n,nn,t,year,scen) )
                - Xdem(n,t,year,scen)
                ;

res_G_RES(rest,n,t,year,scen)..    G(rest,n,t,year,scen) =L= abs(cap_existing(rest,n,year,scen)) * pf(rest,n,t)
;

res_new_cap(i,n,year)..            CAP_new(i,n,year) =G= CAP_new(i,n,year-1)
;

res_start(convt,n,t,year,scen)..        SU(convt,n,t,year,scen) =G= P_on(convt,n,t,year,scen)-P_ON(convt,n,t-1,year,scen)
;

res_min_gen(convt,n,t,year,scen)..      P_on(convt,n,t,year,scen)*g_min(convt) =L= G(convt,n,t,year,scen)
;

res_max_gen(convt,n,t,year,scen)..
                                 G(convt,n,t,year,scen) =L=
%Exc_startup%                                    cap_existing(convt,n,year,scen) * af(convt,n)
%Exc_startup%                                  + CAP_new(convt,n,year) * af(convt,n)
%startup%                                        P_on(convt,n,t,year,scen)
;

res_max_online(convt,n,t,year,scen)..    P_on(convt,n,t,year,scen) =L= (cap_existing(convt,n,year,scen))  * af(convt,n)
%Invest_gen%                                      + CAP_new(convt,n,year) * af(convt,n)
;

max_capacity(i,n,year)..               CAP_new(i,n,year) =L= cap_max(i,n)
;

* shedding costs vary between the countries, this equation aims to prevent for shedding the entire country´s demand
SHED_max(sector,n,t,scen,year)..              SHED(sector,n,t,year,scen) =L= demand(n,t,year,scen) * sector_share(sector,n)
;

##########################    PSP and Reservoirs   ###########################################

storagelevel_max(t,stort,n,year,scen)..   StLevel(stort,n,t,year,scen) =l= (cap_existing(stort,n,year,scen))  * cpf
%Invest_gen%                                          + CAP_new(stort,n,year)*cpf
;

storagelevel(t,stort,n,year,scen)..       StLevel(stort,n,t,year,scen) =e=
                                            StLevel(stort,n,t-1,year,scen) - G(stort,n,t,year,scen) + P_PSP(stort,n,t,year,scen)
;

PSPmax(t,stort,n,year,scen)..             G(stort,n,t,year,scen)+P_PSP(stort,n,t,year,scen) =l= cap_existing(stort,n,year,scen)*af(stort,n)
%Invest_gen%                                                      + CAP_new(stort,n,year)*af(stort,n)
;

PSP_new_max(stort,n,year,scen)..                            CAP_new(stort,n,year) =L= cap_existing(stort,n,'y2020',scen)
;

reservoir_max_gen(ReservT,n,t,year,scen)$cap_existing(ReservT,n,year,scen)..
                         G(ReservT,n,t,year,scen) =L= cap_existing(ReservT,n,year,scen)*af_reservoir(n,t)
;
reservoir_year_cap(ReservT,n,year,scen)$cap_existing(ReservT,n,year,scen)..
                         sum(t,G(ReservT,n,t,year,scen)) =L= cap_existing(ReservT,n,year,scen)* (flh_Reservoir / RHS)
;

***********       Network defintions and restrictions       ********************

Res_lineflow_1(n,nn,t,year,scen)..
                         FLOW(n,nn,t,year,scen) =L=
%Exc_Invest_NTC%                            ntc(n,year,nn)
%Invest_NTC%                                ntc(n,'y2020',nn)
%Invest_incl_Entsoe_additions%             + NTC_Entsoe_invest(n,year,nn)
%Invest_NTC%                               + NTC_new(n,year,nn)$ntc_dist(n,nn)
;
$ontext
Res_lineflow_2(nn,n,t,year,scen)..
                         FLOW(nn,n,t,year,scen) =L=
%Exc_Invest_NTC%                            ntc(nn,year,n)
%Invest_NTC%                                ntc(nn,'y2020',n)
%Invest_incl_Entsoe_additions%             + NTC_Entsoe_invest(nn,year,n)
%Invest_NTC%                               + NTC_new(nn,year,n)$ntc_dist(nn,n)
;
$offtext

RES_NTC_new_twoWay(n,nn,t,year)..       NTC_new(n,year,nn) =E= NTC_new(nn,year,n)
;

res_new_NTC(n,nn,year)..       NTC_new(n,year,nn) =G= NTC_new(n,year-1,nn)
;

CHP_restriction(n,t,year,scen)$CHP_factor(n,year)..
                                heat_factor(t,n)*CHP_factor(n,year) =L= sum(GasT, G(GasT,n,t,year,scen) )
;

res_cvar_1..              VAR + 1/(1-alpha) * sum(scen, probability(scen)*A(scen)) =L= CVAR
;
res_cvar_2(scen)..        A(scen) =G= OC(scen) - VAR
;

*###############################################################################
*                          MODEL formulation
*###############################################################################

MODEL LSEWglobal /

**** EL PART
     OBJECTIVE_EL
     OC_cost
                res_dem
                max_capacity
                res_max_gen
                res_G_RES
                res_cvar_1
                res_cvar_2

%startup%       res_max_online
%startup%       res_start
%startup%       res_min_gen
%store%         storagelevel_max
%store%         storagelevel
%store%         PSPmax
%shed%          SHED_max

%CHP%           CHP_restriction

                reservoir_max_gen
                reservoir_year_cap

                PSP_new_max

%Trade%         Res_lineflow_1
*%Trade%         Res_lineflow_2

%Invest_NTC%    res_new_NTC
%Invest_NTC%    RES_NTC_new_twoWay
%Invest_gen%    res_new_cap
                /;

