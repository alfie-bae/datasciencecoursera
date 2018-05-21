
# Script workflow -

1. load feature labels from features.txt
2. load training and test data into memory, using features to label columns
3. match by index subject labels to training and test data (1-30)
4. match by index activity labels to training and test data
5. replace activity labels (1-6) with activity names (walking, running)
6. tidy data from 561 observations per row to one observation per row
7. filter out only observations that refer to means and standard dev
8. group by feature, subject and activity
9. for each group find the mean of values. 

#Required packages - 

dplyr - data manipulation and chaining operations. 
tidyr - gathering data easily into tidy format 

## Step 1 - load in training and test data 

training_data - dataframe - retrieved from X_train.txt 
                          - 7352 records where each record is a 561 feature vector
                          - each feature vector represents all measurments for one activity. 
                          - No features are labelled in source data

test_data - dataframe - retrieved from X_test.txt
                      - 2947 records where each record is a 561 feature vector
                      - each feature vector represents all measurments taken for one activity
                      - no features are labelled in source data.
                      

Note: both training and test data have no field names in source data.  
      The feature relating to each column is stored in a seperate file - features.txt 
    

features - character vector - retrieved from features.txt
                            - 561 values in length where each character represents one feature name. 
                            
                            
I loaded training and test data using read.table 
while providing the function with the col.names = features vector as an argument.
This meant that both datasets loaded into memory with their correct field names. 

## Step 2 - matching each observation to a subject id (1-30)

Subject labels are held in companion files - subject_train.txt and subject_test.txt
These are index matched so that rows match by their placement.

For example, row 1 of subject_train.txt refers to row 1 of training_data

training_subjects - dataframe - dimensions are 1x7352 
                              - source file is subject_train.txt
                              - Integer values 1-30 where each value refers to a test subject. 
                              - this data frame is index matched to training_data
                              - each row in training subjects refers to the same row in training data
                                 
test_subjects - dataframe - dimensions 1x2947
                          - source file is subject_test.txt
                          - Integer values 1-30 where each value refers to a test subject. 
                          - this data is index matched to test_data
                          - each row in test_subjects refers to the same row in test data
                            
        
I used cbind to add training and test subjects onto their companion dataframes
This allowed me to match each feature vector to one subject. 

## Step 3 - label each feature vector with an activity label (1-6)

similar to labelling each vector with a subject label, 
I labelled each feature vector with an activity name. 

I had to do this by a two-part operation. 

training_activity_labels - dataframe - 1x7352 - companion dataset to training_data
                                              - loaded from y_train.txt
                                              - index matched to training data
                                              - where each row in training activity data refers to
                                              - same row in training data. 
                                              - integer values 1-6

test_activity_labels - - dataframe - 1x7352 - companion dataset to test_data
                                              - loaded from y_test.txt
                                              - index matched to test data
                                              - where each row in test activity data refers to
                                              - same row in test data. 
                                              - integer values 1-6

Again, as these are index matched dataframes, I used cbind to append
training and test activity labels onto their companion datasets.

## Step 4 - replacing feature labels (1-6) with feature names (walking, running)

activities - dataframe - 2x6 dataframe - static config dataframe -
                                       - 2 columns, feature label and activity name 
                                       - loaded from activities.txt

I used a left_join (dplyr) operation to match an activity name for every activity label. 

## Step 5 - merge test and train datasets

full_wearable_dataset - dataframe 10299 (7352 + 2947) x 564 observations   
                      - each row is a 561 feature vector and our 3 new labels 
                      - these labels being subject, activity label, activity name 
                      - combines both training and test data

As training data and test data have identical fields, 
I used the standard rbind operation to append test_data onto the bottom of training_data

## Step 6 - tidy data to one observation per row

tidy_wearable_dataset - 5777739 x 5
                      - feature, value, subject, activity label, activity name 
                      - one row per observation for all training and test data. 

A tidy format is one observation per row. 
This means that each of the 561 observations should be one row in tidy dataset.
As the labels refer to each observation, they can stay as additional columns.

I used the tidyr function 'gather' to compress the dataset into tidy format
with 'feature' and 'value' as our two new tidy fields. 

## Step 7 - filter out only mean and std features


first_order_measurements_only - dataframe - 813621 x 5
                              - only features that represent means or standard deviations 

Once tidy, it was a trivial job to filter out only the features that refer to 
standard deviation and average measumrents. 

I used the dplyr function 'filter' combined with grepl to match 
on features that contained 'mean' or 'std' in their names. 

# ## Step 8 and 9 - For each feature, find the mean per subject and activity.

average_per_subject_activity_feature - 14220 x 4 -
                                     - Feature, subject, activity name, mean 
                                   


I used dplyr's group by to group first_order_measurments_only by activity, feature, subject
I then used summarise to get the mean for the value field for each group. 


