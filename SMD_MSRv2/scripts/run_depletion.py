# -*- coding: utf-8 -*-
"""
Author: Visura Pathirana

This script will create directories and write and place matlab script

"""

# import packages
import numpy as np
import os
from shutil import copyfile

depletion_range = np.linspace(0, 3650, num=101)

for i in depletion_range:

    work_path = "../depl"'{:.0f}'.format(i) 
    os.mkdir(work_path)

    depl_script = " %%SMD MSR Depletion Runner Script\n\
    \n\
    addpath('~/SMD_MSRv2/scripts')\n\
    \n\
    depletion_time = "+'{:.0f}'.format(i)+"; \n\
    \n\
    run('step_insertion_depl.m');  %transient parameter file \n\
    \n\
    run('savedata.m'); \n\
    \n\
    power_data"+'{:.0f}'.format(i)+" = power_data; %saves interpolated power data \n\
    save('power_data"+'{:.0f}'.format(i)+".mat','power_data"+'{:.0f}'.format(i)+"') \n\
    \n\
    ext_react_results"+'{:.0f}'.format(i)+" = [reacttime',react_external_dol']; \n\
    save('ext_react_results"+'{:.0f}'.format(i)+".mat','ext_react_results"+'{:.0f}'.format(i)+"') \n\
    \n\
    temp_data"+'{:.0f}'.format(i)+" = temp_data; %saves interpolated temp data \n\
    save('temp_data"+'{:.0f}'.format(i)+".mat','temp_data"+'{:.0f}'.format(i)+"') \n\
    \n\
    react_data"+'{:.0f}'.format(i)+" = react_data; %saves interpolated react data \n\
    save('react_data"+'{:.0f}'.format(i)+".mat','react_data"+'{:.0f}'.format(i)+"') \n"

    #Write depl script
    depl_file_name = "%s/depl_point_script.m" %work_path
    depl_file = open(os.path.join(work_path, depl_file_name), mode='w+')
    depl_file.write(depl_script)
    depl_file.close()
    
    COPY_FILE = "%s/run_matlab.sh" %work_path
    copyfile("run_matlab.sh", COPY_FILE)

    bashCommand1 = "chmod +x %s" % COPY_FILE
    os.system(bashCommand1)

    bashCommand2 = "cd %s && qsub run_matlab.sh" % work_path
    os.system(bashCommand2)

    bashCommand3 = "cd ~/SMD_MSRv2/scripts"
    os.system(bashCommand3)
