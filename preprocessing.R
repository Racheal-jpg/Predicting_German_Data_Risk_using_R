library(readr)
library(dplyr)
library(ggplot2)


#reading the data as is;through a .data file format;no column name was given ,refer to the data description.
credit_data<-read_delim('./german_data/german.data',delim = " ",col_names = FALSE)

#column name
`colnames <-c("status","duration","credit_history","purpose","credit_amount","savings_accounts","employment","insatllment_rate","personal_status","guarantors","residence_since","property","age","installment_plans","housing","num_credits","job","dependents","telephone","foreign_worker","assesment")

#Attaching columns names  to dataframe
colnames(credit_data)<-col_names

chars_col <- sapply(credit_data,is.character) # find all the charactar columns
credit_data[, chars_col]<- lapply(credit_data[, chars_col], as.factor)