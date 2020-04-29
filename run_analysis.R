library(dplyr)

filename <- "getdata_data_DATA.gov_NGAP"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
act <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
sub_tr <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_tr <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_tr <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
 

# Merge
x <- rbind(x_tr, x_test)
y <- rbind(y_tr, y_test)
sub <- rbind(sub_tr, sub_test)
data <- cbind(sub, y, x)

# Mean & Standart deviation
tidy <- data %>% select(subject, code, contains("mean"), contains("std"))
head(tidy)

# Descriptive activity names
tidy$code <- act[tidy$code, 2]

# label
names(tidy)<-gsub("^t", "time", names(tidy))
names(tidy)<-gsub("^f", "frequency", names(tidy))
names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
names(tidy)<-gsub("BodyBody", "Body", names(tidy))
names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
names(tidy)[2] = "activity"

# independent tidy data set with the average of each variable for each activity and each subject
indep <- tidy %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(indep, "independent_tidy_data_set.txt", row.name=FALSE)

indep
