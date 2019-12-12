#Activate required libraries
library(dplyr)
library(utils)

#Extract all datasets giving appropriate labels
activity_labels <- read.delim("activity_labels.txt", header = FALSE, sep = " ", col.names = c("Activity","Activity Description"))
features <- read.delim("features.txt", header = FALSE, sep = " ", col.names = c("featureID","Feature"))
subject_train <- read.delim("train/subject_train.txt", header = FALSE, sep = " ", col.names = "Subject")
subject_test <- read.delim("test/subject_test.txt", header = FALSE, sep = " ", col.names = "Subject")
y_train <- read.delim("train/y_train.txt", header = FALSE, sep = " ", col.names = "Activity")
y_test <- read.delim("test/y_test.txt", header = FALSE, sep = " ", col.names = "Activity")

#These x files have column names being equivalent to the features
X_train <- read.table("train/X_train.txt", col.names = features$Feature)
X_test <- read.table("test/X_test.txt", col.names = features$Feature)

#Assign each of the Activities with its appropriate description
Activity_test <- merge(y_test,activity_labels, by.x = "Activity", by.y = "Activity")
Activity_train <- merge(y_train,activity_labels, by.x = "Activity", by.y = "Activity")

#Combine the train data sets
Train_combined <- cbind(subject_train, Activity_train, X_train)

#Combine the test data sets
Test_combined <- cbind(subject_test, Activity_test, X_test)

#Combine test and train and arrange by activity
All_combined <- rbind(Train_combined,Test_combined)
All_arranged <- arrange(All_combined,Activity)

#Extract all measurements which are mean and standard deviation
extract <- select(All_arranged, c(Subject, Activity, Activity.Description, contains("mean."), contains("std.")))

#Group by Activity then Subject
GroupActivity <- group_by(extract, Activity.Description, Subject)

#Create the second dataset with means of all variables and save the dataset as a text file
Tidydata <- summarise_all(GroupActivity, mean)
TidydataArrange <- arrange(Tidydata, Activity)
write.table(TidydataArrange,file = "Tidy data.txt", row.names = FALSE)