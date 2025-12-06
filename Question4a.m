%--------------------------------------------------------------
% PART 4(a): Drawing a Vertical Line "I"
% L2 is THREEFOLD increased → longer droplet flight time
% Real-time simulation (total time minimized)
%--------------------------------------------------------------
clear; clc; close all;

%------------------- Given Parameters -------------------------
v = 20;                   % m/s horizontal droplet velocity
L1 = 0.5e-3;              % capacitor length (m)
L2 = 3 * 1.25e-3;         % threefold increased L2 (m)
D  = 3e-3;                % distance after L2 to paper (m)

% Total flight distance for 1 droplet
L_total = L1 + L2 + D;

% New travel time because L2 increased
t_travel = L_total / v;   % ≈ 362.5 microseconds
fprintf("Droplet travel time (new L2) = %.2f microseconds\n", t_travel*1e6);

dpi = 300;                % printing resolution
spacing = 0.0254 / dpi;   % m per printed dot

line_length = 25.4e-3;    % 1 inch vertical line
N = round(line_length / spacing);  % number of droplets (~300)

% Total time is minimized → one droplet every t_travel
dt_fire = t_travel;
total_time = N * dt_fire;

fprintf("Total time to draw I = %.4f seconds\n", total_time);

%------------------- Figure Setup -----------------------------
figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('PART 4(a): Inkjet Simulation with L2 Increased 3×');

xlim([0 L_total * 1.35]);
ylim([-line_length/2 line_length/2]);
zlim([-1e-3 1e-3]);

% Draw Paper Plane
paperX = L_total;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], [0.9 0.9 1], 'FaceAlpha', 0.3);

%------------------- RIGHT-SIDE TEXT ANNOTATIONS ----------------


% Compute annotation x-position outside paper
textX = L_total * 1.18;

% Vertically stacked annotation positions
textY1 = line_length/2 * 0.70;   % Top line
textY2 = line_length/2 * 0.40;   % Middle line
textY3 = line_length/2 * 0.10;   % Bottom line

% Annotation 1: Total print time
text(textX, textY1, 0, sprintf("Total Print Time = %.3f s", total_time), ...
    'FontSize',12, 'Color','b', 'HorizontalAlignment','left');

% Annotation 2: Droplet travel time
text(textX, textY2, 0, "Droplet Travel Time = 363 µs", ...
    'FontSize',12, 'Color','b', 'HorizontalAlignment','left');

% Annotation 3: Completion label “Letter I Drawn”
text(textX, textY3, 0, 'Letter "I" Drawn (Part 4a)', ...
    'FontSize',12, 'Color','b', 'HorizontalAlignment','left');

%------------------- Droplet Initialization -------------------
droplet = plot3(0,0,0,'bo','MarkerFaceColor','b','MarkerSize',6);
drawnow;

% Preallocate for printed dots
y_points = linspace(-line_length/2, line_length/2, N);

%------------------- Simulation Loop --------------------------
tic;  % start real-time timer

for i = 1:N
   y_final = y_points(i);

   % Droplet trajectory to paper
   t_local = linspace(0, t_travel, 12);
   x = v * t_local;
   y = y_final * ones(size(x));
   z = zeros(size(x));

   % Move droplet frame by frame
   for k = 1:length(t_local)
       set(droplet, 'XData', x(k), 'YData', y(k), 'ZData', z(k));
       drawnow limitrate;
   end

   % Impact dot at paper
   plot3(paperX, y_final, 0, 'k.', 'MarkerSize', 10);
   drawnow limitrate;

   % Maintain EXACT timing (real-time)
   elapsed = toc;
   target = i * dt_fire;
   if elapsed < target
       pause(target - elapsed);
   end
end


hold off;

