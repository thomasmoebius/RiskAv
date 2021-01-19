
set
weight /weight1*weight5/
;


loop(weight,
w = (ord(weight)-1)*0.2  ;
*w = 0.8  ;


SOLVE LSEWglobal using lp minimizing COST_EL          ;

                total_elec_costs(weight)             = COST_EL.L               ;
                operational_costs(scen,weight)       = OC.L(scen)              ;
                weighting_factor(weight)             = w       ;
                Var_check(weight)                    = VAR.L    ;
                Cvar_check(weight)                   = Cvar.L    ;
                A_check(scen,weight)                 = A.L(scen) ;

                generation_country_tech(year,n,i,scen,weight)   = sum(t, G.l(i,n,t,year,scen))*RHS ;

* costs calculations on Electricity Market
%Shed%          Shed_costs_yearly_country(year,scen,n,weight)      = sum((t,sector), SHED.l(sector,n,t,year,scen) * vola(sector,n) * discountfactor(year))  * RHS  ;
%Shed%          Shed_yearly(year,scen,n,weight)                    = sum((t,sector), SHED.l(sector,n,t,year,scen) )  * RHS  ;

%Invest_gen%    Invest_costs_yearly_country(year,n,weight) = SUM( i, ic(i) * CAP_new.l(i,n,year)) * discountfactor(year) ;
                price_EL(t,n,year,scen,weight)             = (res_dem.M(t,n,year,scen)/RHS)* (-1) * number_scenarios              ;
                av_price_EL(n,year,scen,weight)            = sum(t,(res_dem.M(t,n,year,scen)/RHS)* (-1)) * number_scenarios/t_number    ;

%Invest_NTC%    invest_NTC(n,nn,year,weight)        = NTC_new.l(n,year,nn)                       ;
%Invest_gen%    invest_gen(n,i,year,weight)           = CAP_new.l(i,n,year)   + EPS                  ;

%Invest_gen%    invest_gen_annual(n,i,year,weight)    = CAP_new.l(i,n,year)-CAP_new.l(i,n,year-1)   ;
%Invest_gen%    invest_gen_cost_total(n,i,year,weight)= invest_gen_annual(n,i,year,weight)*ic(i)               ;


%Trade%     NTC_Flow(t,year,n,nn,scen,weight)            = FLOW.l(n,nn,t,year,scen)                        ;
%Trade%     Import(nn,year,scen,weight)                   = sum((n,t),FLOW.l(n,nn,t,year,scen)) /1000      ;
%Trade%     Export(n,year,scen,weight)                     = sum((nn,t),FLOW.l(n,nn,t,year,scen))/1000     ;
%Trade%     Import_scaled(nn,year,scen,weight)            = sum((n,t),FLOW.l(n,nn,t,year,scen))*RHS/1000     ;
%Trade%     Export_scaled(n,year,scen,weight)              = sum((nn,t),FLOW.l(n,nn,t,year,scen))*RHS/1000   ;

%store%     storagelvl(t,n,i,year,scen,weight)             = StLevel.L(i,n,t,year,scen)                        ;

            curt_RES(n,year,scen,weight)                   = sum( (t,ResT),(cap_existing(rest,n,year,scen)* pf(rest,n,t)-G.l(ResT,n,t,year,scen))
                                                   + (cap_existing('ror',n,year,scen)*af('ror',n)-G.l('ror',n,t,year,scen)));

%startup%   startup(convt,n,t,year,scen,weight)            = SU.L(convt,n,t,year,scen)                          ;

            FullLoadHours(n,year,i,scen,weight)$(cap_existing(i,n,year,scen)
%Invest_gen%                              OR CAP_new.l(i,n,year)
                                           )
                                                 = sum(t, G.l(i,n,t,year,scen)*RHS) / (cap_existing(i,n,year,scen)
%Invest_gen%                                         +CAP_new.l(i,n,year)
                                                 );



);


   generation_EU_tech(year,i,scen,weight)   = sum(n, generation_country_tech(year,n,i,scen,weight)) ;
   expected_gen_EU(year,i,weight)           = sum(scen, generation_EU_tech(year,i,scen,weight)*probability(scen) )  ;

   expected_Shed_costs_yearly_EU(year,weight)  = sum((scen,n), Shed_costs_yearly_country(year,scen,n,weight)  *probability(scen) )    ;
   expected_Shed_costs_total(weight)           = sum(year, expected_Shed_costs_yearly_EU(year,weight) )           ;
   expected_Shed_yearly(year,n,weight)        = sum(scen, Shed_yearly(year,scen,n,weight) *probability(scen)  )+EPS   ;
   expected_Shed_yearly_EU(year,weight)        = sum(n, expected_Shed_yearly(year,n,weight) )                 ;

%Invest_gen%   Invest_costs_yearly_EU(year,weight)         = SUM( n, Invest_costs_yearly_country(year,n,weight))    ;
%Invest_gen%   Invest_costs_total(weight)                  = SUM( year, Invest_costs_yearly_EU(year,weight))     ;

%Invest_gen%   invest_gen_EU(i,year,weight)           = sum(n,invest_gen(n,i,year,weight))+EPS                  ;


execute_unload '%resultdir%%result%.gdx'  generation_EU_tech, expected_gen_EU,   expected_Shed_costs_yearly_EU,  expected_Shed_costs_total, expected_Shed_yearly,
   expected_Shed_yearly_EU,   Invest_costs_yearly_EU,Invest_costs_total, invest_gen_EU
