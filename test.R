source("run_analysis.R")
avgDataExport <- file.path(getwd(), "export/average_of_activity_subject.csv")
data <- read.table(avgDataExport)
print("Dimension of Data.")

dim(data)
cat("Dimension of data. Enter to cont..")
t <- readLines(con="stdin", 1)


print("Str of Data.")
str(data)
cat("str of Data. Enter to cont..")
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

