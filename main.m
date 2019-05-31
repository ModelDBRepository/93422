clear all;
% close all;

%% Global variables
global count cout Spindle1 Spindle2

count = 0; cout = 0; Spindle1(1) = 0; Spindle2(1) = 0;

%% Time vector
t0 = 0;
tf = 70;
t=[t0 tf];

%% Normal case
disp('NORMAL CASE')
disp('Loading parameter set...');
par = parnorm;
disp('Loading initial conditions...');
ini = initial_conditions;
disp('Integrating ODEs...');
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[t1,y1]=ode45('dfs',t,ini,options,par);
disp('Calculating algebraic equations...');
rates1 = algebraic(t1,y1,par);
disp('Calculating movement variables...');
om1 = mv(t1,y1,rates1);
% disp('Plotting...');
% Nplots(t0,tf,t1,y1,rates1,om1);

%% PD case
disp('PARKINSON''S DISEASE CASE')
disp('Loading parameter set...');
par = parpd;
disp('Loading initial conditions...');
ini = initial_conditions;
disp('Integrating ODEs...');
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[t2,y2]=ode45('dfs',t,ini,options,par);
disp('Calculating algebraic equations...');
rates2 = algebraic(t2,y2,par);
disp('Calculating movement variables...');
om2 = mv(t2,y2,rates2);
% disp('Plotting...');
% PDplots(t0,tf,t2,y2,rates2,om2);

disp('Creating plots...')
plots(t0,tf,t1,t2,y1,y2,rates1,rates2,om1,om2);
