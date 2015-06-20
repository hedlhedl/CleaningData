Run_analysis.R processes the data in the following order:

1. read all data from downloaded files
2. merge train and test data using rbind
3. read feature.txt for all the data column names
4. filter relevant mean and std columns by searching for these two keywords in the data columns and subset accordingly
5. get the list of activities for each measurement
6. map numeric activity indicators to descriptive activity indicators by merging with activity.labels.txt
7. Restore the sequence order of the original activity list by using order function, because merging function does not preserve the original order of the data frame.
8. combine activity list with the main data set using cbind, the column name for activity is defined as "Activity"
9. done
