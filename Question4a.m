
clear; clc; close all;


Vx = 20.0;          % droplet horizontal speed [m/s]
W  = 1e-3;          % capacitor plate spacing [m]
L1 = 0.5e-3;        % capacitor length [m]
L2 = 1.25e-3;       % original distance to paper [m]
L2_new = 3 * L2;    % Q4(a): tripled distance to paper

rho = 1000;         % density
d   = 84e-6;        % droplet diameter
q   = -1.9e-10;     % droplet charge

volume = (pi/6) * d^3;
m = rho * volume;

dpi = 300;
pitch = 0.0254 / dpi;

T_cap = L1 / Vx;    % time inside capacitor

coef_orig = (m * W * Vx^2) / (q * L1 * L2);
coef_new  = (m * W * Vx^2) / (q * L1 * L2_new);

dV_orig = abs(coef_orig) * pitch;
dV_new  = abs(coef_new) * pitch;

fprintf("\n----- Q4(a) Voltage Results -----\n");
fprintf("Original L2 pixel voltage = %.2f V\n", dV_orig);
fprintf("New L2×3 pixel voltage     = %.2f V\n", dV_new);
fprintf("Reduction factor           = %.2f\n", dV_new/dV_orig);


N_demo = 40;
t = (0:N_demo) * T_cap;

V_steps_orig = -(0:N_demo) * dV_orig;
V_steps_new  = -(0:N_demo) * dV_new;

figure('Color','w','Position',[200 200 900 500]); hold on; grid on;

stairs(t*1e6, V_steps_orig, 'LineWidth',1.8,'Color',[0 0.4 1]);
stairs(t*1e6, V_steps_new,  'LineWidth',1.8,'Color',[1 0 0]);

xlabel('Time [\mus]');
ylabel('Voltage [V]');
title('Q4(a) Staircase Voltage Comparison (Original L2 vs L2×3)');
legend('Original L2 = 1.25 mm','New L2×3 = 3.75 mm','Location','southwest');

D = L1 + L2_new;       % New total distance to paper

N_drops = 300;         % Draw a full 1-inch "I"
midpoint = floor(N_drops/2);

pixel_index = (1:N_drops) - midpoint;

Vpix_all = pixel_index * dV_new;    % Pixel voltages
y_targets = pixel_index * pitch;    % Ideal y-positions on paper

figure('Color','w','Position',[200 50 1200 700]);
ax = axes(); hold(ax,'on'); grid(ax,'on');
axis equal;

xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
xlim([-0.002, D + 0.002]);
ylim([-0.025 0.025]);
zlim([-0.015 0.015]);

title('Drawing the Letter "I" with L2×3 (ULTRA FAST, Enlarged View, Color Coded)');


px = D;
py = [-0.02 0.02 0.02 -0.02];
pz = [-0.01 -0.01 0.01 0.01];
patch(px*ones(1,4), py, pz,'b','FaceAlpha',0.17, 'EdgeColor','none');


plot3(0, 0, 0, 'ks', 'MarkerSize', 14, 'MarkerFaceColor','k');
text(0, 0.003, 0, 'Inkjet Nozzle','FontSize',13,'FontWeight','bold');

[sx,sy,sz] = sphere(6);
sx = sx*(d/2); sy = sy*(d/2); sz = sz*(d/2);
drop = surf(sx, sy, sz, 'FaceColor','k','EdgeColor','none');

view(35, 20);
camlight headlight;



for n = 1:N_drops
    
    V = Vpix_all(n);
    E = V / W;
    ay = q*E/m;

    % ----- Motion inside capacitor -----
    T1 = L1 / Vx;
    t1 = linspace(0, T1, 3);
    x1 = Vx * t1;
    y1 = 0.5 * ay * t1.^2;

    % ----- Motion after capacitor -----
    Vy = ay * T1;
    T2 = L2_new / Vx;
    t2 = linspace(0, T2, 3);
    x2 = L1 + Vx * t2;
    y2 = y1(end) + Vy * t2;

    % Combined path
    x = [x1 x2];
    y = [y1 y2];
    z = zeros(size(x));

    % ----- Color coding -----
    if V > 0
        droplet_color = [1 0 0];
    elseif V < 0
        droplet_color = [0 0.2 1];
    else
        droplet_color = [0 0 0];
    end
    set(drop,'FaceColor',droplet_color);

    % ----- Trajectory trail -----
    trail = plot3(x, y, z, '-', 'Color', droplet_color, 'LineWidth', 1.2);

    % ----- Animate droplet -----
    for k = 1:length(x)
        set(drop,'XData',sx + x(k), ...
                 'YData',sy + y(k), ...
                 'ZData',sz + z(k));
        title(sprintf('Droplet %d of %d (Colored + Trailed)', n, N_drops));
        drawnow limitrate;
    end

    % Landing mark
    plot3(x(end), y(end), 0, '.', 'Color', droplet_color, 'MarkerSize', 14);

    delete(trail);
end


total_time = N_drops * (T_cap + T2);   % seconds for full pattern

text_position = [0.0005, 0.022, 0];
time_string = sprintf("Total draw time for 'I': %.4f ms", total_time*1000);

text(text_position(1), text_position(2), text_position(3), ...
     time_string, 'FontSize',14, 'FontWeight','bold', 'Color','k');

fprintf("\nTotal time to draw 'I' = %.4f ms\n", total_time*1000);


disp("Color-coded + Trailed Simulation Complete!");
