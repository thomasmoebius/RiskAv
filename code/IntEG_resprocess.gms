*###############################################################################
*                                  AFTERMATH
*###############################################################################



*********************************  ELECTRICITY MODEL ***************************

*$ontext
*       Electricity market parameters: calculation

                total_elec_costs                     = COST_EL.L                                     ;


                generation(t,year,co,i,scen)         = G.l(i,co,t,year,scen)                   ;
                generation_country_tech(year,co,i,scen)   = sum(t, generation(t,year,co,i,scen))*RHS ;
                generation_EU_tech(year,i,scen)           = sum(co, generation_country_tech(year,co,i,scen)) ;
                expected_gen_EU(year,i)         = sum(scen, generation_EU_tech(year,i,scen))/number_scenarios     ;



* costs calculations on Electricity Market
                generation_costs_yearly_country(year,co,scen)  = (sum((noGas,t), G.l(noGas,co,t,year,scen)*vc_f(noGas,co,year,scen))
                                                            + sum( (GasT,t), G.l(GasT,co,t,year,scen)*(carb_cont(GasT)*co2_price(scen, year)/eta_f(GasT,co,year)))
                                                            + sum( (GasT,t), G.l(GasT,'cn_NO',t,year,scen)* fc(GasT,'cn_NO',year,scen)/eta_f(GasT,'cn_NO',year))
                                                            )* discountfactor(year) * RHS     ;
                generation_costs_yearly_EU(year,scen)   = sum(co, generation_costs_yearly_country(year,co,scen) )                 ;
                expected_gen_costs_yearly_EU(year)      = sum(scen, generation_costs_yearly_EU(year,scen) )/number_scenarios     ;
                expected_gen_costs_total                = sum(year, expected_gen_costs_yearly_EU(year) )        ;

                Shed_costs_yearly_country(year,scen,co)      = sum(t, SHED.l(co,t,year,scen) * vola(co) * discountfactor(year))  * RHS  ;
                expected_Shed_costs_yearly_EU(year)  = sum((scen,co), Shed_costs_yearly_country(year,scen,co) ) /number_scenarios      ;
                expected_Shed_costs_total            = sum(year, expected_Shed_costs_yearly_EU(year) )           ;

                Invest_costs_yearly_country(year,co) = SUM( i, ic(i) * CAP_new.l(i,co,year)) * discountfactor(year) ;
                Invest_costs_yearly_EU(year)         = SUM( co, Invest_costs_yearly_country(year,co))    ;
                Invest_costs_total                   = SUM( year, Invest_costs_yearly_EU(year))     ;

                price_EL(t,co,year,scen)             = (res_dem.M(t,co,year,scen)/RHS)* (-1) * number_scenarios              ;
                av_price_EL(co,year,scen)            = sum(t,(res_dem.M(t,co,year,scen)/RHS)* (-1)) * number_scenarios/t_number    ;
                av_peak_price_EL(co,year,scen)       = sum(peak_T,(res_dem.M(peak_T,co,year,scen)/RHS)* (-1))* number_scenarios/ (0.5*t_number)  ;
                av_base_price_EL(co,year,scen)       = sum(base_T,(res_dem.M(base_T,co,year,scen)/RHS)* (-1))* number_scenarios  / (0.5*t_number)  ;

                production_GasT_el(co,year,scen)           = sum((t,GasT), G.l(GasT,co,t,year,scen)*RHS)        ;
                production_GasT_th(co,year,scen)           = sum((t,GasT), G.l(GasT,co,t,year,scen)/eta_f(GasT,co,year)*RHS)   ;

%Invest_NTC%    invest_NTC(co,coco,year)        = NTC_new.l(co,year,coco)                       ;
%Invest_gen%    invest_gen(co,i,year)           = CAP_new.l(i,co,year)   + EPS                  ;
%Invest_gen%    new_cap(co,i,year)              = CAP_new.l(i,co,year)-CAP_new.l(i,co,year-1)   ;
%Invest_gen%    invest_gen_cost_total(co,i,year)= ic(i)*CAP_new.l(i,co,year)                    ;

%Trade%     NTC_Flow(t,year,co,coco,scen)            = FLOW.l(co,coco,t,year,scen)                        ;


%Trade%     Import(coco,year,scen)                   = sum((co,t),FLOW.l(co,coco,t,year,scen)) /1000      ;
%Trade%     Export(co,year,scen)                     = sum((coco,t),FLOW.l(co,coco,t,year,scen))/1000     ;

%Trade%     Import_scaled(coco,year,scen)            = sum((co,t),FLOW.l(co,coco,t,year,scen))*RHS/1000     ;

%Trade%     Export_scaled(co,year,scen)              = sum((coco,t),FLOW.l(co,coco,t,year,scen))*RHS/1000   ;


%Trade%     NTC_utilization(co,coco,year,scen)$( ntc(co,'y2020',coco)
%Trade%%Invest_NTC%                            OR NTC_new.l(co,year,coco)
                                                 )   =sum(t,FLOW.l(co,coco,t,year,scen)) / (ntc(co,'y2020',coco)*t_number
%Trade%%Invest_NTC%                                                         +NTC_new.l(co,year,coco)*t_number
                                                                             ) ;

%store%     storagelvl(t,co,i,year,scen)             = StLevel.L(i,co,t,year,scen)                        ;

            curt_RES(co,year,scen)                   = sum( (t,ResT),(cap_existing(rest,co,year,scen)* pf(rest,co,t)-G.l(ResT,co,t,year,scen))
                                                   + (cap_existing('ror',co,year,scen)*af('ror',co)-G.l('ror',co,t,year,scen)));

%startup%   startup(convt,co,t,year,scen)            = SU.L(convt,co,t,year,scen)                          ;

            FullLoadHours(co,year,i,scen)$(cap_existing(i,co,year,scen)
%Invest_gen%                              OR CAP_new.l(i,co,year)
                                           )
                                                 = sum(t, G.l(i,co,t,year,scen)*RHS) / (cap_existing(i,co,year,scen)
%Invest_gen%                                         +CAP_new.l(i,co,year)
                                                 );


*$offtext


