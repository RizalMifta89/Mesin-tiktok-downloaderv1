FROM python:3.10-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    TZ=Asia/Jakarta

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    python3-dev \
    libssl-dev \
    ffmpeg \
    git \
    chromium \
    chromium-driver \
    ca-certificates \
    curl \
    tini \
    tzdata \
    procps \
    iputils-ping \
    dnsutils \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER_PATH=/usr/bin/chromedriver

COPY requirements.txt /tmp/requirements.txt

RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm -f /tmp/requirements.txt

# Verifikasi alat penting saat image dibangun.
RUN python -c "import pyrogram, psutil, yt_dlp" && \
    ffmpeg -version >/dev/null 2>&1 && \
    ffprobe -version >/dev/null 2>&1 && \
    chromium --version >/dev/null 2>&1 && \
    gallery-dl --version >/dev/null 2>&1

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["python", "main.py"]