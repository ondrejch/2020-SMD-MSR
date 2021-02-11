# -*- coding: utf-8 -*-
"""
Authors: Alex Wheeler, Vik Singh

This script will write create the directories and write a matlab file for each dicretory
This script will not sumit the files however. That will be dine in a separate bash script.

"""

# import packages
import numpy as np
import sys

freq_space = np.logspace(-2, 1, num=100) # this must be the same as in 'MSDR_freq_writer.py'
gain_dat = []
phase_dat = []
phase_orig = []
gain_orig = []

orig_stdout = sys.stdout
output_file  = open('Freq_analysis.m', 'w+')
sys.stdout = output_file

for i in freq_space:
	# first thing is to make directories
	work_file = "../f%f/bode_MSDR_out.txt" % i
	line_dat = np.genfromtxt(work_file, delimiter = ' ')
	gain_dat.append(line_dat[3])
	phase_dat.append(line_dat[4])
	phase_orig.append(line_dat[2])
	gain_orig.append(line_dat[1])

print('Freq =', freq_space, ';\n')
print('Phase_shift =', phase_dat, ';\n')
print('Gain =', gain_dat, ';\n')
print('Old_Phase =', phase_orig, ';\n')
print('Old_Gain =', gain_orig, ';\n')

sys.stdout = orig_stdout
output_file.close()
