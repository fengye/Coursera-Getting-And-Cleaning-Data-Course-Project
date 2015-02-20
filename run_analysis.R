# 1. Merges the training and the test sets to create one data set.

# create data frame objects
Xdf <- data.frame()
ydf <- data.frame()
subjectdf <- data.frame()
dataDir <- "dataset/"

# loop folders, add folders in the following lines if new data set added
folders = c("test", "train")
for (folder in folders)
{
	filename <- paste(c(dataDir, folder, "/X_", folder, ".txt"), collapse="")
	print(paste("Reading", filename))
	Xdf <- rbind(Xdf, read.table(filename, sep="", strip.white=TRUE))

	filename <- paste(c(dataDir, folder, "/y_", folder, ".txt"), collapse="")
	print(paste("Reading", filename))
	ydf <- rbind(ydf, read.table(filename, sep="", strip.white=TRUE))

	filename <- paste(c(dataDir, folder, "/subject_", folder, ".txt"), collapse="")
	print(paste("Reading", filename))
	subjectdf <- rbind(subjectdf, read.table( filename, sep="", strip.white=TRUE))
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
print("Reading features.txt")
featuredf <- read.table(paste(c(dataDir, "features.txt"), collapse=""), sep="", strip.white=TRUE)
print("Finding mean and standard deviation columns")
colnames(Xdf) <- featuredf[,2]
feature_indices <- c(grep(c("mean\\(\\)"), featuredf[,2]), grep(c("std\\(\\)"), featuredf[,2]))
print("Subsetting mean and standard deviation")
MeanAndStdXdf <- Xdf[feature_indices]

# 3. Uses descriptive activity names to name the activities in the data set
print("Reading activity_labels.txt")
activitydf <- read.table(paste(c(dataDir, "activity_labels.txt"), collapse=""), sep="", strip.white=TRUE)
activity_txt_vec <- activitydf[ydf[,1],2]
ydf[,1] <- activity_txt_vec
colnames(ydf) <- c("Activity")

# 4. Appropriately labels the data set with descriptive variable names. 
combineddf <- cbind(subjectdf, ydf, MeanAndStdXdf)
colnames(combineddf)[1] <- "Subject"
print("Writing merge_output.txt")
write.table(combineddf, "merge_output.txt", sep=" ", row.name=FALSE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
CatDatadf <- data.frame()
subjectCount <- length(unique(subjectdf[,1]))
# for every subject
for (subjectIndex in 1:subjectCount)
{
	# for every activity
	for(activityIndex in activitydf[,2])
	{
		selection <- combineddf$Subject==subjectIndex & combineddf$Activity==activityIndex
		# matched rows
		rows <- combineddf[selection, ]
		if (nrow(rows) > 0)
		{
			cat(".")
			CatDatadf <- rbind(CatDatadf, data.frame(c(rows[1,1:2], colMeans(rows[, 3:ncol(rows)]))))
		}
		else
		{
			cat("_")
		}
	}
}
print("Assigning column names")
# assign column names
colnames(CatDatadf) <- colnames(combineddf)

print("Writing merge_output2.txt")
write.table(CatDatadf, "merge_output2.txt", sep=" ", row.name=FALSE)
