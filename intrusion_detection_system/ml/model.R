# ml/model.R

library(dplyr)
library(isofor)
library(ggplot2)
library(shiny)

# Пути
MODEL_SAVE_PATH <- "C:/intrusion_detection_system_v2.0/ml/models/anomaly_model.rds"
PREDICTIONS_SAVE_PATH <- "C:/intrusion_detection_system_v2.0/data/processed/anomalies.csv"

train_anomaly_model <- function(data_path = "C:/intrusion_detection_system_v2.0/data/processed/ready_data.rds") {
  message("Загрузка данных...")
  df <- readRDS(data_path)
  
  message("Предварительная обработка...")
  numeric_df <- df %>% select(where(is.numeric)) %>% na.omit()
  
  # Сохраняем порядок строк
  rownames(numeric_df) <- NULL
  
  scaled_data <- as.matrix(scale(numeric_df))
  
  message("Обучение модели Isolation Forest...")
  model <- iForest(X = scaled_data, nt = 100, phi = 256)
  
  message("Оценка аномалий...")
  scores <- predict(model, newdata = scaled_data)
  
  threshold <- quantile(scores, probs = 0.95)
  anomaly_labels <- ifelse(scores > threshold, 1, 0)
  
  message("Добавление меток аномалий в исходный датафрейм...")
  
  # Восстанавливаем соответствие по порядку строк
  df_clean <- df[match(1:nrow(scaled_data), 1:nrow(df)), ]
  
  df_clean$anomaly_score <- scores
  df_clean$is_anomaly <- factor(anomaly_labels, labels = c("Normal", "Anomaly"))
  
  message("Сохранение модели и результатов...")
  dir.create(dirname(MODEL_SAVE_PATH), showWarnings = FALSE, recursive = TRUE)
  saveRDS(model, MODEL_SAVE_PATH)
  
  write.csv(df_clean, PREDICTIONS_SAVE_PATH, row.names = FALSE)
  
  message("Модель сохранена в ", MODEL_SAVE_PATH)
  message("Результаты с аномалиями сохранены в ", PREDICTIONS_SAVE_PATH)
  
  return(list(model = model, results = df_clean))
}

# Для тестирования
if (interactive()) {
  output <- train_anomaly_model()
  print(head(output$results))
  runApp("C:/intrusion_detection_system_v2.0/ml/")
}