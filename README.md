# BRM Application in Estimating Win Rate in World Championship of League of Legends
Code and report for estimating a team's performance(i.e. Win Rate) in World Championship

# Overview

This repo contains raw and cleaned datasets used in the model, and is created by Zhendong Zhang. In this project, I analyzed DWG's experience in their way to year 2020 world champion in order to get the prior distributions for my Bayesian Regression Model. This model uses the matches data(records) from Season 10 LCK and World Championship for trainning purpose. This repo contains following 3 sections: Input, Output, Script. The raw data is not included since I do not legally own this data.

Input folder contains all the source data.

- Raw data is from: https://oracleselixir.com/tools/downloads. Please choose 2020 Match Data.
- `lck_data.csv` is the cleaned LCK portion of data of 2020.
- `world_data.csv` is the cleaned World Championship portion of data of 2020.

Output folder contains the statistical report and codes.

- `BRM lol.Rmd` is the RMarkdown file for the statistical report, containing the codes used to generating BRM.
- `BRM-lol.pdf` is the PDF version final report

Script folder contains all the scripts of this project.

- `data_cleaning.R` is the script used to clean the raw data of 2020 matches.
