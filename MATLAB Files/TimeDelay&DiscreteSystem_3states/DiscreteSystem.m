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
L = [1.05; 0; 0; 0; 0];
L1 = [0.0006; 0.2375; -0.2499; 2.3757; 0.7571];
%% Initial states 
x10     =   110 ;     % in mg/dl 
x20     =   ub ;      % ubasal 
x30     =   ub ;      % ubasal 
x40     =   0 ;       
x50     =   0 ;        
x0      =   [110; ub; ub; 0; 0];



%% Continous System Definition 5 states

A5_c   =   [0 -th2 0 th4 0; 0 -1/th3 1/th3 0 0; 0 0 -1/th3 0 0;
            0 0 0 -1/th5 1/th5; 0 0 0 0 -1/th5];
B51    =   [th1 0 ; 0 0 ; 0 1/th3 ; 0 0 ; 0 0];
B1    =   [0; 0; 1/th3; 0; 0];
B5_c   =   [th1 0 0; 0 0 0; 0 1/th3 0; 0 0 0; 0 0 0];

C5_c   =   [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
%D   =   [0 0 0];
D5_c      =   [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];

Z1  =  ctrb(A5_c, B51)


%% Continous System definition 3 states 
A3_c   =   [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5];

B3_c   =   [th1 0 0; 0 1/th3 0; 0 0 1/th5];

Ba     =   [0; 1/th3; 0];   % B matrix just for input (insulin)
Bm     =   [0; 0; 1/th3];
Bc     =   [th1; 0; 0];         % Constant for glucose equation
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
sysd3  =   c2d(sys3, 1, 'zoh')
sysd3_TD = c2d(sys3_TD, 1, 'zoh')

% 5 state discrete model
A5   = [1 -49.59 -0.4121 4.877 0.1209; 0 0.9835 0.01639 0 0; 0 0 0.9835 0 0;
       0 0 0 0.9512 0.04756; 0 0 0 0 0.9512];
B5   = [0.85 -0.002296 0.002032; 0 0.0001374 0; 0 0.01653 0; 0 0 0.001209; 
        0 0 0.04877];
C5   = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0; 0 0 0 1 0; 0 0 0 0 1];
C5_d = [1 0 0 0 0];
D5_d = [0 0 0];
D5   = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];
F5   = k*[1/th2 -th3 -th3 (th4*th5)/th2 (th4*th5)/th2]; 
[E] = eig(A5+(B1*F5))% - Positivity gains
Pe = [-1; -1/th3; -1/th3; -0.05; -0.05];
Ld = acker(A5',C5_d',Pe)'
% Discrete System 3 states with delay
A3   = [1 -49.59 4.877; 0 0.9835 0; 0 0 0.9512];
B3   = [0.85 -0.4144 0.1229; 0 0.01653 0; 0 0 0.04877];
C3   = [1 0 0; 0 1 0; 0 0 1];
C3_d = [1 0 0];
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
sys_ad =  c2d(sys_a, 1, 'zoh')
A_d   =   [1 -55.54 3.035; 0 0.9835 0;  0 0 0.9512];
B_d   =   [0.85 -0.4641 0.0765; 0 0.01653 0; 0 0 0.04877]
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


