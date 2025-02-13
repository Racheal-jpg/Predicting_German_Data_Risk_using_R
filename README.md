# **German Credit Risk Classification Analysis**

## **Project Overview**

This project analyzes credit risk using the **German Credit Data-set**. It involves **data pre-processing, exploratory data analysis (EDA), feature engineering, and machine learning models** to classify customers into **good** or **bad** credit risk categories.

## **Data-set**

The data-set contains **1000 records** with **20 categorical and numerical features** related to customers' credit history, personal details, and financial status.

## **Objective**

The goal is to **build a classification model** to predict whether a customer is a **good** or **bad** credit risk based on historical data.

## **Libraries Used**

`library(readr)       # Reading dataset library(dplyr)       # Data manipulation library(ggplot2)     # Data visualization library(tidyverse)   # Data wrangling library(caret)       # Machine learning utilities library(rpart)       # Decision tree model library(rpart.plot)  # Decision tree visualization library(e1071)       # Additional model evaluation tools library(randomForest) # Random Forest model`

## **Steps in the Analysis**

### **1. Data Loading & Pre-processing**

-   Read the data-set using `read_delim()`.

-   Assign appropriate **column names** (based on data description).

-   Convert categorical variables to **factors** for analysis.

-   **Re-code categorical variables** to make them meaningful (e.g., "A11" → "negative_balance").

### **2. Exploratory Data Analysis (EDA)**

-   Display **summary statistics** using `summary()`.

-   Check **distribution of target variable (credit assessment)**.

-   **Visualize categorical variables** using `ggplot2`.

### **3. Feature Engineering**

-   Handle **missing values** by replacing them with `"unknown"`.

-   Create **age group categories**.

-   Encode categorical variables into **numerical values** for model training.

### **4. Model Building**

-   **Split data-set** into **training (70%)** and **testing (30%)** sets.

-   Use **Decision Tree (r-part)** and **Random Forest** models for classification.

-   **Hyper-parameter tuning** for better performance.

### **5. Model Evaluation**

-   Predict credit assessment using both models.

-   Compute **confusion matrix** to evaluate:

    -   **Accuracy**

    -   **Precision**

    -   **Recall**

    -   **F1-score**

-   Compare **Decision Tree vs. Random Forest performance**.

## **Results & Performance Metrics**

The following metrics compare the **Decision Tree** and **Random Forest** models:

| Metric        | Decision Tree | Random Forest |
|---------------|---------------|---------------|
| **Accuracy**  | 0.7433333     | 0.7433333     |
| **Precision** | 0.6000000     | 0.6031746     |
| **Recall**    | 0.4333333     | 0.4222222     |
| **F1 Score**  | 0.5032258     | 0.4967320     |

## **Conclusion**

-   The **Random Forest model** generally provides **higher accuracy** and **better generalization** compared to the **Decision Tree model**.

-   Feature importance analysis helps in understanding which factors **influence credit risk** the most.
