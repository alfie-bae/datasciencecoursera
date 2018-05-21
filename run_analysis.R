
library(dplyr)
library(tidyr)
# if the dataset exists already in folder, do not zip file again. 
if (!(file.exists("./UCI HAR Dataset"))){
  
  source_url <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip'
  download.file(source_url, "uci_dataset.zip")
  unzip("./uci_dataset.zip")
  
}

# column headers for both datasets held in different features.txt file.
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2

# load training and test data into memory. This may take a while due to size of datasets. 
training_data <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features, stringsAsFactors = FALSE)
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features, stringsAsFactors = FALSE)

                
# Label each feature vector(row) with the activity label ('1') and activity name ('walking')

# load activity labels into memory
training_activity_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                                       stringsAsFactors = FALSE,
                                       col.names="activity_label")
test_activity_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",
                                   stringsAsFactors = FALSE,
                                   col.names="activity_label")

# add activity labels as a new column - .
training_data <- cbind(training_data, training_activity_labels)
test_data <- cbind(test_data, test_activity_labels)

# Activity Labels (1-6) are not informative. Let's include the activity names also.  
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                            col.names=c("activity_label", "activity_name"),
                            header = FALSE)

# requirment 2 - label all records with their activity name
# join on activity name for every activity label in both datasets
labelled_training_data <- training_data %>%
  left_join(activities, by=c("activity_label"))

labelled_test_data <- test_data %>%
  left_join(activities, by=c("activity_label"))

# ADDING SUBJECT LABEL TO DATASET
# let's label each record with the subject's ID (1-30)
training_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                                col.names = "subject_id")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                            col.names="subject_id")

# requirment 2 - label all records with their subject
# bind labels to observations to label all feature vectors
labelled_training_data <-cbind(labelled_training_data, training_subjects)
labelled_test_data <- cbind(labelled_test_data, test_subjects)

# Requirement 1 - merge  both training and test datasets
full_wearable_dataset <- rbind(labelled_training_data, labelled_test_data)

# requirement 3 - tidy data - every row containly only one observation 
# tidy - columns gathered to just feature, value, subject id, activity name.
tidy_wearable_dataset <- gather(full_wearable_dataset, "feature", "value", 1:561)

#Requirement 2 - only mean and sd
# Filter only feature measurments that reflect the mean or sd. 
first_order_measurements_only <- tidy_wearable_dataset %>%
  filter(grepl('mean|std', feature)==TRUE)


# Requirement 5
# Analysis - average each variable, for each activity, for each subject. 
average_per_subject_activity_feature <- first_order_measurements_only %>%
  group_by(subject_id, activity_name, feature) %>%
  summarise(Mean = mean(value, na.rm=TRUE)) %>%
  ungroup()

