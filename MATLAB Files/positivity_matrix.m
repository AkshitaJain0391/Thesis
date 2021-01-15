
clear all;
clc;


%%  Parameters of virtuel patient
th1     =   0.85 ;    % in mg/dl/min 
th2     =   50 ;      % in mg/dl / U 
th3     =   60 ;      % in min 
th4     =   5 ;       % in /dl 
th5     =   20 ;      % in min 
k       =   1/47.88;
Gc      =   40;
Gl      =   110;
x0      =   [110; th1/th2; 0];
tau1    =   15;       % time delay to insulin injection
tau2    =   30;       % time delay for meal digestion

%% Metzler matrix %% positivity work
G       =   [1 0 0; 0 1 0; 0 0 1; k/th2 -k*th3 -k*th3;];
D       =   [0 -th2 0; 0 -1/th3 1/th3; k/(th2*th3) -k -k-(1/th3)];
%D = [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5]
H       =   G*D/G;
G1      =   [1 0; 0 1; k/th2 -k*th3];
D1      =   [0 -th2; k/(th2*th3) -(k+(1/th3))];
H1      =   G1*D1/G1;

%% State feedback control

A       =   [0 -th2 th4; 0 -1/th3 0; 0 0 -1/th5];
B       =   [0 0; 1/th3 0; 0 1/th5];
Ba      =   [th1; 0; 0];
C       =   [1 0 0];
D       =   0;


%Create the model.
G = ss(A,B,C,D,'InputDelay',15);
%SF = [0 -k*th3 (k*th5*th4)/(th2)]; %% with smith predictor
SF1 = [k/th2 -k*th3 (k*th5*th4)/(th2)] %% without smith predictor
%F = [k/(th2*45) -k*th3/45 (k*th5*th4)/(th2*45)]

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



sim('TDS_StateSpace.slx')
%% th2 update
% Gl = ans.SimX.Data(:,1);
% if Gl < 100
%     th9 = th2*(1-exp(-Gl/40));
% else
%     th9 = 50;
% end 
% th9