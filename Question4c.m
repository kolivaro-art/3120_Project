clear; clc; close all;


Vx = 20.0;          % droplet horizontal speed [m/s]
W  = 1e-3;          % capacitor plate spacing [m]
L1 = 0.5e-3;        % capacitor length
L2 = 1.25e-3;       % distance to paper

rho = 1000;
d_orig = 84e-6;
d     = 10 * d_orig;   % Q4(c): droplet diameter ×10
q   = -1.9e-10;

volume = (pi/6) * d^3;   % new droplet volume
m = rho * volume;        % new mass

dpi = 300;
pitch = 0.0254 / dpi;


T_cap = L1 / Vx;
T2    = L2 / Vx;

fprintf("\n--- Q4(c): Droplet Diameter ×10 ---\n");
fprintf("Droplet mass = %.3e kg\n", m);
fprintf("T_cap = %.2f us\n", T_cap*1e6);
fprintf("T2    = %.2f us\n", T2*1e6);

coef = (m * W * Vx^2) / (q * L1 * L2);
dV = abs(coef) * pitch;   % VERY LARGE (×1000)

fprintf("Pixel voltage required (new) = %.2f V\n", dV);


N_demo = 40;
t = (0:N_demo) * T_cap;
V_steps = -(0:N_demo) * dV;

figure('Color','w','Position',[300 200 900 500]); hold on; grid on;
stairs(t*1e6, V_steps, 'LineWidth',1.8,'Color',[0 0.4 1]);
xlabel('Time [\mus]');
ylabel('Voltage [V]');
title('Q4(c) Staircase Voltage (Droplet Diameter ×10)');
legend('Droplet Diameter = 10×','Location','southwest');



D = L1 + L2;
N_drops = 300;
midpoint = floor(N_drops/2);

pixel_index = (1:N_drops) - midpoint;
Vpix_all = pixel_index * dV;

figure('Color','w','Position',[200 50 1200 700]);
ax = axes(); hold(ax,'on'); grid(ax,'on');
axis equal;

xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
xlim([-0.002, D + 0.002]);
ylim([-0.025 0.025]);
zlim([-0.015 0.015]);

title('Q4(c) Drawing Letter I (Droplet Diameter ×10)');



px = D;
py = [-0.02 0.02 0.02 -0.02];
pz = [-0.01 -0.01 0.01 0.01];
patch(px*ones(1,4), py, pz,'b','FaceAlpha',0.17,'EdgeColor','none');


plot3(0, 0, 0, 'ks', 'MarkerSize',14,'MarkerFaceColor','k');
text(0,0.003,0,'Inkjet Nozzle','FontSize',13,'FontWeight','bold');


[sx,sy,sz] = sphere(6);
sx=sx*(d/2); sy=sy*(d/2); sz=sz*(d/2);
drop = surf(sx,sy,sz,'FaceColor','k','EdgeColor','none');

view(35,20);
camlight headlight;


for n = 1:N_drops

    V = Vpix_all(n);
    E = V / W;
    ay = q*E/m;        % 1000× smaller acceleration

    % Inside capacitor
    t1 = linspace(0, T_cap, 3);
    x1 = Vx * t1;
    y1 = 0.5 * ay * t1.^2;

    % Exit velocity
    Vy = ay * T_cap;

    % After capacitor
    t2 = linspace(0, T2, 3);
    x2 = L1 + Vx * t2;
    y2 = y1(end) + Vy * t2;

    % Combine
    x = [x1 x2];
    y = [y1 y2];
    z = zeros(size(x));

    % Color coding
    if V > 0, col=[1 0 0];
    elseif V < 0, col=[0 0.2 1];
    else, col=[0 0 0];
    end
    set(drop,'FaceColor',col);

    trail = plot3(x,y,z,'-','Color',col,'LineWidth',1.2);

    for k = 1:length(x)
        set(drop,'XData',sx + x(k), ...
                 'YData',sy + y(k), ...
                 'ZData',sz + z(k));
        drawnow limitrate;
    end

    plot3(x(end),y(end),0,'.','Color',col,'MarkerSize',14);
    delete(trail);
end


total_time = N_drops * (T_cap + T2);

text(0.0005, 0.022, 0, ...
     sprintf("Total draw time: %.3f ms", total_time*1000), ...
     'FontSize',14,'FontWeight','bold','Color','k');

fprintf("\nTotal draw time = %.3f ms\n", total_time*1000);
disp("Q4(c) Simulation Complete!");

