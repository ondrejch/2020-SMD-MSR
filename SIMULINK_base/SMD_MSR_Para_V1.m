%%% Scalable Modular Dynamic MSR Model
%%% Authors - Visura Pathirana, Alex Wheeler
%%% Building on work done by Vikram Sinha and Alex Wheeler
%%% Project advisor - Dr. Ondrej Chvala

%% Simulation Parameter File
%This script calculate and initialize simulation parameters
%User inputs are listed in the User Input section
%Advised to leave user inputs commented to avoid conflicts
%Advised to create a script using included example transient files as a template

%% User Inputs

%%% Basic Simulation Parameters
% simtime = 5000;                                                            %Simulation time [s]
% ts_max = 1e-1;                                                             %Maximum timestep [s] 
% P=8;                                                                       %Operational thermal power [MW]
% 
% %%% Fuel Type
% %%% fuel_type = 235; for FLibe with U235
% %%% fuel_type = 233; for FLiBe with U233
% fuel_type = 235;                                                           
% 
% %%% Source Step Reactivity Insertions & Sinusoidal Reactvity Insertions 
% sourcedata = [0 0 0];                                                      %Neutron source insertions [abs]
% sourcetime = [0 1000 2500];                                                %Neutron source insertion time [s]
% source = timeseries(sourcedata,sourcetime);                                %Defining source timeseries  
% 
% reactdata = [0 0 0];                                                       %Reactivity insertions [abs]
% reacttime = [0 1000 1005];                                                 %Reactivity insertion time [s]
% react = timeseries(reactdata,reacttime);                                   %Defining source timeseries
% 
% omega          = 10.00000;                                                 %Frequncy of the sine wave [rad]
% sin_mag        = 0;                                                        %Amplitude of the sine wave [abs]
% dx             = round((2*pi/omega)/25, 2, 'significant');                 %Size of the time step [s]
% 
% %%% Pump Trips
% Trip_P_pump=20000000;                                                      %Time at which primary pump is tripped [s]
% Trip_S_pump=20000000;                                                      %Time at which secondary pump is tripped [s]
% 
% %%% UHX Parameters
% %%% UHX_MODE = 1; uses a radiator
% %%% UHX_MODE = 2; uses a constant power removal block
% %%% Demand following is allowed only in UHX_MODE = 2 (constant power removal block)
% UHX_MODE = 1;
% Block_UHE=20000000;                                                        %Time at which ultimate heat exchanger will be cut off [s]
% 
% %%% Only for UHX_MODE = 2
% demanddata = [1 1 1/8 1/8 1/8];                                            %Reactivity insertions [abs]
% demandtime = [0 1000 2000 3000 5000];                                      %Reactivity insertion time [s]
% demand = timeseries(demanddata,demandtime);                                %Defining source timeseries                              %Defining source timeseries
% 
% %%% DHRS Parameters
% %%% DHRS_MODE = 1; a sigmoid based DHRS (Normal DHRS)
% %%% DHRS_MODE = 2; a square pulse based DHRS (Broken DHRS)
% %%% DHRS_MODE = 1; allows modifications to sigmoid behavior. Listed under Normal DHRS below in para file
% %%% DHRS_MODE = 2; allows modifications through matlab function block from sim
% %%% DHRS_MODE = 2; allows cold slug insertions
% DHRS_MODE = 1; 
% DHRS_time=20000000;                                                        %Time at which DRACS will be activated. use simtime to keep it off [s]
%
% %%% Only for DHRS_MODE = 1
% DHRS_Power= P*(0.10);                                                      %Maximum power that can be removed by DHRS
% Power_Bleed= P*(0.00);                                                     %Some power will removed from DRACS even when its not used 
%
% %%% Only for DHRS_MODE = 2
% deltaTf_DHRS = 30;                                                         %Temperature drop by broken DHRS [deg. C]
% slug_time = 100000;                                                        %Duration of slug [s]

%% Scaling Factors 

P_MSRE = 8; %Operational power of MSRE [MW]

Psf_li = P/P_MSRE; %Cube scaling factor
Psf_sq = power(Psf_li,1/2); %Square scaling factor
Psf_cu = power(Psf_li,1/3); %Linear scaling factor

%% Circulation Parameters (Salt resident times) {tau_x*vdot_x=volume_x}
%Primary loop
tau_l  = 16.73;  % ORNL-TM-0728 %16.44; % (s)
tau_c  = 8.46;   % ORNL-TM-0728 %8.460; % (s)
tau_hx_c = 8.67; % (sec) delay from hx to core 
tau_c_hx = 3.77; % (sec) delay from core to fuel hx 
tau_DHRS = 1; % DHRS resident time [s]
tau_FP = 1; % FP resident time [s]
tau_c_DHRS = (tau_c_hx - tau_DHRS)/2; % DHRS is placed in the middle of core and hx
tau_DHRS_hx = (tau_c_hx - tau_DHRS)/2; % DHRS is placed in the middle of core and hx
tau_hx_FP = (tau_hx_c - tau_FP)/2; % FB is placed in the middle of hx and core
tau_FP_c = (tau_hx_c - tau_FP)/2; % FB is placed in the middle of hx and core

%Secondary loop
tau_hx_r = 4.71; % (sec) delay from phx to radiator
tau_r_hx = 8.24; % (sec) delay from radiator to phx

vdot_f   = Psf_li*7.5708E-02; % ORNL-TM-0728 % 7.571e-2; % vol. flow rate (m^3/s) ORNL-TM-1647 p.3, ORNL-TM-0728 p.12
vdot_s   = Psf_li*5.36265E-02; % ORNL-TM-0728 p. 164 % 5.236E-02; % coolant volume flow rate (m^3/s) ORNL-TM-1647 p.3
vdot_rs  = Psf_li*94.389; % ORNL-TM-0728 p. 296; 78.82; % air volume flow rate (m^3/s) ORNL-TM-1647 p.2

vdot_f_fc_pc = 0.05; % Free convection flowrate percentage in the primary loop and secondary loop
K_pump = 1/5; % Pump coast down constant for both pumps (modeled as exp decay) 

%% Material Properties

%Material Densities
rho_f    = 2.14647E+03; % (partially enriched U-235)ORNL-TM-0728 p.8 2.243E+03; % (Th-U) density of fuel salt (kg/m^3) ORNL-TM-0728 p.8
rho_g    = 1.860E3; % graphite density (kg/m^3) ORNL-3812 p.77, ORNL-TM-0728 p.87
rho_s    = 1.922e3; % coolant salt density (kg/m^3) ORNL-TM-0728 p.8
rho_tube = 8.7745E+03; % (kg/m^3) density of INOR-8 ORNL-TM-0728 p.20
rho_rs   = 1.1237; % air density (kg/m^3) REFPROP (310K and 0.1MPa)

%Material Specific Heat Capacities
scp_f    = 1.9665E-3;% specific heat capacity of fuel salt (MJ/kg-C) ORNL-TM-0728 p.8
scp_g    = 1.773E-3; %cp_g/m_g; % graphite specific heat capacity (MW-s/kg-C) ORNL-TM-1647 p.3
scp_s    = 2.39E-3;%cp_s/m_s; %2.219E-03; % specific heat capacity of coolant (MJ/(kg-C) ORNL-TM-0728 p.8
scp_t    = 5.778E-04; % specific heat capacity of tubes (MJ/(kg-C)) ORNL-TM-0728 p.20  
scp_rs   = 1.0085E-3; % (MJ/kg-C) specific heat capacity of air at (air_out+air_in)/2 REFPROP

%% Modified Point Kinetics Module 

n_frac0 = 1; % initial fractional nuetron density n/n0 [n/cm^3/s]

%%%U-235 data
if fuel_type == 235
    Lam  = 2.400E-04;  %Mean generation time {ORNL-TM-1070 p.15 for U235}
    lam  = [1.240E-02, 3.05E-02, 1.11E-01, 3.01E-01, 1.140E+00, 3.014E+00];
    beta = [0.000223,0.001457,0.001307,0.002628,0.000766,0.00023]; % U235
    a_f  = -8.71E-05; % U235 (drho/°C) fuel salt temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -5.904E-05; % ORNL-TM-0728 p. 101 %
    a_g  = -6.66E-05; % U235 (drho/°C) graphite temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -6.624E-05; % ORNL-TM-0728 p.101
end

%%%U-233 data
if fuel_type == 233
    Lam    = 4.0E-04;  % mean generation time ORNL-TM-1070 p.15 U233
    lam    = [1.260E-02, 3.370E-02, 1.390E-01, 3.250E-01, 1.130E+00, 2.500E+00]; %U233
    beta   = [0.00023,0.00079,0.00067,0.00073,0.00013,0.00009]; % U233
    a_f    = -11.034E-5; % U233 (drho/°C) fuel salt temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -5.904E-05; % ORNL-TM-0728 p. 101 %
    a_g    = -05.814E-5; % U233  (drho/°C) graphite temperature-reactivity feedback coefficient ORNL-TM-1647 p.3 % -6.624E-05; % ORNL-TM-0728 p.101
end


beta_t = sum(beta); %Total delayed neutron fraction {MSRE}

% reactivity change in going from stationary to circulating fuel
C0(1)  = ((beta(1))/Lam)*(1.0/(lam(1) - (exp(-lam(1)*tau_l) - 1.0)/tau_c));
C0(2)  = ((beta(2))/Lam)*(1.0/(lam(2) - (exp(-lam(2)*tau_l) - 1.0)/tau_c));
C0(3)  = ((beta(3))/Lam)*(1.0/(lam(3) - (exp(-lam(3)*tau_l) - 1.0)/tau_c));
C0(4)  = ((beta(4))/Lam)*(1.0/(lam(4) - (exp(-lam(4)*tau_l) - 1.0)/tau_c));
C0(5)  = ((beta(5))/Lam)*(1.0/(lam(5) - (exp(-lam(5)*tau_l) - 1.0)/tau_c));
C0(6)  = ((beta(6))/Lam)*(1.0/(lam(6) - (exp(-lam(6)*tau_l) - 1.0)/tau_c));

% Reactivity loss from circulating fuel 
bterm     = 0;
for i = 1:6
    bterm = bterm + beta(i)/(1.0 + ((1.0-exp(-lam(i)*tau_l))/(lam(i)*tau_c)));
end
rho_0     = beta_t - bterm; % reactivity lose due to delayed neutrons born outside of the core

%% Core Design Parameters

%scaling needs to be added
W_f      = vdot_f*rho_f;
m_f      = W_f*tau_c; % fuel mass in core (kg)
nn_f     = 2; % number of fuel nodes in core model
mn_f     = (m_f/nn_f); % fuel mass per node (kg)

% Core Upflow
v_g      = 1.95386; % graphite volume(m^3) ORNL-TM-0728 p. 101
m_g      = Psf_li*(v_g*rho_g); % graphite mass (kg)

mcp_g1   = m_g*scp_g; % (mass of material x heat capacity of material) of graphite per lump (MW-s/�C)
mcp_f1   = mn_f*scp_f; % (mass of material x heat capacity of material) of fuel salt per lump (MW-s/�C)
mcp_f2   = mn_f*scp_f; % (mass of material x heat capacity of material) of fuel salt per lump (MW-s/�C)

hA_fg    = Psf_li*(0.02*9/5)/nn_f; % (fuel to graphite heat transfer coeff x heat transfer area) (MW/�C) ORNL-TM-1647 p.3, TDAMSRE p.5

k_g      = 0.07; % fraction of total power generated in the graphite  ORNL-TM-0728 p.9
k_1      = 0.5; % fraction of heat transferred from graphite which goes to first fuel lump
k_2      = 0.5; % fraction of heat transferred from graphite which goes to second fuel lump
k_f      = 0.93;     % fraction of heat generated in fuel - that generated in external loop ORNL-TM-0728 p.9
k_f1     = k_f/nn_f; % fraction of total power generated in lump f1
k_f2     = k_f/nn_f; % fraction of total power generated in lump f2

Tf_in  = 6.32E+02; % in �C ORNL-TM-1647 p.2
T0_f2  = 6.57E+02; % 6.5444E+02; % in �C 6.461904761904777e+02; ORNL-TM-1647 p.2
% T0_f1  = 6.405952380952389E+02; %in �C
% T0_g1  = 6.589285714285924E+02; %in �C 

T0_f1  = Tf_in + (T0_f2-Tf_in)/2; % 6.405952380952389e+02; in �C
T0_g1  = T0_f1+(k_g*P/hA_fg); % 6.589285714285924e+02; in �C 

%% Heat Exchanger 
v_tube = 4572; % (in^3) hx shell volume occupied by tubes
v_cool = 3.164848128000000e+03;  % (in^3) hx volume occupied by coolant
v_he_fuel = 9.904458947741767e+03; % (in^3) volume available to fuel in shell

% Unit conversions
in_m = 1.63871e-5; % 1 cubic inch = 1.63871e-5 cubic meters

% PRIMARY FLOW PARAMETERS 
W_p  = W_f; % fuel flow rate (kg/s)
m_p  = Psf_li*v_he_fuel*in_m*rho_f; % fuel mass in PHE (kg) 
nn_p = 4; % number of fuel nodes in PHE
mn_p = m_p/nn_p; % fuel mass per node (kg)
cp_p = scp_f; % fuel heat capacity (MJ/(kg-C))

% SECONDARY FLOW PARAMETERS 
W_s = vdot_s*rho_s; %this is diffrent from the other number 

m_s      = Psf_li*v_cool*in_m*rho_s; % coolant mass in PHE (kg) 
nn_s     = 4; % number of coolant nodes in PHE
mn_s     = m_s/nn_s; % coolant mass per node (kg)

A_phe    = 2.359E+01; % effective area for heat transfer (primary and secondary, m^2) ORNL-TM-0728 p.164

ha_p     = 6.480E-01; % heat transfer* total area coefficient from primary to tubes (MW/C) ORNL-TM-1647 p.3
ha_s     = 3.060E-01; % heat transfer* total area coefficient from tubes to secondary (MW/C) ORNL-TM-1647 p.3

% Primary Side 
mcp_pn   = mn_p*cp_p; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/�C
hA_pn    = (Psf_li*ha_p)/nn_s; %3.030; % (primary to tube heat transfer coeff x heat transfer area) in MW/�C

% Tubes 
nn_t     = 2; % number of nodes of tubes in model
m_tn     = Psf_li*(v_tube - v_cool)*in_m*rho_tube/nn_t; % mass of tubes (kg)                                     
mcp_tn   = m_tn*scp_t; % from ratio of (A_phe/mcp_t)msbr = (A_phe/mcp_t)msre m_tn*cp_tn; % mass*(heat capacity) of tubes per lump in MW-s/�C      

% Secondary Side - DONE
mcp_sn   = mn_s*scp_s; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/�C
hA_sn    = (Psf_li*ha_s)/nn_s; % (tube to secondary heat transfer coeff x heat transfer area) in MW/�C

% Initial conditions 
% Primary nodes
Tp_in    = T0_f2; % 6.628E+02; % in �C ORNL-TM-1647 p.2
T0_p4    = Tf_in; % in �C ORNL-TM-1647 p.2
T0_p1    = Tp_in - (Tp_in-T0_p4)/4; % in �C
T0_p2    = Tp_in - 2*(Tp_in-T0_p4)/4; % in �C
T0_p3    = Tp_in - 3*(Tp_in-T0_p4)/4; % in �C

% Secondary nodes
Ts_in    = 5.4611E+02; % in �C ORNL-TM-1647 p.2
T0_s4    = 5.7939E+02; % in �C ORNL-TM-1647 p.2
T0_s1    = Ts_in + (T0_s4-Ts_in)/nn_s; % in �C
T0_s2    = Ts_in + 2*(T0_s4-Ts_in)/nn_s; % in �C
T0_s3    = Ts_in + 3*(T0_s4-Ts_in)/nn_s; % in �C

% Tube nodes
T0_t1    = (T0_p1*hA_pn+T0_s3*hA_sn)/(hA_pn+hA_sn); % in °C
T0_t2    = (T0_p3*hA_pn+T0_s1*hA_sn)/(hA_pn+hA_sn); % in °C

%% Pipe Nodes 
m_f_t= W_f*(tau_l+tau_c);  %total fuel mass

mn_pi_c_hx = (W_f*tau_c_hx); %mass of pipe from core to hx
mn_pi_hx_c = (W_f*tau_hx_c); %mass of pipe from hx to core

mn_piDHRS = (W_f*tau_DHRS); %DHRS node mass
mn_piFP = (W_f*tau_FP); %FP node mass


%% Radiator Parameters 
% Initial conditions 
% Primary nodes
Trp_in   = T0_s4; %5.933E+02; % in �C ORNL-TM-1647 p.2
T0_rp    = Ts_in; % in �C ORNL-TM-1647 p.2

% Secondary nodes -  DONE
Trs_in   = 37.78; % (C) air inlet temperature ORNL-TM-1647 p.2
T0_rs    = 148.9; % (C) air exit temperature ORNL-TM-1647 p.2

v_rp     = 0.204183209633634; % volume available to salt in radiator

v_rs = 3.159098197920001;% volume of air inside radiator

% PRIMARY FLOW PARAMETERS - DONE
W_rp  = W_s; % coolant salt flow rate (kg/s)
m_rp  = Psf_li*v_rp*rho_s; % coolant salt mass in rad (kg)                     
nn_rp = 1; % number of coolant salt nodes in radiator
mn_rp = m_rp/nn_rp; % coolant mass per node (kg)
cp_rp = scp_s; % coolant specific heat capacity (MJ/(kg-C)) ORNL-TM-0728 p.8

% SECONDARY FLOW PARAMETERS - DONE
W_rs       = vdot_rs*rho_rs; % air flow rate (kg/s) 

m_rs       = Psf_li*v_rs*rho_rs; % coolant air mass in rad (kg) 
nn_rs      = 1; % number of coolant nodes in rad
mn_rs      = m_rs/nn_rs; % coolant mass per node (kg)

A_rad    = 6.503E1; % (m^2) surface area of radiator ORNL-TM-0728 p.14
h_roverall = P_MSRE/A_rad/((T0_rp+Trp_in)/2-(T0_rs+Trs_in)/2); % cald as: P/A_rad/((T0_rp+Trp_in)/2-(T0_rs+Trs_in)/2)  3.168E-4; % (MW/m^2-C) polimi thesis

% Primary Side 
mcp_rpn   = mn_rp*cp_rp; % (mass of material x heat capacity of material) of fuel salt per lump in MW-s/�C
hA_rpn    = (Psf_li*h_roverall*A_rad)/nn_rs; %3.030; % (primary to secondary heat transfer coeff x heat transfer area) in MW/�C

% Secondary Side - DONE
mcp_rsn   = mn_rs*scp_rs; % (mass of material x heat capacity of material) of coolant salt per lump in MW-s/�C
hA_rsn = (Psf_li*h_roverall*A_rad)/nn_rs; % (tube to secondary heat transfer coeff x heat transfer area) in MW/�C

%% Decay heat data
% this splits the fission products into 
Fiss_factor = 2.464783802008740e-03; % (rel to power) heat per fission relative to power rating [calculated]

% fission yeilds for each of the three groups lumped with heating factor
gamma0  = 9.635981959409105e-01;
gamma1  = 3.560674858154914e-02;
gamma2  = 7.950554775404400e-04;

% decay constants for each of the gorups
lambda0 = 0.0945298;
lambda1 = 0.00441957;
lambda2 = 8.60979e-05;

%% DRACS Parameters

Epsilon=1E-3;
DHRS_TIME_K=10;

%% Broken DHRS
% this block remove a costant amount of power when activated
% doubles as a broken DHRS and a cold slug creator 

rm_power = W_f*scp_f*deltaTf_DHRS;

%% Xenon reactivity effects

gamma_I  = 5.1135e-2; % weighted yield for I-135
gamma_Xe = 1.1628e-2; % weighted yield for Xe-135

lam_I    = 2.875e-5;  % decay constant for I-135 (s^-1)
lam_Xe   = 2.0916e-5; % decay constant for Xe-135 (s^-1)

lam_bubl = 2.0e-2;    % effective bubbling out constant (s^-1)

sig_Xe   = 2.66449e-18; % (cm^2) microscopic cross-section for Xe (n,gamma) reaction 

molc_wt  = .715*(7.016+18.998)+.16*(9.012+2*18.998)+.12*(4*18.998+232.038)+.005*(4*18.998+235.044); % (g/mol)
molc_den = 0.001*rho_f /molc_wt;          % (mol/cm^3)
U_den    = .005*molc_den*6.022E23;       % (#U/cm^3)
U_sig    = 5.851e-22;                    % (cm^2)

Sig_f_msdr = U_den*U_sig;                % (cm^-1)

phi_0 = P/(3.04414e-17*1e6*Sig_f_msdr);  % neutrons cm^-2 s^-1

I_0 = gamma_I*Sig_f_msdr*phi_0/lam_I; 
Xe_0 = (gamma_Xe*Sig_f_msdr*phi_0 + lam_I*I_0)/(lam_Xe + sig_Xe*phi_0 + lam_bubl);

Xe_og = lam_bubl*Xe_0/(lam_Xe); % initial Xe conc. in off-gas system

Sig_a = 1.02345; % (cm^-1) macroscopic absorption cross-section for core

rhoXe_0 = (-sig_Xe/Sig_a)*(gamma_I+gamma_Xe)*Sig_f_msdr*phi_0/(lam_Xe + sig_Xe*phi_0 + lam_bubl);

%% Variant Subsystems
Normal_DHRS=Simulink.Variant('DHRS_MODE==1');

Broken_DHRS=Simulink.Variant('DHRS_MODE==2');

Radiator=Simulink.Variant('UHX_MODE==1');

UHX=Simulink.Variant('UHX_MODE==2');


