$Title IntEG-2 (Jan 2020)

$ontext
energy dispatch & investment model risk aversion analysis
LSEW BTU

    UPPERCASE      - parameter
    lowercase      - variable
$offtext


*###############################################################################
*                                  DEFAULT OPTIONS
*###############################################################################

file fx2;
put fx2;

$eolcom #

*###############################################################################
*                            DIRECTORIRY and FILE MANAGEMENT
*###############################################################################

*Location of input files
$set datadir    data\
$Set DataIn     Input_v2

* version
$setglobal GlobalSCEN v2


$set resultdir  output_v21\
$set       result     Integ_%GlobalSCEN%_base_t25_VoLAmerit

$ontext
all scen with w=[0..0.99] and Alpha=0.8
         -> compare with Alpha 0.9 which scen are picked
all scen with w=[0..0.99] and Alpha=0.8 and NTC
         -> effect of 'export' of load shedding is amplified
all scen with w=[0..0.99] and Alpha=0.8 and constant VOLL
         -> how much of 'export' comes from heterogenity in values and how much form system configuration?
$offtext

#########################################################################
*                                MODEL SPECIFICATIONS
*###############################################################################

                        #SELECT "" TO ACTIVATE / '*' TO DISACTIVATE


                                #RELATED TO PARAMETRIC UNCERTAINTY

set  scen       /EUCO,ST,DG,EVP,s1*s18/
;

scalar
        w                       weighting factor for cvar /0/
        alpha                   confidence level on cvar /0.8/
;

                              #RELATED TO ELECTRICITY  MODEL

$setglobal Store                 "*"             # Storage
$setglobal Shed                  ""              # Load shedding
$setglobal Trade                 ""              # Trade between markets
$setglobal Startup               "*"             # Startups
$setglobal Invest_gen            ""              # Investment in generation capacity
$setglobal Invest_NTC            "*"              # Investment in NTC capacity
$setglobal Invest_incl_Entsoe_additions "*"       # empty field activates NTC additions by Entsoe, '*' deactivates Entsoe NTC additions after 2020
$setglobal CHP                   ""              # considering minim production due to CHP

$setglobal Vola_const            "*"              # empty field activates a constant VoLA in all countries, (*) activates a country specific VoLA
$setglobal upload_NTC_plan       "*"             # when empty: existing NTC´s are replaced by an investment plan from a previous model run, when (*): TYNDP NTC´s


$ifthen "%Startup%" == ""   $setglobal Exc_startup "*"
$else                       $setglobal Exc_startup ""
$endif

$ifthen "%Invest_NTC%" == ""   $setglobal Exc_Invest_NTC "*"
$else                       $setglobal Exc_Invest_NTC ""
$endif


*###############################################################################
*                               DECLARING & MAPPING TIME
*###############################################################################

$include IntEG_v20_declar_time.gms

*###############################################################################
*                               DECLARING & MAPPING TOPOLOGY
*###############################################################################

$include IntEG_v20_declar_topology.gms

*###############################################################################
*                               DECLARING PARAMETERS
*###############################################################################

$include IntEG_v20_declar_parameters.gms

*###############################################################################
*                               DECLARING Scenario Variations
*###############################################################################

$include IntEG_v20_ScenarioVariations.gms


*execute_unload "check.gdx"
*$stop

*###############################################################################
*                        MODEL (variables, equations, model form)
*###############################################################################

$include IntEG_v20_model.gms

*###############################################################################
*                        FIXING VARIABLES & SOLVE OPTIONS
*###############################################################################

$include IntEG_v20_SolveOptions.gms

*###############################################################################
*                               Defining RESULTS parameters
*###############################################################################

$include IntEG_v20_declar_results_loop.gms

*#############################        SOLVING SP         ####################


$include IntEG_v20_loop_w.gms

        execute_unload '%resultdir%%result%.gdx'  ;



