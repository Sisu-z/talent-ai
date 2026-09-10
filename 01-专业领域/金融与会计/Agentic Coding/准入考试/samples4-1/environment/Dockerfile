FROM ghcr.io/blueorbit/docker-factory/spreadsheet:latest

# 2. 设置工作目录（保持一致）
WORKDIR /app

ARG proxy=http://host.docker.internal:7890
ENV http_proxy=$proxy
ENV https_proxy=$proxy

# 3. 复制任务数据到 /app/sheet/
# 注意：宿主机路径是相对于 Dockerfile 所在目录
COPY sheet /app/sheet