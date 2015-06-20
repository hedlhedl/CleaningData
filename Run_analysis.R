library(dplyr)

#load data from file
colname<-read.table("features.txt")
traindata<-read.table("./train/X_train.txt")
trainact<-read.table("./train/y_train.txt")
trainsub<-read.table("./train/subject_train.txt")
testdata<-read.table("./test/X_test.txt")
testact<-read.table("./test/y_test.txt")
testsub<-read.table("./test/subject_test.txt")
activitydata<-read.table("activity_labels.txt")

#Step 1: merge training and test data
databody<-rbind(traindata,testdata)

#Step 2: extract only mean and std data for each measurement
#Step 2a: get the relevant columns by searching for mean and std in the column names from feature.txt
extractmean<-grepl("-mean()",colname[,2],fixed=TRUE)
extractstd<-grepl("--std()",colname[,2],fixed=TRUE)
extract<-extractmean|extractstd
#Step 2b: extract data based on this criteria
extractdata<-databody[,extract]

#Step 4: add descriptive column names to the data set
colnames(extractdata)<-colname[extract,2]

#Step 3a: merge with activity tagging
row_act_origin<-rbind(trainact,testact)
row_act_add_seq<-data.frame(id=seq_len(nrow(row_act_origin)),row_act_origin)
row_act_des<-merge(row_act_add_seq,activitydata,sort=FALSE)
row_act<-row_act_des[order(row_act_des$id),]
Activity<-row_act[,3]
#Step 3b: add descriptive row name as activity
Activitydata<-cbind(Activity,extractdata)

#Step 5:bind with subject data
subdata<-rbind(trainsub,testsub)
totaldata<-cbind(subdata,Activitydata)
colnames(totaldata)[1]<-"Subject"

#Step 6:generate mean data for all variables for each activity, each subject
dataset<-aggregate(totaldata[,3:35],by=list(totaldata$Subject,totaldata$Activity),FUN=mean)
colnames(dataset)[1]<-"Subject"
colnames(dataset)[2]<-"Activity"

#finish, export the clean data to txt file
write.table(dataset,file="cleandata.txt",row.names = FALSE)
