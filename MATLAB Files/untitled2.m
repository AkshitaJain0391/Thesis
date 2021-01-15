%% Trial for phase and gain margin for time delay system
clear all
th2 = 50;
th3 = 60;
IP = tf(1/th3,[1 1/th3]);
s1 = stepinfo(IP);
IP_d = tf(-th2/(th3), [1 1/(th3) 0],'InputDelay', 45); %12.5 %20
IPd = c2d(IP_d, 1, 'impulse')
sys1 = ss(IP_d);
s3 = stepinfo(IP_d);
meal = tf(1/20, [1 1/20]);
ML_d = tf(1/20, [1 1/20], 'InputDelay', 45); %7.01 % 4.50
MLd = c2d(ML_d, 1,'impulse')
%Gl = tf-50*IP_d + 5*ML_d + 0.85
ML_d1 = pade(ML_d);

figure(1), margin(IP_d);
% figure(2), margin(ML_d);
% figure(3), nyquist(MLd);
% figure(4), pzmap(MLd);

IP_cl = feedback([IP_d*60,1],1,1,1);
%margin(IP)
%margin(IP_d)
IP_ds = pade(IP);
IP_d1 = pade(IP_d);
%figure(2), rlocus(IP_d);
s2 = stepinfo(IP_d1)
IP_d2 = pade(ML_d);
%figure(1), margin(IP)
%figure(2), margin(IP_d1)
%rlocusplot(IP_d1)
%[r,k] = rlocus(IP_d1);
[Gm,Pm,Wcg,Wcp] = margin(IP_d)
[Gm,Pm,Wcg,Wcp] = margin(IP_d1);
[Gm,Pm,Wcg,Wcp] = margin(ML_d);
tf1 = tf([0 1] , [60 1], 'InputDelay', 20);
IP_d3 = pade(tf1);
tf2 = tf([0 1], [60 1]);
opt = stepDataOptions('StepAmplitude',1);
opt1 = stepDataOptions('StepAmplitude',1);
%figure(1),step(IP_d,opt);
%figure(2),step(IP_d1,opt1);