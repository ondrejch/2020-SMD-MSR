%%Post processing 

% set time offsets 
% interpolate simulation results 
% extract interesting parameters 

timeoffset = 1950;
timeCutoff = 2300;
% timeCutoff = tout(end);

tout = tout - timeoffset;
time_capture = timeCutoff - timeoffset;

timeOffsetIndex = find(tout==0);
timeCutoffIndex = find(tout==time_capture);

time = tout(timeOffsetIndex:timeCutoffIndex);
time_range = (0 : 0.01 : time_capture).';

power_nom_fission = Temp_mux(timeOffsetIndex:timeCutoffIndex,1);
power_nom_decay = Temp_mux(timeOffsetIndex:timeCutoffIndex,2);
power_nom_total = power_nom_fission + power_nom_decay;

power_data(:,1) = time_range;
power_data(:,2) = interp1(time,power_nom_total,time_range,'linear');
power_data(:,3) = interp1(time,power_nom_fission,time_range,'linear');
power_data(:,4) = interp1(time,power_nom_decay,time_range,'linear');

[power_data_max,power_data_max_index] = max(power_data(:,2));
power_data_max_time = time_range(power_data_max_index);

power_data_halfMax = ((power_data_max-1) /2)+1;

[minValue1, power_data_halfMax1_index] = min(abs(power_data(1:power_data_max_index,2) - power_data_halfMax));
power_data_halfMax1 = power_data(power_data_halfMax1_index,2);
[minValue2, power_data_halfMax2_index] = min(abs(power_data(:,2) - power_data_halfMax));
power_data_halfMax2 = power_data(power_data_halfMax2_index,2);

power_data_halfMax1_time = power_data(power_data_halfMax1_index,1);
power_data_halfMax2_time = power_data(power_data_halfMax2_index,1);

fullWidth_halfMax_time = power_data_halfMax2_time - power_data_halfMax1_time;


% writematrix(power_data,'powerdata.txt');
% type powerdata.txt
% 
% power_results = [power_data_max,power_data_max_time,fullWidth_halfMax_time];
% writematrix(power_results,'powerresults.txt');
% type powerresults.txt

temp_core_in = Temp_mux(timeOffsetIndex:timeCutoffIndex,3);
temp_core_out = Temp_mux(timeOffsetIndex:timeCutoffIndex,6);
temp_grap = Temp_mux(timeOffsetIndex:timeCutoffIndex,4);
temp_core_avg = (temp_core_in + temp_core_out)/2;

temp_data(:,1) = time_range;
temp_data(:,2) = interp1(time,temp_core_avg,time_range,'linear');
temp_data(:,3) = interp1(time,temp_core_in,time_range,'linear');
temp_data(:,4) = interp1(time,temp_core_out,time_range,'linear');
temp_data(:,5) = interp1(time,temp_grap,time_range,'linear');

[avgTemp_data_max,avgTemp_data_max_index] = max(temp_data(:,2));
avgTemp_data_max_time = time_range(avgTemp_data_max_index);

[inTemp_data_max,inTemp_data_max_index] = max(temp_data(:,3));
inTemp_data_max_time = time_range(inTemp_data_max_index);

[outTemp_data_max,outTemp_data_max_index] = max(temp_data(:,4));
outTemp_data_max_time = time_range(outTemp_data_max_index);

[grapTemp_data_max,grapTemp_data_max_index] = max(temp_data(:,5));
grapTemp_data_max_time = time_range(grapTemp_data_max_index);

% writematrix(temp_data,'tempdata.txt');
% type tempdata.txt
% 
% temp_results = [avgTemp_data_max,avgTemp_data_max_time,inTemp_data_max,inTemp_data_max_time,outTemp_data_max,outTemp_data_max_time];
% writematrix(temp_results,'tempresults.txt');
% type tempresults.txt 

rho_fb_tot_pcm = rho_fb_tot*1E5;
rho_fb_f_pcm = rho_fb_f*1E5;
rho_fb_g_pcm = rho_fb_g*1E5;
% rho_tot_pcm = rho_tot*1E5;

rho_fb_tot_offset_pcm = rho_fb_tot_pcm(timeOffsetIndex);
rho_fb_f_offset_pcm = rho_fb_f_pcm(timeOffsetIndex);
rho_fb_g_offset_pcm = rho_fb_g_pcm(timeOffsetIndex);
% rho_tot_offset_pcm = rho_tot_pcm(timeOffsetIndex);

react_fb_tot_pcm = rho_fb_tot_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_tot_offset_pcm;
react_fb_f_pcm = rho_fb_f_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_f_offset_pcm;
react_fb_g_pcm = rho_fb_g_pcm(timeOffsetIndex:timeCutoffIndex) - rho_fb_g_offset_pcm;
% react_tot_pcm = rho_tot_pcm(timeOffsetIndex:timeCutoffIndex) - rho_tot_offset_pcm; 
%react_external_pcm = rho_external(timeoffset:timeCutoff);
reacttime = reacttime - timeoffset;
react_external_dol = reactdata/rho_0;


react_data(:,1) = time_range;
react_data(:,2) = interp1(time,react_fb_tot_pcm,time_range,'linear');
react_data(:,3) = interp1(time,react_fb_f_pcm,time_range,'linear');
react_data(:,4) = interp1(time,react_fb_g_pcm,time_range,'linear');
% react_data(:,5) = interp1(time,react_tot_pcm,time_range,'linear');
%react_data(:,6) = interp1(time,react_external_pcm,time_range,'linear');

[react_fb_tot_pcm_data_max,react_fb_tot_pcm_data_max_index] = min(react_data(:,2));
react_fb_tot_pcm_data_max_time = time_range(react_fb_tot_pcm_data_max_index);

[react_fb_f_pcm_data_max,react_fb_f_pcm_data_max_index] = min(react_data(:,3));
react_fb_f_pcm_data_max_time = time_range(react_fb_f_pcm_data_max_index);

[react_fb_g_pcm_data_max,react_fb_g_pcm_data_max_index] = min(react_data(:,4));
react_fb_g_pcm_data_max_time = time_range(react_fb_g_pcm_data_max_index);

% [react_tot_pcm_data_max,react_tot_pcm_data_max_index] = min(react_data(:,5));
% react_tot_pcm_data_max_time = time_range(react_tot_pcm_data_max_index);

% writematrix(react_data,'reactdata.txt');
% type reactdata.txt

% react_results = [react_fb_tot_pcm_data_max,react_fb_tot_pcm_data_max_time,react_fb_f_pcm_data_max,react_fb_f_pcm_data_max_time,react_fb_g_pcm_data_max,react_fb_g_pcm_data_max_time,react_tot_pcm_data_max,react_tot_pcm_data_max_time];
% writematrix(react_results,'reactresults.txt');
% type reactresults.txt 

sim_results = [depletion_time,power_data_max,fullWidth_halfMax_time,avgTemp_data_max,grapTemp_data_max,react_fb_tot_pcm_data_max,react_fb_f_pcm_data_max,react_fb_g_pcm_data_max ];
writematrix(sim_results,'sim_results.txt');
type sim_results.txt

%power_data_results = [time_range,power_data(:,2)];
%save('power_data_results.mat','power_data_results')

%ext_react_results = [reacttime,react_external_dol];
%save('ext_react_results.mat','ext_react_results')


% figure(2)
% %%%Plot relative; total, fission, decay 
% subplot(3,1,1)
% hold on
% grid on
% plot(time_range,power_data(:,2),'color','#FF00FF','LineWidth',1)
% plot(time_range,power_data(:,3),'color','#0000FF','LineWidth',1)
% plot(time_range,power_data(:,4),'color','#00FFFF','LineWidth',1)
% title('Normalized Power')
% ylabel('Relative Power')
% legend('Total','Fission','Decay')
% xlim([0 time_capture]) 
% ylim([-inf inf])
% % set(gca, 'YScale', 'log')
% % set(gca,'YTick', 10^-5:0);
% 
% %%%Plot core temps; inlet, outlet, graphite
% subplot(3,1,2)
% hold on
% grid on
% plot(time_range,temp_data(:,3),'color','#FF3333','LineWidth',1)
% plot(time_range,temp_data(:,4),'color','#581845','LineWidth',1)
% title('Core Tempratures')
% legend('Fuel Inlet', 'Fuel Outlet')
% ylabel('Temprature / [deg C]')
% xlim([0 time_capture]) 
% ylim([-inf inf])
% 
% 
% %%%Plot temprature feedback; totel, fuel, graphite
% subplot(3,1,3)
% hold on
% grid on
% plot(time_range,react_data(:,2),'color','#f28500','LineWidth',1)
% plot(time_range,react_data(:,3),'green','LineWidth',1)
% plot(time_range,react_data(:,4),'color','#536878','LineWidth',1)
% % plot(time,rho_tot_pcm - rho_tot_offset_pcm,'red','#536878','LineWidth',1)
% 
% title('Temperature-Reactivity Feedback')
% xlabel('Time [s]')
% ylabel('Reativity [pcm]')
% legend('Total', 'Fuel', 'Graphite')
% xlim([0 time_capture]) 
% ylim([-inf inf])
% 
% x0=10;
% y0=10;
% width=1100;
% height=1050;
% set(gcf,'position',[x0,y0,width,height])
% 
% % % Save plot as fig and png
% % saveas(gcf,'step_insertion_result.png')
% % savefig('step_insertion_result.fig')
% 
% % 
% % %plot nominal power and external reactivity 
% % figure(3)
% % hold on
% % grid on
% % yyaxis left
% % ylabel('Nominal Power')
% % plot(time_range,power_data(:,2),'color','#FF00FF','LineWidth',1)
% % yyaxis right
% % plot(reacttime,react_external_dol,'--','color','#0000FF','LineWidth',1)
% % ylabel('Reactivity [$]')
% % xlabel('Time [s]')
% % legend('Power','External reactivity')
% % xlim([0 time_capture]) 
% % ylim([-inf inf])
% % 
% % saveas(gcf,'step_insertion_plot.png')
% % savefig('step_insertion_plot.fig')



