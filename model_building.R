#german  credit risk classification analysis
  

library(tidyverse)
library(rpart)  # decison tree alogrithm
library(rpart.plot)  #decison tree analysis
library(e1071)  #Additional model evalution tools


#1 exploratory Data Analysis(EDA)
#load the dataset
credit_data <- read.csv("credit_data_recode.csv",stringsAsFactors = TRUE)

#Basic dataset overview
str(credit_data)
summary(credit_data)

#distribution of target variable
table(credit_data$assesment)
prop.table(table(credit_data$assesment))

#visualize categorical variable distribution
categorical_vars <-c("status", "credit_history","purpose","saving_account",
                     "employment", "personal_status","housing","job")

plot_categorical_distribution <- function(data,var){ggplot(data,aes(x = !!sym(var),fill = assesment)) + geom_bar(Position = "fill") +
    theme_minimal()+
    labs(title = paste("Distribution of", var, "by credit Assessment"),
         y = "propotion")+
    coord_flip()
  }

#create plots for each categorical variable
categorical_plots <- lapply(categorical_vars, function(var){
  plot_categorical_distribution(credit_data,var)
})

#2. feature engineering
# HAndle missing values (if any)
credit_data<-credit_data %>%
  mutate(across(where(is.character), ~replace_na(., "unknown")))

#create age group
credit_data <- credit_data%>%
  mutate(
    status_encoded = as.numeric(factor(status)),
    credit_history_encoded = as.numeric(factor(credit_history)),
    purpose_encoded = as.numeric(factor(purpose)),
    savings_accounts_encoded = as.numeric(factor(employment))
  )

#3. model building
#set seed for reproductibility
set.seed(123)

#spilt data into training and testing set
index <- createDataPartition(credit_data$assesment,p = 0.7, list = FALSE)
Train_data <- credit_data[index, ]
test_data<- credit_data[index, ]

#prepare features and target
features <- c("duration", "credit_amount", "insatllment_rate","age",
              "num_credits","status_encoded",
              "credit_history_encoded",
              "purpose_encoded","savings_account_encoded","employment_encoded")

#decison tree model
dt_model<- rpart(
  formula = as.factor(assesment)~.,
  data = Train_data[, c(features, "assesment")],
  method = "class",
  control =rpart.control(maxdepth = 5)
)

#plot decison tree
rpart.plot(dt_model,
           main = "Credit Risk Decision Tree",
           fallen.leaves = TRUE)

#.MODEL Evaluation
#prediction
predictions<- predict(dt_model,test_data[, features],type = "class")

#confusion matrix
conf_matrix <- confusionmatrix(predictions,as.factor(test_data$assesment))
print(conf_matrix)

#additional performance metrics
accuracy <- conf_matrix$overall["Accuracy"]
precision <- conf_matrix$byclass["Precision"]
recall <- conf_matrix$byclass["Recall"]
f1_score  <- conf_matrix$byclass["F1"]

performance_summary
performance_summary <-data_frame(
  metric =c("Accuracy","Precision","Recall","F1 score"),
  value = c(accuracy,precision,recall,f1_score)
)

print(performance_summary)
