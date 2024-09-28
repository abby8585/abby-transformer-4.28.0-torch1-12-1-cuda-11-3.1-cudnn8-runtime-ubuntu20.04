# Base image with CUDA support
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04

LABEL maintainer="Your Name"

# Set the DEBIAN_FRONTEND environment variable to suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Install PyTorch and CUDA toolkit
ARG PYTORCH_VERSION="2.1.0+cu121"
RUN python3 -m pip install --no-cache-dir torch==${PYTORCH_VERSION} torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install transformers and datasets
RUN python3 -m pip install --no-cache-dir transformers==4.31.0 datasets

# Install SageMaker Training Toolkit
RUN python3 -m pip install --no-cache-dir sagemaker-training

# Install additional Python packages as needed
RUN python3 -m pip install --no-cache-dir numpy pandas boto3

# Set the working directory
WORKDIR /opt/ml/code

# Set environment variables for SageMaker
ENV SAGEMAKER_SUBMIT_DIRECTORY /opt/ml/code

# Ensure that the container recognizes GPUs
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Set the entry point to use SageMaker training toolkit
ENTRYPOINT ["python3", "-m", "sagemaker_training.train"]
