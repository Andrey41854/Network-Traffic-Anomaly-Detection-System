# Network-Traffic-Anomaly-Detection-System

## Описание 

Проект предназначен для обнаружения аномалий в сетевом трафике.  
Наш проект использует алгоритм Isolation Forest из библиотеки `isofor` для выявления аномалий и приложение `Shiny` для визуализации результатов.

## Установка 

1) Первый запуск

    1. Установите зависимости:
       install.packages(c("readr", "dplyr", "ggplot2", "shiny", "DT", "leaflet", "isofor"))

    2. Запустите:
       source("first_run.R")

    Этот скрипт выполняет полный цикл:
    загрузка → очистка → подготовка → обучение модели → запуск интерфейса.
   

2) Повторный запуск интерфейса

   Запустите:
   source("run_app.R")


## Структура проекта

```text
intrusion_detection_system_v2.0/
├── data/
│   ├── raw/                   # Исходные (сырые) данные
│   └── processed/             # Обработанные и предсказанные данные
├── etl/
│   ├── extract.R              # Загрузка исходных данных
│   ├── transform.R            # Очистка и нормализация
│   └── load.R                 # Финальная подготовка данных
├── ml/
│   ├── preprocessing.R        # Масштабирование признаков
│   ├── model.R                # Обучение модели и прогноз
│   └── app.R                  # Shiny-приложение
├── docs/                      # Документация
│   ├── README.md
│   ├── setup_guide.md
│   ├── architecture.md
│   ├── data_description.md
│   └── results.md
├── run_app.R                  # Запуск Shiny-приложения
├── first_run.R                # Полный запуск всего пайплайна
├── launch_app.bat             # Автозапуск на Windows
