# read sensor data
sensor_data<-function(category)
{
    	# read the column names
    	qfile_name <- file.path(".", paste("features", ".txt",sep=""))
    	col_names <- read.table(qfile_name, header=FALSE, as.is=T, col.names=c("MeasureID", "MeasureName"))

	#read sensor data
    	qfile_name <- file.path(category, paste("X_", category, ".txt",sep=""))
    	data <- read.table(qfile_name, header=FALSE, col.names=col_names$MeasureName)
	
	
	# select the columns required
    	req_col_names <- grep(".*mean\\(\\)|.*std\\(\\)", col_names$MeasureName)
	
	data<-data[,req_col_names]


	
}


add_column<-function(data,category)
{
	# read the activitsensory data
    	qfile_name <- file.path(category, paste("y_",category, ".txt",sep=""))
    	activity_table <- read.table(qfile_name, header=FALSE, col.names=c("Activity_ID"))

	#read subject data
    	qfile_name <- file.path(category, paste("subject_",category, ".txt",sep=""))
    	subject_table <- read.table(qfile_name, header=FALSE, col.names=c("Subject_ID"))
	

	# append the activity id and subject id columns
    	data$Activity_ID <- activity_table$Activity_ID
    	data$Subject_ID <- subject_table$Subject_ID
	data
}

merge_data_set<-function()
{


   
    data <- rbind(add_column(sensor_data("train"),"train"), add_column(sensor_data("test"),"test"))
    #cnames <- colnames(data)
    #cnames <- gsub("\\.+mean\\.+", cnames, replacement="Mean")
    #cnames <- gsub("\\.+std\\.+", cnames, replacement="Std")
    #colnames(data) <- cnames
    data
}


apply_descriptive_label <- function(data) {
    descriptive_labels <- read.table("activity_labels.txt", header=FALSE, as.is=TRUE, col.names=c("Activity_ID", "Activity_Name"))
    #descriptive_labels$Activity_Name <- as.factor(descriptive_labels$Activity_Name)
    data_descriptive <- merge(data, descriptive_labels)
    data_descriptive
}
#Wrapper function
create_assignment_data_set<-function(tidy_file)
{
	print("This routine assumes that the extracted files from the zip file \"getdata_projectfiles_UCI HAR Dataset\" are available in \"UCI HAR Dataset\" in the current directory in original structure.")
	print(" Source Data Archive:")
	print(" https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
	print("Creating tidy dataset as tidy_data.csv...")


	tidy_data_set<-apply_descriptive_label(merge_data_set())
	write.table(tidy_data_set,tidy_file)

}


create_assignment_data_set("tidy_data.txt")

print("Data Set created successfully.")

