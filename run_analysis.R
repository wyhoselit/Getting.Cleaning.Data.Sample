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
names(YData) <- "Activity"

names(Subject) <- "Subject"
# Appropriately labels the data set with descriptive variable names. 
labeledData <- cbind(Subject,YData,XData)

# * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



allSubjects = length(unique(Subject)[,1])
allActivities = length(activityLabels[,1])

avgData <- labeledData[1:(allSubjects * allActivities),]

currentRow = 1
numCols = ncol(labeledData)

for( s in unique(Subject)[,1]){
        for( a in activityLabels[,2]){
                avgData[currentRow,1] = s
                avgData[currentRow,2] = a
                c <- labeledData[labeledData$Subject== s & labeledData$Activity == a,]
                avgData[currentRow,3:numCols] <- colMeans(c[,3:numCols])
                currentRow = currentRow +1
        }
}

if(!file.exists("export")) {dir.create("export")}

avgDataExport <- file.path(getwd(), "export/average_of_activity_subject.csv")
write.table(avgData, avgDataExport)
