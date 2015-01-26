system.time( source("run_analysis.R")) 

require(dplyr)
analysisDataExport <- file.path(getwd(), "export/mean_of_activity_subject.csv")
data <- read.table(analysisDataExport) %>% tbl_df(.)

print("Dimension of Data.")

dim(data)
cat("Dimension of data. Enter to cont..")
t <- readLines(con="stdin", 1)


print("Print Data.")
data
cat("Print Data. Enter to cont..")
t <- readLines(con="stdin", 1)

print("Summary of Data.")
summary(data)
cat("summary of Data. Enter to cont..")
t <- readLines(con="stdin", 1)

print("Head of Data.")
head(data)
cat("head of Data. Enter to cont..")
t <- readLines(con="stdin", 1)

print("Tail of Data.")
tail(data)
cat("tail of Data. Enter to cont..")
t <- readLines(con="stdin", 1)

