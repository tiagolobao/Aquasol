clc; clear;
%% Entradas

%Dados Constantes do problema
Aa = 1.7453e-4;
Cp = 4190;
H = 4;
Leq = 5.67;
Bl = 0.1024;
p = 975;
dc = 0;
neq = 588;
Ta = 25;

nl=4; nc=7; ncp=3; na=7;
neq = nl*nc*ncp*na;

%p*Cp*Aa*Tof = Bl*I - H(T - Ta)/Leq - Cp*meq*(Tof-Tif)/Leq;
%Entradas e saídas no equilíbrio
Tbarra = 15;
Tif = 70; %u2
Tof = Tif + Tbarra; %y
I = 900; %u3
Tof_deriv = 0; %y'
meq = -( p*Cp*Aa*Tof_deriv*Leq -Bl*I*Leq +H*(Tof-Tif-Ta) ) / ( Cp*(Tof-Tif) );
mf = meq * neq; %u1

%Tof= saída do sistema
% I = irradiação (perturbação)
% Tif = temperatura de entrada (perturbação)
% mf = entrada do sistema em malha aberta

%% LINEARIZAÇÃO DO SISTEMA

%Espaço de estados
A = -( (H/(2*Leq)) + ((Cp*mf)/(neq*Leq)) ) / (p*Cp*Aa);
B = -( Cp*Tof ) / ( neq*Leq*p*Cp*Aa );
C = [1];
D = [0];

%Função de transferência
[NUM,DEN] = ss2tf(A,B,C,D);
G = tf(NUM,DEN);

%% CONTROLE DO SISTEMA

%Controlador PI

% Settling time = 21.7s
% Overshoot = 6%
kp = - 5.045;
ki = - 0.3851;
io = 0;
C = pid (kp,ki);

%Função de transferência das pertubações
P1 = G;
P2 = G;

%Controlador feedfoward
Gff1 = -P1/G;
Gff2 = -P2/G;
