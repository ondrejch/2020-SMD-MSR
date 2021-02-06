 %%SMD MSR Depletion Runner Script
    
    addpath('~/SMD_MSR_depl_step/scripts')
    
    depletion_time = 2664; 
    
    run('Final_transient_2.m');  %transient parameter file 
    
    run('savedata.m'); 
    
    power_data2664 = power_data; %saves interpolated power data 
    save('power_data2664.mat','power_data2664') 
    
    ext_react_results2664 = [reacttime',react_external_dol']; 
    save('ext_react_results2664.mat','ext_react_results2664') 
    
    temp_data2664 = temp_data; %saves interpolated temp data 
    save('temp_data2664.mat','temp_data2664') 
    
    react_data2664 = react_data; %saves interpolated react data 
    save('react_data2664.mat','react_data2664') 
