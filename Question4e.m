%--------------------------------------------------------------
% PART 4(e): Drawing a Vertical Line "I"
% Droplet charge is FIVEFOLD increased
% But V = 0 so deflection is unchanged → same trajectory
%--------------------------------------------------------------
clear; clc; close all;

%------------------- Given Parameters -------------------------
v = 20;                 % horizontal velocity (m/s)
L1 = 0.5e-3;            % m
L2 = 1.25e-3;           % m
D  = 3e-3;              % m

q_original = -1.9e-10;       % C
q_new = 5 * q_original;      % fivefold increase

% Total flight distance
L_total = L1 + L2 + D;

% Travel time
t_travel = L_total / v;      % 237.5 microseconds
fprintf("Droplet travel time = %.2f microseconds\n", t_travel*1e6);

%------------------- Printing Parameters ----------------------
dpi = 300;
spacing = 0.0254 / dpi;      % 84.67 µm
line_length = 25.4e-3;       % 1 inch

N = round(line_length / spacing);    % 300 droplets
dt_fire = t_travel;
total_time = N * dt_fire;

fprintf("Total time to draw I = %.4f seconds\n", total_time);
fprintf("New droplet charge = %.2e C\n", q_new);

%------------------- Figure Setup -----------------------------
figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('PART 4(e): Inkjet Simulation with Droplet Charge ×5');

xlim([0 L_total * 1.35]);
ylim([-line_length/2 line_length/2]);
zlim([-1e-3 1e-3]);

% Paper plane
paperX = L_total;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], [0.9 0.9 1], 'FaceAlpha', 0.3);

%------------------- Right-Side Text --------------------------
textX = L_total * 1.18;

text(textX, line_length/2 * 0.75, 0, ...
    sprintf("Total Print Time = %.4f s", total_time), ...
    'FontSize',12, 'Color','b');

text(textX, line_length/2 * 0.50, 0, ...
    sprintf("Droplet Travel Time = %.2f µs", t_travel*1e6), ...
    'FontSize',12, 'Color','b');

text(textX, line_length/2 * 0.25, 0, ...
    sprintf("Charge = %.2e C", q_new), ...
    'FontSize',12, 'Color','b');

text(textX, line_length/2 * 0.10, 0, ...
    'Letter "I" Drawn (Part e)', ...
    'FontSize',12, 'Color','b');

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
        set(droplet,'XData',x(k),'YData',y(k),'ZData',z(k));
        drawnow limitrate;
    end

    % Print droplet on paper
    plot3(paperX, y_final, 0, 'k.', 'MarkerSize', 10);
    drawnow limitrate;

    % Real-time pacing
    elapsed = toc;
    target = i * dt_fire;
    if elapsed < target
        pause(target - elapsed);
    end
end

hold off;
