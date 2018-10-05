library(tidyverse)
library(dplyr)
library(DT)
library(shiny)
library(googleVis)
library(ggplot2)
library(ggthemes)
devtools::install_github("jcheng5/bubbles")  # Load a developer version bubble plot
library(plotly)

# read in the csv file
survey_data = read_csv("./survey_data_0722fnl01.csv")

####### Data Manipulation, convert the categorical data into factor #############

survey_data$SkipMeals <- factor(survey_data$SkipMeals, levels = c("Never", "1~2/wk", "3~4/wk","Daily"))

survey_data$Exercise <- factor(survey_data$Exercise, levels = c("Rarely", "1~2/wk", "3~4/wk","Daily"))

survey_data$HoursComputer <- factor(survey_data$HoursComputer, levels = c("<1", "1~4", "5~8","9~12", ">12"))

survey_data$JobSatisfaction = as.factor(survey_data$JobSatisfaction)

survey_data$JobSatisfaction <- factor(survey_data$JobSatisfaction, levels = c("5", "3", "1","0", "-1", "-3", "-5"))

survey_data$CompanySize <- factor(survey_data$CompanySize, levels = c("<10", "10~19", "20~99","100~499", "500~999", "1k~5k", "5k~10k", "10k+"))

survey_data$SalaryRange <- factor(survey_data$SalaryRange, levels = c("<50k", "50k~100k", "100k~150k","150k~200k", ">200k"))

survey_data$FormalEducation <- factor(survey_data$FormalEducation, levels = c("No degree", "Associate", "Bachelor","Master", "Other doctoral", "Professional"))






