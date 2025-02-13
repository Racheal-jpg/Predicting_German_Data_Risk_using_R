#german credit risk classification analysis
  

library(tidyverse)
library(caret)
library(rpart)  # decision tree algorithm
library(rpart.plot)  #decision tree analysis
library(e1071)  #Additional model evaluation tools
library(randomForest)

#1 exploratory Data Analysis(EDA)
#load the data_set
credit_data <- read.csv("credit_data_recode.csv",stringsAsFactors = TRUE)

#Basic data_set overview
str(credit_data)
summary(credit_data)

#distribution of target variable
table(credit_data$assesment)
prop.table(table(credit_data$assesment))

#visualize categorical variable distribution
categorical_vars <-c("status", "credit_history","purpose","savings_accounts",
                     "employment", "personal_status","housing","job")

plot_categorical_distribution <- function(data,var){ggplot(data,aes(x = !!sym(var),fill = assesment)) + geom_bar(position = "fill") +
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
credit_data <- credit_data %>%
  mutate(age_group = cut(age, 
                         breaks = c(0, 25, 36, 45, 55, inf),
                         labels = c("18-25", "26-35", "36-45", "46-55", "55+")
                         )
         )


#Encoding categorical variable
credit_data <- credit_data%>%
  mutate(
    status_encoded = as.numeric(factor(status)),
    credit_history_encoded = as.numeric(factor(credit_history)),
    purpose_encoded = as.numeric(factor(purpose)),
    savings_accounts_encoded = as.numeric(factor(employment)),
    employment_encoded = as.numeric(factor(employment))
  )


#3 model building
#set seed for reproducibility
set.seed(123)

#shuffle data before splitting
credit_data<- credit_data[sample(nrow(credit_data)), ]


#split data into training and testing set
index <- createDataPartition(credit_data$assesment,p = 0.7, list = FALSE)
Train_data <- credit_data[index, ]
test_data<- credit_data[-index, ]

#prepare features and target
features <- c("duration", "credit_amount", "insatllment_rate","age",
              "num_credits","status_encoded",
              "credit_history_encoded",
              "purpose_encoded","savings_accounts_encoded","employment_encoded")

#decison tree model
dt_model<- rpart(
  formula = as.factor(assesment)~.,
  data = Train_data[, c(features, "assesment")],
  method = "class",
  control =rpart.control(maxdepth = 10,  #Minimum observaion in node
                         minsplit = 20,  # complexity parameter
                         cp =0.01,   #minimum observation in terminal nodes
                         minbucket = 7)
)


#Using Random Forest
rf_model<- randomForest(
  as.factor(assesment) ~ .,
  data = Train_data[, c(features, "assesment")],
  ntree = 500,
  mtry =sqrt(length(features))
)

#plot decison tree
rpart.plot(dt_model,
           main = "Credit Risk Decision Tree",
           fallen.leaves = TRUE)

#.MODEL Evaluation
#prediction
predictions<- predict(dt_model,test_data[, features],type = "class")

#predictions for random forest model
predictions_rf<- predict(rf_model,test_data[, features], type = "class")

#confusion matrix for decision tree model
conf_matrix <- confusionMatrix(predictions,as.factor(test_data$assesment))
print(conf_matrix)

#confusion Matrix for random forest model
conf_matrix_rf<-confusionMatrix(predictions_rf,
                                as.factor(test_data$assesment))
#print(conf_matrix_rf)

#additional performance metrics
accuracy <- conf_matrix$overall["Accuracy"]
precision <- conf_matrix$byClass["Precision"]
recall <- conf_matrix$byClass["Recall"]
f1_score  <- conf_matrix$byClass["F1"]

#Additional performance metrics for Random forest
accuracy_rf<- conf_matrix_rf$overall["Accuracy"]
precision_rf <- conf_matrix_rf$byClass["Precision"]
recall_rf <- conf_matrix_rf$byClass["Recall"]
f1_score_rf <- conf_matrix_rf$byClass["F1"]


perf_metrics<-c(accuracy = accuracy,
                precision = precision,
                recall = recall,
                f1score = f1_score)

#performance matrics for random forest
perf_metrics_rf<- c(accuracy = accuracy_rf,
                    precision = precision_rf,
                    recall = recall_rf,
                    f1score = f1_score_rf)

percentage <- function(i){
  x = sprintf("%.2f", i * 100)
  return(x)
}
sapply(perf_metrics, percentage)
sapply(perf_metrics_rf, percentage)


#performance_summary
performance_summary <-data_frame(
  metric =c("Accuracy","Precision","Recall","F1 score"),
  value = c(accuracy,precision,recall,f1_score)
)

print(performance_summary)

