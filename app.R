library(shiny)
library(bslib)
library(ggplot2)
library(scales)
library(DT)

# ── Load data and model ──────────────────────────────────────────────────────
car_data <- read.csv("car_price_dataset.csv")
model <- readRDS("car_price_model.rds")

# ── Pre-compute dropdown choices ─────────────────────────────────────────────
brands <- sort(unique(car_data$Brand))
fuel_types <- sort(unique(car_data$Fuel_Type))
transmissions <- sort(unique(car_data$Transmission))

# ── Theme ────────────────────────────────────────────────────────────────────
app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#2c3e50",
  "navbar-bg" = "#2c3e50"
)

# ── UI ───────────────────────────────────────────────────────────────────────
ui <- page_navbar(
  title = "Used Car Price Predictor",
  theme = app_theme,
  fillable = FALSE,

  # Tab 1: Price Predictor
  nav_panel(
    title = "Price Predictor",
    icon = icon("car"),
    layout_sidebar(
      sidebar = sidebar(
        title = "Enter Car Details",
        width = 350,
        selectInput("brand", "Brand:", choices = brands),
        selectInput("model_name", "Model:", choices = NULL),
        sliderInput("year", "Manufacturing Year:",
                    min = min(car_data$Year), max = max(car_data$Year),
                    value = 2018, step = 1, sep = ""),
        selectInput("fuel_type", "Fuel Type:", choices = fuel_types),
        selectInput("transmission", "Transmission:", choices = transmissions),
        numericInput("engine_size", "Engine Size (L):", value = 2.0, min = 1.0, max = 5.0, step = 0.1),
        numericInput("mileage", "Mileage (km):", value = 50000, min = 0, max = 400000, step = 5000),
        numericInput("doors", "Doors:", value = 4, min = 2, max = 5, step = 1),
        numericInput("owner_count", "Previous Owners:", value = 1, min = 1, max = 5, step = 1),
        actionButton("predict", "Predict Price", class = "btn-primary btn-lg w-100 mt-3")
      ),
      layout_columns(
        col_widths = c(12),
        card(
          card_header(class = "bg-primary text-white", "Predicted Price"),
          card_body(
            class = "text-center",
            uiOutput("prediction_display")
          )
        ),
        card(
          card_header("How does your car compare?"),
          card_body(
            plotOutput("comparison_plot", height = "350px")
          )
        )
      )
    )
  ),

  # Tab 2: Data Explorer
  nav_panel(
    title = "Data Explorer",
    icon = icon("chart-bar"),
    layout_columns(
      col_widths = c(6, 6, 12),
      card(
        card_header("Price Distribution by Brand"),
        card_body(plotOutput("brand_plot", height = "400px"))
      ),
      card(
        card_header("Price vs Mileage"),
        card_body(plotOutput("mileage_plot", height = "400px"))
      ),
      card(
        card_header("Dataset Preview"),
        card_body(DTOutput("data_table"))
      )
    )
  ),

  # Tab 3: About
  nav_panel(
    title = "About",
    icon = icon("info-circle"),
    layout_columns(
      col_widths = c(6, 6, 12),
      card(
        card_header("About This Project"),
        card_body(
          tags$p("This application predicts used car prices based on vehicle attributes
                  using a machine learning model trained on 10,000 car listings."),
          tags$h5("Features Used"),
          tags$ul(
            tags$li(tags$strong("Brand & Model"), " — Vehicle make and specific model"),
            tags$li(tags$strong("Year"), " — Manufacturing year"),
            tags$li(tags$strong("Engine Size"), " — Engine displacement in liters"),
            tags$li(tags$strong("Fuel Type"), " — Diesel, Petrol, Hybrid, or Electric"),
            tags$li(tags$strong("Transmission"), " — Manual, Automatic, or Semi-Automatic"),
            tags$li(tags$strong("Mileage"), " — Total kilometers driven"),
            tags$li(tags$strong("Doors"), " — Number of doors"),
            tags$li(tags$strong("Owner Count"), " — Number of previous owners")
          ),
          tags$h5("Model"),
          tags$p("Linear regression with 10-fold cross-validation, trained using the caret package in R.")
        )
      ),
      card(
        card_header("Dataset Summary"),
        card_body(
          tags$table(
            class = "table table-striped",
            tags$tr(tags$td(tags$strong("Records")), tags$td(format(nrow(car_data), big.mark = ","))),
            tags$tr(tags$td(tags$strong("Brands")), tags$td(length(brands))),
            tags$tr(tags$td(tags$strong("Price Range")),
                    tags$td(paste(dollar(min(car_data$Price)), "–", dollar(max(car_data$Price))))),
            tags$tr(tags$td(tags$strong("Year Range")),
                    tags$td(paste(min(car_data$Year), "–", max(car_data$Year)))),
            tags$tr(tags$td(tags$strong("Avg Mileage")),
                    tags$td(paste(format(round(mean(car_data$Mileage)), big.mark = ","), "km")))
          )
        )
      ),
      card(
        card_header("Author"),
        card_body(
          tags$p(tags$strong("Aditya Arte")),
          tags$p("MBA + Business Analytics Dual Degree Candidate"),
          tags$p("Hult International Business School"),
          tags$a(href = "https://www.linkedin.com/in/aditya-arte/", target = "_blank",
                 icon("linkedin"), " LinkedIn Profile")
        )
      )
    )
  )
)

# ── Server ───────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  # Update model choices when brand changes
  observeEvent(input$brand, {
    models_for_brand <- sort(unique(car_data$Model[car_data$Brand == input$brand]))
    updateSelectInput(session, "model_name", choices = models_for_brand)
  })

  # Prediction logic
  predicted_price <- eventReactive(input$predict, {
    req(input$model_name)

    new_data <- data.frame(
      Brand = input$brand,
      Model = input$model_name,
      Year = input$year,
      Engine_Size = input$engine_size,
      Fuel_Type = input$fuel_type,
      Transmission = input$transmission,
      Mileage = input$mileage,
      Doors = input$doors,
      Owner_Count = input$owner_count
    )

    tryCatch(
      predict(model, new_data),
      error = function(e) {
        # Fall back: try without Brand/Doors/Owner_Count for older models
        fallback_data <- new_data[, c("Model", "Year", "Engine_Size", "Fuel_Type",
                                       "Transmission", "Mileage"), drop = FALSE]
        predict(model, fallback_data)
      }
    )
  })

  # Prediction display
  output$prediction_display <- renderUI({
    req(predicted_price())
    price <- predicted_price()
    formatted <- formatC(round(price, 2), format = "f", big.mark = ",", digits = 2)

    tagList(
      tags$h1(
        style = "font-size: 3.5rem; font-weight: 700; color: #27ae60; margin: 1rem 0;",
        paste0("$", formatted)
      ),
      tags$p(
        class = "text-muted",
        paste0("Estimated market value for a ", input$year, " ", input$brand, " ", input$model_name)
      )
    )
  })

  # Comparison plot
  output$comparison_plot <- renderPlot({
    req(predicted_price(), input$model_name)

    same_model <- car_data[car_data$Model == input$model_name, ]
    pred_val <- predicted_price()

    if (nrow(same_model) == 0) {
      same_model <- car_data[car_data$Brand == input$brand, ]
      plot_title <- paste("Your car vs other", input$brand, "vehicles")
    } else {
      plot_title <- paste("Your car vs other", input$brand, input$model_name, "listings")
    }

    ggplot(same_model, aes(x = Mileage, y = Price)) +
      geom_point(alpha = 0.4, color = "#95a5a6", size = 2) +
      geom_point(aes(x = input$mileage, y = pred_val),
                 color = "#e74c3c", size = 5, shape = 18) +
      geom_hline(yintercept = pred_val, color = "#e74c3c", linetype = "dashed", alpha = 0.5) +
      annotate("text", x = max(same_model$Mileage) * 0.8, y = pred_val,
               label = paste0("Your car: $", formatC(round(pred_val), format = "d", big.mark = ",")),
               color = "#e74c3c", fontface = "bold", vjust = -1) +
      scale_x_continuous(labels = comma) +
      scale_y_continuous(labels = dollar) +
      labs(title = plot_title, x = "Mileage (km)", y = "Price ($)") +
      theme_minimal(base_size = 14)
  })

  # Brand price plot
  output$brand_plot <- renderPlot({
    brand_avg <- aggregate(Price ~ Brand, data = car_data, FUN = mean)
    brand_avg <- brand_avg[order(brand_avg$Price), ]

    ggplot(brand_avg, aes(x = reorder(Brand, Price), y = Price, fill = Price)) +
      geom_col(alpha = 0.85) +
      coord_flip() +
      scale_y_continuous(labels = dollar) +
      scale_fill_gradient(low = "#3498db", high = "#e74c3c") +
      labs(x = NULL, y = "Average Price ($)") +
      theme_minimal(base_size = 13) +
      theme(legend.position = "none")
  })

  # Mileage scatter plot
  output$mileage_plot <- renderPlot({
    ggplot(car_data, aes(x = Mileage, y = Price, color = Fuel_Type)) +
      geom_point(alpha = 0.25, size = 1.5) +
      geom_smooth(method = "lm", se = FALSE, size = 0.8) +
      scale_x_continuous(labels = comma) +
      scale_y_continuous(labels = dollar) +
      scale_color_brewer(palette = "Set2") +
      labs(x = "Mileage (km)", y = "Price ($)", color = "Fuel Type") +
      theme_minimal(base_size = 13)
  })

  # Data table
  output$data_table <- renderDT({
    display_data <- car_data[, c("Brand", "Model", "Year", "Fuel_Type",
                                  "Transmission", "Engine_Size", "Mileage", "Price")]
    display_data$Price <- dollar(display_data$Price)
    display_data$Mileage <- format(display_data$Mileage, big.mark = ",")

    datatable(display_data,
              options = list(pageLength = 10, scrollX = TRUE),
              rownames = FALSE,
              colnames = c("Brand", "Model", "Year", "Fuel", "Trans",
                           "Engine (L)", "Mileage (km)", "Price"))
  })
}

# ── Run ──────────────────────────────────────────────────────────────────────
shinyApp(ui = ui, server = server)
