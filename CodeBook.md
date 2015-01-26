# Course Project Code Book

Source of the [original data download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

[Original description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)




# How to Run this Script

 * Directly from Unix run:
  * $ `Rscript test.R`
 * or direct from R:
  * `source("run_analysis.R")`
 * will perform the following to clean up and export analysis data to: "export/mean_of_activity_subject.csv"

## What this Script doing

### Pre-requirement:
* This script is using "dplyr" package with version greater than 0.4. So after install "dplyr" version is old, the script will stop running. you need to manual update "dplyr" version and try again.
* The original data source need to access by running script. This script will download directly for you.

### How the program get the Mean of All Activity value.
* Downloading data files to temp, if no Analysis data found.
 * We will save the Analysis tidy raw data in "data/AnalysisData.csv"
 * This will perform us to run analysis quickly in future.
* Merges Training and Test Data.
  * we need to merge "Train" and "Test" data from origin dataset
  * In this Analysis, we only focus on "mean" and "standard deviation"
    * From origin featues_info.txt, these column are labeled as mean() and std()
      * mean(): Mean value, std(): Standard deviation
    * cause the orgin X_train/test Files are too large with other dataset, we filter out these data and save in XData.
      * read features.txt and get index of (mean/std) with ?grep expression
      * ?read.table and select only these indeices  
      * name columns with ?colnames as features.txt defined, replace "()" using ?gsub
  * Get Subject of "Train" and "Test"
  * Get Activity of dataset
    * Get Y(train/test) data and activity_labels.txt which defined these id.
      * we use ?inner_join and labels of Y
  * Finally bind Subject, Activity and (mean/std) data together.
    * Save this dataset to "data/AnalysisData.csv" for future use.
* Finally, calculate mean of all activity value.
  * we use "dplyr" ?group_by function, Grouping Subject and Activity
  * then use ?summarise_each to calculate mean of all value.
  * sort table with Subject and Activity.
  * Save this table to "export/mean_of_activity_subject.csv"
* That's all, Thanks you.


# What these variables mean

## Features Info
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- = 3*5 = 15
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- =5
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- =3*3 = 15
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag
- =4

The set of variables that were estimated from these signals are:

- mean: Mean value
- std: Standard deviation

### 33 feature with mean and standard deviation = 66 measurement with Subject and Activity = 68 columns.

## Activity

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

### 6 Activity with 30 volunteers = 180 rows.


# The analysis data is dimension of 180 x 68.

### Finally, Sorry for my broken English :P
