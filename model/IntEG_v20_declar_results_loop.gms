    PARAMETERS

           objective(*)                                     objective  value in €
           total_elec_costs(*)                              total costs of the electricity sector in EUR
           operational_costs(scen,*)                        total OC in EUR
           operational_costs_expected(*)                    expected total OC in EUR (risk neutral)

           weighting_factor(*)
           Var_check(*)
           Cvar_check(*)
           A_check(scen,*)

            generation(year,n,i,t,scen,*)                 houry production of each technology in each country in MWh for all scenarios

            generation_country(year,n,i,scen,*)           country-specific production of each technology in each scenario
            generation_EU(year,i,scen,*)                  EU wide production of each technology in each scen
            generation_expected_country(year,i,*)            expected  country-specific production per technology
            generation_expected_EU(year,i,*)                 expected EU wide production per technology

            generation_costs_yearly_country(year,n,scen,*)   yearly generation costs in each country and scen
            generation_costs_yearly_EU(year,scen,*)          EU wide yearly generation costs in each scen
            generation_expected_costs_yearly_EU(year,*)      EU wide expected yearly generation costs
            generation_expected_costs_total(*)               total expected generation costs
            
            Shedding_activity(sector,year,scen,n,t,*)        shedding activity in MWh per h

            Shed_costs_yearly_country(year,scen,n,*)     yearly Shedding costs in each country and scen
            expected_Shed_costs_yearly_EU(year,*)        expected EU wide yearly Shedding costs
            expected_Shed_costs_total(*)                 total expected Shedding costs

            Shed_yearly(year,scen,n,*)                  annual shedding activities in MWh
            expected_Shed_yearly_EU(year,*)             expected EU wide yearly Shedding activities
            expected_Shed_yearly(year,n,*)

            Invest_costs_yearly_country(year,n,*)        yearly invest costs in each country
            Invest_costs_yearly_EU(year,*)               EU wide yearly invest costs
            Invest_costs_total(*)                        total expected invest costs

           invest_NTC(n,nn,year,*)                      NTC investments in MW (aggregated till final year)
           Invest_costs_NTC_total(*)                    overall investment costs in NTCs´in €
            
           invest_gen(n,i,year,*)                         cummulated capacity investments until the respective year in MW
           invest_gen_annual_added(n,i,year,*)            newly installed capacity in the respective year in MW

           invest_gen_EU(i,year,*)

           NTC_Flow(t,year,n,nn,scen,*)                   hourly line flows in MWh
           Import(n,year,scen,*)                          Import t_number hours per year in GWh
           Export(n,year,scen,*)                          Import t_number hours per year in GWh
           Import_scaled(n,year,scen,*)                   Import scaled to 8760 hours per year in GWh
           Export_scaled(n,year,scen,*)                   Export scaled to 8760 hours per year in GWh


           price_EL(t,n,year,scen,*)                      hourly electricity price in EUR per MWh
           av_price_EL(n,year,scen,*)                     yearly average price in EUR per MWh


           curtRES(n,year,scen,*)                        RES curtailment per scenario and country and year
           curtRES_expected(n,year,*)                    expected RES curtailment per country and year
           curtRES_expected_EU(year,*)                   expected RES curtailment in EU per year
           FullLoadHours(n,year,i,scen,*)                full load hours for each technology

%startup%   startup(i,n,t,year,scen,*)
%store%     storagelvl(t,n,i,year,scen,*)
 ;
