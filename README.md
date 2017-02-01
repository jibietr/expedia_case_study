# Expedia case study

**Q1**

Code is in :
preproc_aggregates.R (to preprocess some data)
analysis_expedia_case_study.Rmd

To run the *.Rmd file, first create a soft link to the data directory

ln -s ../data/ www/

Then, run the following line in your R console:

*rmarkdown::run("analysis_expedia_case_study.Rmd", shiny_args = list(port = 8080))*


**Q2**

Code is in *code/read_and_manipulate.R* 

Output is in *results/*




