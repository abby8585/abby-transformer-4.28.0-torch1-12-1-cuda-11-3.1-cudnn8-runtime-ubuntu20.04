# Base PyTorch image with CUDA and cuDNN support
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

LABEL maintainer="Abiola"

# Set the DEBIAN_FRONTEND environment variable to suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies, including git, gcc, and python3-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    gcc \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Install Python packages required for model training
RUN python3 -m pip install --no-cache-dir \
    transformers==4.31.0 \
    datasets \
    sagemaker-training \
    numpy \
    pandas \
    boto3

# Set the working directory as per SageMaker standards
WORKDIR /opt/ml/code

# Set environment variables for SageMaker to recognize the submission directory
ENV SAGEMAKER_SUBMIT_DIRECTORY=/opt/ml/code

# Set environment variables for GPU availability and driver capabilities
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Install the SageMaker PyTorch container training toolkit
RUN python3 -m pip install --no-cache-dir sagemaker-pytorch-training

# Ensure that the correct entry point for SageMaker PyTorch container is set
ENTRYPOINT ["python3", "-m", "sagemaker_pytorch_container.training"]
