#!/bin/bash

# Path to conda installation
CONDA_PATH=$(conda info --base)

# Make conda tools visible
source "${CONDA_PATH}"/etc/profile.d/conda.sh

# Project environment
ENV_NAME="multimodal-clust-env"
ENV_PATH=${CONDA_PATH}/envs/${ENV_NAME}

# MINC environment paths
MINC_ENV_NAME="minc-env"
#MINC_ENV_NAME="clustering-autism-minc-env"
MINC_ENV_PATH=${CONDA_PATH}/envs/${MINC_ENV_NAME}

# Create MINC environment and install minc-toolkit-v2
#echo -e "\nBuilding MINC environment..."
#conda create -n $MINC_ENV_NAME -c minc-forge minc-toolkit-v2 -y

# Create conda environment and install R
echo -e "\nCreating environment..."
conda create -n $ENV_NAME -c conda-forge r-base=4.4.2 python=3.12.10 -y

# Install compiled R packages via conda (faster)
echo -e "\nInstalling R packages..."
#conda install -n $ENV_NAME -c conda-forge --file R_packages_conda.txt -y

echo -e "\nInstalling python packages..."
conda install -n $ENV_NAME -c conda-forge --file python_packages_conda.txt -y

# Set $MINC_TOOLKIT upon activation
cat <<EOF > "${ENV_PATH}"/etc/conda/activate.d/activate-minc-toolkit.sh
if [ -n "\${MINC_TOOLKIT}" ]; then
  export MINC_TOOLKIT_PREV="\${MINC_TOOLKIT}"
fi
export MINC_TOOLKIT=$MINC_ENV_PATH
EOF

# Unset $MINC_TOOLKIT upon deactivation
cat <<EOF > "${ENV_PATH}"/etc/conda/deactivate.d/deactivate-minc-toolkit.sh
# restore pre-existing MINC_TOOLKIT
if [ -n "\${MINC_TOOLKIT_PREV}" ]; then
  export MINC_TOOLKIT="\${MINC_TOOLKIT_PREV}"
  unset MINC_TOOLKIT_PREV
else
  unset MINC_TOOLKIT
fi
EOF

# Build hook to set environment paths upon activation
cat <<EOF > "${ENV_PATH}"/etc/conda/activate.d/set-env-vars.sh
if [ -n "\${PYTHONPATH}" ]; then
  export PYTHONPATH_PREV="\${PYTHONPATH}"
fi
export PROJECTPATH="$PWD"
export DATADIR="$PROJECTPATH"
export PATH_PREFIX="\${MINC_TOOLKIT}/bin"
export PATH="\${PATH_PREFIX}:\$PATH"
EOF

# Build hook to unset environment paths upon deactivation
cat <<EOF > "${ENV_PATH}"/etc/conda/deactivate.d/unset-env-vars.sh
if [ -n "\${PYTHONPATH_PREV}" ]; then
  export PYTHONPATH="\${PYTHONPATH_PREV}"
  unset PYTHONPATH_PREV
else
  unset PYTHONPATH
fi
export PATH=\${PATH#"\${PATH_PREFIX}:"}
unset PROJECTPATH
unset DATADIR
unset PATH_PREFIX
EOF