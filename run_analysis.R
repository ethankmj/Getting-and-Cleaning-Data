#R script called run_analysis.R
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation 
#  for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
#
#
getwd()
setwd("C:/Users/PHUNKMJ/Desktop/Coursera/Modules 3/UCI HAR Dataset")

library(plyr)
library(reshape2)
library(dplyr)
library(data.table)

# Part1
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subjectsfile <- rbind(subject_train, subject_test)

# part2
features <- read.table("features.txt")

# get only columns with mean() or std() in their names
meanstd_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, meanstd_features]

# correct the column names
names(x_data) <- features[meanstd_features, 2]

# part 3
activitieslbl <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activitieslbl[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# part4

# correct column name
names(subjectsfile) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subjectsfile)

# Part5

# 66 <- 68 columns but last two (activity & subject)
averagesdata <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averagesdata, "tidydata.txt", row.name=FALSE)