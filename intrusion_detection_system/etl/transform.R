# etl/transform.R

library(dplyr)
library(readr)

# Путь к сырым данным
RAW_DATA_PATH <- "C:/intrusion_detection_system_v2.0/data/raw/UNSW-NB15_1.csv"
PROCESSED_DATA_PATH <- "C:/intrusion_detection_system_v2.0/data/processed/cleaned_data.csv"

# Функция для очистки имен колонок
clean_column_names <- function(df) {
  colnames(df) <- make.names(colnames(df), unique = TRUE)
  return(df)
}

# Очистка и преобразование данных
clean_data <- function(path = RAW_DATA_PATH) {
  message("Чтение данных...")
  df <- read_csv(path)
  
  message("Очистка названий колонок...")
  df <- clean_column_names(df)
  
  message("Приведение типов и очистка...")
  # Удаление проблемных колонок (например, с пустыми или некорректными именами)
  df <- df %>%
    select(-contains("X.")) %>%         # убрать лишние X.
    select(-contains("..."))            # убрать переименованные дубликаты
  
  # Пример: удаление бесполезных колонок (если есть arp, icmp и т.д.)
  # df <- df %>% filter(proto != "arp")  # если нужно исключить ARP-трафик
  
  message("Сохранение обработанных данных...")
  write_csv(df, PROCESSED_DATA_PATH)
  message("Обработанные данные сохранены в ", PROCESSED_DATA_PATH)
  
  return(df)
}
if (interactive()) {
  df_clean <- clean_data()
  source("C:/intrusion_detection_system_v2.0/etl/load.R")
}