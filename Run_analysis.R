
# download the file
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile = "./data/Dateset.zip",method = "curl")
#######
# get the data
#######

## get feature data
data_fea_test <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\test\\X_test.txt",header = FALSE)
data_fea_train <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\train\\X_train.txt",header = FALSE)

## get subject data 
data_sub_test <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\test\\subject_test.txt",header = FALSE)
data_sub_train <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\train\\subject_train.txt",header = FALSE)

## get activity data
data_act_test <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\test\\y_test.txt",header = FALSE)
data_act_train <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\train\\y_train.txt",header = FALSE)


# Merge training and testing dataset 
data_sub <- rbind(data_sub_train,data_sub_test)
data_act <- rbind(data_act_train,data_act_test)
data_fea <- rbind(data_fea_train,data_fea_test)

# name the columns
feature_name <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\features.txt")
names(data_fea) <- feature_name$V2

names(data_sub) <- "Subject"
names(data_act) <- "Activity"

#merge by columns
Data <- cbind(data_fea,data_sub,data_act)

#########
# extract only the measurements on the mean and std for each measurement
#########
mean_std_index <- grep("\\bmean\\b|\\bstd\\b",names(Data),ignore.case = TRUE)

Data_new <- Data[,c(mean_std_index,562,563)]

########
# use descriptive activity names to name the activities
########

activity_lable <- read.table("C:\\Users\\teren\\OneDrive\\Desktop\\Coursera\\week4 peer grading\\data\\UCI HAR Dataset\\activity_labels.txt")

Data_new$Activity <- as.character(Data_new$Activity)
for (i in 1:6) {
  Data_new$Activity[Data_new$Activity == i] <- as.character(activity_lable[i,2])
}
Data_new$Activity <- as.factor(Data_new$Activity)

#########
# appropriately labels the dataset columns name 
########
names(Data_new)<-gsub("^t", "time", names(Data_new))
names(Data_new)<-gsub("^f", "frequency", names(Data_new))
names(Data_new)<-gsub("Acc", "Accelerometer", names(Data_new))
names(Data_new)<-gsub("Gyro", "Gyroscope", names(Data_new))
names(Data_new)<-gsub("Mag", "Magnitude", names(Data_new))
names(Data_new)<-gsub("BodyBody", "Body", names(Data_new))

####
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
####
Data_new$Subject <- as.factor(Data_new$Subject)
library(plyr)
Data_new_2 <- aggregate(.~ Subject + Activity, Data_new,mean)
Data_new_2 <- Data_new_2[order(Data_new_2$Subject,Data_new_2$Activity),]
write.table(Data_new_2, file = "Data_new_2.txt", row.names = FALSE)








