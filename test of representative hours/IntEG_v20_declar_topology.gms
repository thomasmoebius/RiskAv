********************************  Global MODEL TOPOLOGY ***************************
SETS
    n                all nodes
    co(n)            consumption nodes for gas and all nodes for electricity
    coo(co)          co without Norway
    ;


    alias(n,m);
    alias(n,nn);
    alias(co,coco);

*****************************  ELECTRICITY MODEL TOPOLOGY *********************

SETS
    i                      all electricity generation technologiess
        ResT(i)            only RES generation technologies
        ConvT(i)           only conventional technologies
        StorT(i)           only storage technologies
        GasT(i)            only gas fuel technologies
        ReservT(i)         only Reservoirs

    scen_up         scenarios which are used to upload all scenario data
                    /EUCO_up, ST_up, DG_up/
    ;