# Use the specified base image from AWS ECR
FROM 763104351884.dkr.ecr.us-east-2.amazonaws.com/huggingface-pytorch-training:1.13.1-transformers4.26.0-gpu-py38-cu113-ubuntu20.04

LABEL maintainer="Abiola"

# Set the DEBIAN_FRONTEND environment variable to suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Upgrade pip to the latest version
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Install Python packages required for model training
# Upgrade transformers and torch to be compatible with llama3.1
RUN python3 -m pip install --no-cache-dir \
    transformers==4.31.0 \
    torch==2.1.0 \
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

# Ensure that the correct entry point for SageMaker PyTorch container is set
ENTRYPOINT ["python3", "-m", "sagemaker_pytorch_container.training"]
