$Title IntEG version 21 (16 Sept 2021)

$ontext
energy dispatch & investment model risk aversion analysis
LSEW BTU

    UPPERCASE      - parameter
    lowercase      - variable
$offtext


*###############################################################################
*                                  DEFAULT OPTIONS
*###############################################################################

$eolcom #

*###############################################################################
*                            DIRECTORIRY and FILE MANAGEMENT
*###############################################################################

*Location of input files
$set datadir    data\
$Set DataIn     Input_v21

* version
$setglobal GlobalSCEN v21


$set resultdir  output\
$set result     Integ_%GlobalSCEN%



#########################################################################
*                                MODEL SPECIFICATIONS
*###############################################################################

                        #SELECT "" TO ACTIVATE / '*' TO DISACTIVATE


                                #RELATED TO PARAMETRIC UNCERTAINTY

set  scen       /EUCO,ST,DG,EVP,s1*s18/
;

scalar
        w                       weighting factor for cvar
        alpha                   confidence level on cvar /0.8/
;

                              #RELATED TO ELECTRICITY  MODEL

$setglobal Store                 ""             # Storage mechanism activated with "", deactivated with "*"
$setglobal Store_invest          ""             # Storage investments activated with "", deactivated with "*"
$setglobal Shed                  ""             # Load shedding activated with "", deactivated with "*"
$setglobal Trade                 ""             # Trade between markets activated with "", deactivated with "*"
$setglobal Startup               "*"             # Startup mechanism activated with "", deactivated with "*"
$setglobal Invest_gen            ""             # Investment in generation capacity activated with "", deactivated with "*"
$setglobal Invest_NTC            ""             # Investment in NTC capacity activated with "", deactivated with "*"

$setglobal Vola_const            "*"             # European VoLA in all countries with "", country specific VoLA with "*"

$ifthen "%Startup%" == ""   $setglobal Exc_startup "*"
$else                       $setglobal Exc_startup ""
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



