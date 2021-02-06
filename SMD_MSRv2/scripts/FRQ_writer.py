# -*- coding: utf-8 -*-
"""
Authors: Alex Wheeler

This script will write create the directories and write a matlab file for each dicretory
This script will not sumit the files however. That will be dine in a separate bash script.

"""

# import packages
import numpy as np
import os
from shutil import copyfile

freq_space = np.logspace(-2, 1, num=100) # these are the frequencies for which the analysis is done

# matlab fies needed to run analysis111
parm_file = 'General_Pameter.m' # parameter file
sim_file = 'General_MSR.slx' # simulink model


for i in freq_space:
	# first thing is to make directories
	work_path = "../f%f" % i
	work_path_2 = "f%f" %i
	os.mkdir(work_path)
	
	## copying files is unnessisary when using addpath function in matlab
	# copy files to new directory
	# copyfile('testing.m', work_path)
	
	########################
	# write matlab script that will run the analysis
	bode_script = "%% MSDR fequency analysis script \n\
	format longe \n\
	\n\
	addpath('~/Final_freq_SMD_MSR/SMD_MSR_2_pipe_nodes_with_delays/scripts')\n\
	\n\
	run('Modular_scalable_Para_V2');\n\
	\n\
	omega = " + "{:.5f}".format(i) + ";\n\
	sin_mag        = 1e-5;\n\
	dx = round((2*pi/omega)/25, 2, 'significant');\n\
	simtime = 1000 + dx*25*7;\n\
	\n\
	sim('MSD_MSR_Sim_V2');\n\
	\n\
	period   = 2*pi/omega;\n\
	indices  = find(tout>=1000);\n\
	new_tout = tout(indices);\n\
	new_pow  = PKE_Neutronics(indices,3);\n\
	new_sin  = simout(indices);\n\
	\n\
	ssindex  = find(tout<999);\n\
	ss_pow   = PKE_Neutronics(ssindex,3);\n\
	ss       = ss_pow(end);\n\
	[pks, locs, w, p]     = findpeaks(new_pow);\n\
	[pks1, locs1, w1, p1] = findpeaks(new_sin);\n\
	\n\
	phase = ((new_tout(locs1(5))-new_tout(locs(5)))/period)*360;\n\
	gain  = (pks(end-1)-ss)/(.1e-4);\n\
	\n\
	yu = max(new_pow);\n\
	yl = min(new_pow);\n\
	yr = (yu-yl)/2;\n\
	ym = mean(new_pow);                        %% Estimate offset\n\
	\n\
	fit = @(b,new_tout)  b(1).*(sin(2*pi*new_tout/period + b(2))) + b(3);    %% Function to fit\n\
	fcn = @(b) sum((fit(b,new_tout) - new_pow).^2);                          %% Least-Squares cost function\n\
	s = fminsearch(fcn, [yr;  .2;  ym]);                       %% min least-squares\n\
	new_gain = abs(s(1)/(.1e-4));\n\
	\n\
	% regenerate the data and find phase from these peaks\n\
	x_fit_dat = linspace(1000, simtime, 1000);\n\
	source_fit_data = linspace(0, simtime-1000, 1000);\n\
	y_fit_dat = s(1).*(sin(2*pi*x_fit_dat/period + s(2))) + s(3);\n\
	input_dat = 1e-5.*(sin(2*pi*source_fit_data/period));\n\
	[pks2, locs2, w2, p2] = findpeaks(y_fit_dat);\n\
	[pks3, locs3, w3, p3] = findpeaks(input_dat);\n\
	new_phase = ((x_fit_dat(locs3(3))-x_fit_dat(locs2(3)))/period)*360;\n\
	\n\
	pow_file = 'power_out.txt';\n\
	time_file = 'time_out.txt';\n\
	dlmwrite(pow_file, PKE_Neutronics(:,2), 'precision', 10);\n\
	dlmwrite(time_file, tout, 'precision', 10);\n\
	filename = 'bode_MSDR_out.txt';\n\
	formatSpec = '%5.5f %5.5f %5.5f %5.5f %5.5f';\n\
	out_file = fopen(filename,'w');\n\
	fprintf(out_file, formatSpec, omega, gain, phase, new_gain, new_phase);\n\
	fclose(out_file);" 
	
	# write the analysis script
	bode_file_name = "%s/bode_point_script.m" %work_path
	bode_file = open(os.path.join(work_path, bode_file_name), mode='w+')
	bode_file.write(bode_script)
	bode_file.close()
	
	COPY_FILE = "%s/run_matlab.sh" % work_path
	copyfile("run_matlab.sh", COPY_FILE)
	
	bashCommand3 = "chmod +x %s" % COPY_FILE
	os.system(bashCommand3)
	
	bashCommand = "cd %s && qsub run_matlab.sh" % work_path
	os.system(bashCommand)
	bashCommand2 = "cd ~/Final_freq_SMD_MSR/SMD_MSR_2_pipe_nodes_with_delays/scripts"
	os.system(bashCommand2)

