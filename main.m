clc; clear;
% Entradas

Aa = 1.7453e-4; %Absorver cross-section area
Cp = 4190;
H = 4;
Leq = 5.67;
Bl = 0.1024;
p = 975;
dc = 0;
neq = 588;
Ta = 25;

% Ponto de Operação
mf_po = 2.55;
Tbarra = 15;
Tif = 70;
Tof = Tif + Tbarra;

%Temperature
% T = (T0f + Tif) / 2;

% Equivalent Mass Flow
% meq = mf/neq

nl = 4;
nc = 7;
ncp = 3;
na = 7;
neq = nl*nc*ncp*na;

%Tof= saída do sistema
% I = irradiação (perturbação)
% Tif = temperatura de entrada (perturbação)
% meq = entrada do sistema em malha aberta
I = 900;

%ESPACO DE ESTADOS LINEARIZADO

A = -( (H/(2*Leq)) + ((Cp*mf_po)/(neq*Leq)) ) / (p*Cp*Aa);
B = -( Cp*Tof ) / ( neq*Leq*p*Cp*Aa );
C = [1];
D = [0];

[NUM,DEN] = ss2tf(A,B,C,D);

%Planta
G = tf(NUM,DEN);

%Pós PID TUNER
kp = - 0.0797;
ki = - 0.0030554	;
io = 0;

%Controlador
C = pid (kp,ki);

%Função de transferência completa
T = feedback(C*G,1);

%Função de transferência das pertubações
P1 = G;
P2 = G;

%Controlador feedfoward
Gff1 = -P1/G;
Gff2 = -P2/G;

