# ml/app.R

library(shiny)
library(ggplot2)
library(DT)
library(leaflet)

# UI
ui <- fluidPage(
  titlePanel("IDS: Система обнаружения вторжений на основе сетевого трафика"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("score_threshold", "Порог anomaly_score:", 
                  min = 0, max = 1, value = 0.95, step = 0.01),
      
      selectInput("protocol_filter", "Фильтр по протоколу:",
                  choices = c("Все", "udp", "tcp", "arp")),
      
      textInput("search_value", "Значение для точного поиска"),
      
      selectInput("search_column", "Выберите колонку для поиска", choices = NULL),
      
      actionButton("refresh", "Применить фильтры"),
      downloadButton("download_data", "Экспорт в CSV"),
      
      br(), br(),
      actionButton("close_app", "Завершить работу")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Аномалии", 
                 DTOutput("anomalies_table"),
                 verbatimTextOutput("summary_stats")
        ),
        tabPanel("График", plotOutput("score_hist"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Загрузка данных один раз
  df_results <- read.csv("C:/intrusion_detection_system/data/processed/anomalies.csv")
  
  # Понятные названия колонок
  colnames(df_results)[colnames(df_results) == "X59.166.0.0"] <- "Source_IP"
  colnames(df_results)[colnames(df_results) == "X1390"] <- "Source_Port"
  colnames(df_results)[colnames(df_results) == "X149.171.126.6"] <- "Dest_IP"
  colnames(df_results)[colnames(df_results) == "X53"] <- "Dest_Port"
  colnames(df_results)[colnames(df_results) == "udp"] <- "Protocol"
  colnames(df_results)[colnames(df_results) == "CON"] <- "Connection_State"
  colnames(df_results)[colnames(df_results) == "X0.001055"] <- "Duration"
  colnames(df_results)[colnames(df_results) == "X132"] <- "Bytes_From_Client"
  colnames(df_results)[colnames(df_results) == "X164"] <- "Bytes_From_Server"
  colnames(df_results)[colnames(df_results) == "X31"] <- "Packets_From_Client"
  colnames(df_results)[colnames(df_results) == "X29"] <- "Packets_From_Server"
  colnames(df_results)[colnames(df_results) == "dns"] <- "Service"
  colnames(df_results)[colnames(df_results) == "X500473.9375"] <- "State_Client_to_Server"
  colnames(df_results)[colnames(df_results) == "X621800.9375"] <- "State_Server_to_Client"
  colnames(df_results)[colnames(df_results) == "X66"] <- "Total_Relations"
  colnames(df_results)[colnames(df_results) == "X82"] <- "Same_Service_Flag"
  colnames(df_results)[colnames(df_results) == "X0.017"] <- "Error_Service_Server"
  colnames(df_results)[colnames(df_results) == "X0.013"] <- "Same_Source_Flag"
  colnames(df_results)[colnames(df_results) == "X7"] <- "Count_Attacks_Same_Host"
  
  # Доступные колонки для поиска
  updateSelectInput(session, "search_column", choices = names(df_results))
  
  # Реактивное подмножество данных
  filtered_data <- eventReactive(input$refresh, {
    req(input$refresh)
    
    data <- df_results[df_results$is_anomaly == "Anomaly", ]
    
    if (input$protocol_filter != "Все") {
      data <- data[data$Protocol == input$protocol_filter, , drop = FALSE]
    }
    
    data <- data[data$anomaly_score >= input$score_threshold, ]
    
    # Точный поиск по колонке
    if (!is.null(input$search_value) && input$search_value != "") {
      col <- input$search_column
      data <- data[data[[col]] == input$search_value, ]
    }
    
    return(data)
  })
  
  # Вывод таблицы с аномалиями
  output$anomalies_table <- renderDT({
    datatable(filtered_data(), 
              options = list(pageLength = 10, searching = TRUE),  # Убираем глобальный поиск
              filter = 'top')  # Фильтрация сверху по колонкам
  })
  
  # Экспорт в CSV
  output$download_data <- downloadHandler(
    filename = function() { "anomalies_export.csv" },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
  
  # Гистограмма anomaly_score
  output$score_hist <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes(x = anomaly_score, fill = is_anomaly)) +
      geom_histogram(bins = 50, alpha = 0.7, show.legend = FALSE) +
      labs(title = "Распределение anomaly_score", x = "Anomaly Score", y = "Частота") +
      theme_minimal()
  })
  
  # Статистика под таблицей
  output$summary_stats <- renderPrint({
    data <- filtered_data()
    cat("Найдено аномалий:", nrow(data), "\n")
    cat("Средний anomaly_score:", mean(data$anomaly_score), "\n")
    cat("Максимальный anomaly_score:", max(data$anomaly_score), "\n")
  })
  

  
  # Кнопка завершения работы
  observeEvent(input$close_app, {
    stopApp()
  })
}

# Запуск приложения
shinyApp(ui = ui, server = server)