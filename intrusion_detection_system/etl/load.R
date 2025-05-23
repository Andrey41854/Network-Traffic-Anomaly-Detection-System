# etl/load.R

library(readr)

# Абсолютные пути
PROCESSED_DATA_PATH <- "C:/intrusion_detection_system_v2.0/data/processed/cleaned_data.csv"
OUTPUT_RDS_PATH <- "C:/intrusion_detection_system_v2.0/data/processed/ready_data.rds"

# Функция для загрузки и сохранения данных
load_and_save <- function() {
  message("Загрузка очищенных данных...")
  df <- read_csv(PROCESSED_DATA_PATH)
  
  message("Сохранение данных в формате .rds...")
  saveRDS(df, file = OUTPUT_RDS_PATH)
  
  message("Данные готовы для использования ML-модулем.")
  return(df)
}
if (interactive()) {
  df_ready <- load_and_save()
  source("C:/intrusion_detection_system_v2.0/ml/preprocessing.R")
}