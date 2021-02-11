% %% Plot MSDR Depletion Results
% run('all_depl_results.m')
% 
% load('power_data0.mat');
% load('power_data1825.mat');
% load('power_data3650.mat');
% 
% load('temp_data0.mat');
% load('temp_data1825.mat');
% load('temp_data3650.mat');
% 
% load('react_data0.mat');
% load('react_data1825.mat');
% load('react_data3650.mat');
% 
% load('ext_react_results0.mat');  
% load('ext_react_results1825.mat');  
% load('ext_react_results3650.mat');


timecut = 250;

figure(1)
subplot(3,1,1)
box on
grid on 
hold on
plot(power_data0(:,1),power_data0(:,2),'red')
plot(power_data1825(:,1),power_data1825(:,2),'blue')
plot(power_data3650(:,1),power_data3650(:,2),'green')
ylabel('Nominal Power')
yyaxis right
plot(ext_react_results0(:,1),ext_react_results0(:,2),'--red')
plot(ext_react_results1825(:,1),ext_react_results1825(:,2),'--blue')
plot(ext_react_results3650(:,1),ext_react_results3650(:,2),'--green')
ylabel('Reactvity Inserted [$]')
legend('BOC','Mid Cycle (5 years)', 'EOC (10 years)','BOC reactvity','Mid Cycle (5 years) reactvity', 'EOC (10 years) reactvity')
title('Nominal Power & External Reactivity')
xlim([25 timecut]) 
ylim([-inf inf])

subplot(3,1,2)
box on
grid on 
hold on
plot(temp_data0(:,1),temp_data0(:,2),'red','LineStyle','-')
plot(temp_data1825(:,1),temp_data1825(:,2),'blue','LineStyle','-')
plot(temp_data3650(:,1),temp_data3650(:,2),'green','LineStyle','-')
ylabel('Temprature [C]')
title('Core Avg. Fuel Temperatures')
xlim([25 timecut]) 
ylim([-inf inf])

subplot(3,1,3)
box on
grid on 
hold on
plot(react_data0(:,1),react_data0(:,2),'red','LineStyle','-')
plot(react_data1825(:,1),react_data1825(:,2),'blue','LineStyle','-')
plot(react_data3650(:,1),react_data3650(:,2),'green','LineStyle','-')
ylabel('Reactivity [pcm]')
xlabel('Time [s]')
title('Total Temperatures Feedback')
xlim([25 timecut])
ylim([-inf inf])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])

figure(2)
subplot(3,1,1)
box on
grid on
hold on
yyaxis left
plot(depletion_time,maxPowerVal)
ylabel('Nominal Power')
yyaxis right
plot(depletion_time,FWHM)
ylabel('FWHM [s]')
title('Maximum Nominal Power & FWHM')
xlim([0 3650])
ylim([-inf inf])

subplot(3,1,2)
box on
grid on
hold on
yyaxis left
plot(depletion_time,avgTempMax)
ylabel('Avg. Fuel Temperatures [C]')
yyaxis right
plot(depletion_time,avgTempGrapMax)
ylabel('Graphite Temperatures [C]')
title('Maximum Core Temperatures')
xlim([0 3650])
ylim([-inf inf])

subplot(3,1,3)
box on
grid on 
hold on 
yyaxis left
plot(depletion_time,react_fb_f_pcmMax)
ylabel('Fuel Feedback [pcm]')
% plot(depletion_time,react_fb_tot_pcmMax)
yyaxis right
plot(depletion_time,react_fb_g_pcmMax)
ylabel('Graphite Feedback [pcm]')
xlabel('Depletion [days]')
title('Minimum Temperatures Feedbacks')
xlim([0 3650])
ylim([-inf inf])

x0=10;
y0=10;
width=1100;
height=1050;
set(gcf,'position',[x0,y0,width,height])