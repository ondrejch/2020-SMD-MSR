#!/bin/bash
#PBS -V
#PBS -q corei7
#PBS -l nodes=1:ppn=8

#### cd working directory (where you submitted your job)
cd ${PBS_O_WORKDIR}

#### load modulo
module load matlab/R2019a

#### Executable Line
matlab -nodisplay -nodesktop -nojvm -nosplash -r 'run bode_point_script.m; exit'
