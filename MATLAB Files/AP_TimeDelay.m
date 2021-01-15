%% Time delay system:

clear;
clc;
%%  Parameters of virtual patient  
th1 = 0.85 ;    % en mg/dl/min 
th2 = 50 ;      % en mg/dl / U 
th3 = 60 ;      % en min 
th4 = 5 ;       % en /dl 
th5 = 20 ;      % en min 
ub = th1/th2 ;  % ubasal en U/min
%k = 1;         % Positivity scaling gain

%% Initial States 
x10 = 110 ;     % en mg/dl 
x20 = ub ;      % ubasal 
x30 = 0 ;       % a jeun 
x0 = [110; ub; 0];


%% System Definition
A = [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5];
B = [0 0; 1/th3 0; 0 1/th5];
%Ba = [0 ; 0 ; 1/th3 ; 0 ; 0];
%Bm = [0; 0; 1/th3; 0; 0];
%Bc = [th1; 0; 0; 0; 0];
C = [1 1 1];
D = [0 0];

%% Time delays
t1 = 900;
t2 = 1800;


G = ss(A,B,C,D,'InputDelay',[t1;t2])

%% Static Feedback


