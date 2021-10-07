
*********************************  Processing Results  *************************

                total_elec_costs(weight)                    = COST_EL.L                                     ;
                operational_costs(scen,weight)              = OC.L(scen)


                generation_country_tech(year,n,i,scen,weight)   = sum(t, G.l(i,n,t,year,scen))*RHS ;
                generation_EU_tech(year,i,scen,weight)           = sum(n, generation_country_tech(year,n,i,scen,weight)) ;
                expected_gen_EU(year,i,weight)         = sum(scen, generation_EU_tech(year,i,scen,weight))/number_scenarios     ;



* costs calculations on Electricity Market
                generation_costs_yearly_country(year,n,scen)  = (sum((noGas,t), G.l(noGas,n,t,year,scen)*vc_f(noGas,n,year,scen))
                                                            + sum( (GasT,t), G.l(GasT,n,t,year,scen)*(carb_cont(GasT)*co2_price(scen, year)/eta_f(GasT,n,year)))
                                                            + sum( (GasT,t), G.l(GasT,'cn_NO',t,year,scen)* fc(GasT,'cn_NO',year,scen)/eta_f(GasT,'cn_NO',year))
                                                            )* discountfactor(year) * RHS     ;
                generation_costs_yearly_EU(year,scen)   = sum(n, generation_costs_yearly_country(year,n,scen) )                 ;
                expected_gen_costs_yearly_EU(year)      = sum(scen, generation_costs_yearly_EU(year,scen) )/number_scenarios     ;
                expected_gen_costs_total                = sum(year, expected_gen_costs_yearly_EU(year) )        ;

                Shed_costs_yearly_country(year,scen,n)      = sum(t, SHED.l(n,t,year,scen) * vola(n) * discountfactor(year))  * RHS  ;
                expected_Shed_costs_yearly_EU(year)  = sum((scen,n), Shed_costs_yearly_country(year,scen,n) ) /number_scenarios      ;
                expected_Shed_costs_total            = sum(year, expected_Shed_costs_yearly_EU(year) )           ;

                Invest_costs_yearly_country(year,n) = SUM( i, ic(i) * CAP_new.l(i,n,year)) * discountfactor(year) ;
                Invest_costs_yearly_EU(year)        = SUM( n, Invest_costs_yearly_country(year,n))    ;
                Invest_costs_total                  = SUM( year, Invest_costs_yearly_EU(year))     ;



%Invest_NTC%    invest_NTC(n,nn,year)          = NTC_new.l(n,year,nn)                       ;
%Invest_gen%    invest_gen(n,i,year)           = CAP_new.l(i,n,year)   + EPS                ;
%Invest_gen%    new_cap(n,i,year)              = CAP_new.l(i,n,year)-CAP_new.l(i,n,year-1)  ;
%Invest_gen%    invest_gen_cost_total(n,i,year)= ic(i)*CAP_new.l(i,n,year)                  ;

%Trade%     NTC_Flow(t,year,n,nn,scen)            = FLOW.l(n,nn,t,year,scen)                        ;


%Trade%     Import(nn,year,scen)                   = sum((n,t),FLOW.l(n,nn,t,year,scen)) /1000      ;
%Trade%     Export(n,year,scen)                    = sum((nn,t),FLOW.l(n,nn,t,year,scen))/1000     ;

%Trade%     Import_scaled(nn,year,scen)            = sum((n,t),FLOW.l(n,nn,t,year,scen))*RHS/1000     ;

%Trade%     Export_scaled(n,year,scen)             = sum((nn,t),FLOW.l(n,nn,t,year,scen))*RHS/1000   ;


%store%     storagelvl(t,n,i,year,scen)            = StLevel.L(i,n,t,year,scen)                        ;

            curt_RES(n,year,scen)                  = sum( (t,ResT),(cap_existing(rest,n,year,scen)* pf(rest,n,t)-G.l(ResT,n,t,year,scen))
                                                      + (cap_existing('ror',n,year,scen)*af('ror',n)-G.l('ror',n,t,year,scen)));

%startup%   startup(convt,n,t,year,scen)           = SU.L(convt,n,t,year,scen)                          ;

            FullLoadHours(n,year,i,scen)$(cap_existing(i,n,year,scen)
%Invest_gen%                              OR CAP_new.l(i,n,year)
                                           )  = sum(t, G.l(i,n,t,year,scen)*RHS) / (cap_existing(i,n,year,scen)
%Invest_gen%                                         +CAP_new.l(i,n,year)
                                                 );
