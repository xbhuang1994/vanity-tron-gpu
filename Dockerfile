FROM ubuntu:20.04

# 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        clang \
        libclc-dev \
        ocl-icd-opencl-dev \
        ocl-icd-libopencl1 \
        opencl-headers \
        make

# 设置工作目录
WORKDIR /src
