# ============================================================================ #
# CAPSTONE ASSIGNMENT PART 1: DESCRIBING AND EVALUATING THE DATASET
# Name: [type your name here]
# Student number: [type your student number here]
# ============================================================================ #



# IMPORTANT: PLEASE READ BEFORE BEGINNING YOUR WORK ----------------------------


# NOTE: Type your name and student number in the spaces provided at the top of
# this script.

# NOTE: Make sure you are working within a dedicated R Project folder for the Capstone
# assignment, and that the PolicingMH.csv data file is also in this folder.

# NOTE: This script does not contain code (other than the code to load
# packages). Wherever the script says "INSERT - and run the correct code to...", 
# you must insert and run the code needed to complete that step on the blank lines
# beneath. Use the code and processes taught in the course tutorials.

# NOTE: Some steps only apply under certain conditions. Where a step does not
# apply to this dataset, the instructions will tell you to leave that section
# blank.

# NOTE: Answer every question in this script. Each question begins with
# "QUESTION -" and is followed by "[type your response here]". Replace the
# placeholder with your full answer. Every line of your answer must begin with #
# so that R reads it as a comment rather than code (if a line of your answer
# does not start with #, your script will produce an error when it runs).

# NOTE: Run your code as you go (do not wait until the end to try running
# everything all at once). That way, if you have any errors, you can catch them
# as you work. Save your work regularly.

# NOTE: You do not need to save or submit your graphs separately. We will run
# your script to check that your graphs are produced correctly, so write your
# interpretations in this script, in response to the questions provided.

# NOTE: Before submitting, restart R (Session > Restart R) and click Source to
# run the full script from the top. This confirms your code runs from start to
# finish without errors. Then search the script for "QUESTION" and "type your response 
# here" to make sure you have answered every question. Then save this script and 
# submit it (as an .R file) to the Part 1 Dropbox on LEARN.




# STEP 1: IDENTIFY RQ, VARIABLES OF INTEREST, HYPOTHESES, & BIVARIATE TESTS ----


# QUESTION - Research question:
# What factors are associated with the severity of police use of force when
# responding to mental health crisis calls?

# QUESTION - Name of any independent variable(s) (and variable type):
# dispatch_risk (categorical - ordinal)
# weapon (categorical - nominal)
# co_response (categorical - nominal)
# backup_units (categorical - nominal)
# race (categorical - nominal)
# shift (categorical - nominal)
# subject_distress (numeric - continuous/ratio)
# disadvantage (numeric - continuous/interval)
# pov_rate (numeric - continuous/ratio)
# officer_years (numeric - continuous/ratio)

# QUESTION - Name of dependent variable (and variable type):
# force_severity (numeric - continuous/ratio)

# QUESTION - Null hypothesis (H0):
# The IVs are not associated with force severity.

# QUESTION - Alternative hypothesis (H1):
# The IVs are associated with force severity.

# QUESTION - Name of bivariate test type for each DV-IV pairing:
# dispatch_risk: one-way ANOVA
# weapon: independent-samples t-test
# co_response: independent-samples t-test
# backup_units: independent-samples t-test
# race: one-way ANOVA
# shift: one-way ANOVA
# subject_distress: Pearson's correlation
# disadvantage: Pearson's correlation
# pov_rate: Pearson's correlation
# officer_years: Pearson's correlation




# STEP 2: ESTABLISH THE R ENVIRONMENT ------------------------------------------


# NOTE: You must take these steps at the start of each new R work session.


### LOAD PACKAGES ----


# If it's your first time using any packages below, copy this code into the
# console (without the # at the start) and hit 'enter':
# install.packages(c("readr", "psych", "epiDisplay", "dplyr"))

# Load the packages required for this analysis:

      library(readr)
      library(psych)
      library(epiDisplay)
      library(dplyr)


### IMPORT THE DATASET ----

# NOTE: The CSV file (and this script) must be in the R Project folder you are
# working in.

# INSERT - and run the correct code to read and store your dataset:

df <- read_csv("PolicingMH.csv")



### INSPECT IMPORTED DATASET ----

# INSERT - and run the correct code to view your dataset:

View(df)

# QUESTION - Are there missing values in the original dataset and, if so, how are
# they coded?
# Yes. Missing values are coded as -999.

# INSERT - and run the correct code to obtain an overview of current variable types
# in your dataset:

str(df)

# QUESTION - Are there any variables that need to be transformed from character
# to factor type?
# Yes:
# dispatch_risk
# weapon
# co_response
# backup_units
# race
# shift

# INSERT - and run the correct code to obtain an overview of categorical (character)
# variable levels:

table(df$dispatch_risk)
table(df$weapon)
table(df$co_response)
table(df$backup_units)
table(df$race)
table(df$shift)

# QUESTION - Are there any ordinal variables with levels that need to be re-
# ordered?
# Yes. dispatch_risk is listed as High, Low, Moderate and needs to be
# re-ordered to Low, Moderate, High.



# STEP 3: TRANSFORM DATA (as needed) -------------------------------------------

# NOTE: You must take these steps at the start of each new R work session.


### CREATE CLEAN COPY OF DATASET ----

# INSERT - and run the correct code to create and store a "clean" copy of your dataset:

df_clean <- df



### RE-CODE MISSING VALUES ----

# NOTE: If you have no missing values in your dataset, leave this section blank.

# INSERT - and run the correct code to re-code missing values:

df_clean[df_clean == -999] <- NA


# INSERT - and run the correct code to check the re-coding was successful:

colSums(is.na(df_clean))



### CONVERT CATEGORICAL VARIABLES FROM CHARACTER TO FACTOR TYPE ----

# NOTE: If you have no categorical variables in your dataset, leave this section
# blank.

# INSERT - and run the correct code to convert categorical variables to factor type:

df_clean$dispatch_risk <- as.factor(df_clean$dispatch_risk)
df_clean$weapon <- as.factor(df_clean$weapon)
df_clean$co_response <- as.factor(df_clean$co_response)
df_clean$backup_units <- as.factor(df_clean$backup_units)
df_clean$race <- as.factor(df_clean$race)
df_clean$shift <- as.factor(df_clean$shift)


# INSERT - and run the correct code to check your transformations:

str(df_clean)



### PUT ORDINAL VARIABLE LEVELS IN PROPER ORDER ----

# NOTE: If you have no ordinal variables in your dataset, or all ordinal
# variable groups are listed in proper order, leave this section blank.

# INSERT - and run the correct code to re-order levels for each applicable ordinal
# variable:

df_clean$dispatch_risk <- factor(df_clean$dispatch_risk, levels = c("Low", "Moderate", "High"))


# INSERT - and run the correct code to check your transformations for each re-ordered
# variable:

levels(df_clean$dispatch_risk)





# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (dispatch_risk) -----------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 1" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (dispatch_risk) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$dispatch_risk)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# Moderate is the largest group (186, 41.7%), followed by Low (164, 36.8%).
# High is the smallest group (96, 21.5%). 4 cases are missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (dispatch_risk) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$dispatch_risk)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes.

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# Moderate, with 186 cases.



# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (weapon) ------------------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 2" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (weapon) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$weapon)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# Most cases had no weapon (342, 76.0%). Only 108 cases (24.0%) had a
# weapon. No cases are missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (weapon) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$weapon)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes.

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# No, with 342 cases.



# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (co_response) -------------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 3" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (co_response) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$co_response)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# No (243, 54.0%) is somewhat larger than Yes (207, 46.0%). No cases are
# missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (co_response) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$co_response)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes.

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# No, with 243 cases.



# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (backup_units) ------------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 4" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (backup_units) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$backup_units)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# Almost an even split: No (225, 50.3%) and Yes (222, 49.7%). 3 cases are
# missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (backup_units) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$backup_units)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes. No is the highest group, but only 3 cases more than Yes.

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# No, with 225 cases.



# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (race) --------------------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 5" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (race) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$race)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# White is by far the largest group (283, 64.0%), followed by Black
# (84, 19.0%) and Other (75, 17.0%). 8 cases are missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (race) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$race)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes.

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# White, with 283 cases.



# STEP 4A: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (shift) -------------------

# NOTE: Be sure to specify which categorical variable you are working with by
# replacing "Variable 6" in the parentheses following the STEP 4A heading above,
# and each subsequent sub-heading below.


### OBTAIN TABLE AND VISUAL PLOT FOR CATEGORICAL VARIABLE (shift) ----

# INSERT - and run the correct code to obtain a frequency table and bar chart for
# a categorical variable:

tab1(df_clean$shift)

# QUESTION - Use the frequency table and bar chart you obtained to comment on the
# general shape of the categorical variable's distribution:
# Cases are spread fairly evenly: Evening (159, 35.7%), Day (150, 33.6%)
# and Overnight (137, 30.7%). 4 cases are missing.


### OBTAIN DESCRIPTIVES FOR CATEGORICAL VARIABLE (shift) ----

# INSERT - and run the correct code to extract the mode of a categorical variable
# from frequency table:

names(which.max(table(df_clean$shift)))

# NOTE: After running the above code, use your frequency table to determine
# whether your categorical variable is unimodal or bimodal/multimodal.

# QUESTION - Is the variable unimodal?
# Yes. Evening is the highest group, but all three shifts are nearly even
# (35.7%, 33.6%, 30.7%).

# QUESTION - What is the mode (or modes) and how many cases fall within that
# category?
# Evening, with 159 cases.



# STEP 4B: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (force_severity) ----------

# NOTE: Be sure to specify which numeric variable you are working with by
# replacing "Variable 7" in the parentheses following the STEP 4B heading above,
# and each subsequent sub-heading below.


### OBTAIN VISUAL PLOT FOR NUMERIC VARIABLE (force_severity) ----

# INSERT - and run the correct code to obtain a histogram for a numeric variable:

hist(df_clean$force_severity)

# QUESTION - Use the histogram you obtained to comment on the general shape of
# the numeric variable's distribution:
# Roughly bell-shaped, with one peak around 45 to 50 and a slightly longer
# right tail.


### OBTAIN DESCRIPTIVES FOR NUMERIC VARIABLE (force_severity) ----

# INSERT - and run the correct code to obtain descriptive values for a numeric variable:

describe(df_clean$force_severity, IQR = TRUE)

# QUESTION - What are the mean and median values of the numeric variable, and
# what do they tell us?
# The average force severity score is 49.97 and the middle score is 48.40.
# Because they are close, the distribution is roughly symmetric.

# QUESTION - What is the minimum and maximum value, and range, of the numeric
# variable?
# Min = 25.9, max = 82.4, range = 56.5.

# QUESTION - What is the IQR of the numeric variable, and what does it tell us?
# IQR = 16.55. The middle 50% of cases span 16.55 points.

# QUESTION - What is the standard deviation of the numeric variable, and what
# does it tell us?
# SD = 11.32. Scores typically fall about 11.32 points from the mean.

# QUESTION - If the numeric variable is normally distributed, between what two
# values should approx. 95% of the data fall?
# Between 27.32 and 72.62 (mean +/- 2 SD).

# QUESTION - What are the skew and kurtosis values for the numeric variable?
# Skew = 0.36, kurtosis = -0.40.

# QUESTION - Does the numeric variable appear normally distributed, and why or
# why not?
# Yes. Skew and kurtosis are both between -1 and 1, and the histogram is
# roughly bell-shaped.

# QUESTION - What is the best measure of central tendency for the numeric
# variable, and why?
# Mean, because the distribution is approximately normal.



# STEP 4B: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (subject_distress) --------

# NOTE: Be sure to specify which numeric variable you are working with by
# replacing "Variable 8" in the parentheses following the STEP 4B heading above,
# and each subsequent sub-heading below.


### OBTAIN VISUAL PLOT FOR NUMERIC VARIABLE (subject_distress) ----

# INSERT - and run the correct code to obtain a histogram for a numeric variable:

hist(df_clean$subject_distress)

# QUESTION - Use the histogram you obtained to comment on the general shape of
# the numeric variable's distribution:
# Roughly symmetric, with one broad peak around 40 to 50. It is fairly flat,
# with scores spread widely from about 5 to 93.


### OBTAIN DESCRIPTIVES FOR NUMERIC VARIABLE (subject_distress) ----

# INSERT - and run the correct code to obtain descriptive values for a numeric variable:

describe(df_clean$subject_distress, IQR = TRUE)

# QUESTION - What are the mean and median values of the numeric variable, and
# what do they tell us?
# The average subject distress score is 49.22 and the middle score is 48.40.
# Because they are close, the distribution is roughly symmetric.

# QUESTION - What is the minimum and maximum value, and range, of the numeric
# variable?
# Min = 5.1, max = 92.9, range = 87.8.

# QUESTION - What is the IQR of the numeric variable, and what does it tell us?
# IQR = 32.40. The middle 50% of cases span 32.40 points.

# QUESTION - What is the standard deviation of the numeric variable, and what
# does it tell us?
# SD = 20.73. Scores typically fall about 20.73 points from the mean.

# QUESTION - If the numeric variable is normally distributed, between what two
# values should approx. 95% of the data fall?
# Between 7.76 and 90.68 (mean +/- 2 SD).

# QUESTION - What are the skew and kurtosis values for the numeric variable?
# Skew = 0.12, kurtosis = -0.91.

# QUESTION - Does the numeric variable appear normally distributed, and why or
# why not?
# Yes. Skew and kurtosis are both between -1 and 1, and the histogram is
# roughly symmetric.

# QUESTION - What is the best measure of central tendency for the numeric
# variable, and why?
# Mean, because the distribution is approximately normal.



# STEP 4B: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (disadvantage) ------------

# NOTE: Be sure to specify which numeric variable you are working with by
# replacing "Variable 9" in the parentheses following the STEP 4B heading above,
# and each subsequent sub-heading below.


### OBTAIN VISUAL PLOT FOR NUMERIC VARIABLE (disadvantage) ----

# INSERT - and run the correct code to obtain a histogram for a numeric variable:

hist(df_clean$disadvantage)

# QUESTION - Use the histogram you obtained to comment on the general shape of
# the numeric variable's distribution:
# Roughly symmetric and bell-shaped, with one broad peak around 40 to 60.


### OBTAIN DESCRIPTIVES FOR NUMERIC VARIABLE (disadvantage) ----

# INSERT - and run the correct code to obtain descriptive values for a numeric variable:

describe(df_clean$disadvantage, IQR = TRUE)

# QUESTION - What are the mean and median values of the numeric variable, and
# what do they tell us?
# The average neighbourhood disadvantage score is 49.73 and the middle score
# is 49.15. Because they are close, the distribution is roughly symmetric.

# QUESTION - What is the minimum and maximum value, and range, of the numeric
# variable?
# Min = 9.4, max = 89.7, range = 80.3.

# QUESTION - What is the IQR of the numeric variable, and what does it tell us?
# IQR = 26.72. The middle 50% of cases span 26.72 points.

# QUESTION - What is the standard deviation of the numeric variable, and what
# does it tell us?
# SD = 18.31. Scores typically fall about 18.31 points from the mean.

# QUESTION - If the numeric variable is normally distributed, between what two
# values should approx. 95% of the data fall?
# Between 13.12 and 86.35 (mean +/- 2 SD).

# QUESTION - What are the skew and kurtosis values for the numeric variable?
# Skew = 0.07, kurtosis = -0.73.

# QUESTION - Does the numeric variable appear normally distributed, and why or
# why not?
# Yes. Skew and kurtosis are both between -1 and 1, and the histogram is
# roughly bell-shaped.

# QUESTION - What is the best measure of central tendency for the numeric
# variable, and why?
# Mean, because the distribution is approximately normal.



# STEP 4B: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (pov_rate) ----------------

# NOTE: Be sure to specify which numeric variable you are working with by
# replacing "Variable 10" in the parentheses following the STEP 4B heading above,
# and each subsequent sub-heading below.


### OBTAIN VISUAL PLOT FOR NUMERIC VARIABLE (pov_rate) ----

# INSERT - and run the correct code to obtain a histogram for a numeric variable:

hist(df_clean$pov_rate)

# QUESTION - Use the histogram you obtained to comment on the general shape of
# the numeric variable's distribution:
# Roughly symmetric and bell-shaped, with one peak around 15 to 25.


### OBTAIN DESCRIPTIVES FOR NUMERIC VARIABLE (pov_rate) ----

# INSERT - and run the correct code to obtain descriptive values for a numeric variable:

describe(df_clean$pov_rate, IQR = TRUE)

# QUESTION - What are the mean and median values of the numeric variable, and
# what do they tell us?
# The average neighbourhood poverty rate is 20.88% and the middle rate is
# 20.80%. Because they are close, the distribution is roughly symmetric.

# QUESTION - What is the minimum and maximum value, and range, of the numeric
# variable?
# Min = 1.5, max = 37.5, range = 36.0.

# QUESTION - What is the IQR of the numeric variable, and what does it tell us?
# IQR = 10.45. The middle 50% of cases span 10.45 percentage points.

# QUESTION - What is the standard deviation of the numeric variable, and what
# does it tell us?
# SD = 7.10. Values typically fall about 7.10 percentage points from the
# mean.

# QUESTION - If the numeric variable is normally distributed, between what two
# values should approx. 95% of the data fall?
# Between 6.69 and 35.08 (mean +/- 2 SD).

# QUESTION - What are the skew and kurtosis values for the numeric variable?
# Skew = 0.04, kurtosis = -0.54.

# QUESTION - Does the numeric variable appear normally distributed, and why or
# why not?
# Yes. Skew and kurtosis are both between -1 and 1, and the histogram is
# roughly bell-shaped.

# QUESTION - What is the best measure of central tendency for the numeric
# variable, and why?
# Mean, because the distribution is approximately normal.



# STEP 4B: OBTAIN VISUALS AND DESCRIPTIVE STATISTICS (officer_years) -----------

# NOTE: Be sure to specify which numeric variable you are working with by
# replacing "Variable 11" in the parentheses following the STEP 4B heading above,
# and each subsequent sub-heading below.


### OBTAIN VISUAL PLOT FOR NUMERIC VARIABLE (officer_years) ----

# INSERT - and run the correct code to obtain a histogram for a numeric variable:

hist(df_clean$officer_years)

# QUESTION - Use the histogram you obtained to comment on the general shape of
# the numeric variable's distribution:
# Right-skewed. Most officers have under 4 years of service, with a long
# tail out to about 19 years.


### OBTAIN DESCRIPTIVES FOR NUMERIC VARIABLE (officer_years) ----

# INSERT - and run the correct code to obtain descriptive values for a numeric variable:

describe(df_clean$officer_years, IQR = TRUE)

# QUESTION - What are the mean and median values of the numeric variable, and
# what do they tell us?
# The average officer has 4.74 years of service and the middle officer has
# 3.00 years. Because the mean is higher than the median, the distribution is
# right-skewed.

# QUESTION - What is the minimum and maximum value, and range, of the numeric
# variable?
# Min = 0.6, max = 18.9, range = 18.3.

# QUESTION - What is the IQR of the numeric variable, and what does it tell us?
# IQR = 5.73. The middle 50% of cases span 5.73 years.

# QUESTION - What is the standard deviation of the numeric variable, and what
# does it tell us?
# SD = 4.30. Values typically fall about 4.30 years from the mean.

# QUESTION - If the numeric variable is normally distributed, between what two
# values should approx. 95% of the data fall?
# Between -3.86 and 13.33 (mean +/- 2 SD).

# QUESTION - What are the skew and kurtosis values for the numeric variable?
# Skew = 1.19, kurtosis = 0.47.

# QUESTION - Does the numeric variable appear normally distributed, and why or
# why not?
# No. Skew is above 1, and the histogram is right-skewed.

# QUESTION - What is the best measure of central tendency for the numeric
# variable, and why?
# Median, because the distribution is skewed.



# END OF SCRIPT