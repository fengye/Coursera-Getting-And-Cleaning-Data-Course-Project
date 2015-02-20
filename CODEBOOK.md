# CODE BOOK

ORIGINAL DATA PAGE
==================
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

DATA OBTAINED FROM
==================
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

DATA PROCESSING PROCEDURE
=========================
1. Read the "X", "y", and "subject" data from "dataset/train" and "dataset/test" directory respectively
2. Concate them using rbind() into data frame Xdf, ydf and subjectdf respectively. Xdf is a 10299x561 data frame. ydf is a 10299x1 data frame. subjectdf is a 10299x1 data frame.
3. Read the "feature" data from "dataset/features.txt" into data frame featuredf. featuredf is a 561x2 data frame.
4. Assign featuredf's human readable name as Xdf's column name
5. Find the standard deviation and mean column, by grep() the column name. This results in a vector with length of 66, stored in varaible feature_indices
6. Filter and subsetting the Xdf using feature_indices. This results in a 10299x66 data frame, stored in variable MeanAndStdXdf
7. Reading the "activity label" data from "dataset/activity_labels.txt" into data frame activitydf. activitydf is a 6x2 data frame.
8. Replace ydf's activity index value with activity label text from activitydf, and assign "Activity" as the column name of ydf
9. cbind subjectdf, ydf and MeanAndStdXdf into data frame combineddf, and assign "Subject" as the name of the first column of combineddf. combineddf is a 10299x68 data frame.
10. Write combineddf as "merge_output.txt" using write.table() as intermediate results
11. Loop through every subject(30 in total) and every activity(6 in total),
11.1 	Select the rows from combineddf with corresponding subject and activity
11.2    If the rows is not empty, then calculate the means of every column except the "Subject" and "Activity", and stored in data frame called CatDatadf
12. Got CatDatadf as a 180x68 data frame.
13. Write CatDatadf as "merge_output2.txt" using write.tabe() as the final results.
