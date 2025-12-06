
clear; close all; clc;


D = 3e-3;            % distance to paper (m)
v = 20;              % droplet velocity (m/s)
t_total = D/v;    % travel time (s) -> 150 microseconds
d_droplet = 84e-6;   % droplet diameter (m)
rho = 1000;          % density (not used here, kept for reference)

% frames & timing
Nframes = 200;                     % number of animation frames
t = linspace(0, t_total, Nframes); % time vector
dt = t(2)-t(1);

x = v .* t;    % x position (m) from 0 to D (should equal D at t_total)
y = zeros(size(t)); % centerline in y
z = zeros(size(t)); % centerline in z

fprintf('Final x = %.6e m, expected D = %.6e m, difference = %.3e m\n', x(end), D, x(end)-D);

fig = figure('Color','w','Position',[200 200 900 600]);
ax = axes(fig);
hold(ax,'on');
grid(ax,'on');
axis(ax,'equal');

margin = 0.001; % 1 mm margin
xlim([ -0.5e-3, D + 0.5e-3 ]);
ylim([ -1e-3, 1e-3 ]);
zlim([ -1e-3, 1e-3 ]);

xlabel('X (m)','FontSize',12);
ylabel('Y (m)','FontSize',12);
zlabel('Z (m)','FontSize',12);
title('Inkjet Droplet Motion (No Electric Field) -- reaches paper in 150 \mus','FontSize',14);

plot3(0,0,0,'ks','MarkerFaceColor',[0.2 0.2 0.2],'MarkerSize',10);
text(0, -0.5e-3, 0, 'Droplet gun','FontSize',10,'HorizontalAlignment','center');


paper_x = D;
py = [-0.5e-3  0.5e-3  0.5e-3 -0.5e-3] ;
pz = [-0.8e-3 -0.8e-3  0.8e-3  0.8e-3] ;
px = paper_x * ones(size(py));
patch('XData',px,'YData',py,'ZData',pz,'FaceColor',[0.85 0.9 1],'FaceAlpha',0.6,'EdgeColor','k');
text(paper_x + 0.15e-3, 0, 0, 'Paper (center at 0,0)','FontSize',10);

[sx,sy,sz] = sphere(18); % coarse sphere - good enough for small droplet
sx = sx * (d_droplet/2); sy = sy * (d_droplet/2); sz = sz * (d_droplet/2);


h_droplet = surf(sx + x(1), sy + y(1), sz + z(1), ...
    'FaceColor',[0 0.4470 0.7410],'EdgeColor','none','FaceLighting','gouraud');
material(h_droplet,'shiny');
camlight headlight;

plot3(x, y, z, ':','Color',[0.7 0.7 0.7]);

view(40,18);

saveGIF = false; % set true if you want GIF file
gifFilename = 'droplet_motion_no_field.gif';

for k = 1:Nframes

    set(h_droplet,'XData', sx + x(k), 'YData', sy + y(k), 'ZData', sz + z(k));
    
  
    tms = t(k)*1e6; % microseconds
    title(ax, sprintf('Time = %.1f \\mus (%.1f%%) -- Droplet hitting center at %.0f \\mus', tms, 100*k/Nframes, t_total*1e6),'FontSize',14);
    
    drawnow;
    

    if saveGIF
        frame = getframe(fig);
        im = frame2im(frame);
        [A,map] = rgb2ind(im,256);
        if k==1
            imwrite(A,map,gifFilename,'gif','LoopCount',Inf,'DelayTime',dt);
        else
            imwrite(A,map,gifFilename,'gif','WriteMode','append','DelayTime',dt);
        end
    end
    

    pause(dt);
end

plot3(x(end), y(end), z(end), 'ro','MarkerFaceColor','r','MarkerSize',8);
text(x(end)+0.12e-3, 0, 0, 'Hit center of paper','FontSize',10,'Color','r');

fprintf('Animation finished. Final x = %.6e m (should be %.6e m)\n', x(end), D);
