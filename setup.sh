#!/bin/bash

# Path to conda installation
CONDA_PATH=$(conda info --base)

# Make conda tools visible
source "${CONDA_PATH}"/etc/profile.d/conda.sh

# Environment names 
ENV_NAME="multimodal-clust-env"

# Create conda environment and install R
echo -e "\nCreating environment..."
conda create -n $ENV_NAME -c conda-forge r-base=4.4.2 python=3.12.10 -y

# Install compiled R packages via conda (faster)
echo -e "\nInstalling R packages..."
#conda install -n $ENV_NAME -c conda-forge --file R_packages_conda.txt -y

echo -e "\nInstalling python packages..."
conda install -n $ENV_NAME -c conda-forge --file python_packages_conda.txt -y
