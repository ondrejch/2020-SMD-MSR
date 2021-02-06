# -*- coding: utf-8 -*-
"""
Authors: Alex Wheeler, Vik Singh

This script will rerun the crashed runs.

"""

# import packages
import numpy as np
import os
from shutil import copyfile

freq_space = np.linspace(0, 3560, num=101) # these are the frequencies for which the analysis is done


for i in freq_space:
	# first thing is to make directories
	work_path = "../depl"'{:.0f}'.format(i)
	
	# check if model ran and rerun if not
	result_file = "%s/sim_results.txt" %work_path
	
	if os.path.isfile(result_file):
		print("%s is done" %work_path)
	else:
		print("%s is NOT done" %work_path)
		bashCommand = "cd %s && qsub run_matlab.sh" % work_path
		os.system(bashCommand)
		bashCommand = "cd ../scripts"
		os.system(bashCommand)

