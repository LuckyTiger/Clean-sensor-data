require(dplyr)

features <- read.table("UCI HAR Dataset/features.txt")[,2]
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")
#Get feature names
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_label <- read.table("UCI HAR Dataset/train/y_train.txt")
names(train_set) <- features
names(train_subject)<-"Subject"
names(train_label) <- "Activity"

#Extract mean and standart deviation for each measurement 
train_set_part <- train_set[,grepl("mean|std",names(train_set))]
train_data <- cbind(train_subject,train_label,train_set_part)

test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_label <- read.table("UCI HAR Dataset/test/y_test.txt")
names(test_set) <- features
names(test_subject)<-"Subject"
names(test_label) <- "Activity"
test_set_part <- test_set[,grepl("mean|std",names(test_set))]
test_data <- cbind(test_subject,test_label,test_set_part)

#Bind train data and test data together
data <- rbind(train_data,test_data)
data$Activity <- activity_label[data$Activity,][,2]
write.table(data, "tidydata.txt")

data_tbl <- tbl_df(data)
by_subact <- group_by(data_tbl, Subject, Activity)
result <- summarise_each(by_subact, funs(mean))
write.table(result, "SummariseBySubjectAndAct.txt", col.names = FALSE)