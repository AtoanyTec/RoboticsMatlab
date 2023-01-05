% Kinamatic bicycle
% Atoany Fierro
% 

%% 
clc
clear all
close all

%% Escenario 

% Carro
L = 2.7;                        % Distancia entre ejes          [m]
a = 0.935;                      % Sobresaliente delantero       [m]
b = L;                          % Dist CG - eje delantero       [m]
c = L/2;                        % Dist CG - eje trasero         [m]
d = 0.995;                      % Sobresaliente trasero         [m]
w = 1.780;                      % Ancho                         [m]

% Condiciones iniciales
x0      = 0;                    % Ángulo inicial eje x trasero  [m]
y0      = 0;                    % Ángulo inicial eje y trasero  [m]
psi0    = 0;                    % Ángulo yaw inicial            [rad]
delta0  = 0;                    % Ángulo de dirección inicial   [rad]
z0 = [x0 x0 psi0 delta0];

% Parámetros
tf      = 30;                   % Tiempo final                  [s]
fR      = 30;                   % Tasa de frames                [fps]
dt      = 1/fR;                 % Resolución de tiempo          [s]
time    = linspace(0,tf,tf*fR); % Tiempo                        [s]


%% Simulación  
options = odeset('RelTol',1e-5);
[tout,zout] = ode45(@(t,z) car(t,z,L),time,z0,options);

% Recuperando estados
x = zout(:,1);                  % Posición eje x trasero        [m]
y = zout(:,2);                  % Posición eje y trasero        [m]
g = zout(:,3);                  % Ángulo Yaw                    [rad]

% Tasa Yaw y velocidad
% Alocación de memoria
dg  = zeros(length(time),1);
v   = zeros(length(time),1);
for i=1:length(time)
    [dz,vel]    = car(time(i),zout(i,:),L);
    dg(i)       = dz(3);
    v(i)        = vel;
end

% Estados para animación
XT      = x + c*cos(g);         % Posición CG X                 [m]
YT      = y + c*sin(g);         % Posición CG Y                 [m]
PSI     = zout(:,3);            % Ángulo Yaw                    [rad]
dPSI    = dg;                   % Tasa Yaw                      [rad/s]
VEL     = v;                    % Velocidad del vehículo        [m/s]
ALPHAT  = atan(dg*c/v);         % Ángulo desplazamiento lateral [rad]


%% Animación

% Estructura para animación
data.XT        = XT;
data.YT        = YT;
data.PSI       = PSI;
data.dPSI      = dPSI;
data.VEL       = VEL;
data.ALPHAT    = ALPHAT;
data.TSpan     = time;
data.a         = a;
data.b         = b;
data.c         = c;
data.d         = d;
data.wT        = w;

animation(data);


