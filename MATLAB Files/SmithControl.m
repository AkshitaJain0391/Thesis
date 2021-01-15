%% Smith Prediction Control

clear;
clc;
%%  Parameters of virtual Patients
th1 = 0.85 ;    % en mg/dl/min 
th2 = 50 ;      % en mg/dl / U 
th3 = 60 ;      % en min 
th4 = 5 ;       % en /dl 
th5 = 20 ;      % en min 
ub = th1/th2 ;  % ubasal en U/min
k = 1;
tau1 = 15;      % Insulin subcutaneous to plasma delay
tau2 = 20;      % Meal delay
tau3 = 5;       % Measurement delay

%% Initial States 
x10 = 110 ;     % en mg/dl 
x20 = ub ;      % ubasal 
x30 = ub ;      % ubasal 
x40 = 0 ;       % a jeun 
x50 = 0 ;       % a jeun 
x0 = [110; ub; ub; 0; 0];



%% System Definition without delay
A = [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5];
B = [0 0; 1/th3 0; 0 1/th5];
C = [1 0 0];
D = [0 0];

[A,B,C,D] = tf2ss([1/th3 0], [1 1/th3]);

IP = tf([1/th3 0], [1 1/th3], 'InputDelay', 15);
CHO = tf([1/th5 0], [1 1/th5], 'InputDelay', 30);


