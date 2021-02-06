%%% Scalable Modular Dynamic MSR Model
%%% Authors - Visura Pathirana, Alex Wheeler
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Transient - 2
%%% Runs a simulation of UHX failure with DHRS open & SCRAM simultaniously
%%% Results are plotted in three panels; Reactor power, Core tempratures & feedbacks
%%% Simulation done in five steps

%%% Step - 1; Simulation is run for 2000[s] at 8[Mw_t]
%%% Step - 2; Using UHX_MODE = 1, Radiator tripped at 2000[s]
%%% Step - 3; Using DHRS_MODE = 1, Normal DHRS open at 2000[s]
%%% Step - 4; -2800[pcm] worth reactivity inserted as a step at 2000[s]
%%% Step - 5; Simulation continued till 9000[s]

%% User Inputs

%%% Basic Simulation Parameters
simtime = 2300;                                                            %Simulation time [s]
ts_max = 1e-2;                                                             %Maximum timestep [s] 
P=8;                                                                       %Operational thermal power [MW]

%%% Fuel Type
%%% fuel_type = 235; for FLibe with U235
%%% fuel_type = 233; for FLiBe with U233
%%% fuel_type = 123; for FLiBe with U235 with depletion accounting
fuel_type = 123; 
% depletion_time = 0; %[days] int only. Work with fuel type 123.

%%% Source Step Reactivity Insertions & Sinusoidal Reactvity Insertions 
sourcedata = [0 0 0];                                                      %Neutron source insertions [abs]
sourcetime = [0 1000 2500];                                                %Neutron source insertion time [s]
source = timeseries(sourcedata,sourcetime);                                %Defining source timeseries  

reactdata = [0 0 0.001 0.001 0.001 0.001];                        %Reactivity insertions [abs]
reacttime = [0 2000 2000 5000 7500 15000];                                 %Reactivity insertion time [s]
react = timeseries(reactdata,reacttime);                                   %Defining source timeseries

omega          = 10.00000;                                                 %Frequncy of the sine wave [rad]
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
Block_UHE=200000;                                                            %Time at which ultimate heat exchanger will be cut off [s]

%%% Only for UHX_MODE = 2
demanddata = [1 1 1 1 1];                                                  %Reactivity insertions [abs]
demandtime = [0 1000 2000 3000 5000];                                      %Reactivity insertion time [s]
demand = timeseries(demanddata,demandtime);                                %Defining source timeseries                               %Defining source timeseries

%%% DHRS Parameters
%%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
%%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
%%% DHRS_MODE = 1 all  ows modifications to sigmoid behavior. Listed under Normal DHRS below
%%% DHRS_MODE = 2 allows modifications through matlab function block from sim
%%% DHRS_MODE = 2 allows cold slug insertions
DHRS_MODE = 1; 
DHRS_time=200000;                                                            %Time at which DRACS will be activated. use simtime to keep it off [s]

%%% Only for DHRS_MODE = 1
DHRS_Power= P*(0.10);                                                      %Maximum power that can be removed by DHRS
Power_Bleed= P*(0.00);                                                     %Some power will removed from DRACS even when its not used 

%%% Only for DHRS_MODE = 2
deltaTf_DHRS = 30;                                                         %Temperature drop by broken DHRS [deg. C]
slug_time = 8.46;                                                          %Duration of slug [s]


run('SMD_MSR_Para_V1')
sim('SMD_MSR_Sim_V1.slx');

% %% Plotting Results 
% %Create time offsets and find time = 0 index for other offsets
% timeoffset = 1000;
% timemax    = simtime - timeoffset;
% time = tout - timeoffset;
% offsetindex = find(time==0);
% 
% %%%Turn reactivity from absolute to pcm
% rho_fb_tot_pcm=rho_fb_tot*1E5;
% rho_fb_f_pcm=rho_fb_f*1E5;
% rho_fb_g_pcm=rho_fb_g*1E5;
% 
% %%%Setting values to offset
% rho_fb_tot_offset_pcm = rho_fb_tot_pcm(offsetindex);
% rho_fb_f_offset_pcm = rho_fb_f_pcm(offsetindex);
% rho_fb_g_offset_pcm = rho_fb_g_pcm(offsetindex);
% 
% figure(2)
% %%%Plot relative; total, fission, decay 
% subplot(3,1,1)
% hold on
% grid on
% plot(time,(Temp_mux(:,1) + Temp_mux(:,2)),'color','#FF00FF','LineWidth',1)
% plot(time,Temp_mux(:,1),'color','#0000FF','LineWidth',1)
% plot(time,Temp_mux(:,2),'color','#00FFFF','LineWidth',1)
% title('Normalized Power')
% ylabel('Relative Power')
% legend('Total','Fission','Decay')
% xlim([0 timemax]) 
% ylim([-inf inf])
% % set(gca, 'YScale', 'log')
% % set(gca,'YTick', 10^-5:0);
% 
% %%%Plot core temps; inlet, outlet, graphite
% subplot(3,1,2)
% hold on
% grid on
% plot(time,Temp_mux(:,3),'color','#FF3333','LineWidth',1)
% plot(time,Temp_mux(:,4),'color','#581845','LineWidth',1)
% plot(time,Temp_mux(:,6),'color','#FFC300','LineWidth',1)
% title('Core Temperatures')
% legend('Fuel Inlet','Graphite', 'Fuel Outlet')
% ylabel('Temprature / [deg C]')
% xlim([0 timemax]) 
% ylim([-inf inf])
% 
% 
% %%%Plot temprature feedback; totel, fuel, graphite
% subplot(3,1,3)
% hold on
% grid on
% plot(time,rho_fb_tot_pcm - rho_fb_tot_offset_pcm,'color','#f28500','LineWidth',1)
% plot(time,rho_fb_f_pcm - rho_fb_f_offset_pcm,'green','LineWidth',1)
% plot(time,rho_fb_g_pcm - rho_fb_g_offset_pcm,'color','#536878','LineWidth',1)
% title('Temperature Feedback')
% xlabel('Time [s]')
% ylabel('Reativity [pcm]')
% legend('Total', 'Fuel', 'Graphite')
% xlim([0 timemax]) 
% ylim([-inf inf])
% 
% x0=10;
% y0=10;
% width=1100;
% height=1050;
% set(gcf,'position',[x0,y0,width,height])
% 
% figure(3)
% 
% tRC = 6070; 
% 
% yyaxis left
% plot(time - tRC,Temp_mux(:,1),'color','#0000FF','LineWidth',1)
% ylabel('Fission Power')
% 
% yyaxis right
% plot(time - tRC,(rho_fb_tot_pcm - rho_fb_tot_offset_pcm)/rho_0,'color','#f28500','LineWidth',1)
% ylabel('Reativity $')
% 
% xlim([0 6300-tRC]) 
% ylim([-inf inf])
% 
% % figure(4)
% % 
% % tRC = 0; 
% % 
% % yyaxis left
% % plot(time - tRC,Temp_mux(:,1),'color','#0000FF','LineWidth',1)
% % ylabel('Fission Power')
% % 
% % yyaxis right
% % plot(time - tRC,rho_fb_tot_pcm - rho_fb_tot_offset_pcm,'color','#f28500','LineWidth',1)
% % ylabel('Reativity [pcm]')
% % 
% % xlim([0 timemax]) 
% % ylim([-inf inf])
% % 
% % title('Temperature Feedback')
% % xlabel('Time [s]')
% 
% 
% 
% % Save plot as fig and png
% saveas(gcf,'Transient_2.png')
% savefig('Transient_2.fig')
