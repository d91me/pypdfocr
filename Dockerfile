# --- Базовый образ ---
# Используем ЧИСТЫЙ Debian Bullseye как основу. Это дает нам современный Tesseract v5.
FROM debian:bullseye-slim

# Устанавливаем переменную окружения, чтобы apt-get не задавал интерактивных вопросов.
ENV DEBIAN_FRONTEND=noninteractive

# --- Установка системных зависимостей ---
# Устанавливаем ВСЁ, КРОМЕ python-pip. Добавляем curl для скачивания.
RUN apt-get update && apt   Из команды `apt-get install` убран `python-pip` и добавлен `curl`.
*   Добавлен новый `RUN` блок, который скачивает и устанавливает `pip` для Python 2.7 вручную.

### Ваши финальные действия:

1.  **Замените** ваш старый `Dockerfile` на этот, новый.
2.  **Сохраните, закоммитьте и запушьте** изменения в ваш репозиторий.
3.  Зайдите в **Coolify** и нажмите **`Redeploy`-get install -y \
    # Утилиты для pypdfocr
    tesseract-ocr \
    tesseract-ocr-rus \
    tesseract-ocr-osd \
    ghostscript \
    imagemagick \
    poppler-utils \
    # Среда Python 2.7
    python2.7 \
    python2.7-dev \
    # Утилиты для сборки и скачивания
    build-essential \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# --- РАЗРЕШЕНИЕ**.

**Теперь мы победим!** Этот метод обходит ограничения системы и делает именно то, что нам нужно. Вы почти у цели, это самый последний рывок ПОЛИТИКИ БЕЗОПАСНОСТИ IMAGEMAGICK ---
# Разрешаем ImageMagick работать с PDF.
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

# ---
