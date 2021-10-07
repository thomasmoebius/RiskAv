*########################## fixing Variables ##################################

CAP_new.fx('RoR',n,year)        =0      ;
CAP_new.fx('Biomass',n,year)    =0      ;
CAP_new.fx(ReservT,n,year)      =0      ;
CAP_new.fx('OCOT',n,year)       =0      ;
CAP_new.fx(ResT,n,year)         =0      ;
CAP_new.fx('Hard Coal',n,year)   =0      ;
CAP_new.fx('PSP','DK',year)   =0      ;
CAP_new.fx('PSP','NL',year)   =0      ;
*CAP_new.fx('PSP','BALTIC',year)   =0      ;
CAP_new.fx('PSP','HU',year)   =0      ;
CAP_new.fx('PSP','RO',year)   =0      ;
CAP_new.fx('PSP','SE',year)   =0      ;
CAP_new.fx('PSP','SI',year)   =0      ;
CAP_new.fx('PSP','FI',year)   =0      ;
CAP_new.fx('PSP','NO',year)   =0      ;
CAP_new.fx('PSP','UK',year)   =0      ;
*CAP_new.fx('PSP','CZ',year)   =0      ;
*CAP_new.fx('PSP','BALKAN',year)   =0      ;

CAP_new.fx('PSP',n,'y2020')   =0      ;
CAP_new.fx('Lignite',n,'y2020')   =0      ;
CAP_new.fx('Nuclear',n,'y2020')   =0      ;
CAP_new.fx('CCGT',n,'y2020')   =0      ;

G.fx('Biomass',n,t,year,scen)   = cap_existing('Biomass',n,year,scen) * af('Biomass',n)      ;
G.fx('RoR',n,t,year,scen)       = cap_existing('RoR',n,year,scen) * af('RoR',n)      ;


*########################## options ##################################

    option LP = CPLEX;
    option threads = 0;
    option reslim = 800000;


   LSEWglobal.optfile   = 1 ;
   LSEWglobal.dictfile  = 0 ;
*    LSEWglobal.savepoint=1 ;
   LSEWglobal.SCALEOPT  = 1 ;
   LSEWglobal.holdfixed = 1 ;

   COST_EL.scale        = 1e006;


* Turn off the listing of the input file
* Turn off the listing and cross-reference of the symbols used

$offlisting
$offsymxref offsymlist
;
option
    limrow = 0,
    limcol = 0,
    solprint = off,
    sysout = off
;
