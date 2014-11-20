# CodeBook
JeffLi  
November 18, 2014  

## Data Description
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (`WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

1.First row of the Code, indicates that this project need package "dplyr", if you don't have one, install it.

```r
require(dplyr)
```

```
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

2.Then, use method `read.table` to read data from txt files, and store them in variables.

```r
features <- read.table("UCI HAR Dataset/features.txt")
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_label <- read.table("UCI HAR Dataset/train/y_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_label <- read.table("UCI HAR Dataset/test/y_test.txt")
```

3.Give those variables in these data sets with appropriately labels

```r
names(train_set) <- features$V2
names(train_subject)<-"Subject"
names(train_label) <- "Activity"
names(test_set) <- features$V2
names(test_subject)<-"Subject"
names(test_label) <- "Activity"
```

4. Extracts only the measurements on the mean and standard deviation for each measurement. And use `rbind` command to merge them.

```r
train_set_part <- train_set[,grepl("mean|std",names(train_set))]
test_set_part <- test_set[,grepl("mean|std",names(test_set))]
train_data <- cbind(train_subject,train_label,train_set_part)
test_data <- cbind(test_subject,test_label,test_set_part)
data <- rbind(train_data,test_data)
```

5. Give those activity with descriptive activity names. And write those tidydata into tidydata.txt in your workspace

```r
data$Activity <- activity_label[data$Activity,][,2]
write.table(data, "tidydata.txt")
```

6.Finally, Let's see what's the processed data look like

```r
head(data[,1:5])
```

```
##   Subject Activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
## 1       1 STANDING         0.2885845       -0.02029417        -0.1329051
## 2       1 STANDING         0.2784188       -0.01641057        -0.1235202
## 3       1 STANDING         0.2796531       -0.01946716        -0.1134617
## 4       1 STANDING         0.2791739       -0.02620065        -0.1232826
## 5       1 STANDING         0.2766288       -0.01656965        -0.1153619
## 6       1 STANDING         0.2771988       -0.01009785        -0.1051373
```

7. One more thing, as the fifth project require, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
data_tbl <- tbl_df(data)
by_subact <- group_by(data_tbl, Subject, Activity)
result <- summarise_each(by_subact, funs(mean))
write.table(data, "SummariseBySubjectAndAct.txt", col.names = FALSE)
```





