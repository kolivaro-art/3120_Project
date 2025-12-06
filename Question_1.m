%--------------------------------------------------------------
% Inkjet Printer Simulation: Drawing a Vertical Line ("I")
% Vertical Y-axis motion; completes in ~0.0825 seconds
%--------------------------------------------------------------
clear; clc; close all;

%------------------- PARAMETERS -------------------------------
v = 20;                    % m/s downward droplet velocity
H = 3e-3;                  % m distance from nozzle to paper
t_travel = 150e-6;         % s travel time for one droplet
dpi = 300;                 % resolution
spacing = 0.0254 / dpi;    % m vertical spacing between droplets
total_time = 0.0825;       % s total simulation duration
line_length = 25.4e-3;     % 1 inch vertical line

%------------------- GEOMETRY -------------------------------
N = round(line_length / spacing);  % number of droplets (~300)
z_points = linspace(-line_length/2, line_length/2, N); % along Z-axis

%------------------- DROPLET SHAPE --------------------------
d_droplet = 84e-6; % m
[sx, sy, sz] = sphere(16);
sx = sx * d_droplet/2; sy = sy * d_droplet/2; sz = sz * d_droplet/2;

%------------------- FIGURE SETUP ---------------------------
fig = figure('Color','w','Position',[200 200 900 600]);
ax = axes(fig); hold(ax,'on'); grid(ax,'on'); axis(ax,'equal');
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Inkjet Printer Simulation (Y-axis) — Target 0.0825 s','FontSize',13);
xlim([-1e-3 1e-3]); ylim([-H-0.5e-3 0.5e-3]);
zlim([-line_length/2-0.5e-3 line_length/2+0.5e-3]);
view(40,18); camlight headlight;

% Paper plane (X–Z plane)
paper_y = -H;
px = [-0.8e-3 0.8e-3 0.8e-3 -0.8e-3];
pz = [-line_length/2 line_length/2 line_length/2 -line_length/2];
py = paper_y * ones(size(px));
patch('XData',px,'YData',py,'ZData',pz,...
      'FaceColor',[0.85 0.9 1],'FaceAlpha',0.5,'EdgeColor','k');
text(0,paper_y-0.0003,0,'Paper','FontSize',9,'HorizontalAlignment','center');
plot3(0,0,0,'ks','MarkerFaceColor',[0.2 0.2 0.2]); 
text(0,0.0005,0,'Nozzle','FontSize',9,'HorizontalAlignment','center');

% Droplet sphere
h_drop = surf(sx,sy,sz,'FaceColor',[0 0.4470 0.7410],'EdgeColor','none','FaceLighting','gouraud');
material(h_drop,'shiny');
plot3([0 0],[-H 0],[0 0],':','Color',[0.6 0.6 0.6]);

%------------------- SIMULATION LOOP -------------------------
fprintf('Running %d droplets, target time = %.4f s\n',N,total_time);
sim_start = tic;

for i = 1:N
    z_final = z_points(i);
    % simple linear flight from nozzle (Y=0) to paper (Y=-H)
    y_traj = linspace(0,-H,4);
    x_traj = zeros(size(y_traj));
    z_traj = z_final*ones(size(y_traj));

    for k = 1:length(y_traj)
        set(h_drop,'XData',sx+x_traj(k),'YData',sy+y_traj(k),'ZData',sz+z_traj(k));
        elapsed_us = toc(sim_start)*1e6;
        title(ax,sprintf('Droplet %d/%d | z = %.2f mm | Time = %.1f µs', ...
              i,N,z_final*1e3,elapsed_us),'FontSize',12);
        drawnow limitrate nocallbacks;
    end

    % mark impact
    plot3(0,-H,z_final,'k.','MarkerSize',10);
end

%------------------- END SUMMARY -----------------------------
final_time = toc(sim_start);
text(0,-H/2,0,sprintf('Letter "I" Drawn (%.5f s)',final_time),...
     'FontSize',12,'Color','b','HorizontalAlignment','center');
fprintf('✅ Simulation completed in %.6f s (target %.6f s)\n',final_time,total_time);
hold off;
