# --- Базовый образ ---
# Используем официальный, легковесный образ Python 2.7 на основе Debian Buster.
# Это необходимо, так как pypdfocr несовместим с Python 3.
FROM python:2.7-slim-buster

# --- Установка системных зависимостей ---
# Устанавливаем всё необходимое для работы pypdfocr: Tesseract, Ghostscript, ImageMagick, Poppler.
# Добавляем tesseract-ocr-osd для корректного определения ориентации страниц (OSD).
# Добавляем build-essential и python-dev для сборки Python-пакетов с C-расширениями (например, Pillow).
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

# --- Установка приложения ---
# Устанавливаем рабочую директорию внутри контейнера.
WORKDIR /app

# Копируем весь исходный код из нашего репозитория в рабочую директорию.
COPY . .

# Обновляем pip и устанавливаем недостающую зависимость PyYAML,
# а затем саму библиотеку pypdfocr и её python-зависимости.
RUN pip install --upgrade pip && \
    pip install PyYAML && \
    pip install .

# --- Определение рабочих папок (томов) ---
# Объявляем папки, в которые Coolify будет подключать постоянное хранилище с сервера.
VOLUME /app/watch_folder
VOLUME /app/processed_files
VOLUME /app/original_files

# --- Команда запуска ---
# Указываем команду, которая будет выполняться при старте контейнера.
# Запускаем pypdfocr в режиме мониторинга (-w) с авто-сортировкой (-f),
# используя файл конфигурации (-c).
CMD ["pypdfocr", "-w", "/app/watch_folder", "-f", "-c", "/app/config/config.yaml"]
