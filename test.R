source("run_analysis.R")
avgDataExport <- file.path(getwd(), "export/average_of_activity_subject.csv")
data <- read.table(avgDataExport)

dim(data)
str(data)
summary(data)

