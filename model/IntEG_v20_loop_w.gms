
set
weight /weight1*weight6/
;

loop(weight,
w = (ord(weight)-1)*0.2  ;
w$(ord(weight)=6) = 0.99 ;


SOLVE LSEWglobal using lp minimizing COST_EL          ;

                objective(weight)                    = COST_EL.L               ;
                operational_costs(scen,weight)       = OC.L(scen)              ;
                weighting_factor(weight)             = w       ;
                Var_check(weight)                    = VAR.L    ;
                Cvar_check(weight)                   = Cvar.L    ;
                A_check(scen,weight)                 = A.L(scen) ;

                generation(year,n,i,t,scen,weight)   =  G.l(i,n,t,year,scen)   ;

* costs calculations on Electricity Market

                price_EL(t,n,year,scen,weight)             = (res_dem.M(t,n,year,scen)/RHS)* (-1) * number_scenarios              ;
                av_price_EL(n,year,scen,weight)            = sum(t,(res_dem.M(t,n,year,scen)/RHS)* (-1)) * number_scenarios/t_number    ;

%Invest_NTC%    invest_NTC(n,nn,year,weight)          = NTC_new.l(n,year,nn)                    ;
%Invest_gen%    invest_gen(n,i,year,weight)           = CAP_new.l(i,n,year)   + EPS                  ;


%Shed%          Shedding_activity(sector,year,scen,n,t,weight) = SHED.l(sector,n,t,year,scen)       ;


%Trade%     NTC_Flow(t,year,n,nn,scen,weight)            = FLOW.l(n,nn,t,year,scen)                        ;
%Trade%     Import(nn,year,scen,weight)                   = sum((n,t),FLOW.l(n,nn,t,year,scen)) /1000      ;
%Trade%     Export(n,year,scen,weight)                     = sum((nn,t),FLOW.l(n,nn,t,year,scen))/1000     ;
%Trade%     Import_scaled(nn,year,scen,weight)            = sum((n,t),FLOW.l(n,nn,t,year,scen))*RHS/1000     ;
%Trade%     Export_scaled(n,year,scen,weight)              = sum((nn,t),FLOW.l(n,nn,t,year,scen))*RHS/1000   ;

%store%     storagelvl(t,n,i,year,scen,weight)             = StLevel.L(i,n,t,year,scen)                        ;

            curtRES(n,year,scen,weight)                   = sum( (t,ResT),(cap_existing(rest,n,year,scen) * pf(rest,n,t) - G.l(ResT,n,t,year,scen))
                                                           + (cap_existing('ror',n,year,scen) * af('ror',n) - G.l('ror',n,t,year,scen)))    ;

%startup%   startup(convt,n,t,year,scen,weight)            = SU.L(convt,n,t,year,scen)                          ;

            FullLoadHours(n,year,i,scen,weight)$(cap_existing(i,n,year,scen)
%Invest_gen%                              OR CAP_new.l(i,n,year)
                                           )
                                                 = sum(t, G.l(i,n,t,year,scen)*RHS) / (cap_existing(i,n,year,scen)
%Invest_gen%                                         +CAP_new.l(i,n,year)
                                                 );



);


   generation_country(year,n,i,scen,weight) = sum(t, generation(year,n,i,t,scen,weight))*RHS ;
   generation_EU(year,i,scen,weight)        = sum(n, generation_country(year,n,i,scen,weight)) ;
   generation_expected_country(year,i,weight)      = sum(scen, generation_EU(year,i,scen,weight)*probability(scen) )  ;
   generation_expected_EU(year,i,weight)           = sum(scen, generation_EU(year,i,scen,weight)*probability(scen) )  ;

   generation_costs_yearly_country(year,n,scen,weight)  = sum(i, generation_country(year,n,i,scen,weight) * vc_f(i,n,year,scen) * discountfactor(year) * RHS)  ;
   generation_costs_yearly_EU(year,scen,weight)         = sum(n, generation_costs_yearly_country(year,n,scen,weight))  ;
   generation_expected_costs_yearly_EU(year,weight)     = sum(scen, generation_costs_yearly_EU(year,scen,weight)*probability(scen))      ;
   generation_expected_costs_total(weight)              = sum(year, generation_expected_costs_yearly_EU(year,weight))  ;

%Shed%   Shed_costs_yearly_country(year,scen,n,weight)    = sum((t,sector), Shedding_activity(sector,year,scen,n,t,weight) * vola(sector,n) * discountfactor(year))  * RHS  ;
%Shed%    expected_Shed_costs_yearly_EU(year,weight)       = sum((scen,n), Shed_costs_yearly_country(year,scen,n,weight) * probability(scen) )    ;
%Shed%    expected_Shed_costs_total(weight)                = sum(year, expected_Shed_costs_yearly_EU(year,weight) )           ;

%Shed%    Shed_yearly(year,scen,n,weight)            = sum((t,sector), Shedding_activity(sector,year,scen,n,t,weight) )  * RHS  ;
%Shed%    expected_Shed_yearly(year,n,weight)        = sum(scen, Shed_yearly(year,scen,n,weight) *probability(scen)  ) + EPS   ;
%Shed%    expected_Shed_yearly_EU(year,weight)       = sum(n, expected_Shed_yearly(year,n,weight) )                 ;


%Invest_gen%   invest_gen_annual_added(n,i,year,weight)   = invest_gen(n,i,year,weight) - invest_gen(n,i,year-1,weight) +EPS  ;
%Invest_gen%   invest_gen_EU(i,year,weight)               = sum(n,invest_gen(n,i,year,weight))+EPS                  ;

%Invest_gen%   Invest_costs_yearly_country(year,n,weight) = SUM( i, ic(i) * invest_gen(n,i,year,weight)) * discountfactor(year) ;
%Invest_gen%   Invest_costs_yearly_EU(year,weight)        = SUM( n, Invest_costs_yearly_country(year,n,weight))    ;
%Invest_gen%   Invest_costs_total(weight)                 = SUM( year, Invest_costs_yearly_EU(year,weight))     ;

%Invest_NTC%   Invest_costs_NTC_total(weight)         = SUM((n,nn,year) , ic_ntc * ntc_dist(n,nn) * invest_NTC(n,nn,year,weight)  * discountfactor(year)) ;

    curtRES_expected(n,year,weight)     = sum(scen, curtRES(n,year,scen,weight) *probability(scen))  ;
    curtRES_expected_EU(year,weight)    = sum(n, curtRES_expected(n,year,weight))                    ;


    operational_costs_expected(weight)   = sum(scen, operational_costs(scen,weight)* probability(scen))  ;
    total_elec_costs(weight)             = operational_costs_expected(weight)
%Invest_gen%                                  +  Invest_costs_total(weight)
%Invest_NTC%                                  +  Invest_costs_NTC_total(weight)
        ;




execute_unload '%resultdir%%result%.gdx'






