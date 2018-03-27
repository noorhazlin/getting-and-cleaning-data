#Read feature and activity file
feature <- read.table("./UCI HAR Dataset/features.txt")[,2]
activity_label<- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#Read test dataset
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

#Read train dataset
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Set labels for X dataset
names(X_test) = feature
names(X_train) = feature

#Extracts only the measurements on the mean and standard deviation for each measurement.
extract_feature <- grepl("mean|std", feature)
X_test = X_test[,extract_feature]
X_train = X_train[,extract_feature]

#Load activity data for y_test dataset
y_test[,2] = activity_label[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

#Bind data
all_data<-as.data.table(subject_test)
test_data <- cbind(all_data, y_test, X_test)
data_train <- cbind(as.data.table(subject_train), y_train, X_train)

#Load activity data for y_train dataset
y_train[,2] = activity_label[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#Merge test and train data
data = rbind(test_data, fill=TRUE,data_train)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./UCI HAR Dataset/tidy_data.txt")
