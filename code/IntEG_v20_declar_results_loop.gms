    PARAMETERS

           total_elec_costs(*)                              total costs of the electricity sector in EUR
           operational_costs(scen,*)                        total OC in EUR

           weighting_factor(*)
           Var_check(*)
           Cvar_check(*)
           A_check(scen,*)

*            generation(t,year,n,i,scen,*)                  houry production of each technology in each country in MWh for all scenarios

            generation_country_tech(year,n,i,scen,*)  country specific production of each technology in each scen
            generation_EU_tech(year,i,scen,*)          EU wide production of each technology in each scen
            expected_gen_EU(year,i,*)                  ecpected EU wide production

            generation_costs_yearly_country(year,n,scen,*)   yearly generation costs in each country and scen
            generation_costs_yearly_EU(year,scen,*)           EU wide yearly generation costs in each scen
            expected_gen_costs_yearly_EU(year,*)          EU wide expected yearly generation costs
            expected_gen_costs_total(*)                    total expected generation costs

            Shed_costs_yearly_country(year,scen,n,*)     yearly Shedding costs in each country and scen
            expected_Shed_costs_yearly_EU(year,*)         expected EU wide yearly Shedding costs
            expected_Shed_costs_total(*)                   total expected Shedding costs

         Shed_yearly(year,scen,n,*)             annual shedding activities in MWh
         expected_Shed_yearly_EU(year,*)         expected EU wide yearly Shedding activities
         expected_Shed_yearly(year,n,*)

            Invest_costs_yearly_country(year,n,*)        yearly invest costs in each country
            Invest_costs_yearly_EU(year,*)                EU wide yearly invest costs
            Invest_costs_total(*)                          total expected invest costs

           invest_NTC(n,nn,year,*)                      cummulated NTC investments over the years in MW
           invest_gen(n,i,year,*)                         cummulated capacity investments over the years in MW
           invest_gen_annual(n,i,year,*)                  newly installed capacity in each year for each country and technology in MW
           invest_gen_cost_total(n,i,year,*)              total investment costs per year, country and technology in EUR

           invest_gen_EU(i,year,*)

           NTC_Flow(t,year,n,nn,scen,*)                 hourly line flows in MWh
           Import(n,year,scen,*)                          Import t_number hours per year in GWh
           Export(n,year,scen,*)                          Import t_number hours per year in GWh
           Import_scaled(n,year,scen,*)                   Import scaled to 8760 hours per year in GWh
           Export_scaled(n,year,scen,*)                   Export scaled to 8760 hours per year in GWh

*           NTC_utilization(n,nn,year,scen,*)            utilization rate of a transport capacity

           price_EL(t,n,year,scen,*)                      hourly electricity price in EUR per MWh
           av_price_EL(n,year,scen,*)                     yearly average price in EUR per MWh
*           av_peak_price_EL(n,year,scen,*)                yearly average peak price in EUR per MWh
*           av_base_price_EL(n,year,scen,*)                yearly average base price in EUR per MWh

           curt_RES(n,year,scen,*)                        sum of RES curtailment during one year
           FullLoadHours(n,year,i,scen,*)                 full load hours for each technology

*           production_GasT_el(n,year,scen,*)              production by gas fired power plants in MWh_el
*           production_GasT_th(n,year,scen,*)              production by gas fired power plants in MWh_th

%startup%   startup(i,n,t,year,scen,*)
%store%     storagelvl(t,n,i,year,scen,*)
 ;
