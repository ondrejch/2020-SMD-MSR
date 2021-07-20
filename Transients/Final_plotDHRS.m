%%% Modular Scalable Dynamic MSR Model
%%% Authors - Visura Pathirana, Alex Wheeler
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Plot DHRS
%%% This script similate DHRS behaviour with diffrent DHRS constants
%%% Plotting section graphs reactor powers, core temps, feedbacks 

%% Simulation Parameters  

P=100;  %Operational thermal power set to 100 [MWt]  
run('Modular_scalable_Para_V2.m')

simtime = 60; %Simulation time [s]

DHRS_time=10; %Time at which DHRS open

DHRS_Power=P*(0.10); %Maximum power that can be removed by DHRS [%]
Power_Bleed= P*(0.005); %DHRS power bleed during DHRS remains closed [%]
Epsilon=1E-3;


DHRS_TIME_K_values= [5,10,15,20];
Color = ["#FF33F6", "#FF8633", "#33FF42", "#1115F7"]; 

for i = 1:numel(DHRS_TIME_K_values)
    DHRS_TIME_K = DHRS_TIME_K_values(i);
%     sim('MSD_MSR_Sim_V2.slx')
    hold on
    plot(DHRS,'color',Color(i),'LineWidth',1)
end   
grid on
ylabel('Decay Heat Removal System Power [%]')
xlabel('Time [s]')
legend('t_{DHRS} = 5s','t_{DHRS} = 10s', 't_{DHRS} = 15s','t_{DHRS} = 20s')
% xlim([0 simtime]) 
% ylim([0 inf])

x0=10;
y0=10;
width=1000;
height=750;
set(gcf,'position',[x0,y0,width,height])

% % Save plot as fig and png
% saveas(gcf,'DHRS_t.png')
% savefig('DHRS_t.fig')