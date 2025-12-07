
clear; clc; close all;


Vx_orig = 20.0;          % original droplet speed [m/s]
Vx = 2 * Vx_orig;        % Q4(d): doubled speed = 40 m/s

W  = 1e-3;               % capacitor plate spacing [m]
L1 = 0.5e-3;             % capacitor length [m]
L2 = 1.25e-3;            % distance to paper [m]

rho = 1000;              % density
d   = 84e-6;             % droplet diameter
q   = -1.9e-10;          % droplet charge

volume = (pi/6) * d^3;   % droplet volume
m = rho * volume;        % droplet mass

dpi = 300;
pitch = 0.0254 / dpi;    % pixel size [m]


T_cap_orig = L1 / Vx_orig;
T2_orig    = L2 / Vx_orig;

T_cap_new = L1 / Vx;
T2_new    = L2 / Vx;

fprintf("\n--- Q4(d): Horizontal Speed Doubled ---\n");
fprintf("Original T_cap = %.2f us, New = %.2f us\n", T_cap_orig*1e6, T_cap_new*1e6);
fprintf("Original T2    = %.2f us, New = %.2f us\n", T2_orig*1e6, T2_new*1e6);


coef_orig = (m * W * Vx_orig^2) / (q * L1 * L2);
coef_new  = (m * W * Vx^2)       / (q * L1 * L2);

dV_orig = abs(coef_orig) * pitch;
dV_new  = abs(coef_new)  * pitch;

fprintf("Original pixel voltage = %.3f V\n", dV_orig);
fprintf("New pixel voltage (Vx doubled) = %.3f V\n", dV_new);


N_demo = 40;

t_orig = (0:N_demo) * T_cap_orig;
t_new  = (0:N_demo) * T_cap_new;

V_steps_orig = -(0:N_demo) * dV_orig;
V_steps_new  = -(0:N_demo) * dV_new;

figure('Color','w','Position',[300 200 900 500]); hold on; grid on;

stairs(t_orig*1e6, V_steps_orig, 'LineWidth',1.8,'Color',[0 0.4 1]);
stairs(t_new*1e6,  V_steps_new,  'LineWidth',1.8,'Color',[1 0 0]);

xlabel('Time [\mus]');
ylabel('Voltage [V]');
title('Q4(d) Staircase Voltage: Original Speed vs Doubled Speed');
legend('Original Vx = 20 m/s','New Vx = 40 m/s','Location','southwest');



D = L1 + L2;
N_drops = 300;
midpoint = floor(N_drops/2);

pixel_index = (1:N_drops) - midpoint;
Vpix_all = pixel_index * dV_new;

figure('Color','w','Position',[200 50 1200 700]);
ax = axes(); hold(ax,'on'); grid(ax,'on');
axis equal;

xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
xlim([-0.002, D + 0.002]);
ylim([-0.025 0.025]);
zlim([-0.015 0.015]);

title('Q4(d) Drawing Letter I (Horizontal Speed Doubled)');


px = D;
py = [-0.02 0.02 0.02 -0.02];
pz = [-0.01 -0.01 0.01 0.01];
patch(px*ones(1,4), py, pz,'b','FaceAlpha',0.17,'EdgeColor','none');


plot3(0, 0, 0, 'ks', 'MarkerSize',14,'MarkerFaceColor','k');
text(0,0.003,0,'Inkjet Nozzle','FontSize',13,'FontWeight','bold');


[sx,sy,sz] = sphere(6);
sx = sx*(d/2); sy = sy*(d/2); sz = sz*(d/2);
drop = surf(sx,sy,sz,'FaceColor','k','EdgeColor','none');

view(35,20);
camlight headlight;



for n = 1:N_drops
    
    V = Vpix_all(n);
    E = V / W;
    ay = q*E/m;


    t1 = linspace(0, T_cap_new, 3);
    x1 = Vx * t1;
    y1 = 0.5 * ay * t1.^2;

    Vy = ay * T_cap_new;

   
    t2 = linspace(0, T2_new, 3);
    x2 = L1 + Vx * t2;
    y2 = y1(end) + Vy * t2;

    
    x = [x1 x2];
    y = [y1 y2];
    z = zeros(size(x));

   
    if V > 0, col=[1 0 0];
    elseif V < 0, col=[0 0.2 1];
    else, col=[0 0 0];
    end
    set(drop,'FaceColor',col);

    trail = plot3(x, y, z, '-', 'Color', col, 'LineWidth', 1.2);

    for k = 1:length(x)
        set(drop,'XData',sx + x(k), ...
                 'YData',sy + y(k), ...
                 'ZData',sz + z(k));
        drawnow limitrate;
    end

    plot3(x(end),y(end),0,'.','Color',col,'MarkerSize',14);
    delete(trail);
end


T_drop_new = T_cap_new + T2_new;
total_time = N_drops * T_drop_new;

text(0.0005, 0.022, 0, ...
     sprintf("Total draw time: %.3f ms", total_time*1000), ...
     'FontSize',14,'FontWeight','bold','Color','k');

fprintf("\nTotal draw time (Vx doubled) = %.3f ms\n", total_time*1000);
disp("Q4(d) Simulation Complete!");
