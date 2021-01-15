
function Nbar =rscale(A,B,C,D,K)
% Given the single-input linear system: 
%       .
% 		x = Ax + Bu
%   	y = Cx + Du
% and the feedback matrix K,
% 
% the function rscale(A,B,C,D,K) finds the scale factor N which will 
% eliminate the steady-state error to a step reference 
% using the schematic below:
%
%                         /---------\
%      R         +     u  | .	    |
%      ---> N --->() ---->| X=Ax+Bu |--> y=Cx ---> y
%                -|       \---------/
%                 |             | 
%                 |<---- K <----|
%
%8/21/96 Yanjie Sun of the University of Michigan
%        under the supervision of Prof. D. Tilbury
%% System Definition
th1 = 0.85 ;    % en mg/dl/min 
th2 = 50 ;      % en mg/dl / U 
th3 = 60 ;      % en min 
th4 = 5 ;       % en /dl 
th5 = 20 ;      % en min 
 
ub = th1/th2 ;  % ubasal en U/min
A = [0 -th2 0 th4 0; 0 -1/th3 1/th3 0 0; 0 0 -1/th3 0 0; 0 0 0 -1/th5 1/th5; 0 0 0 0 -1/th5];
B = [0 0; 0 0; 1/th3 0; 0 0; 0 1/th5];
Bm = [0; 0; 1/th3; 0; 0];
Bc = [th1; 0; 0; 0; 0];
C = [1 0 0 0 0];
D = [0 0];
K = 1.0e+04 * [0.0348   -2.6599   -0.0248    0.2215    0.0085];
%%
s1 = size(A,1);
Z = [zeros(1,s1) 1];
%N = [A,B;C,D];
N = ([A,B;C,D])\Z';
Nx = N(1:s1);
Nu = N(1+s1);
Nbar=Nu + K*Nx;