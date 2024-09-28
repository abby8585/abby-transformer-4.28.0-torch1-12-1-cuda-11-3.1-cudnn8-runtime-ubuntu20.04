# Base image with CUDA support
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    ffmpeg \
    libsndfile1-dev \
    tesseract-ocr \
    espeak-ng \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Install PyTorch and CUDA toolkit
ARG PYTORCH_VERSION="2.0.1+cu121"
RUN python3 -m pip install --no-cache-dir torch==${PYTORCH_VERSION} torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install transformers and other dependencies
RUN python3 -m pip install --no-cache-dir transformers==4.31.0 datasets

# Install SageMaker Training Toolkit
RUN python3 -m pip install --no-cache-dir sagemaker-training

# Install additional Python packages as needed
RUN python3 -m pip install --no-cache-dir numpy pandas boto3
