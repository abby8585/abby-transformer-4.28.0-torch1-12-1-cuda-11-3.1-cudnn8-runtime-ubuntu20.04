# Base image with CUDA support
FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04

# Set environment variables
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a symlink for the python command
RUN ln -s /usr/bin/python3.8 /usr/bin/python

# Upgrade pip
RUN pip install --upgrade pip

# Install required Python packages
RUN pip install torch==1.12.1 \
    transformers==4.28.0 \
    datasets \
    boto3 \
    sagemaker \
    numpy \
    pandas

# Install SageMaker Training Toolkit
RUN pip install sagemaker-training

# Copy your training script and any additional code
COPY train.py /opt/ml/code/train.py

# Set the working directory
WORKDIR /opt/ml/code

# Set environment variables for SageMaker
ENV SAGEMAKER_PROGRAM train.py
ENV SAGEMAKER_SUBMIT_DIRECTORY /opt/ml/code

# Ensure that the container recognizes GPUs
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Define the entry point
ENTRYPOINT ["python", "/opt/ml/code/train.py"]
