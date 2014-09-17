getdata
=======

Course project for Coursera Getting and Cleaning Data course 201409
Describes how the script works

1) The script starts by loading the libraries tidyr and dplyr

2) I manually downloaded and unzipped the data files in my working directory (instructions did not say that this part had to be scripted).  They are in the subdirectory "UCI HAR Dataset" in the hierarchies as per the original unzipped files.

3) I gave the file name/path for each file needed a semi-descriptive variable name

4) Read each file needed into a data frame, adding column names from other files or hardcoded as appropriate (features were column names for the measurements)

- Only loaded the x data when it wasn't there as it took a long time to load

5) Combine the y labels (which activity) with the x measurements and subject number in a dataframe 
(do 4 and 5 for both training (n) and test (s)  data)

6) I set a column in the dataframe to identify if it was testing or training data since I didn't know if we'd need to differentiate.  I never used it.

7) I rowbinded the test and training data (they had the same columns) - if the subject #'s in test and train data overlapped and were different people then I might have done something wrong, but I didn't see anything in the instructions that made any differentiation, so subject 1 was grouped together in test and train.
If they needed to be separated I would have needed to mutate the Subject column to be a merge of subject ID and test/train.


8) I converted this to a data table to use dplyr functions then selected only the columns that contained mean or std.  
Contains did not seem to differentiate between mean() and meanFreq but discussion said it was OK to include meanFreq if you explained it, so I am considering meanFreq as a column we wanted too.

9) Then I realized I hadn't added the activity names, so I did

10) Finally, I used aggregate with mean to get the average of the columns over Subject and Activity and wrote it to a file
