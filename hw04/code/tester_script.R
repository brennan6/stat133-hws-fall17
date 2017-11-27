#test script
install.packages("testthat", repos = "http://cran.rstudio.com/")
library(testthat)



#source in functions to be tested
source("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/code/functions.R")

getwd()
sink("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/output/test-reporter.txt")
test_file("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/code/tests.R")
sink()


