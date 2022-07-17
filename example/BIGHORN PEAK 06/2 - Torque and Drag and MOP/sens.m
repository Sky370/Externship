clear; clc; close all;

% T = readtable('welldata.xlsx');
% wellnames = unique(T(:, 'WELLNAME'));
% welltable = getWellData(wellnames(2, :), T);
% foo = 5;


%% Vertical section
T_vert = table2array(readtable('Bighorn.xlsx', 'Sheet', 'Vert_sec'));
N_vert = length(T_vert(:,1));
hookLoad_vert = zeros(N_vert, 1);
% parse through all data points in vertical
for i = 1:N_vert
    params.MW = T_vert(i, 10);
    params.OD_St = T_vert(i, 11);
    params.ID_St = T_vert(i, 12);
    params.AirWbSt = T_vert(i, 13);
    params.WBHA = T_vert(i, 14);
    params.Rb = T_vert(i, 15);
    params.f = T_vert(i, 16);
    params.V = [T_vert(1, 1), T_vert(i, 1); 1, 2];
    hookLoad_vert(i) = TorqueDragSens(params);
end

%% Curvature section
T_curv = table2array(readtable('Bighorn.xlsx', 'Sheet', 'Curv_sec'));
N_curv = length(T_curv(:,1));
hookLoad_curv = zeros(N_curv, 1);
% parse through all data points in vertical
for i = 1:N_curv
    params.MW = T_curv(i, 10);
    params.OD_St = T_curv(i, 11);
    params.ID_St = T_curv(i, 12);
    params.AirWbSt = T_curv(i, 13);
    params.WBHA = T_curv(i, 14);
    params.Rb = T_curv(i, 15);
    params.f = T_curv(i, 16);
    params.V = [T_vert(end, 1), T_curv(i, 1); 1, 2];
    hookLoad_curv(i) = TorqueDragSens(params);
end

%% Lateral section
T_late = table2array(readtable('Bighorn.xlsx', 'Sheet', 'Lat_sec'));
N_late = length(T_late(:,1));
hookLoad_late = zeros(N_late, 1);
% parse through all data points in vertical
for i = 1:N_late
    params.MW = T_late(i, 10);
    params.OD_St = T_late(i, 11);
    params.ID_St = T_late(i, 12);
    params.AirWbSt = T_late(i, 13);
    params.WBHA = T_late(i, 14);
    params.Rb = T_late(i, 15);
    params.f = T_late(i, 16);
    params.V = [T_vert(end, 1), T_curv(end, 1), T_late(i, 1); 1, 2, 3];
    hookLoad_late(i) = TorqueDragSens(params);
end

hookLoad = [hookLoad_vert; hookLoad_curv; hookLoad_late];
depth = [T_vert(:, 1); T_curv(:, 1); T_late(:, 1)];

figure(1)
plot(hookLoad, depth)
set(gca,'YDir','Reverse');
xlabel('HookLoad (lbf)', 'Interpreter', 'Latex','FontSize',20);
ylabel('Measured Depth (ft)','Interpreter', 'Latex','FontSize',20);
set(gca,'FontSize',20);

function welltable = getWellData(wellname, T)
   wellname = table2array(wellname);
   wellname = wellname{1};
   T_num = table2array(T(:,2:end));
   T_name = table2array(T(:, 1));
   ourwellbool = strcmp(T_name, wellname);
   welltable = T_num(ourwellbool, :);
end