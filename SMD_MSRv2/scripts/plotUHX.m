%% Plot MSDR Depletion Results
run('all_depl_results.m')

load('power_data0.mat');
load('power_data1825.mat');
load('power_data3650.mat');

load('temp_data0.mat');
load('temp_data1825.mat');
load('temp_data3650.mat');

load('react_data0.mat');
load('react_data1825.mat');
load('react_data3650.mat');

load('ext_react_results0.mat');  
load('ext_react_results1825.mat');  
load('ext_react_results3560.mat');


timecut = 250;

figure(1)
subplot(3,1,1)
grid on 
hold on
plot(power_data0(:,1),power_data0(:,2),'red')
plot(power_data1825(:,1),power_data1825(:,2),'blue')
plot(power_data3650(:,1),power_data3650(:,2),'green')
ylabel('Relative Power')
yyaxis right
plot(rho0(:,1),rho0(:,2),'--','red')
plot(rho1762(:,1),rho1762(:,2),'--','blue')
plot(rho3560(:,1),rho3560(:,2),'--','green')
ylabel('Reactvity inserted [$]')
legend('BOC','Mid Cycle (5 years)', 'EOC (10 years)')
xlim([0 timecut]) 
ylim([-inf inf])

subplot(3,1,2)
grid on 
hold on
plot(temp_data0(:,1),temp_data0(:,2),'red','LineStyle','-')
plot(temp_data1825(:,1),temp_data1825(:,2),'blue','LineStyle','-')
plot(temp_data3650(:,1),temp_data3650(:,2),'green','LineStyle','-')
ylabel('Core Avg Temp [C]')
xlim([0 timecut]) 
ylim([-inf inf])

subplot(3,1,3)
grid on 
hold on
plot(react_data0(:,1),react_data0(:,2),'red','LineStyle','-')
plot(react_data1825(:,1),react_data1825(:,2),'blue','LineStyle','-')
plot(react_data3650(:,1),react_data3650(:,2),'green','LineStyle','-')
ylabel('Total Temp Feedback [pcm]')
xlabel('Time [s]')
xlim([0 timecut])
ylim([-inf inf])


figure(2)
subplot(3,1,1)
grid on
hold on
yyaxis left
plot(depletion_time,maxPowerVal)
ylabel('Maximum nominal power')
yyaxis right
plot(depletion_time,FWHM)
ylabel('FWHM [s]')

subplot(3,1,2)
grid on
hold on
plot(depletion_time,avgTempMax)
plot(depletion_time,avgTempGrapMax)
ylabel('Maximum temprature [C]')

subplot(3,1,3)
grid on 
hold on 
plot(depletion_time,react_fb_tot_pcmMax)
plot(depletion_time,react_fb_f_pcmMax)
plot(depletion_time,react_fb_g_pcmMax)
ylabel('Maximum reactivity [pcm]')
xlabel('Depletion [days]')