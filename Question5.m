% =====================================================================
% PART 5 — FULL SIMULATION (R2-A, WITH LONG CAPACITORS)
% UPDATED: Staircase plots now show 40-step staircases (plot only)
% =====================================================================

clear; clc; close all;

%% ---------------------------------------------------------------
% 1. CONSTANTS + GEOMETRY
% ---------------------------------------------------------------

q = -1.9e-10;      % droplet charge (C)
m = 3e-12;         % droplet mass (kg)
v_x = 20;          % horizontal velocity (m/s)

% Long capacitors (your chosen final version)
L1 = 0.12;         % 120 mm coarse capacitor
W1 = 0.8e-3;

L2 = 0.08;         % 80 mm fine capacitor
W2 = 0.6e-3;

gap = 2e-3;
D   = 3e-3;

L_total = L1 + gap + L2 + D;

%% ---------------------------------------------------------------
% 2. LETTER H PARAMETERS
% ---------------------------------------------------------------

H_height = 279.4e-3;               % full 11-inch height
dpi = 300;
spacing = 0.0254 / dpi;           % dot spacing for 300 dpi

N_vert = round(H_height / spacing);
bar_width = 25.4e-3;               % 1-inch bar width
N_bar = round(bar_width / spacing);

bar_y = H_height / 2;

%% ---------------------------------------------------------------
% 3. TIME CONSTANTS
% ---------------------------------------------------------------

t_cap = (L1 + L2) / v_x;      % time inside capacitors
t_hit = L_total / v_x;        % time to reach paper

%% ---------------------------------------------------------------
% 4. ORIGINAL VOLTAGE COMPUTATION (physics unchanged)
% ---------------------------------------------------------------

target_y = linspace(bar_y - spacing*N_bar/2, ...
                    bar_y + spacing*N_bar/2, N_bar);

V_required = target_y ./ t_cap;
a_required = V_required * 2 / t_cap;

V1 = (a_required * m * W1) ./ q;     % coarse capacitor voltage
V2 = 0.30 * V1;                      % fine capacitor voltage

V1 = max(min(V1, 800), -800);        % clamp
V2 = max(min(V2, 300), -300);

%% ---------------------------------------------------------------
% 5. CREATE 40-STEP PLOT-ONLY STAIRCASE VERSIONS
% ---------------------------------------------------------------

Nsteps = 40;                % number of steps in staircase plot

edges = round(linspace(1, N_bar, Nsteps));

V1_plot = zeros(1, Nsteps);
V2_plot = zeros(1, Nsteps);

for k = 1:Nsteps
    V1_plot(k) = V1(edges(k));   % sample the real waveform
    V2_plot(k) = V2(edges(k));
end

t_plot = (1:Nsteps) * t_cap * 1e6;   % microseconds

%% ---------------------------------------------------------------
% 6. FIGURE LAYOUT
% ---------------------------------------------------------------

figure('Color','w','Position',[100 50 1400 900]);

ax1 = subplot(2,2,1);
ax2 = subplot(2,2,2);
ax3 = subplot(2,2,3);
ax4 = subplot(2,2,4);

%% ---------------------------------------------------------------
% PANEL 1 — Droplet Flight
% ---------------------------------------------------------------

axes(ax1); hold on; grid on;
title('Droplet Flight Through Long Capacitors');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
xlim([0 L_total]); ylim([0 H_height]); zlim([-1e-3 1e-3]);

patch([0 L1 L1 0], [0 0 H_height H_height],[0 0 0 0], ...
     [0.9 0.9 1],'FaceAlpha',0.3);

patch([L1+gap L1+gap+L2 L1+gap+L2 L1+gap], ...
     [0 0 H_height H_height],[0 0 0 0], ...
     [0.7 0.9 1],'FaceAlpha',0.3);

droplet = plot3(ax1,0,0,0,'bo','MarkerFaceColor','b');

%% ---------------------------------------------------------------
% PANEL 2 — Paper (H drawing)
% ---------------------------------------------------------------

axes(ax2); hold on; grid on;
title('Printed H — Full Height');
xlabel('X (m)'); ylabel('Y (m)');
xlim([0 bar_width]); ylim([0 H_height]);

%% ---------------------------------------------------------------
% PANEL 3 — V1(t) 40-step staircase (plot only)
% ---------------------------------------------------------------

axes(ax3); cla; hold on; grid on;
stairs(t_plot, V1_plot, 'b', 'LineWidth', 2);
title('V1(t) — 40-Step Staircase (Plot Only)');
xlabel('Time [\mus]');
ylabel('V1 [V]');

%% ---------------------------------------------------------------
% PANEL 4 — V2(t) 40-step staircase (plot only)
% ---------------------------------------------------------------

axes(ax4); cla; hold on; grid on;
stairs(t_plot, V2_plot, 'r', 'LineWidth', 2);
title('V2(t) — 40-Step Staircase (Plot Only)');
xlabel('Time [\mus]');
ylabel('V2 [V]');

drawnow;

%% ---------------------------------------------------------------
% 7. DRAW LEFT VERTICAL LEG
% ---------------------------------------------------------------

axes(ax2);

for i = 1:N_vert
    y = i * spacing;
    set(droplet,'XData',0,'YData',y,'ZData',0);
    drawnow limitrate;
    plot(0, y,'b.','MarkerSize',8);
end

%% ---------------------------------------------------------------
% 8. DRAW RIGHT VERTICAL LEG
% ---------------------------------------------------------------

for i = 1:N_vert
    y = i * spacing;
    set(droplet,'XData',0,'YData',y,'ZData',0);
    drawnow limitrate;
    plot(bar_width, y,'b.','MarkerSize',8);
end

%% ---------------------------------------------------------------
% 9. DRAW HORIZONTAL BAR
% ---------------------------------------------------------------

for i = 1:N_bar

    V1_now = V1(i);
    V2_now = V2(i);

    a1 = q*V1_now/(m*W1);
    a2 = q*V2_now/(m*W2);
    a_total = a1 + a2;

    Vy = a_total * t_cap;
    y_bar = bar_y + Vy * (t_hit - t_cap);

    x_draw = (i-1)*spacing;

    set(droplet,'XData',0,'YData',y_bar,'ZData',0);
    drawnow limitrate;

    plot(x_draw, y_bar,'b.','MarkerSize',8);
end

disp('DONE — Full H drawn, staircase plots updated (40-step visual).');


