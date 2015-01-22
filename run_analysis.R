# You should create one R script called run_analysis.R that does the following. 
# * Merges the training and the test sets to create one data set.

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=temp,method="curl")

trainTmp <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
testTmp <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))

XData <- rbind(trainTmp, testTmp)

trainTmp <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
testTmp <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
Subject <- rbind(trainTmp, testTmp)


trainTmp <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
testTmp <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
YData <- rbind(trainTmp, testTmp)

# * Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
activityLabels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))

unlink(temp)

indexFocus <- grep ("-mean\\(\\)|-std\\(\\)", features[,2])
XData <- XData[,indexFocus]

names(XData) <- features[indexFocus,2]

# * Uses descriptive activity names to name the activities in the data set
YData[,1] = activityLabels[YData[,1],2]

# Appropriately labels the data set with descriptive variable names. 
# * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.