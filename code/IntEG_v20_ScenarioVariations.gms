

*TYNDP scenarios
demand(n,t,year,'EUCO') = demand_upload(n,t,year,'EUCO_up');
demand(n,t,year,'ST') = demand_upload(n,t,year,'ST_up');
demand(n,t,year,'DG') = demand_upload(n,t,year,'DG_up');

cap_existing(i,n,year,'EUCO') = cap_existing_upload(i,n,year,'EUCO_up');
cap_existing(i,n,year,'ST') = cap_existing_upload(i,n,year,'ST_up');
cap_existing(i,n,year,'DG') = cap_existing_upload(i,n,year,'DG_up');

fc(i,n,year,'EUCO') = fc_upload(i,n,year,'EUCO_up') ;
fc(i,n,year,'ST') = fc_upload(i,n,year,'ST_up') ;
fc(i,n,year,'DG') = fc_upload(i,n,year,'DG_up') ;

co2_price('EUCO',year) = co2_price_upload('EUCO_up', year);
co2_price('ST',year) = co2_price_upload('ST_up', year);
co2_price('DG',year) = co2_price_upload('DG_up', year);

*expected value problem

        EVP_demand(n,t,year)                = sum(scen_up, demand_upload(n,t,year,scen_up))/3;
        EVP_cap_existing(i,n,year)          = sum(scen_up, cap_existing_upload(i,n,year,scen_up))/3;
        EVP_fc(i,n,year)                    = sum(scen_up, fc_upload(i,n,year,scen_up))/3;
        EVP_co2_price(year)                  = sum(scen_up, co2_price_upload(scen_up,year))/3;
        EVP_vc_f(i,n,year)$eta_f(i,n,year) = sum(scen_up, (fc_upload(i,n,year,scen_up)+ carb_cont(i)*co2_price_upload(scen_up,year))/eta_f(i,n,year))/3;
        EVP_vc_m(i,n,year)$eta_f(i,n,year) = sum(scen_up, (fc_upload(i,n,year,scen_up)+ carb_cont(i)*co2_price_upload(scen_up,year))/eta_m(i,n,year))/3;


demand(n,t,year,'EVP')      = EVP_demand(n,t,year)                     ;
cap_existing(i,n,year,'EVP') = EVP_cap_existing(i,n,year)               ;
fc(i,n,year,'EVP')          = EVP_fc(i,n,year)                         ;
co2_price('EVP',year)        = EVP_co2_price(year)                       ;

*interpolations demand
*EUCO-ST
demand(n,t,year,'s1')  = demand(n,t,year,'EUCO')*(-0.1) + demand(n,t,year,'ST')* 1.1                         ;
demand(n,t,year,'s2')  = demand(n,t,year,'EUCO')*(1/3)  + demand(n,t,year,'ST')*(2/3)                        ;
demand(n,t,year,'s3')  = demand(n,t,year,'EUCO')* 0.5   + demand(n,t,year,'ST')* 0.5                         ;
demand(n,t,year,'s4')  = demand(n,t,year,'EUCO')*(2/3)  + demand(n,t,year,'ST')*(1/3)                        ;
demand(n,t,year,'s5')  = demand(n,t,year,'EUCO')* 1.1   + demand(n,t,year,'ST')*(-0.1)                       ;

*DG-ST
demand(n,t,year,'s6')  = demand(n,t,year,'DG')*(-0.1) + demand(n,t,year,'ST')* 1.1                           ;
demand(n,t,year,'s7')  = demand(n,t,year,'DG')*(1/3)  + demand(n,t,year,'ST')*(2/3)                          ;
demand(n,t,year,'s8')  = demand(n,t,year,'DG')* 0.5   + demand(n,t,year,'ST')* 0.5                           ;
demand(n,t,year,'s9')  = demand(n,t,year,'DG')*(2/3)  + demand(n,t,year,'ST')*(1/3)                          ;
demand(n,t,year,'s10') = demand(n,t,year,'DG')* 1.1   + demand(n,t,year,'ST')*(-0.1)                         ;

*EUCO-DG
demand(n,t,year,'s11') = demand(n,t,year,'EUCO')*(-0.1) + demand(n,t,year,'DG')* 1.1                         ;
demand(n,t,year,'s12') = demand(n,t,year,'EUCO')*(1/3)  + demand(n,t,year,'DG')*(2/3)                        ;
demand(n,t,year,'s13') = demand(n,t,year,'EUCO')* 0.5   + demand(n,t,year,'DG')* 0.5                         ;
demand(n,t,year,'s14') = demand(n,t,year,'EUCO')*(2/3)  + demand(n,t,year,'DG')*(1/3)                        ;
demand(n,t,year,'s15') = demand(n,t,year,'EUCO')* 1.1   + demand(n,t,year,'DG')*(-0.1)                       ;

*EVP-(EUn,ST,DG)
demand(n,t,year,'s16') = demand(n,t,year,'EVP')*0.5 + demand(n,t,year,'EUCO')*0.5                            ;
demand(n,t,year,'s17') = demand(n,t,year,'EVP')*0.5 + demand(n,t,year,'ST')*0.5                              ;
demand(n,t,year,'s18') = demand(n,t,year,'EVP')*0.5 + demand(n,t,year,'DG')*0.5                              ;


*interpolations cap_existing
*EUCO-ST
cap_existing(i,n,year,'s1')  = cap_existing(i,n,year,'EUCO')*(-0.1) + cap_existing(i,n,year,'ST')* 1.1       ;
cap_existing(i,n,year,'s2')  = cap_existing(i,n,year,'EUCO')*(1/3)  + cap_existing(i,n,year,'ST')*(2/3)      ;
cap_existing(i,n,year,'s3')  = cap_existing(i,n,year,'EUCO')* 0.5   + cap_existing(i,n,year,'ST')* 0.5       ;
cap_existing(i,n,year,'s4')  = cap_existing(i,n,year,'EUCO')*(2/3)  + cap_existing(i,n,year,'ST')*(1/3)      ;
cap_existing(i,n,year,'s5')  = cap_existing(i,n,year,'EUCO')* 1.1   + cap_existing(i,n,year,'ST')*(-0.1)     ;

*DG-ST
cap_existing(i,n,year,'s6')  = cap_existing(i,n,year,'DG')*(-0.1) + cap_existing(i,n,year,'ST')* 1.1        ;
cap_existing(i,n,year,'s7')  = cap_existing(i,n,year,'DG')*(1/3)  + cap_existing(i,n,year,'ST')*(2/3)       ;
cap_existing(i,n,year,'s8')  = cap_existing(i,n,year,'DG')* 0.5   + cap_existing(i,n,year,'ST')* 0.5        ;
cap_existing(i,n,year,'s9')  = cap_existing(i,n,year,'DG')*(2/3)  + cap_existing(i,n,year,'ST')*(1/3)       ;
cap_existing(i,n,year,'s10') = cap_existing(i,n,year,'DG')* 1.1   + cap_existing(i,n,year,'ST')*(-0.1)      ;

*EUCO-DG
cap_existing(i,n,year,'s11') = cap_existing(i,n,year,'EUCO')*(-0.1) + cap_existing(i,n,year,'DG')* 1.1      ;
cap_existing(i,n,year,'s12') = cap_existing(i,n,year,'EUCO')*(1/3)  + cap_existing(i,n,year,'DG')*(2/3)     ;
cap_existing(i,n,year,'s13') = cap_existing(i,n,year,'EUCO')* 0.5   + cap_existing(i,n,year,'DG')* 0.5      ;
cap_existing(i,n,year,'s14') = cap_existing(i,n,year,'EUCO')*(2/3)  + cap_existing(i,n,year,'DG')*(1/3)     ;
cap_existing(i,n,year,'s15') = cap_existing(i,n,year,'EUCO')* 1.1   + cap_existing(i,n,year,'DG')*(-0.1)    ;

*EVP-(EUn,ST,DG)
cap_existing(i,n,year,'s16') = cap_existing(i,n,year,'EVP')*0.5 + cap_existing(i,n,year,'EUCO')*0.5         ;
cap_existing(i,n,year,'s17') = cap_existing(i,n,year,'EVP')*0.5 + cap_existing(i,n,year,'ST')*0.5           ;
cap_existing(i,n,year,'s18') = cap_existing(i,n,year,'EVP')*0.5 + cap_existing(i,n,year,'DG')*0.5           ;


*interpolations fc
*EUCO-ST
fc(i,n,year,'s1')  = fc(i,n,year,'EUCO')*(-0.1) + fc(i,n,year,'ST')* 1.1                                     ;
fc(i,n,year,'s2')  = fc(i,n,year,'EUCO')*(1/3)  + fc(i,n,year,'ST')*(2/3)                                    ;
fc(i,n,year,'s3')  = fc(i,n,year,'EUCO')* 0.5   + fc(i,n,year,'ST')* 0.5                                     ;
fc(i,n,year,'s4')  = fc(i,n,year,'EUCO')*(2/3)  + fc(i,n,year,'ST')*(1/3)                                    ;
fc(i,n,year,'s5')  = fc(i,n,year,'EUCO')* 1.1   + fc(i,n,year,'ST')*(-0.1)                                   ;

*DG-ST
fc(i,n,year,'s6')  = fc(i,n,year,'DG')*(-0.1) + fc(i,n,year,'ST')* 1.1                                       ;
fc(i,n,year,'s7')  = fc(i,n,year,'DG')*(1/3)  + fc(i,n,year,'ST')*(2/3)                                      ;
fc(i,n,year,'s8')  = fc(i,n,year,'DG')* 0.5   + fc(i,n,year,'ST')* 0.5                                       ;
fc(i,n,year,'s9')  = fc(i,n,year,'DG')*(2/3)  + fc(i,n,year,'ST')*(1/3)                                      ;
fc(i,n,year,'s10') = fc(i,n,year,'DG')* 1.1   + fc(i,n,year,'ST')*(-0.1)                                     ;

*EUCO-DG
fc(i,n,year,'s11') = fc(i,n,year,'EUCO')*(-0.1) + fc(i,n,year,'DG')* 1.1                                     ;
fc(i,n,year,'s12') = fc(i,n,year,'EUCO')*(1/3)  + fc(i,n,year,'DG')*(2/3)                                    ;
fc(i,n,year,'s13') = fc(i,n,year,'EUCO')* 0.5   + fc(i,n,year,'DG')* 0.5                                     ;
fc(i,n,year,'s14') = fc(i,n,year,'EUCO')*(2/3)  + fc(i,n,year,'DG')*(1/3)                                    ;
fc(i,n,year,'s15') = fc(i,n,year,'EUCO')* 1.1   + fc(i,n,year,'DG')*(-0.1)                                   ;

*EVP-(EUn,ST,DG)
fc(i,n,year,'s16') = fc(i,n,year,'EVP')*0.5 + fc(i,n,year,'EUCO')*0.5                                        ;
fc(i,n,year,'s17') = fc(i,n,year,'EVP')*0.5 + fc(i,n,year,'ST')*0.5                                          ;
fc(i,n,year,'s18') = fc(i,n,year,'EVP')*0.5 + fc(i,n,year,'DG')*0.5                                          ;


*interpolations CO2
*EUCO-ST
co2_price('s1',year)  = co2_price('EUCO',year)*(-0.1) + co2_price('ST',year)* 1.1                               ;
co2_price('s2',year)  = co2_price('EUCO',year)*(1/3)  + co2_price('ST',year)*(2/3)                              ;
co2_price('s3',year)  = co2_price('EUCO',year)* 0.5   + co2_price('ST',year)* 0.5                               ;
co2_price('s4',year)  = co2_price('EUCO',year)*(2/3)  + co2_price('ST',year)*(1/3)                              ;
co2_price('s5',year)  = co2_price('EUCO',year)* 1.1   + co2_price('ST',year)*(-0.1)                             ;

*DG-ST
co2_price('s6',year)  = co2_price('DG',year)*(-0.1) + co2_price('ST',year)* 1.1                                 ;
co2_price('s7',year)  = co2_price('DG',year)*(1/3)  + co2_price('ST',year)*(2/3)                                ;
co2_price('s8',year)  = co2_price('DG',year)* 0.5   + co2_price('ST',year)* 0.5                                 ;
co2_price('s9',year)  = co2_price('DG',year)*(2/3)  + co2_price('ST',year)*(1/3)                                ;
co2_price('s10',year) = co2_price('DG',year)* 1.1   + co2_price('ST',year)*(-0.1)                               ;

*EUCO-DG
co2_price('s11',year) = co2_price('EUCO',year)*(-0.1) + co2_price('DG',year)* 1.1                               ;
co2_price('s12',year) = co2_price('EUCO',year)*(1/3)  + co2_price('DG',year)*(2/3)                              ;
co2_price('s13',year) = co2_price('EUCO',year)* 0.5   + co2_price('DG',year)* 0.5                               ;
co2_price('s14',year) = co2_price('EUCO',year)*(2/3)  + co2_price('DG',year)*(1/3)                              ;
co2_price('s15',year) = co2_price('EUCO',year)* 1.1   + co2_price('DG',year)*(-0.1)                             ;

*EVP-(EUn,ST,DG)
co2_price('s16',year) = co2_price('EVP',year)*0.5 + co2_price('EUCO',year)*0.5                                  ;
co2_price('s17',year) = co2_price('EVP',year)*0.5 + co2_price('ST',year)*0.5                                    ;
co2_price('s18',year) = co2_price('EVP',year)*0.5 + co2_price('DG',year)*0.5                                    ;


*variable cost computation
vc_f(i,n,year,scen) = (fc(i,n,year,scen) + carb_cont(i)*co2_price(scen,year))/ eta_f(i,n,year)+varOM(i);
vc_m(i,n,year,scen) = (fc(i,n,year,scen) + carb_cont(i)*co2_price(scen,year))/ eta_m(i,n,year)+varOM(i);
