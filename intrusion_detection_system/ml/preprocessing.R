# ml/preprocessing.R

library(dplyr)
library(readr)

DATA_PATH <- "C:/intrusion_detection_system_v2.0/data/processed/ready_data.rds"

load_and_prepare <- function() {
  message("Загрузка данных...")
  df <- readRDS(DATA_PATH)
  
  message("Предварительная очистка...")
  # Удаление строк с NA
  df <- df %>% na.omit()
  
  # Удаление нечисловых колонок, если они мешают (например, IP-адреса)
  numeric_df <- df %>% select(where(is.numeric))
  
  message("Масштабирование данных...")
  # Масштабирование числовых признаков
  scaled_data <- as.data.frame(scale(numeric_df))
  
  message("Данные готовы для моделирования.")
  return(scaled_data)
}

# Для тестирования
if (interactive()) {
  data_scaled <- load_and_prepare()
  print(head(data_scaled))
  source("C:/intrusion_detection_system_v2.0/ml/model.R")
}