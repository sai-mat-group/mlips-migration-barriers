#!/bin/csh
# ---------------------------
#SBATCH -N 2 
#SBATCH --ntasks-per-node=48
#SBATCH --time=00:59:59
#SBATCH --job-name=test
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
#SBATCH --partition=debug 
#---------------------------

#---------------------------
#Explanation for SBATCH keywords
#N: number of nodes
#ntasks per node: 48 (DO NOT CHANGE this number)
#time: wall-time
#job-name: name of job (arbitrary name)
#error: filename of error file
#output: filename of output file (outputs job details, not your VASP data)
#partition: queue (see below)
#---------------------------

#---------------------------
#Possible partitions to be assigned in #SBATCH --partition; these partitions are the queues
#Below text is taken from parampravega documentation on SERC website
# Partition, Priority, Max Wall-time, Min cores for job, Max cores for job, Max jobs per user, Max submit per user
# small		0	3-00:00:00	-		196			5		-
# medium	50	2-00:00:00	-		768			3		-
#large		100	1-00:00:00	-		1536			1		-
#debug: unclear
#highmemory: unclear


#NOTE: The current settings on the machine, as indicated below, are different from what is listed on SERC website
#Use these as guidance for now
# Partition,   Priority, Max Wall-time, Min cores for job, Max cores for job, Max jobs per user, max submit per user
#     debug       1000      01:00:00       cpu=96        	cpu=528          1               3 
#     small       3000    1-00:00:00       cpu=96       	cpu=1056         4               9 
#    medium       3700    1-00:00:00      cpu=1056      	cpu=8160         1               2 
#     large       4000    1-00:00:00      cpu=8160     		cpu=20400        1               2 
#  highmemory     5000    1-00:00:00       cpu=48      		cpu=7440         4               9 

#To check for updates in partition settings of the ParamPravega cluster, execute the following command on terminal
#	sacctmgr show qos format=name,priority,MaxWall,MinTRES,MaxTRES,MaxJobsPU,MaxSubmitPU
#You can use the above command to check why your jobs are/are not running on the machine!
#---------------------------

#---------------------------
#Useful commands
#sbatch submit_script.csh -- Submit job
#scancel <job_name> or scancel <job_id> - Delete a job
#squeue - List out current jobs that are running or queued
#sinfo - Lists status of resources (how many small, medium, large, etc. jobs running)
#---------------------------


#---------------------------
#DO NOT CHANGE the following lines
#Preferred version of oneapi-tbb is 2021.5.0 during compilation
#Preferred version of oneapi-mkl is 2022.0.1 during compilation
source /home-ext/apps/spack/share/spack/setup-env.csh
spack load intel-oneapi-compilers@2022.0.1
spack load intel-oneapi-tbb@2021.5.0
spack load intel-oneapi-mkl@2022.0.1
spack load intel-oneapi-mpi@2021.5.0
spack load fftw@3.3.10%intel@2021.5.0 /tphl5ba

setenv I_MPI_FABRICS shm:ofi
setenv OMP_NUM_THREADS 1
#---------------------------


#Change into job submission directory
cd $SLURM_SUBMIT_DIR

#Update to the right path of VASP executable
#Remember, NEB calculations need vtst executable
set VASP_EXEC="/scratch/metderej/param_pravega/6.3.1_cpu_vtst/vasp_std"

#Setup single-relax
mkdir job
cp INCAR KPOINTS POTCAR job
cp -r 0* job
#If there are more than 9 images in NEB calculation, un-comment the following line
cp -r 1* job
cd job
mpiexec.hydra -n $SLURM_NTASKS ${VASP_EXEC} >& output
cd ..

#Cleanup relax
mkdir relax
#Remove `--exclude "CHG* --exclude "vasprun.xml" ` if those files are needed
rsync -azu --exclude "CHG*" --exclude "vasprun.xml" job/* relax/
rm -rf job

#Finished
