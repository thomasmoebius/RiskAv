*########################## fixing Variables ##################################

CAP_new.fx('RoR',n,year)        =0      ;
CAP_new.fx('Biomass',n,year)    =0      ;
CAP_new.fx(ReservT,n,year)      =0      ;
CAP_new.fx('OCOT',n,year)       =0      ;
CAP_new.fx(ResT,n,year)         =0      ;

G.fx('Biomass',n,t,year,scen)   = cap_existing('Biomass',n,year,scen) * af('Biomass',n)      ;
G.fx('RoR',n,t,year,scen)       = cap_existing('RoR',n,year,scen) * af('RoR',n)      ;


*########################## options ##################################

    option LP = CPLEX;
    option threads = 0;
    option reslim = 500000;

   LSEWglobal.optfile = 1;
   LSEWglobal.dictfile = 0;
*    LSEWglobal.savepoint=1;
   LSEWglobal.SCALEOPT = 1;

    COST_EL.scale = 1e006;


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
