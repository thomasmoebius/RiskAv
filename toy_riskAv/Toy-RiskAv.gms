
$ontext
--------------------------------------------------------------------------
..........................................................................

A toy case for risk-neutral and risk-averse investment planning problem

Display reports show:
- 5 solutions for deterministic problems
- 1 solution for stochastic risk-neutral problem
- 5 solutions for stochastic risk-averse problem w=[0..0.8]

Date: 26.11.2020
Iegor
..........................................................................
--------------------------------------------------------------------------
$offtext


set     s scenarios /s1*s5/
        i iterations /i1*i5/
        p tech /base, mid, peak/
        t time periods /t1*t5/
        ;

parameters
vc(p), ic(p), d(t), report (*,*,*), report_y (*,*,*), report_RA (*,*,*), report_RA2(*,*,*);

*so screening curves for base/mid intersect at 3
vc('base') = 2;
ic('base') = 14;
vc('mid')  = 4;
ic('mid')  = 8;
vc('peak') = 20;
ic('peak') = 2;
d(t) = 0;

Table demand(t,s) 'time-series demand per scenario'
    s1      s2      s3      s4      s5
t1  1       2       3       5       7
t2  1       2       2       3       3
t3  1       1       1       3       3
t4  1       2       2       3       3
t5  1       2       3       5       6
;

*******Det Scenarios
positive variables
x(p),y(p,t),u(t);

variables
TC;

equations
obj, dem, caps;

obj..            TC    =e= sum(p, ic(p)*x(p))
                         + sum((p,t), vc(p)*y(p,t));
dem(t)..         d(t)  =e= sum(p, y(p,t));
caps(p,t)..      y(p,t)=l= x(p);

model det /obj, dem, caps/;

loop(s,

d(t) = demand(t,s);
display d;

solve det using LP minimizing TC;

report ( "TC", '', s)    = TC.l;
report ( "INV",p, s)     = x.l(p)+eps;
report_y (p,t,s)         = y.l(p,t)+eps;
);

display report;

*******Stoch Problem

positive variables
xx(p),yy(p,t,s);

equations
sobj, sdem, scaps;

sobj..             TC       =e= sum(p, ic(p)*xx(p)) + sum((p,t,s), vc(p)*yy(p,t,s))/card(s);
sdem(t,s)..    demand(t,s)   =e= sum(p, yy(p,t,s));
scaps(t,s,p).. yy(p,t,s) =l= xx(p);

model stoch /sobj, sdem, scaps/;

solve stoch using LP minimizing TC;

report ( "TC", '', 'SP')    = TC.l;
report ( "INV",p, 'SP')     = xx.l(p)+eps;

*execute_unload 'toy.gdx';
*$stop;

*******Risk-Av
parameters alpha,w;

alpha = 0.8;
w = 0;

positive variables
xxx(p),yyy(p,t,s),OC(s),
var, cvar, a(s);

equations
RA_obj, RA_dem, RA_OC, RA_caps, RA_cvar, RA_aux;

RA_obj..                TC  =e= sum(p, ic(p)*xxx(p)) + (1-w)*sum((s), OC(s)/card(s)) + w*cvar ;
RA_OC(s)..              OC(s) =e= sum((p,t), vc(p)*yyy(p,t,s));
RA_dem(t,s)..           demand(t,s) =e= sum(p, yyy(p,t,s));
RA_caps(t,s,p)..        yyy(p,t,s)      =l= xxx(p);
RA_cvar..               var + 1/(1-alpha)*sum(s,(a(s)/card(s))) =L= cvar;
RA_aux(s)..             a(s) =G= OC(s) - var ;

model RiskAv /RA_obj, RA_dem, RA_OC, RA_caps, RA_cvar, RA_aux/;

loop(i,

solve RiskAV using LP minimizing TC;

         report_RA  ("w","",i)   = w;
         report_RA  ("TC","",i)  = TC.l;
         report_RA  ("var","",i) = var.l    +eps;
         report_RA  ("cvar","",i)= cvar.l   +eps;

         report_RA2  ("OC",s,i)  = OC.l(s) +eps;
         report_RA2  ("a",s,i)  = a.l(s)          +eps;
         report_RA2  ('inv',p,i) = xxx.l(p)       +eps;
         report_RA2  ("ic",p,i) = ic(p)*xxx.l(p)  +eps;

         w = w + 0.2;
);

option report:1, report_y:1,report_RA:1;
display report;
*display report_y;
display report_RA;
display report_RA2;
$stop;
