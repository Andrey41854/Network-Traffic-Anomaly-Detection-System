library(shiny)

# Указываем путь к Shiny-приложению
app_path <- "C:/intrusion_detection_system_v2.0/ml/"

# Проверяем, существует ли файл
if (!file.exists(app_path)) {
  stop("Файл ", app_path, " не найден. Проверьте структуру проекта.")
}

# Запускаем приложение
runApp(app_path)