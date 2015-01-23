# jhdss_gacd_project
Project for the course "Getting and Cleaning Data" of the Data Science specialization offered by Johns Hopkins.

The run_analysis.R file performs all the steps necessary to read in the file and produce a tidy summary that includes the means for all of the mean and std data columns in the original data sets. I'll outline those steps here.

Asumption: the run_analysis.R file is in the same folder as the following files:
* activity_labels.txt
* features.txt
* subject_test.txt
* subject_train.txt
* X_test.txt
* X_train.txt
* y_test.txt
* y_train.txt

These can be extract from the zip file found at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The steps performed by run_analysis.R are:

1. Read in the features and activities
2. For each set:
..1. Read in the subject and y data files, applying a column name to each
..2. Read in the X data file and set its column names to features
..3. Combine all the columns from the x, y and subject sets into a single data frame
..4. Merge the activity names into the data frame
3. Combine the rows from the train and test sets
4. Use grep to determine the relevant columns
5. Use tolower and gsub to clean up the column names (make lower case and remove periods)
6. Update column names to be descriptive (e.g. replace "acc" with "acceleration", etc)
7. Save the resulting data frame to a file, so that re-running the script will be faster.
8. Build a new data frame with the same columns and with a single row for each subject and activity, where the value in a data column	is the mean for that column for the given subject and activity
9. Save the new data frame to a file

The resulting file, named "means_by_activity_and_subject.txt", is available in this repository, along with a markdown codebook "means_by_activity_and_subject__codebook.md" describing the data.
