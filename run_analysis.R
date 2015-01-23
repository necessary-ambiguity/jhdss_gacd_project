# run_analysis.R
# Author: necessary-ambiguity


#source("getdata.R")

main <- function(forceRead=FALSE) {
	temporaryfile <- "mergeddata.csv"
	getdata <- function() {
		testname <- "_test"
		trainname <- "_train"

		idsubject <- "idsubject"

		idactivity <- "idact"
		activityname <- "activity"

		idfeature <- "idfeature"
		featurename <- "feature"

		readactivities <- function() {
	# Get the list of activity labels
			filename <- "activity_labels.txt"
			columns <- c(idactivity, activityname)
			df <- read.table(filename, sep=" ", col.names=columns)
	# Tidy the activity names
			df[, activityname] <- gsub("_", "", tolower(df[, activityname]), fixed=TRUE)
			df

		}
		readfeatures <- function() {
	# Get the list of features (names of the measurement columns)
			filename <- "features.txt"
			columns <- c(idfeature, featurename)
			df <- read.table(filename, sep=" ", col.names=columns)
			df[, featurename]
		}
		readdatasets <- function(setname, activities, features) {
			subjectsname <- "subject"
			activitiesname <- "y"
			xname <- "X"
			ext <- ".txt"

	# Read in the subjects (single column)
			columns <- c(idsubject)
			subjects <- read.table(paste0(subjectsname, setname, ext), col.names=columns)

	# Read in the activities (single column)
			columns <- c(idactivity)
			idactivities <- read.table(paste0(activitiesname, setname, ext), col.names=columns)

	# Read in the measurements (many columns)
			xvalues <- read.table(paste0(xname, setname, ext), col.names=features)

	# Combine all the columns into a single data frame
			xvalues <- cbind(idactivities, xvalues)
			xvalues <- cbind(subjects, xvalues)

	# Uses descriptive activity names to name the activities in the data set
			xvalues <- merge(xvalues, activities)

			xvalues
		}
		activities <- readactivities()
		features <- readfeatures()
		dftest <- readdatasets(testname, activities, features)
		dftrain <- readdatasets(trainname, activities, features)

	# Merges the training and the test sets to create one data set.
		mergedata <- function(dftrain, dftest) {
			results <- rbind(dftest, dftrain)
		}
		dfresults <- mergedata(dftrain, dftest)
		dftest <- NULL
		dftrain <- NULL

	# Extracts only the measurements on the mean and standard deviation for each measurement.
		extractrelevantmeasurements <- function(df) {
			# return only the columns we care about

			df[, c("idsubject", "activity", grep("(.mean...[XYZ]|.std...[XYZ]|.mean..|.std..)$", names(df), value=TRUE))]
		}
		dfresults <- extractrelevantmeasurements(dfresults)

		write.table(dfresults, file=temporaryfile, row.names=FALSE)
		dfresults
	}

	if (!file.exists(temporaryfile)) {
		dfresults <- getdata()
	} else {
		dfresults <- read.table(temporaryfile, header=TRUE)
	}

	# Appropriately labels the data set with descriptive variable names.
	assigndescriptivenames <- function(df) {
		names(df) <- gsub(".", "", tolower(names(df)), fixed=TRUE)
		names(df) <- gsub("tbody", "timebody", names(df), fixed=TRUE)
		names(df) <- gsub("tgravity", "timegravity", names(df), fixed=TRUE)
		names(df) <- gsub("fbody", "frequencybody", names(df), fixed=TRUE)
		names(df) <- gsub("fgravity", "frequencygravity", names(df), fixed=TRUE)

		names(df) <- gsub("acc", "accelerometer", names(df), fixed=TRUE)
		names(df) <- gsub("gyro", "gyroscope", names(df), fixed=TRUE)
		names(df) <- gsub("mag", "magnitude", names(df), fixed=TRUE)
		
		names(df) <- gsub("std", "standarddeviation", names(df), fixed=TRUE)
		df
	}
	dfresults <- assigndescriptivenames(dfresults)


	# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	tidydata <- function(df) {
		aggregate(x=df[,3:ncol(df)], by=list(subject=df$idsubject, activity=df$activity), FUN="mean")
	}
	dfresults <- tidydata(dfresults)

	dfresults
}

dftidy <- main(TRUE)
filename <- "means_by_activity_and_subject.txt"
write.table(dftidy, file=filename, row.names=FALSE)