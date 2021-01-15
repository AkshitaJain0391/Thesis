clear;
clc;
%%  Parametres du patient virtuel 
th1 = 0.32 ;    % en mg/dl/min 
th2 = 50 ;      % en mg/dl / U 
th3 = 70 ;      % en min 
th4 = 2.7 ;       % en /dl 
th5 = 22 ;      % en min 
ub = th1/th2 ;  % ubasal en U/min
k = 1;
tau1 = 15;
tau2 = 30;
%% Etats initiaux 
x10 = 110 ;     % en mg/dl 
x20 = ub ;      % ubasal 
x30 = ub ;      % ubasal 
x40 = 0 ;       % a jeun 
x50 = 0 ;       % a jeun 
x0 = [110; ub; ub; 0; 0];



%% System Definition
A = [0 -th2 0 th4 0; 0 -1/th3 1/th3 0 0; 0 0 -1/th3 0 0; 0 0 0 -1/th5 1/th5; 0 0 0 0 -1/th5];
B = [0 0; 0 0; 1/th3 0; 0 0; 0 1/th5];
Ba = [0 ; 0 ; 1/th3 ; 0 ; 0];
Bm = [0; 0; 1/th3; 0; 0];
Bc = [th1; 0; 0; 0; 0];
C = [1 0 0 0 0]
D = [0 0];


%% State feedback 
Cm = ctrb(A, B); % to check controllability
rank(Cm)
[V, E] = eig(A)
%p = [-0.0125; -0.0167; -0.0167; -0.05; -0.05]; %poles of the system
p = [-1; -0.016; -0.015; -0.052; -0.051]; %positivity poles
F = -place(A, B, p) % Gains of the state feedback
L = acker(A',C',p)'
s = A - L*C
%[b,a] = ss2tf(A, B, C, D) % Build transfer function
%Fin = [0.000775   -2.2403   -2.7469    0.0746    0.2235]; % Results are
%obtained but input is not always positive
Fin = k*[1/th2 -th3 -th3 2 2]; % - Positivity gains

[E] = eig(A+Ba*Fin);

%% Gains 
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

%% TF for smith predictor control

tf1 = tf([1/th3], [1 1/th3]);
e1 = exp(tf([-tau1 0], 1));

G1 = tf1*e1;

%% Scenario 
Tfinal = 1500 ;    % duree de la simulation en minutes 
temps = 0 : 1 : Tfinal ;  

% Repas
repas = zeros (1, length(temps));   % entree repas

 repas (100:110) = 5;    %3;        % 3   g/min pendant 10 minutes soit 30 g
  %  repas (480:489) = 3 ;           % 3   g/min pendant 10 minutes soit 30 g
   % repas (720:739) = 2.5;          % 2.5 g/min pendant 20 minutes soit 50 g
   % repas (1200:1229) = 3;          % 2   g/min pendant 30 minutes soit 60 g
    
   % repas (1440+480:1440+489) = 3 ;           % 3   g/min pendant 10 minutes soit 30 g
    %repas (1440+720:1440+739) = 2.5;          % 2.5 g/min pendant 20 minutes soit 50 g
   % repas (1440+1200:1440+1229) = 2;          % 2   g/min pendant 30 minutes soit 60 g


