%%% Scalable Modular Dynamic MSR Model
%%% Authors - Visura Pathirana, Alex Wheeler
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Benchmark Transient - 1 --> +10[pcm] for U235 MSRE @ 1MW, 5MW & 8MW
%%% Runs step insertions of +10[pcm] for U235 MSRE @ 1MW, 5MW & 8MW
%%% Results are ploted along with MSRE one region, nine region in three panels for each power
%%% Simulations done in four steps in a loop

%%% Step - 1; Simulation is run for 2000[s] at 8[Mw_t]
%%% Step - 2; Using UHX_MODE = 2, simulation is brought to 1[MW_t]
%%% Step - 3; Allow 3000[s] to come to steady state at 1[MW_t]
%%% Step - 4; +13.9[pcm] worth reactivity is inserted as a step at 5000[s]

%% Benchmark 1 - Inputs

op_power = [1,5,8];

i=3;

    %%% Basic Simulation Parameters
    simtime = 5500;                                                            %Simulation time [s]
    ts_max = 1e-1;                                                             %Maximum timestep [s] 
    P=8;                                                                       %Operational thermal power [MW]

    %%% Fuel Type
    %%% fuel_type = 235; for FLibe with U235
    %%% fuel_type = 233; for FLiBe with U233
    fuel_type = 235;                                                           

    %%% Source Step Reactivity Insertions & Sinusoidal Reactvity Insertions 
    sourcedata = [0 0 0];                                                      %Neutron source insertions [abs]
    sourcetime = [0 1000 2500];                                                %Neutron source insertion time [s]
    source = timeseries(sourcedata,sourcetime);                                %Defining source timeseries  

    reactdata = [0 10.0E-5 10.0E-5];                                           %Reactivity insertions [abs]
    reacttime = [0 5000 6000];                                                 %Reactivity insertion time [s]
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
    Block_UHE=20000000;                                                        %Time at which ultimate heat exchanger will be cut off [s]

    %%% Only for UHX_MODE = 2
    demanddata = [1 1 op_power(i)/8 op_power(i)/8 op_power(i)/8];              %Reactivity insertions [abs]
    demandtime = [0 1000 2000 3000 6000];                                      %Reactivity insertion time [s]
    demand = timeseries(demanddata,demandtime);                                %Defining source timeseries

    %%% DHRS Parameters
    %%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
    %%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
    %%% DHRS_MODE = 1 allows modifications to sigmoid behavior. Listed under Normal DHRS below
    %%% DHRS_MODE = 2 allows modifications through matlab function block from sim
    %%% DHRS_MODE = 2 allows cold slug insertions
    DHRS_MODE = 1; 
    DHRS_time=20000000;                                                        %Time at which DRACS will be activated. use simtime to keep it off [s]

    %%% Only for DHRS_MODE = 1
    DHRS_Power= P*(0.10);                                                      %Maximum power that can be removed by DHRS
    Power_Bleed= P*(0.00);                                                     %Some power will removed from DRACS even when its not used 
    
    %%% Only for DHRS_MODE = 2
    deltaTf_DHRS = 30;                                                         %Temperature drop by broken DHRS [deg. C]
    slug_time = 100000;                                                        %Duration of slug [s]

    run('SMD_MSR_Para_V1')
    sim('SMD_MSR_Sim_V1.slx');
    %% Plotting Results 
    %Create time offsets and find time = 0 index for other offsets
    timeoffset = 5000; 
    time = tout - timeoffset;
    offsetindex = find(time==0);

    powerR = (Temp_mux(:,1)+Temp_mux(:,2))*P;
    poweroffset = powerR(offsetindex );


    figure (1)
    hold on
    plot(time,(powerR - poweroffset),'color','#FF00FF','LineWidth',1)



    x0=10;
    y0=10;
    width=1100;
    height=1050;
    set(gcf,'position',[x0,y0,width,height])


% Save plot as fig and png
saveas(gcf,'+10[pcm]_U235_model_comparisons.png')
savefig('+10[pcm]_U235_model_comparisons.fig')


