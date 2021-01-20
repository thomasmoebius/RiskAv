
                production_GasT_el(n,year)           = sum((t,GasT), G.l(GasT,n,t,year,'EUCO')*RHS)        ;
                production_GasT_th(n,year)           = sum((t,GasT), G.l(GasT,n,t,year,'EUCO')/eta_f(GasT,n,year)*RHS)   ;

%Invest_gen%    invest_gen(n,i,year)           = CAP_new.l(i,n,year)   + EPS                  ;
%Invest_gen%    new_cap(n,i,year)              = CAP_new.l(i,n,year)-CAP_new.l(i,n,year-1)   ;


                curt_RES(n,year)                   = sum( (t,ResT),(cap_existing(rest,n,year,'EUCO')* pf(rest,n,t)-G.l(ResT,n,t,year,'EUCO'))
                                                   + (cap_existing('ror',n,year,'EUCO')*af('ror',n)-G.l('ror',n,t,year,'EUCO')));


                FullLoadHours(n,year,i)$(cap_existing(i,n,year,'EUCO')
%Invest_gen%                              OR CAP_new.l(i,n,year))
                                          = sum(t, G.l(i,n,t,year,'EUCO')*RHS) / (cap_existing(i,n,year,'EUCO')
%Invest_gen%                              + CAP_new.l(i,n,year)
                                          );
