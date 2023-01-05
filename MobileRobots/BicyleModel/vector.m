function vector(startCoord, angle, modulus, color)

    coord1  = startCoord;                                   % Vector de coordenada inicial
    theta   = angle;
    modulus = 0.7 * modulus;                                % Tamaño del vector
    coord2  = modulus*[cos(theta) sin(theta)] + coord1;     % Vector de coordenada final

    esc     = 1;    % Escala
    l       = 0.5;  % Ancho relativo al triángulo (0-1)

    % Forma y orientación del triángulo
    c1 = esc * l*[-sin(theta) +cos(theta)];     % esquina 1 - izquierda inferior
    c2 = esc * l*[+sin(theta) -cos(theta)];     % esquina 2 - derecha inferior
    c3 = esc*[+cos(theta) +sin(theta)];         % esquina 3 - altura

    % Escala y posicionamiento
    x = [c1(1)+coord2(1) c2(1)+coord2(1) c3(1)+coord2(1)];
    y = [c1(2)+coord2(2) c2(2)+coord2(2) c3(2)+coord2(2)];

    hold on
    fill(x, y, color)
    p = plot([coord1(1) coord2(1)],[coord1(2) coord2(2)],color);
    set(p, 'LineWidth', 2)

    % Vector de origen
    m = plot(coord1(1),coord1(2),strcat('*', color));
    set(m, 'MarkerSize', 10)
    
end