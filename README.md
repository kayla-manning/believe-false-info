# Replication Report: Is the Political Right More Credulous?: Experimental Evidence Against Asymmetric Motivations to Believe False Political Information

#### Kayla Manning, Spring 2021

## Study Information

The original study assesses the inclination of voters from each political party to endorse false, damaging information about political opponents, ultimately finding no evidence that either side has a greater proclivity to endorse false political information. In an experiment, researchers randomized the partisanship of originally crafted rumors to remove potential biases. The main analysis uses OLS regression to measure the relationship between rumor endorsement and the respondents' partisanship. In a supplemental regression, the researchers include interaction terms to assess potential asymmetries between respondents’ party identification and the party addressed by the rumor. In addition, the analysis includes a sensitivity analysis that compares models with and without voters identifying as independents. 

The Journal of Politics published the [original study](https://www-journals-uchicago-edu.ezp-prod1.hul.harvard.edu/doi/pdf/10.1086/711133), and the Harvard Dataverse contains the [replication data](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/9ERCTY).

Ryan, T., & Aziz, A. (2020). Is the Political Right More Credulous?: Experimental Evidence Against Asymmetric Motivations to Believe False Political Information.

## How to run the code:

1. Clone and open the repository in RStudio.
2. Open [replication_report.Rmd](replication_report.Rmd).
3. Run this file, either by knitting the file to produce the final PDF, or executing one chunk at a time.

## Files included in this repository:

- [replication_report.Rmd](replication_report.Rmd): This file contains the code used to create the final replication and my accompanying analyses. The file will install any packages if necessary, load the packages and data, and execute all regressions and analyses. Knitting this file will produce `replication_report.pdf`.
- [replication_report.pdf](replication_report.pdf): This is the final report in PDF form; this document does not display the underlying R code and only displays the code output with the written report.
- [replication_data](replication_data): This folder contains all of the replication data from the original study, downloaded from the [Harvard Dataverse](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/9ERCTY).

## R environment

- R version: R version 4.0.3 (2020-10-10)
- Platform: x86_64-apple-darwin17.0         
- Packages: `tidyverse`, `haven`, `stargazer`, `extrafont`
