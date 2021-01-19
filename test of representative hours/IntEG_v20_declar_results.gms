
    PARAMETERS
    
           total_elec_costs                              total costs of the electricity sector in EUR
           generation(t,year,co,i,allscen)                  houry production of each technology in each country in MWh for all scenarios
                 generation_EUCO(t,year,co,i,allscen)   houry production of each technology in each country in MWh for scenario 1
                 generation_ST(t,year,co,i,allscen)     houry production of each technology in each country in MWh for scenario 2
                 generation_DG(t,year,co,i,allscen)     houry production of each technology in each country in MWh for scenario 3
            generation_country_tech(year,co,i,allscen)  country specific production of each technology in each scen
            generation_EU_tech(year,i,allscen)          EU wide production of each technology in each scen
            expected_gen_EU(year,i)                  ecpected EU wide production

            generation_costs_yearly_country(year,co,allscen)   yearly generation costs in each country and scen
            generation_costs_yearly_EU(year,allscen)           EU wide yearly generation costs in each scen
            expected_gen_costs_yearly_EU(year)          EU wide expected yearly generation costs
            expected_gen_costs_total                    total expected generation costs

            Shed_costs_yearly_country(year,allscen,co)     yearly Shedding costs in each country and scen
            expected_Shed_costs_yearly_EU(year)         expected EU wide yearly Shedding costs
            expected_Shed_costs_total                   total expected Shedding costs

            Invest_costs_yearly_country(year,co)        yearly invest costs in each country
            Invest_costs_yearly_EU(year)                EU wide yearly invest costs
            Invest_costs_total                          total expected invest costs

           invest_NTC(co,coco,year)                      cummulated NTC investments over the years in MW
           invest_gen(co,i,year)                         cummulated capacity investments over the years in MW
           new_cap(co,i,year)                            newly installed capacity in each year for each country and technology in MW
           invest_gen_cost_total(co,i,year)              total investment costs per year, country and technology in EUR
           NTC_Flow(t,year,co,coco,allscen)                 hourly line flows in MWh
                 NTC_Flow_EUCO(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 1
                 NTC_Flow_ST(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 2
                 NTC_Flow_DG(t,year,co,coco,allscen)        hourly line flows in MWh for scenario 3

           Import(co,year,allscen)                          Import t_number hours per year in GWh
           Export(co,year,allscen)                          Import t_number hours per year in GWh
           Import_scaled(co,year,allscen)                   Import scaled to 8760 hours per year in GWh
                 Import_scaled_EUCO(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 1
                 Import_scaled_ST(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 2
                 Import_scaled_DG(co,year,allscen)          Import scaled to 8760 hours per year in GWh for scenario 3
           Export_scaled(co,year,allscen)                   Export scaled to 8760 hours per year in GWh
                 Export_scaled_EUCO(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 1
                 Export_scaled_ST(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 2
                 Export_scaled_DG(co,year,allscen)          Export scaled to 8760 hours per year in GWh for scenario 3

           NTC_utilization(co,coco,year,allscen)            utilization rate of a transport capacity

           price_EL(t,co,year,allscen)                      hourly electricity price in EUR per MWh
           av_price_EL(co,year,allscen)                     yearly average price in EUR per MWh
           av_peak_price_EL(co,year,allscen)                yearly average peak price in EUR per MWh
           av_base_price_EL(co,year,allscen)                yearly average base price in EUR per MWh

           curt_RES(co,year,allscen)                        sum of RES curtailment during one year
           FullLoadHours(co,year,i,allscen)                 full load hours for each technology
                 FullLoadHours_EUCO(co,year,i,allscen)        full load hours for each technology
                 FullLoadHours_ST(co,year,i,allscen)        full load hours for each technology
                 FullLoadHours_DG(co,year,i,allscen)        full load hours for each technology
           production_GasT_el(co,year,allscen)              production by gas fired power plants in MWh_el
           production_GasT_th(co,year,allscen)              production by gas fired power plants in MWh_th

%startup%   startup(i,co,t,year,allscen)
%store%     storagelvl(t,co,i,year,allscen)
 ;
