# run_analysis.R
# Author: necessary-ambiguity


#source("getdata.R")

main <- function() {
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
			filename <- "activity_labels.txt"
			columns <- c(idactivity, activityname)
			read.table(filename, sep=" ", col.names=columns)
		}
		readfeatures <- function() {
			filename <- "features.txt"
			columns <- c(idfeature, featurename)
			features <- read.table(filename, sep=" ", col.names=columns)
			features$feature
		}
		readdatasets <- function(setname, activities, features) {
			subjectsname <- "subject"
			activitiesname <- "y"
			xname <- "X"
			ext <- ".txt"

			columns <- c(idsubject)
			subjects <- read.table(paste0(subjectsname, setname, ext), col.names=columns)

			columns <- c(idactivity)
			idactivities <- read.table(paste0(activitiesname, setname, ext), col.names=columns)

			xvalues <- read.table(paste0(xname, setname, ext), col.names=features)

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

	# Appropriately labels the data set with descriptive variable names.
		assigndescriptivenames <- function(df) {
			names(df) <- gsub(".", "", tolower(names(df)), fixed=TRUE)
			df
		}
		dfresults <- assigndescriptivenames(dfresults )

		write.table(dfresults, file=temporaryfile, row.names=FALSE)
		dfresults
	}

	if (!file.exists(temporaryfile)) {
		dfresults <- getdata()
	} else {
		dfresults <- read.table(temporaryfile, header=TRUE)
	}

	# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	tidydata <- function(df) {
		aggregate(x=df[,3:ncol(df)], by=list(subject=df$idsubject, activity=df$activity), FUN="mean")
	}
	dfresults <- tidydata(dfresults)

	dfresults
}

dftidy <- main()
filename <- "means_by_activity_and_subject.txt"
write.table(dftidy, file=filename, row.names=FALSE)