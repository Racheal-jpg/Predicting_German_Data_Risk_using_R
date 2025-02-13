library(readr)
library(dplyr)
library(ggplot2)


#reading the data as is;through a .data file format;no column name was given ,refer to the data description.
credit_data<-read_delim('./german_data/german.data',delim = " ",col_names = FALSE)

#column name
colnames <-c("status","duration","credit_history","purpose","credit_amount","savings_account","employment","insatllment_rate","personal_status","guarantors","residence_since","property","age","installment_plans","housing","num_credits","job","dependents","telephone","foreign_worker","assesment")

#Attaching columns names  to dataframe
colnames(credit_data)<-col_names

chars_col <- sapply(credit_data,is.character) # find all the charactar columns
credit_data[, chars_col]<- lapply(credit_data[, chars_col], as.factor)

# Preprocessing
# As it stands for moving to the next step (Exploratory Data Analysis) we need to recode the dataset to get more understanding as to what give a bad credit and good credit
# Create a copy of the dataset for recoding
credit_data_recode <- credit_data %>%
  mutate(
    # Recode for "status" (Attribute 1)
    status = case_when(
      status == "A11" ~ "negative_balance",
      status == "A12" ~ "small_balance",
      status == "A13" ~ "large_balance",
      status == "A14" ~ "no_account",
      TRUE ~ status
    ),
    
    # Recode for "credit_history" (Attribute 3)
    credit_history = case_when(
      credit_history == "A30" ~ "no_credits",
      credit_history == "A31" ~ "all_paid",
      credit_history == "A32" ~ "current_credits_paid",
      credit_history == "A33" ~ "past_delay",
      credit_history == "A34" ~ "critical_account",
      TRUE ~ credit_history
    ),
    
    # Recode for "purpose" (Attribute 4)
    purpose = case_when(
      purpose == "A40" ~ "new_car",
      purpose == "A41" ~ "used_car",
      purpose == "A42" ~ "furniture",
      purpose == "A43" ~ "electronics",
      purpose == "A44" ~ "appliances",
      purpose == "A45" ~ "repairs",
      purpose == "A46" ~ "education",
      purpose == "A47" ~ "vacation",
      purpose == "A48" ~ "retraining",
      purpose == "A49" ~ "business",
      purpose == "A410" ~ "other",
      TRUE ~ purpose
    ),
    
    # Recode for "savings_account" (Attribute 6)
    savings_account = case_when(
      savings_account == "A61" ~ "low_savings",
      savings_account == "A62" ~ "moderate_savings",
      savings_account == "A63" ~ "good_savings",
      savings_account == "A64" ~ "high_savings",
      savings_account == "A65" ~ "unknown_savings",
      TRUE ~ savings_account
    ),
    
    # Recode for "employment" (Attribute 7)
    employment = case_when(
      employment == "A71" ~ "unemployed",
      employment == "A72" ~ "less_than_1yr",
      employment == "A73" ~ "1_to_4yrs",
      employment == "A74" ~ "4_to_7yrs",
      employment == "A75" ~ "7_or_more_yrs",
      TRUE ~ employment
    ),
    
    # Recode for "personal_status" (Attribute 9)
    personal_status = case_when(
      personal_status == "A91" ~ "male_divorced",
      personal_status == "A92" ~ "female_divorced",
      personal_status == "A93" ~ "male_single",
      personal_status == "A94" ~ "male_married",
      personal_status == "A95" ~ "female_single",
      TRUE ~ personal_status
    ),
    
    # Recode for "guarantors" (Attribute 10)
    guarantors = case_when(
      guarantors == "A101" ~ "none",
      guarantors == "A102" ~ "co_applicant",
      guarantors == "A103" ~ "guarantor",
      TRUE ~ guarantors
    ),
    
    # Recode for "property" (Attribute 12)
    property = case_when(
      property == "A121" ~ "real_estate",
      property == "A122" ~ "insurance",
      property == "A123" ~ "car_or_other",
      property == "A124" ~ "no_property",
      TRUE ~ property
    ),
    
    # Recode for "installment_plans" (Attribute 14)
    installment_plans = case_when(
      installment_plans == "A141" ~ "bank",
      installment_plans == "A142" ~ "stores",
      installment_plans == "A143" ~ "none",
      TRUE ~ installment_plans
    ),
    
    # Recode for "housing" (Attribute 15)
    housing = case_when(
      housing == "A151" ~ "rent",
      housing == "A152" ~ "own",
      housing == "A153" ~ "free",
      TRUE ~ housing
    ),
    
    # Recode for "job" (Attribute 17)
    job = case_when(
      job == "A171" ~ "unemployed",
      job == "A172" ~ "unskilled_resident",
      job == "A173" ~ "skilled_employee",
      job == "A174" ~ "management",
      TRUE ~ job
    ),
    
    # Recode for "telephone" (Attribute 19)
    telephone = case_when(
      telephone == "A191" ~ "none",
      telephone == "A192" ~ "registered",
      TRUE ~ telephone
    ),
    
    # Recode for "foreign_worker" (Attribute 20)
    foreign_worker = case_when(
      foreign_worker == "A201" ~ "yes",
      foreign_worker == "A202" ~ "no",
      TRUE ~ foreign_worker
    ),
    
    # Recode for "assessment" (1 = good, 2 = bad)
    assessment = case_when(
      assessment == 1 ~ "good",
      assessment == 2 ~ "bad",
      TRUE ~ as.character(assessment)  # Handle unexpected values
    )
  )