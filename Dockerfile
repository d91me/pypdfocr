# --- Базовый образ ---
# Используем Python 2.7 на основе Debian Bullseye (новее), чтобы получить
# современный Tesseract v4+, который знает команду "-psm".
FROM python:2.7-slim-bullseye

# --- Установка системных зависимостей ---
# Устанавливаем всё необходимое для работы.
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-rus \
    tesseract-ocr-osd \
    ghostscript \
    imagemagick \
    poppler-utils \
    build-essential \
    python-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# --- РАЗРЕШЕНИЕ ПОЛИТИКИ БЕЗОПАСНОСТИ IMAGEMAGICK (ФИНАЛЬНЫЙ ФИКС) ---
# По умолчанию ImageMagick блокирует работу с PDF. Нам нужно явно разрешить
# ему читать и записывать PDF. Путь к файлу в Debian Bullseye.
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

# --- Установка приложения ---
# Устанавливаем рабочую директорию внутри контейнера.
WORKDIR /app

# Копируем весь исходный код из нашего репозитория в рабочую директорию.
COPY . .

# Обновляем pip и устанавливаем зависимости.
RUN pip install --upgrade pip && \
    pip install PyYAML && \
    pip install .

# --- Определение рабочих папок (томов) ---
# Эти папки будут управляться через Coolify.
VOLUME /app/watch_folder
VOLUME /app/processed_files
VOLUME /app/original_files

# --- Команда запуска ---
# Запускаем pypdfocr в режиме мониторинга.
CMD ["pypdfocr", "-w", "/app/watch_folder", "-f", "-c", "/app/config/config.yaml"]
