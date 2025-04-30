# Used-Car-Price-Prediction

This R analysis and Shiny web application predicts the selling price of a used car based on its attributes such as model, fuel type, transmission, engine size, manufacturing year, and mileage. It leverages a pre-trained regression model built using R.

---

## Features

- Interactive UI for users to input car details  
- Predicts used car prices based on real-world data  
- Model trained using regression techniques on a cleaned car dataset  
- Deployed using `shinyapps.io` or can be run locally  

---

## Tech Stack

- **Frontend:** R Shiny  
- **Backend Model:** RDS file with pre-trained regression model  
- **Data Source:** `car_price_dataset.csv`  
- **Libraries Used:** `shiny`, `readr`, `base R` functions  

---

## How to Run Locally

1. Clone this repository  
2. Make sure you have R and RStudio installed  
3. Install the required packages (if not already):

    ```r
    install.packages("shiny")
    ```

4. Place the following files in the same directory:
    - `car_price_dataset.csv`
    - `car_price_model.rds`
    - `app.R` (this file contains the Shiny app code)

5. Run the app:

    ```r
    shiny::runApp("app.R")
    ```

---

## Project Structure

```
car-price-predictor/
│
├── app.R                  # Shiny app source code
├── car_price_model.rds    # Trained regression model
├── car_price_dataset.csv  # Dataset used for dropdown options
└── README.md              # Project documentation
```

---

## Prediction Model Details

The model was trained using features such as:
- `Model` (categorical)
- `Year` (numeric)
- `Fuel_Type` (categorical)
- `Transmission` (categorical)
- `Engine_Size` (numeric)
- `Mileage` (numeric)

The trained model (`car_price_model.rds`) is loaded into the app and used to make real-time predictions based on user input.

---

## Deployment

The app is deployed on [shinyapps.io](https://aditya-arte.shinyapps.io/submission/)

---

## Author

Aditya Arte  
MBA + Business Analytics Dual Degree Candidate  
Hult International Business School  
[LinkedIn Profile](https://www.linkedin.com/in/aditya-arte/)
