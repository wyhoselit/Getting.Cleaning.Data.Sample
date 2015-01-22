# You should create one R script called run_analysis.R that does the following. 
# * Merges the training and the test sets to create one data set.
labeledDataFile <- file.path(getwd(), "data/labeledData.csv")


if(file.exists(labeledDataFile)){
        labeledData <- read.table(labeledDataFile)
}else
{
        print("No labeled Cleaned Data found!!")
        
        temp <- tempfile()
        print("Downloading File")
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=temp,method="curl")
        
        print("Merges Training and Test Data.")
        
        trainTmp <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
        testTmp <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
        
        XData <- rbind(trainTmp, testTmp)
        print(paste("Memory Size of X origin:", format(object.size(XData),"auto"))
        )
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
        
        print("Extracts only the measurements on the mean and standard deviation")
        
        indexFocus <- grep ("-mean\\(\\)|-std\\(\\)", features[,2])
        XData <- XData[,indexFocus]
        
        print(paste("Memory Size of X Current:", format(object.size(XData),"auto"))
        )
        names(XData) <- features[indexFocus,2]
#         * Uses descriptive activity names to name the activities in the data set
        YData[,1] = activityLabels[YData[,1],2]
        names(YData) <- "Activity"
        
        names(Subject) <- "Subject"
        # Appropriately labels the data set with descriptive variable names. 
        print("Already get Labeled Data.")
        
        labeledData <- cbind(Subject,YData,XData)

              
        if(!file.exists("data")) {dir.create("data")}
        print(paste("Save labeled Data to", labeledDataFile, sep=" "))
        write.table(labeledData, labeledDataFile)
}

# * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

print(paste("Memory Size of labeled Data:", format(object.size(labeledData),"auto")))

print("Tidy data set with the average of each variable for each activity and each subject")
allSubjects = length(unique(labeledData$Subject))
allActivities = length(unique(labeledData$Activity) )

avgData <- labeledData[1:(allSubjects * allActivities),]

currentRow = 1
numCols = ncol(labeledData)

for( s in unique(labeledData$Subject) ){
        for( a in unique(labeledData$Activity) ){
                avgData[currentRow,1] = s
                avgData[currentRow,2] = a
                c <- labeledData[labeledData$Subject== s & labeledData$Activity == a,]
                avgData[currentRow,3:numCols] <- colMeans(c[,3:numCols])
                currentRow = currentRow +1
        }
}



if(!file.exists("export")) {dir.create("export")}

avgDataExport <- file.path(getwd(), "export/average_of_activity_subject.csv")
print(paste( "Export to",avgDataExport, sep=" " ))
write.table(avgData, avgDataExport)

print("All Done, Thanks you!!!")
print("=======================")
print("")
