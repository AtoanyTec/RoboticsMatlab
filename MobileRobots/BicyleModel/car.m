function [dz,v] = car(t,z,L)

    % Estados
    g = z(3);
    delta = z(4);               % Ángulo de dirección           [rad] 

    v = 15/3.6;                 % Velocidad del eje trasero     [m/s]
    
    % STEERING
    % Straight line
        t1 = 2;                 % Duración de línea recta       [s]
        deltaRate = 0;

    % Cambio de dirección 1
        steerChangeDuration_1 = 1; % [s]
        if t > t1 && t < t1 + steerChangeDuration_1
            deltaRate = 15*pi/180;
        end
    
    % Modelo cinemático bicicleta
    dx = v*cos(g);
    dy = v*sin(g);
    dg = v/L*tan(delta);
    dd = deltaRate; 

    dz = [dx ; dy ; dg ; dd];
    
end