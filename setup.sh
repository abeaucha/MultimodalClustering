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
