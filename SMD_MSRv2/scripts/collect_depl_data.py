# -*- coding: utf-8 -*-
"""
Author: Visura Pathirana

This script will create directories and write and place matlab script

"""

# import packages
import numpy as np
import os
import sys
from shutil import copyfile

depletion_range = np.linspace(0, 3650, num=101)

DepletionTime = []
maxPowerVal = []
fullWidthHalfMax = []
avgTempMax = []
avgTempGrapMax = []
react_fb_tot_pcmMax = []
react_fb_f_pcmMax = []
react_fb_g_pcmMax = []

for i in depletion_range:
	
	work_path = "../depl"'{:.0f}'.format(i)
	result_file = "%s/sim_results.txt" %work_path
	line_dat = np.genfromtxt(result_file, delimiter = ',')
	DepletionTime.append(line_dat[0])
	maxPowerVal.append(line_dat[1])
	fullWidthHalfMax.append(line_dat[2])
	avgTempMax.append(line_dat[3])
	avgTempGrapMax.append(line_dat[4])
	react_fb_tot_pcmMax.append(line_dat[5])
	react_fb_f_pcmMax.append(line_dat[6])
	react_fb_g_pcmMax.append(line_dat[7])

	if i%365 == 0:
		power_results = "power_data"+'{:.0f}'.format(i)+".mat"
		temp_results = "temp_data"+'{:.0f}'.format(i)+".mat"
		react_results = "react_data"+'{:.0f}'.format(i)+".mat"

		powerCopy = "cp "+ work_path + "/" + power_results + " ../scripts/results" 
		os.system(powerCopy)
		
		tempCopy = "cp "+ work_path + "/" + temp_results + " ../scripts/results" 
		os.system(tempCopy)

		reactCopy = "cp "+ work_path + "/" + react_results + " ../scripts/results" 
		os.system(reactCopy)

orig_stdout = sys.stdout
output_file  = open('all_depl_results.m', 'w+')
sys.stdout = output_file

print('depletion_time =', DepletionTime,';\n')
print('maxPowerVal = ', maxPowerVal,';\n')
print('FWHM = ', fullWidthHalfMax,';\n')
print('avgTempMax = ', avgTempMax,';\n')
print('avgTempGrapMax = ', avgTempGrapMax,';\n')
print('react_fb_tot_pcmMax = ', react_fb_tot_pcmMax,';\n')
print('react_fb_f_pcmMax = ', react_fb_f_pcmMax,';\n')
print('react_fb_g_pcmMax = ', react_fb_g_pcmMax,';\n')

sys.stdout = orig_stdout
output_file.close()
