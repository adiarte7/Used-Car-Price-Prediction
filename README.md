# Used Car Price Prediction

A machine learning project that analyzes 10,000 used car listings and provides an interactive web application to predict car prices based on vehicle attributes.

**Live Demo:** [aditya-arte.shinyapps.io/submission](https://aditya-arte.shinyapps.io/submission/)

---

## Overview

This project explores the factors that influence used car pricing and builds a predictive model deployed as an interactive Shiny web application. Users can input car details and receive an estimated market value instantly.

### Key Findings

- **Year** is the strongest positive predictor — newer cars retain more value
- **Mileage** has a strong negative correlation with price
- **Electric & Hybrid** vehicles command a ~15% price premium over Petrol/Diesel
- **Automatic** transmission adds value over Manual and Semi-Automatic
- **Engine Size** has a positive correlation — larger engines cost more

---

## Project Structure

```
Used-Car-Price-Prediction/
├── app.R                      # Shiny web application (3-tab interface)
├── car_price_analysis.Rmd     # Full EDA, visualization, and model training
├── car_price_dataset.csv      # Dataset (10,000 listings, 10 features)
├── car_price_model.rds        # Trained regression model
└── README.md
```

---

## Features

### Shiny Web Application (`app.R`)

| Tab | Description |
|-----|-------------|
| **Price Predictor** | Input car details and get an instant price estimate with a comparison chart |
| **Data Explorer** | Interactive charts showing price distributions by brand, mileage trends, and a searchable data table |
| **About** | Model methodology, dataset summary, and project information |

**App highlights:**
- Brand → Model cascading dropdowns (selecting a brand filters available models)
- Comparison scatter plot showing your car vs similar listings
- Responsive Bootstrap 5 UI via `bslib`
- Interactive data table with sorting and search

### Analysis Notebook (`car_price_analysis.Rmd`)

- Exploratory data analysis with 15+ visualizations
- Correlation heatmap across all features
- Feature engineering (car age derivation)
- Model comparison: Linear Regression vs Ridge Regression
- Residual diagnostics (predicted vs actual, Q-Q plot, residual distribution)
- Feature importance analysis

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Language | R |
| Web Framework | Shiny + bslib (Bootstrap 5) |
| Visualization | ggplot2, corrplot |
| ML Training | caret (with cross-validation) |
| Data Tables | DT |
| Deployment | shinyapps.io |

---

## Model Details

| Metric | Value |
|--------|-------|
| Algorithm | Linear Regression with 10-fold CV |
| Training Split | 80% train / 20% test |
| Features | Brand, Model, Year, Engine Size, Fuel Type, Transmission, Mileage, Doors, Owner Count |
| Dataset Size | 10,000 records |

### Features Used

| Feature | Type | Description |
|---------|------|-------------|
| Brand | Categorical | Vehicle manufacturer |
| Model | Categorical | Specific car model |
| Year | Numeric | Manufacturing year (2000–2023) |
| Engine_Size | Numeric | Engine displacement in liters |
| Fuel_Type | Categorical | Diesel, Petrol, Hybrid, Electric |
| Transmission | Categorical | Manual, Automatic, Semi-Automatic |
| Mileage | Numeric | Total kilometers driven |
| Doors | Numeric | Number of doors (2–5) |
| Owner_Count | Numeric | Number of previous owners |

---

## Getting Started

### Prerequisites

- [R](https://cran.r-project.org/) (>= 4.0)
- [RStudio](https://posit.co/download/rstudio-desktop/) (recommended)

### Install Dependencies

```r
install.packages(c("shiny", "bslib", "ggplot2", "scales", "DT",
                    "tidyverse", "corrplot", "caret"))
```

### Run the App

```r
shiny::runApp("app.R")
```

### Reproduce the Analysis

Open `car_price_analysis.Rmd` in RStudio and click **Knit** to regenerate the full analysis report with all visualizations and model training.

---

## Data Source

[Kaggle — Car Price Dataset](https://www.kaggle.com/datasets/asinow/car-price-dataset/data) (10,000 synthetic car listings with 10 attributes)

---

## Author

**Aditya Arte**
MBA + Business Analytics Dual Degree Candidate
Hult International Business School
[LinkedIn](https://www.linkedin.com/in/aditya-arte/)
