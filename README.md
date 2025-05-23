# Network-Traffic-Anomaly-Detection-System

## Описание 

Проект предназначен для обноружений аномалий в сетевом трафике. Наш проект использует библиотеку isolation forest для обноружения аномалий в сетевом трафике и приложение Shiny для визуализации результатов.

##Установка 

1) Первый запуск

    1. Установить зависимости:install.packages(c("readr", "dplyr", "ggplot2", "shiny", "DT", "leaflet", "isofor"))
    2. Запустить: source("first_run.R")

    Это пройдёт по всему конвейеру: загрузка → очистка → подготовка → обучение модели → запуск интерфейса.
   

2) Повторный запуск только интерфейса

   Запустите: source("run_app.R")

##Структура проекта

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
```
