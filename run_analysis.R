analysisDataFile <- file.path(getwd(), "data/AnalysisData.csv")
usePackage <- function(p) {
        if (!is.element(p, installed.packages()[,1]))
                install.packages(p, dep = TRUE)
        require(p, character.only = TRUE)
}
usePackage("dplyr")

print(packageVersion("dplyr"))
if( packageVersion("dplyr") <= "0.4.0") { stop("Please update dplyr > =0.4 and try again")}
        
if(file.exists(analysisDataFile)){
        
        analysisData <-   read.table(analysisDataFile) %>% tbl_df(.)
}else
{
        print("No Analysis Cleaned Data found!!")
        
        temp <- tempfile()
        print("Downloading File")
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=temp,method="curl")
        
        print("Merges Training and Test Data.")
        # * Extracts only the measurements on the mean and standard deviation for each measurement. 
        print("Extracts only the measurements on the mean and standard deviation from features")

        features <-tbl_df( read.table(unz(temp, "UCI HAR Dataset/features.txt")))

        indexFocus <- grep ("-mean\\(\\)|-std\\(\\)", features$V2)
        XData <- rbind_list(
                        read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt")) %>%
                                tbl_df(.) %>%
                                        select(indexFocus),
                        read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt")) %>%
                                tbl_df(.) %>%
                                        select(indexFocus)
                   ) 
        colnames(XData) <- gsub("\\(|\\)", "", select(filter(features, V1 %in% indexFocus), V2)$V2)
        print(paste("Memory Size of X :", format(object.size(XData),"auto")))

        Subject <- rbind_list(
                read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt")),
                read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
        )
        print(paste("Memory Size of Subject origin:", format(object.size(Subject),"auto")))    
        
        YData <- rbind_list(read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt")),
                           read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt")))

        print(paste("Memory Size of YData origin:", format(object.size(YData),"auto")))    
        
        activityLabels <- tbl_df(read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt")))
        
        unlink(temp)

        #         * Uses descriptive activity names to name the activities in the data set
        YData <-YData %>%
                inner_join(activityLabels, by = "V1") %>%
                select(V2) %>%
                        rename(Activity =V2) 

        colnames(Subject) <- "Subject"
        
        # Appropriately labels the data set with descriptive variable names. 
        print("Already get Analysis Data. Combine all in one table.")
        analysisData <- tbl_df(
                bind_cols(Subject,
                           YData,
                           XData))

        if(!file.exists("data")) {dir.create("data")}
        print(paste("Save labeled Data to", analysisDataFile, sep=" "))
        write.table(analysisData, analysisDataFile)
}

# * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

print(paste("Memory Size of labeled Data:", format(object.size(analysisData),"auto")))

print("Tidy data set with the average of each variable for each activity and each subject")
analysisMeanData <- analysisData %>%
                group_by(Subject,Activity) %>%
                        summarise_each(funs(mean)) %>%
                                arrange(Subject,Activity)

if(!file.exists("export")) {dir.create("export")}

meanDataExport <- file.path(getwd(), "export/mean_of_activity_subject.csv")
print(paste( "Export to",meanDataExport, sep=" " ))
write.table(analysisMeanData, meanDataExport)

print("All Done, Thanks you!!!")
print("=======================")
print("")
