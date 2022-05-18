%%% Scalable Modular Dynamic MSR Model
%%% Authors - Visura Pathirana, Alex Wheeler
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala



%% User Inputs

%%% Basic Simulation Parameters
simtime = 60000;                                                            %Simulation time [s]
ts_max = 1e-1;                                                             %Maximum timestep [s] 
P=8;                                                                       %Operational thermal power [MW]
RelP0 = 0.01;

%%% Fuel Type
%%% fuel_type = 235; for FLibe with U235
%%% fuel_type = 233; for FLiBe with U233
fuel_type = 235;                                                           

%%% Source Step Reactivity Insertions & Sinusoidal Reactvity Insertions 
sourcedata = [0 0 0];                                                      %Neutron source insertions [abs]
sourcetime = [0 1000 2500];                                                %Neutron source insertion time [s]
source = timeseries(sourcedata,sourcetime);                                %Defining source timeseries  

reactdata = [0 0 1000E-5 1000E-5];                                                       %Reactivity insertions [abs]
reacttime = [0 30000 30000 200000];                                                 %Reactivity insertion time [s]
react = timeseries(reactdata,reacttime);                                   %Defining source timeseries

omega          = 1;                                                 %Frequncy of the sine wave [rad]
sin_mag        = 0;                                                        %Amplitude of the sine wave [abs]
dx             = round((2*pi/omega)/25, 2, 'significant');                 %Size of the time step [s]

%%% Pump Trips
Trip_P_pump=20000000;                                                      %Time at which primary pump is tripped [s]
Trip_S_pump=20000000;                                                      %Time at which secondary pump is tripped [s]

%%% UHX Parameters
%%% UHX_MODE = 1; uses a radiator
%%% UHX_MODE = 2; uses a constant power removal block
%%% Demand following is allowed only in UHX_MODE = 2 (constant power removal block)
UHX_MODE = 2;
Block_UHE=0;                                                            %Time at which ultimate heat exchanger will be cut off [s]

%%% Only for UHX_MODE = 2
demanddata = [RelP0 RelP0 RelP0 RelP0 RelP0];                                                  %Reactivity insertions [abs]
%demanddata = [1 1 1 1 1];    
demandtime = [0 1000 2000 3000 50000];                                      %Reactivity insertion time [s]
demand = timeseries(demanddata,demandtime);                                %Defining source timeseries                               %Defining source timeseries

%%% DHRS Parameters
%%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
%%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
%%% DHRS_MODE = 1 all  ows modifications to sigmoid behavior. Listed under Normal DHRS below
%%% DHRS_MODE = 2 allows modifications through matlab function block from sim
%%% DHRS_MODE = 2 allows cold slug insertions
DHRS_MODE = 1; 
DHRS_time=0;                                                            %Time at which DRACS will be activated. use simtime to keep it off [s]

%%% Only for DHRS_MODE = 1
DHRS_Power= P*(RelP0);                                                      %Maximum power that can be removed by DHRS
Power_Bleed= P*(0.00);                                                     %Some power will removed from DRACS even when its not used 

%%% Only for DHRS_MODE = 2
deltaTf_DHRS = 30;                                                         %Temperature drop by broken DHRS [deg. C]
slug_time = 8.46;                                                          %Duration of slug [s]

%run('SMD_MSR_Para_V1.m')
run('SMD_MSR_ZPR_Para.m')
sim('SMD_MSR_Sim_V1.slx')

%% Save Results

% timeoffset = 20000;
% timeCutoff = simtime;
% % timeCutoff = tout(end);
% 
% tout = tout - timeoffset;
% time_capture = timeCutoff - timeoffset;
% 
% timeOffsetIndex = find(tout==0);
% timeCutoffIndex = find(tout==time_capture);
% 
% time = tout(timeOffsetIndex:timeCutoffIndex);
% time_range = (0 : 0.01 : time_capture).';
% 
% power_nom_fission = Temp_mux(timeOffsetIndex:timeCutoffIndex,1);
% power_nom_decay = Temp_mux(timeOffsetIndex:timeCutoffIndex,2);
% power_nom_total = power_nom_fission + power_nom_decay;
% 
% power_data(:,1) = time_range;
% power_data(:,2) = interp1(time,power_nom_total,time_range,'linear');
% power_data(:,3) = interp1(time,power_nom_fission,time_range,'linear');
% power_data(:,4) = interp1(time,power_nom_decay,time_range,'linear');
% 
% temp_core_in = Temp_mux(timeOffsetIndex:timeCutoffIndex,3);
% temp_core_out = Temp_mux(timeOffsetIndex:timeCutoffIndex,6);
% temp_grap = Temp_mux(timeOffsetIndex:timeCutoffIndex,4);
% temp_core_avg = (temp_core_in + temp_core_out)/2;
% 
% temp_data(:,1) = time_range;
% temp_data(:,2) = interp1(time,temp_core_avg,time_range,'linear');
% temp_data(:,3) = interp1(time,temp_core_in,time_range,'linear');
% temp_data(:,4) = interp1(time,temp_core_out,time_range,'linear');
% temp_data(:,5) = interp1(time,temp_grap,time_range,'linear');
% 
%%Turn reactivity from absolute to pcm
rho_fb_tot_pcm=rho_fb_tot*1E5;
rho_fb_f_pcm=rho_fb_f*1E5;
rho_fb_g_pcm=rho_fb_g*1E5;
% 
% react_data(:,1) = time_range;
% react_data(:,2) = interp1(time,react_fb_tot_pcm,time_range,'linear');
% react_data(:,3) = interp1(time,react_fb_f_pcm,time_range,'linear');
% react_data(:,4) = interp1(time,react_fb_g_pcm,time_range,'linear');
% 
% save('power_data.mat',power_data) 
% save('temp_data.mat',temp_data)
% save('react_data.mat',temp_data)

%Create time offsets and find time = 0 index for other offsets
plottimeStart = 19000;
timeoffset = 30000;

timemin = -5000;
timemax    = 25000;

time = tout - timeoffset; 
offsetindex = find(time==0); 
% 
figure(1)
%%%Plot relative; total, fission, decay 
subplot(3,1,1)
hold on
grid on
plot(time,(Temp_mux(:,1) + Temp_mux(:,2)),'color','#FF00FF','LineWidth',1)
%plot(time,Temp_mux(:,1),'color','#0000FF','LineWidth',1)
%plot(time,Temp_mux(:,2),'color','#00FFFF','LineWidth',1)
title('Normalized Power')
ylabel('Relative Power')
%legend('Total','Fission','Decay')
xlim([timemin timemax]) 
ylim([-inf inf])
set(gca, 'YScale', 'log')
% set(gca,'YTick', 10^-5:0);

%%%Plot core temps; inlet, outlet, graphite
subplot(3,1,2)
hold on
grid on
plot(time,((Temp_mux(:,3)+Temp_mux(:,6))/2),'color','#FF3333','LineWidth',1)
plot(time,Temp_mux(:,4),'color','#581845','LineWidth',1)
%plot(time,Temp_mux(:,6),'color','#FFC300','LineWidth',1)
title('Core Avg. Temperatures')
legend('Fuel','Graphite')
ylabel('Temperatures [deg C]')
xlim([timemin timemax]) 
ylim([-inf inf])



%%%Plot temprature feedback; totel, fuel, graphite
subplot(3,1,3)
hold on
grid on
plot(time,rho_fb_tot_pcm,'color','#f28500','LineWidth',1)
plot(time,rho_fb_f_pcm,'green','LineWidth',1)
plot(time,rho_fb_g_pcm,'color','#536878','LineWidth',1)
title('Temperature Feedback')
xlabel('Time [s]')
ylabel('Reativity [pcm]')
legend('Total', 'Fuel', 'Graphite')
xlim([timemin timemax]) 
ylim([-inf inf])
% 
% 
% x0=10;
% y0=10;
% width=1100;
% height=1050;
% set(gcf,'position',[x0,y0,width,height])
% % 
% % % Save plot as fig and png
% % saveas(gcf,'Transient_1.png')
% % savefig('Transient_1.fig')
