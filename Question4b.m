%--------------------------------------------------------------
% PART 4(b): Drawing a Vertical Line "I"
% L1 is TWOFOLD increased → new droplet flight time
% Real-time simulation (minimal total time)
%--------------------------------------------------------------
clear; clc; close all;

%------------------- Given Parameters -------------------------
v = 20;                   % m/s droplet velocity
L1 = 2 * 0.5e-3;          % TWOfold increased L1
L2 = 1.25e-3;             % unchanged
D  = 3e-3;                % unchanged

% Total flight distance
L_total = L1 + L2 + D;

% New flight time
t_travel = L_total / v;     % expected 262.5 µs
fprintf("Droplet travel time = %.2f microseconds\n", t_travel*1e6);

% Printing resolution
dpi = 300;
spacing = 0.0254 / dpi;

% Draw 1-inch vertical line
line_length = 25.4e-3;
N = round(line_length / spacing);

% Minimal printing time
dt_fire = t_travel;
total_time = N * dt_fire;

fprintf("Total time to draw I = %.4f seconds\n", total_time);

%------------------- Figure Setup -----------------------------
figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('PART 4(b): Inkjet Simulation with L1 Doubled');

xlim([0 L_total * 1.35]);
ylim([-line_length/2 line_length/2]);
zlim([-1e-3 1e-3]);

% Paper plane
paperX = L_total;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], [0.9 0.9 1], 'FaceAlpha', 0.3);

%------------------- Annotations on Right Side ----------------
textX = L_total * 1.18;

text(textX, line_length/2 * 0.70, 0, ...
    sprintf("Total Print Time = %.3f s", total_time), ...
    'FontSize',12,'Color','b');

text(textX, line_length/2 * 0.40, 0, ...
    "Droplet Travel Time = 262.5 µs", ...
    'FontSize',12,'Color','b');

text(textX, line_length/2 * 0.10, 0, ...
    'Letter "I" Drawn (Part b)', ...
    'FontSize',12,'Color','b');

%------------------- Droplet Initialization -------------------
droplet = plot3(0,0,0,'bo','MarkerFaceColor','b','MarkerSize',6);
drawnow;

% Y positions for droplets
y_points = linspace(-line_length/2, line_length/2, N);

%------------------- Simulation Loop --------------------------
tic;

for i = 1:N

    y_final = y_points(i);

    t_local = linspace(0, t_travel, 12);
    x = v * t_local;
    y = y_final * ones(size(t_local));
    z = zeros(size(t_local));

    % Animate droplet flight
    for k = 1:length(t_local)
        set(droplet, 'XData', x(k),'YData', y(k),'ZData', z(k));
        drawnow limitrate;
    end

    % Print droplet
    plot3(paperX, y_final, 0, 'k.', 'MarkerSize', 10);
    drawnow limitrate;

    % Real-time sync
    elapsed = toc;
    target = i * dt_fire;
    if elapsed < target
        pause(target - elapsed);
    end
end

hold off;
