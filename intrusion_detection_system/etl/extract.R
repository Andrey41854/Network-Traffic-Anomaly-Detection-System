# Загрузка библиотек
library(readr)
library(dplyr)

# Путь к данным
RAW_DATA_PATH <- "C:/intrusion_detection_system_v2.0/data/raw/UNSW-NB15_1.csv"

# Чтение данных
load_data <- function(path = RAW_DATA_PATH) {
  message("Чтение данных из ", path)
  data <- read_csv(path)
  return(data)
}

if (interactive()) {
  df <- load_data()
  source("C:/intrusion_detection_system_v2.0/etl/transform.R")
}
