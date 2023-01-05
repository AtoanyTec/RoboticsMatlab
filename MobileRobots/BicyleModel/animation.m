function animation(data)

    % Color
    color_Front_Axle    = 'b';
    color_Rear_Axle     = 'g';
    color_Car           = 'r';

    % Retrieving data
    TOUT    = data.TSpan;
    XT      = data.XT;              % Posición x CG                     [m]
    YT      = data.YT;              % Posición y CG                     [m]
    PSI     = data.PSI;             % Ángulo yaw del vehículo           [rad]
    VEL     = data.VEL;             % Velocidad CG del vehículo         [m/s]
    ALPHAT  = data.ALPHAT;          % Ángulo desplazamiento lateral     [rad]
    dPSI    = data.dPSI;            % Tasa Yaw                          [rad/s]
    a       = data.a;               % Sobresaliente delantero           [m]
    b       = data.b;               % Dist CG - eje delantero           [m]
    c       = data.c;               % Dist CG - eje trasero             [m]
    d       = data.d;               % Sobresaliente trasero             [m]
    lT      = data.wT / 2;          % Mitad del ancho del vehículo      [m]


    % Ángulo desplazamiento lateral @ eje delantero [rad]
    ALPHAF = atan2((b * dPSI + VEL.*sin(ALPHAT)),(VEL.*cos(ALPHAT)));

    
    %Ángulo desplazamiento lateral @ eje trasero [rad]
    ALPHAR = atan2((-c * dPSI + VEL.*sin(ALPHAT)),(VEL.*cos(ALPHAT)));

    % Velocidad @ eje delantero [m/s]
    VF = sqrt((VEL.*cos(ALPHAT)).^2 + (b * dPSI + VEL.*sin(ALPHAT)).^2);
    % Velocidad @ eje trasero [m/s]
    VR = sqrt((VEL.*cos(ALPHAT)).^2 + (-c * dPSI + VEL.*sin(ALPHAT)).^2);

    % Posición de las esquinas y ejes relativos al CG
    rt1t = [a+b;lT];                    % Frente izquierdo
    rt2t = [a+b;-lT];                   % Frente derecho
    rt3t = [-c-d;-lT];                  % Derecha trasera
    rt4t = [-c-d;lT];                   % Isquierda trasera

    eif = [b;0];                        % Eje delantero
    eir = [-c;0];                       % Eje trasero


    % Posiciones absolutas de esquinas y ejes

    %Prealocando de matriz
    rt1i = zeros(length(TOUT),2);
    rt2i = zeros(length(TOUT),2);
    rt3i = zeros(length(TOUT),2);
    rt4i = zeros(length(TOUT),2);

    eff = zeros(length(TOUT),2);
    err = zeros(length(TOUT),2);

    % Bucle de inicio
    for j=1:length(TOUT)
        % Matriz de rotación (T t1 t2 t3) a (o i j k)
        RTI=[cos(PSI(j)) -sin(PSI(j));sin(PSI(j)) cos(PSI(j))];
        % Vectores de posción 1, 2, 3 e 4 relativos al origen de la
        % referencia inercial  (T t1 t2 t3)
        rt1i(j, 1:2) = (RTI * rt1t)';
        rt2i(j, 1:2) = (RTI * rt2t)';
        rt3i(j, 1:2) = (RTI * rt3t)';
        rt4i(j, 1:2) = (RTI * rt4t)';
        % Posición de los ejes delantero y trasero
        eff(j, 1:2) = (RTI * eif);     % Frente
        err(j, 1:2) = (RTI * eir);     % Posterior
    end

    % Posiciones absolutas de esquinas y ejes
    % Vectores de posición 1, 2, 3 e 4 relativos a la base (o i j k)
    rc1t=[XT YT]+rt1i;
    rc2t=[XT YT]+rt2i;
    rc3t=[XT YT]+rt3i;
    rc4t=[XT YT]+rt4i;
    % Posiciones absolutas de eje delantero y posterior
    ef = [XT YT]+eff;
    er = [XT YT]+err;

    figure
    % set(gcf,'Position',[50 50 1280 720]) % YouTube: 720p
    % set(gcf,'Position',[50 50 854 480]) % YouTube: 480p
    set(gcf,'Position',[50 50 640 640]) % Social
    
    % Crear y abrir un objeto de escritura de video
    v = VideoWriter('Kinematic_bicycle_open.mp4','MPEG-4');
    v.Quality = 100;
    open(v);
    
    hold on ; grid on ; axis equal
    set(gca,'xlim',[min(XT)-5 max(XT)+5],'ylim',[min(YT)-5 max(YT)+5])
    xlabel('x distancia [m]');
    ylabel('y distancia [m]');

    for j = 1:length(TOUT)
        
        cla
        
        % Ejes
        plot(ef(:,1),ef(:,2),color_Front_Axle)
        plot(er(:,1),er(:,2),color_Rear_Axle)

        % Coordenadas de las esquinas
        xc = [rc1t(j, 1) rc2t(j, 1) rc3t(j, 1) rc4t(j, 1)];
        yc = [rc1t(j, 2) rc2t(j, 2) rc3t(j, 2) rc4t(j, 2)];

        % Vehículo
        fill(xc, yc,color_Car)

        % Vectores de velocidad
        % Colores diferentes
        vector(ef(j, 1:2),(ALPHAF(j)+PSI(j)),VF(j),color_Front_Axle);
        vector(er(j, 1:2),(ALPHAR(j)+PSI(j)),VR(j),color_Rear_Axle);

        title(strcat('Tiempo=',num2str(TOUT(j),"%.2f"),' s'))

        frame = getframe(gcf);
        writeVideo(v,frame);

    end

    close(v);
    
end