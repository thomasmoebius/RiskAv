
********************************  Global MODEL TOPOLOGY ***************************
SETS
    n                all nodes
    ;

    alias(n,nn);

*****************************  ELECTRICITY MODEL TOPOLOGY *********************

SETS
    i                      all electricity generation technologiess
        ResT(i)            only RES generation technologies
        ConvT(i)           only conventional technologies
        StorT(i)           only storage technologies
        GasT(i)            only gas fuel technologies
        ReservT(i)         only Reservoirs
        noGas(i)           conventional technologies without Gas technologies

    sector       economic sectors consuming electricity  /sector_1*sector_15 /

    scen_up         scenarios which are used to upload all scenario data
                    /EUCO_up, ST_up, DG_up/
    ;
