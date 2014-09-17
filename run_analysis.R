# run_analysis.R
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(tidyr)
library(dplyr)

# Load the Data set: 
# Give up and extract the file manually... in "UCI HAR Dataset" in working directory
# we want to use descriptive activity names (activity_labels.txt)
# 1. Merges the training and the test sets to create one data set.
# Identify file locations
trainingSub <- "UCI HAR Dataset/train/subject_train.txt" # identifies training subject
trainingX <- "UCI HAR Dataset/train/X_train.txt" # training set
trainingY <- "UCI HAR Dataset/train/y_train.txt" # training labels
testingSub <- "UCI HAR Dataset/test/subject_test.txt" # identifies test
testingX <- "UCI HAR Dataset/test/X_test.txt" # test set
testingY <- "UCI HAR Dataset/test/y_test.txt" # test labels
activityLabels <- "UCI HAR Dataset/activity_labels.txt"
features <- "UCI HAR Dataset/features.txt" # features (names of cols in X_train and X_test)

# read file contents into data frames (names are shorter and not as descriptive)
al <- read.table(activityLabels, col.names=c("id", "activity"))
fs <- read.table(features) # read features table (labels to data set)
if (!exists("xs")) { # takes a long time to read this, only do if not there
    xs<- read.table(testingX, col.names=fs[,2]) 
    } 
as<- read.table(testingY, col.names="Activity")
ys<- read.table(testingSub, col.names="Subject")
ms<- data.frame(ys,as,xs) # merge testing set and labels
if (!exists("xn")) {  # takes a long time to read this, only do if not there
    xn<- read.table(trainingX, col.names=fs[,2]) 
    }
an<- read.table(trainingY, col.names="Activity") 
yn<- read.table(trainingSub, col.names="Subject")
mn<- data.frame(yn,an, xn) # merge training set and labels

mn$t<- "train" # column to identify this is a training set
ms$t <- "test"  # column to identify this is a test set

#merge the testing and training data sets - columns should be the same, additional rows
mns <- rbind(mn, ms) # "merge" of mn and ms (actually rbind)

# Convert this to a data table
mnst <- tbl_df(mns) # data table of mns

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
emnst <-  select(mnst, Subject, Activity, t, contains("mean()"), contains("std()")) # extracted mnst

# 3. Uses descriptive activity names to name the activities in the data set
emnst$Activity <- al[emnst$Activity,2]
# 4. Appropriately labels the data set with descriptive variable names. 
# already did that (set column names when I read in the tables)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
# Did not wind up using: gemnst <- group_by(emnst, Subject, Activity) # grouped emnst

#aggregated extracted merged training and test table
aemnst <- aggregate(emnst[,4:89], by = list(subject = gemnst$Subject, activity = gemnst$Activity), mean)

write.table(aemnst, "tidyDataSet.txt", sep = ",", row.name=FALSE)