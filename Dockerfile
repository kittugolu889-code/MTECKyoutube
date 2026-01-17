FROM python:3.9-slim-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gcc \
    libffi-dev \
    ffmpeg \
    aria2 \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -U yt-dlp

CMD sh -c "gunicorn app:app --bind 0.0.0.0:${PORT:-8000} --workers ${WEB_CONCURRENCY:-1} --threads 2 --timeout 120"
