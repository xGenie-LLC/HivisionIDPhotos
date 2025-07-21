FROM python:3.10-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 安装 Python 依赖
COPY requirements.txt requirements-app.txt ./
RUN pip install --no-cache-dir -r requirements.txt -r requirements-app.txt

# 拷贝代码
COPY . .

# ✅ 下载模型
RUN python3 scripts/download_model.py --models all

EXPOSE 7860

# ✅ 不带无效参数
CMD ["python3", "-u", "app.py", "--host", "0.0.0.0", "--port", "7860"]
