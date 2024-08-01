#!/bin/bash
# full_test_remora.slurm
#-----------------------------------------------------------------
#SBATCH -J full_test_remora                     # Job name
#SBATCH -o full_test_remora.%j.out              # Stdout output file
#SBATCH -e full_test_remora.%j.err              # Stderr error file
#SBATCH -p gpu-a100                             # Queue name
#SBATCH -N 1                                    # Total # of nodes
#SBATCH -n 1                                    # Total # of mpi tasks
#SBATCH -t 48:00:00                             # Run time (hh:mm:ss)
#-----------------------------------------------------------------

# Load modules
module unload xalt
module load remora
module use /scratch/tacc/apps/bio/alphafold/modulefiles

module load alphafold/2.3.2-ctr
module list

# Log start time
echo -n "starting at: "
date

# Make output directory
mkdir -p $SCRATCH/AlphaFold_benchmarking/5005_full_Remora/output

# Run Alphafold and monitor with Remora
remora apptainer exec --env TF_FORCE_UNIFIED_MEMORY=1,XLA_PYTHON_CLIENT_MEM_FRACTION=4.0,OPENMM_CPU_THREADS=8 \
               --nv /scratch/tacc/apps/bio/alphafold/2.3.2/images/alphafold_2.3.2.sif \
               /app/run_alphafold.sh \
               --flagfile=$AF2_HOME/examples/flags/full_dbs.ff \
               --fasta_paths=$SCRATCH/AlphaFold_benchmarking/5005aa.fasta \
               --output_dir=$SCRATCH/AlphaFold_benchmarking/5005_full_Remora/output \
               --model_preset=monomer \
               --max_template_date=2020-05-14 \
               --use_gpu_relax=True

# Log end time
echo -n "ending at: "
date