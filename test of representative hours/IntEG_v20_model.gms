*###############################################################################
*                                    VARIABLES
*###############################################################################

*********************************  ELECTRICITY  MODEL  *************************

    POSITIVE VARIABLES

        G(i,n,t_all,year,allscen)           generation of technology i at time t
        P_ON(i,n,t_all,year,allscen)        online capacity of technology i at time t
        SU(i,n,t_all,year,allscen)          start up variable
        CAP_new(i,n,year)                   installed capacity
        SHED(n,t_all,year,allscen)          load sheding at a VoLA
        P_PSP(i,n,t_all,year,allscen)       pumping of water back to the PSP reservoir
        StLevel(i,n,t_all,year,allscen)     level of the PSP storage at time t

        NTC_new(n,year,nn)                  invested NTC capacity in MW
        FLOW(n,nn,t_all,year,allscen)       transfered capacity in MW
        ;

    VARIABLES
        Cost_GLobal       total cost of gas market combined with total costs of electricity market
        COST_EL            total cost of electricity production
        ;


*################################################################################################################
*                                                   EQUATIONS
*################################################################################################################

*#################################  INTEGRATED  MODEL #################################


EQUATIONS

        OBJECTIVE_GLOBAL                objective function combining GAS and ELECTRICITY
;

OBJECTIVE_GLOBAL..
         Cost_GLobal =e= (COST_EL)*inf_factor/1e6
         ;

EQUATIONS

OBJECTIVE_EL                                      minimizing total costs
res_dem(t,co,year,allscen)                        energy balance (supply=demand)
res_start(i,co,t,year,allscen)                startup restriction
res_G_RES(i,co,t,year,allscen)                 maximum for RES generation depends on hourly pf anc cap_RES
res_min_gen(i,co,t,year,allscen)              minimum generation
res_max_gen(i,co,t,year,allscen)              maximum generation
res_max_online(i,co,t,year,allscen)           maximum online restriction
max_capacity(i,co,year)                           maximum potential capacity [MW]
storagelevel(t,i,co,year,allscen)             level of the PSP storage
PSPmax(t,i,co,year,allscen)                   PSP power limitation to installed turbine capacity
SHED_max(co,t,allscen,year)                       maximum shedding in a country
storagelevel(t,i,co,year,allscen)             storage level at time t
storagelevel_max(t,i,co,year,allscen)         max level of reservoir (upper basin)

reservoir_max_gen(i,co,t,year,allscen)
reservoir_year_cap(i,co,year,allscen)

Res_lineflow_1(co,coco,t,year,allscen)
Res_lineflow_2(coco,co,t,year,allscen)

res_new_cap(i,co,year)                   ensures that new cap has to be paid each year after construction
res_new_NTC(co,coco,year)                built connections exist for all following years (new cap has to be paid each year after construction )
RES_NTC_new_twoWay(co,coco,t,year)       the investment in a line affects both directions equally

CHP_restriction(co,t,year,allscen)       minimum production due to CHP
;

OBJECTIVE_EL..
            COST_EL    =E=
                SUM( scen, (
                  SUM( (i,co,t,year), vc_f(i,co,year,scen) * G(i,co,t,year,scen) * discountfactor(year)  ) *RHS
%startup%       + SUM( (convt,co,t,year), SU(convt,co,t,year,scen) * sc(convt) ) * discountfactor(year)  *RHS
%startup%       + SUM( (convt,co,t,year), (P_on(convt,co,t,year,scen)-G(convt,co,t,year,scen)) * (vc_m(convt,co)- vc_f(convt,co)) *g_min(convt) / (1-g_min(convt)) * discountfactor(year))  *RHS
%shed%          + SUM( (co,t,year), SHED(co,t,year,scen)*vola(co) * discountfactor(year)   )  *RHS
                ))
%Inc_Stoch%     /number_scenarios

%Invest_gen%    + SUM( (i,co,year), ic(i) * CAP_new(i,co,year) * discountfactor(year))
%Invest_NTC%    + SUM( (co,coco,year), ic_ntc * ntc_dist(co,coco) * NTC_new(co,year,coco) * discountfactor(year) )
 ;

res_dem(t,co,year,scen)..
            demand(co,t,year,scen) =E=
                  SUM( convt, G(convt,co,t,year,scen)) + SUM(rest, G(rest,co,t,year,scen) )
%store%         + SUM( stort,G(stort,co,t,year,scen) *eta_f(stort,co,year) - P_PSP(stort,co,t,year,scen) )
                + SUM( ReservT$cap_existing(ReservT,co,year,scen), G(ReservT,co,t,year,scen) )
%shed%          + SHED(co,t,year,scen)
%Trade%         + SUM( coco, FLOW(coco,co,t,year,scen) - FLOW(co,coco,t,year,scen) )
                ;

res_G_RES(rest,co,t,year,scen)..    G(rest,co,t,year,scen) =L= (cap_existing(rest,co,year,scen)) * pf(rest,co,t)
;

res_new_cap(i,co,year)..            CAP_new(i,co,year) =G= CAP_new(i,co,year-1)
;

res_start(convt,co,t,year,scen)..        SU(convt,co,t,year,scen) =G= P_on(convt,co,t,year,scen)-P_ON(convt,co,t-1,year,scen)
;

res_min_gen(convt,co,t,year,scen)..      P_on(convt,co,t,year,scen)*g_min(convt) =L= G(convt,co,t,year,scen)
;

res_max_gen(convt,co,t,year,scen)..
                                 G(convt,co,t,year,scen) =L=
%Exc_startup%                                    cap_existing(convt,co,year,scen) * af(convt,co)
%Exc_startup%                                  + CAP_new(convt,co,year) * af(convt,co)
%startup%                                        P_on(convt,co,t,year,scen)
;

res_max_online(convt,co,t,year,scen)..    P_on(convt,co,t,year,scen) =L= (cap_existing(convt,co,year,scen))  * af(convt,co)
%Invest_gen%                                      + CAP_new(convt,co,year) * af(convt,co)
;

max_capacity(i,co,year)..               CAP_new(i,co,year) =L= cap_max(i,co)
;

*A comment why it takes place
SHED_max(co,t,scen,year)..              SHED(co,t,year,scen) =L= demand(co,t,year,scen)*0.2
;

##########################    PSP and Reservoirs   ###########################################

storagelevel_max(t,stort,co,year,scen)..   StLevel(stort,co,t,year,scen) =l= (cap_existing(stort,co,year,scen))  * cpf
%Invest_gen%                                          + CAP_new(stort,co,year)*cpf
;

storagelevel(t,stort,co,year,scen)..       StLevel(stort,co,t,year,scen) =e=
                                            StLevel(stort,co,t-1,year,scen) - G(stort,co,t,year,scen) + P_PSP(stort,co,t,year,scen)
;

PSPmax(t,stort,co,year,scen)..             G(stort,co,t,year,scen)+P_PSP(stort,co,t,year,scen) =l= cap_existing(stort,co,year,scen)*af(stort,co)
%Invest_gen%                                                      + CAP_new(stort,co,year)*af(stort,co)
;

reservoir_max_gen(ReservT,co,t,year,scen)$cap_existing(ReservT,co,year,scen)..
                         G(ReservT,co,t,year,scen) =L= cap_existing(ReservT,co,year,scen)*af(ReservT,co)
;
reservoir_year_cap(ReservT,co,year,scen)$cap_existing(ReservT,co,year,scen)..
                         sum(t,G(ReservT,co,t,year,scen)) =L= cap_existing(ReservT,co,year,scen)*flh_Reservoir
;

***********       Network defintions and restrictions       ********************

Res_lineflow_1(co,coco,t,year,scen)..
                         FLOW(co,coco,t,year,scen) =L=
                                             ntc(co,year,coco)
%Invest_NTC%                               + NTC_new(co,year,coco)$ntc_dist(co,coco)
;

Res_lineflow_2(coco,co,t,year,scen)..
                         FLOW(coco,co,t,year,scen) =L=
                                             ntc(coco,year,co)
%Invest_NTC%                               + NTC_new(coco,year,co)$ntc_dist(coco,co)
;

RES_NTC_new_twoWay(co,coco,t,year)..       NTC_new(co,year,coco) =E= NTC_new(coco,year,co)
;

res_new_NTC(co,coco,year)..       NTC_new(co,year,coco) =G= NTC_new(co,year-1,coco)
;

CHP_restriction(co,t,year,scen)$CHP_factor(co,year)..
                                heat_factor(t,co)*CHP_factor(co,year) =L= sum(GasT, G(GasT,co,t,year,scen) )
;


*###############################################################################
*                          MODEL formulation
*###############################################################################

MODEL LSEWglobal /

    OBJECTIVE_GLOBAL

     OBJECTIVE_EL
                res_dem
                max_capacity
                res_max_gen
                res_G_RES

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

%Trade%         Res_lineflow_1
%Trade%         Res_lineflow_2

%Invest_NTC%    res_new_NTC
%Invest_NTC%    RES_NTC_new_twoWay
%Invest_gen%    res_new_cap
                /;

