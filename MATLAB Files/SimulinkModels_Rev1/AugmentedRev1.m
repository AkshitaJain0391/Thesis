clear;
clc;
%%  Parameters of virtuel patient
th1     =   0.85 ;    % in mg/dl/min 
th2     =   50 ;      % in mg/dl / U 
th3     =   60 ;      % in min 
th4     =   5 ;       % in /dl 
th5     =   20 ;      % in min 
ub      =   th1/th2 ; % ubasal in U/min
k       =   1;        % tuning gain
tau1    =   15;       % time delay to insulin injection
tau2    =   30;       % time delay for meal digestion
Gref    =   110;
%% Initial states 
x10     =   110 ;     % in mg/dl 
x20     =   ub ;      % ubasal 
x30     =   ub ;      % ubasal 
x40     =   0 ;       
x50     =   0 ;        
x0      =   [110; ub; ub; 0; 0];



%% System Definition

A   =   [0 -th2 0 th4 0; 0 -1/th3 1/th3 0 0; 0 0 -1/th3 0 0; 
        0 0 0 -1/th5 1/th5; 0 0 0 0 -1/th5];

B   =   [0 0; 0 0; 1/th3 0; 0 0; 0 1/th5];

Ba  =   [0 ; 0 ; 1/th3 ; 0 ; 0];   % B matrix just for input (insulin)
Bm  =   [0; 0; 1/th3; 0; 0];
Bc  =   [th1; 0; 0; 0; 0];         % Constant for glucose equation
C   =   [1 0 0 0 0];
%C   =   [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
D   =   [0 0 0];
%D   =   [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];
Fin =   k*[1/th2 -th3 -th3 2 2];   % - Positivity gains
SF1 = [k/th2 -k*th3 (k*th5*th4)/(th2)];

%% Discrete System

% Continous System Definition 5 states

A5_c   =   [0 -th2 0 th4 0; 0 -1/th3 1/th3 0 0; 0 0 -1/th3 0 0;
            0 0 0 -1/th5 1/th5; 0 0 0 0 -1/th5];

B5_c   =   [th1 0 0; 0 0 0; 0 1/th3 0; 0 0 0; 0 0 1/th5];

C5_c   =   [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
%D   =   [0 0 0];
D5_c      =   [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];

%% Continous System definition 3 states 
A3_c   =   [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5];

B3_c   =   [th1 0 0; 0 1/th3 0; 0 0 1/th5];

Ba     =   [0; 1/th3; 0];   % B matrix just for input (insulin)
Bm     =   [0; 0; 1/th3];
%Bc     =   [th1; 0; 0];         % Constant for glucose equation
%C   =   [1 0 0 0 0];
C3_c   =   [1 0 0; 0 1 0; 0 0 1];
%D   =   [0 0 0];
D3_c   =   [0 0 0; 0 0 0; 0 0 0];

F3     =   [k/th2 -k*th3 (k*th5*th4)/(th2)];

% Discrete System 5 states
sys5   =   ss(A5_c,B5_c,C5_c,D5_c);

% Discrete System 3 states 
sys3   =   ss(A3_c,B3_c,C3_c,D3_c);
sys3_TD =  ss(A3_c,B3_c,C3_c,D3_c, 'InputDelay',[0; 15; 30]);
sysd3  =   c2d(sys3, 1, 'zoh');
sysd3_TD = c2d(sys3_TD, 1, 'zoh');

% 5 state discrete model
A5   = [1 -49.59 -0.4121 4.877 0.1209; 0 0.9835 0.01639 0 0; 0 0 0.9835 0 0;
       0 0 0 0.9512 0.04756; 0 0 0 0 0.9512];
B5   = [0.85 -0.002296 0.002032; 0 0.0001374 0; 0 0.01653 0; 0 0 0.001209; 
        0 0 0.04877];
C5   = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
D5   = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];
F5   = k*[1/th2 -th3 -th3 2 2];   % - Positivity gains
% Discrete System 3 states with delay
A3   = [1 -49.59 4.877; 0 0.9835 0; 0 0 0.9512];
B3   = [0.85 -0.4144 0.1229; 0 0.01653 0; 0 0 0.04877];
C3   = [1 0 0; 0 1 0; 0 0 1];
D3   = [0 0 0; 0 0 0; 0 0 0];
C_obs= [1 0 0];
D_obs= [0 0 0]; 
L_obs= [1.5; 0; 0];

% % system study
% [b, a] = ss2tf(A2, B2, C2, D2, 3)
% dis    = tf([0 0.1229 0.0001 -0.1190],a)
% dis_d  = tf([0 0.1229 0.0001 -0.1190],a, 'InputDelay', 45)
% dis1   = c2d(dis,1)
% figure(1), margin(dis)
% figure(2), margin(dis_d)

%% Discrete model for adolescent
A_a   =   [0 -56 56/18 ; 0 -1/60 0; 0 0 -1/20];
B_a   =   [0.85 0 0; 0 1/60 0; 0 0 1/20];
C_a   =   [1 0 0; 0 1 0; 0 0 1];
D_a   =   [0 0 0; 0 0 0; 0 0 0];

sys_a =   ss(A_a,B_a,C_a,D_a, 'InputDelay',[0; 15; 30]);
sys_ad =  c2d(sys_a, 1, 'zoh');
A_d   =   [1 -55.54 3.035; 0 0.9835 0;  0 0 0.9512];
B_d   =   [0.85 -0.4641 0.0765; 0 0.01653 0; 0 0 0.04877];
c_d   =   [1 0 0; 0 1 0; 0 0 1];
D_d   =   [0 0 0; 0 0 0; 0 0 0];

%% Scenario 
Tfinal = 1500 ;    % duree de la simulation en minutes 
temps = 0 : 1 : Tfinal ;  

% Repas
repas = zeros (1, length(temps)) ;  % entree repas

 repas (110:120) = 3 ;    %3;        % 3   g/min pendant 10 minutes soit 30 g
  %  repas (480:489) = 3 ;           % 3   g/min pendant 10 minutes soit 30 g
   % repas (720:739) = 2.5;          % 2.5 g/min pendant 20 minutes soit 50 g
   % repas (1200:1229) = 3;          % 2   g/min pendant 30 minutes soit 60 g
    
   % repas (1440+480:1440+489) = 3 ;           % 3   g/min pendant 10 minutes soit 30 g
    %repas (1440+720:1440+739) = 2.5;          % 2.5 g/min pendant 20 minutes soit 50 g
   % repas (1440+1200:1440+1229) = 2;          % 2   g/min pendant 30 minutes soit 60 g




%%  Simulation
%t = 0:0.01:2;
%sim('ModelwithSF.slx',Tfinal);


%% State feedback - Pole placement
Cm = ctrb(A, B); % to check controllability
rank(Cm)
[V, E] = eig(A)
%p = [-0.0125; -0.0167; -0.0167; -0.05; -0.05]; %poles of the system
%p = [-1; -0.016; -0.015; -0.052; -0.051]; %positivity poles
p = [-0.0167; -0.0107; -0.0107; -0.05; -0.05];
F = -place(A, B, p) % Gains of the state feedback
%L = acker(A',C',p)'
L = [0.0048; 0; 0; 0; 0];
%s = A - L*C
%[b,a] = ss2tf(A, B, C, D) % Build transfer function
Fin1 = [0.000775  -2.2403   -2.7469    0.0746    0.2235]; % Results are
%obtained but input is not always positive

%[E] = eig(A+Ba*Fin)

%% Gains - LQR function implementation
% -0.001996
% 
% %%LQR function
 
% R = sdpvar(1,1);
% Q = sdpvar(5,5);
% L1 = R>=0;
% L2 = Q>=0;
% L3 = u>=0;
% L = L1+L2+L3;
% optimize(L);
% Q = double(Q);
% R = double(R);
% [K,S,P] = lqr(A,Ba,10*Q,R*1.1*10^-5)


%% PI parameters
Gr = 110 ;
kp = -100 ;
ki = - 0.3; 
k_aw = 2.5 ;
Td = 100;

