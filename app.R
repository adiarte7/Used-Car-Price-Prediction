library(shiny)

# Load the model and data
car_data <- read.csv("car_price_dataset.csv")
model <- readRDS("car_price_model.rds")

# Extract dropdown choices
unique_models <- unique(car_data$Model)
unique_fuel_type <- unique(car_data$Fuel_Type)
unique_transmission <- unique(car_data$Transmission)

# Define UI
ui <- fluidPage(
  titlePanel("Car Price Predictor"),
  sidebarLayout(
    sidebarPanel(
      selectInput("model", "Car Model:", choices = unique_models),
      selectInput("fuel_type", "Fuel Type:", choices = unique_fuel_type),
      selectInput("transmission", "Transmission:", choices = unique_transmission),
      numericInput("engine_size", "Engine Size:", 1, min = 1, max = 5),
      numericInput("year", "Manufacturing Year:", 2023, min = 2000, max = 2023),
      numericInput("mileage", "Mileage (in km):", 10000, min = 0, step = 10000),
      actionButton("predict", "Predict Price")
    ),
    mainPanel(
      h3("Predicted Price:"),
      verbatimTextOutput("prediction")
    )
  )
)

# Define server
server <- function(input, output) {
  prediction <- eventReactive(input$predict, {
    new_data <- data.frame(
      Model = input$model,
      Year = input$year,
      Fuel_Type = input$fuel_type,
      Transmission = input$transmission,
      Engine_Size = input$engine_size,
      Mileage = input$mileage
    )
    predict(model, new_data)
  })
  
  output$prediction <- renderText({
    req(prediction())
    formatted <- formatC(round(prediction(), 2), format = "f", big.mark = ",", digits = 2)
    paste0("$", formatted)
  })
}

# Run app
shinyApp(ui = ui, server = server)