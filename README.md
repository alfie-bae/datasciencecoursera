Hello,

This analysis requires you to run 'run_analysis.R' only. 

This script requires the following packages that do not come with R 3.3 

dplyr
tidyr
data.table 

This script should perform the following tasks -

0. preliminary - download the UCI HAR dataset if required. 

1. load feature labels from features.txt
2. load training and test data into memory, using features to label columns
3. match by index subject labels to training and test data (1-30)
4. match by index activity labels to training and test data
5. replace activity labels (1-6) with activity names (walking, running)
6. tidy data from 561 observations per row to one observation per row
7. filter out only observations that refer to means and standard dev
8. group by feature, subject and activity
9. for each group find the mean of values. 

Please note that due to the size of the datasets involved, this script may take around 3-5 minutes to complete. 

Yours sincerely

Alfie 