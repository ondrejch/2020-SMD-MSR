%This script read depletion data from a .txt file and create an evenly
%spaced matrix with time for depletion data

%read stored depletion data
depl_data_raw = importdata('kin_dyn_edit.txt');
% depl_data_raw = importdata('dep_test.txt');

%turn depletion raw data to a matlab array
depl_matx=depl_data_raw.data;

%set time range of depletion in depletion data
range_depl = depl_matx(1,1) : 1 : depl_matx(end,1); %time range from zero to last element [days]

depl_beta(:,1) = interp1(depl_matx(:,1),depl_matx(:,2),range_depl,'spline'); %beta 1
depl_beta(:,2) = interp1(depl_matx(:,1),depl_matx(:,3),range_depl,'spline'); %beta 2
depl_beta(:,3) = interp1(depl_matx(:,1),depl_matx(:,4),range_depl,'spline'); %beta 3
depl_beta(:,4) = interp1(depl_matx(:,1),depl_matx(:,5),range_depl,'spline'); %beta 4
depl_beta(:,5) = interp1(depl_matx(:,1),depl_matx(:,6),range_depl,'spline'); %beta 5
depl_beta(:,6) = interp1(depl_matx(:,1),depl_matx(:,7),range_depl,'spline'); %beta 6
depl_sum_beta = depl_beta(:,1)+depl_beta(:,2)+depl_beta(:,3)+depl_beta(:,4)+depl_beta(:,5)+depl_beta(:,6);
depl_Lam = interp1(depl_matx(:,1),depl_matx(:,8),range_depl,'spline').'; %LAMBDA
depl_fuel_temp_coef = interp1(depl_matx(:,1),depl_matx(:,9),range_depl,'spline').'; %fuel temp coef
depl_grap_temp_coef = interp1(depl_matx(:,1),depl_matx(:,10),range_depl,'spline').'; %grap temp coef
