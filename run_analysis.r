library(reshape2)

file_name <- "getdata_dataset.zip"

## Downloading and unzipping the given dataset:
if (!file.exists(file_name)){
  file_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(file_URL, file_name, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_ename) 
}

# Loading activity labels and features
activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_Labels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extracting  the data on mean and standard deviation only
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted_names <- features[featuresWanted,2]
featuresWanted_names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted_names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted_names <- gsub('[-()]', '', featuresWanted.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
train_Activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_Subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_Subjects, train_Activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
test_Activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_Subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Subjects, test_Activities, test)


# Merging Datasets and adding labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted_names)

# Turning activities and subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

#Creating an independent tidy data set with the average of each variable for each activity and each subject
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

