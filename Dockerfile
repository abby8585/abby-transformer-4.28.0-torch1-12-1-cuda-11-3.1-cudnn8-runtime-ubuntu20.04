# Use an optimized base image
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

LABEL maintainer="Your Name"

# Install necessary system dependencies including python3-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN python3 -m pip install --no-cache-dir \
    transformers==4.31.0 \
    datasets \
    sagemaker-training \
    numpy \
    pandas \
    boto3

# Set the working directory
WORKDIR /opt/ml/code

# Set environment variables for SageMaker
ENV SAGEMAKER_SUBMIT_DIRECTORY=/opt/ml/code

# Ensure that the container recognizes GPUs
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Set the entry point to use SageMaker training toolkit
ENTRYPOINT ["python3", "-m", "sagemaker_training.train"]
