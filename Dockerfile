# --- Базовый образ ---
# Используем ЧИСТЫЙ Debian Bullseye как основу. Это дает нам современный Tesseract v5.
FROM debian:bullseye-slim

# Устанавливаем переменную окружения, чтобы apt-get не задавал интерактивных вопросов.
ENV DEBIAN_FRONTEND=noninteractive

# --- Установка системных зависимостей ---
# Устанавливаем ВСЁ, включая ca-certificates для curl.
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-rus \
    tesseract-ocr-osd \
    ghostscript \
    imagemagick \
    poppler-utils \
    python2.7 \
    python2.7-dev \
    build-essential \
    curl \
    ca-certificates \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# --- Устанавливаем PIP для Python 2 вручную ---
# Скачиваем официальный установщик и запускаем его с python2.7.
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python2.7 get-pip.py && \
    rm get-pip.py

# --- РАЗРЕШЕНИЕ ПОЛИТИКИ БЕЗОПАСНОСТИ IMAGEMAGICK ---
# Разрешаем ImageMagick работать с PDF.
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

# --- Установка приложения ---
WORKDIR /app
COPY . .

# Устанавливаем Python-зависимости, используя pip для Python 2.
RUN pip2 install --upgrade pip && \
    pip2 install PyYAML && \
    pip2 install .

# --- Определение рабочих папок (томов) ---
VOLUME /app/watch_folder
VOLUME /app/processed_files
VOLUME /app/original_files

# --- Команда запуска ---
# Запускаем pypdfocr, используя исполняемый файл Python 2.7.
CMD ["python2.7", "/usr/local/bin/pypdfocr", "-w", "/app/watch_folder", "-f", "-c", "/app/config/config.yaml"]
