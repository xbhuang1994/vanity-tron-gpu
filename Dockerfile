# 基于 Ubuntu 20.04 镜像构建
FROM nvidia/opencl:latest

# 更新软件包索引并安装所需的依赖项
RUN apt-get update && \
    apt-get install -y opencl-headers ocl-icd-opencl-dev g++ cmake make

# 创建工作目录并将源代码复制到其中
WORKDIR /app
COPY . /app

# 构建程序
RUN make
# RUN cp /app/profanity.x64 /output/
# 设置程序入口点
CMD ["./profanity.x64"]
