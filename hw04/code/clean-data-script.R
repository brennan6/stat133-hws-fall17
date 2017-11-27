#Clean Data Script
source("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/code/functions.R")
dat <- read.csv("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/data/rawdata/rawscores.csv")
library(dplyr)

sink('hw04/output/summary-rawscores.txt')
str(dat)
summary_stats(dat)
print_stats(summary_stats(dat))
sink()

#replace all of the NA with 0 in dat
dat[is.na(dat)] <- 0

#rescale QZ1
dat$QZ1 <- rescale100(dat$QZ1, xmin = 0, xmax = 12)

#rescale QZ2
dat$QZ2 <- rescale100(dat$QZ2, xmin = 0, xmax = 18)

#rescale QZ3
dat$QZ3 <- rescale100(dat$QZ3, xmin = 0, xmax = 20)

#rescale QZ4
dat$QZ4 <- rescale100(dat$QZ4, xmin = 0, xmax = 20)

#add Lab
dat_lab = c()
for (i in 1:nrow(dat)) {
  dat_lab[i] <- score_lab(dat$ATT[i])
}
dat <- dat %>% mutate(Lab = dat_lab)

#add Test1 and Test2
dat <- dat %>% mutate(Test1 = rescale100(dat$EX1, xmin = 0, xmax = 80))
dat<- dat %>% mutate(Test2 = rescale100(dat$EX2, xmin = 0, xmax = 90))

#add Homework variable
hw <- c()
for(i in 1:nrow(dat)) {
  hw[i] <- get_average(drop_lowest(c(dat$HW1[i], dat$HW2[i], dat$HW3[i],
                        dat$HW4[i], dat$HW5[i], dat$HW6[i],
                        dat$HW7[i], dat$HW8[i], dat$HW9[i])),
                       na.rm = TRUE)
}
dat <- dat %>%
  mutate(Homework = hw)

#add Quiz variable
quiz <- c()
for(i in 1:nrow(dat)) {
  quiz[i] <- get_average(drop_lowest(c(dat$QZ1[i], dat$QZ2[i], dat$QZ3[i],
                                     dat$QZ4[i])),
                       na.rm = TRUE)
}
dat <- dat %>%
  mutate(Quiz = quiz)

#add Overall variable
overall <- c()
for(i in 1:nrow(dat)){
  overall[i] <- sum((dat$Lab[i] * .10), (dat$Homework[i] * .3), (dat$Quiz[i] * .15),
                    (dat$Test1[i] * .2), (dat$Test2[i] * .25))
}
dat <- dat %>%
  mutate(Overall = overall)

#add Grade variable
grade <- c()
for(i in 1:nrow(dat)){
  if (dat$Overall[i] < 50 ) grade[i] <- "F"
  else if (dat$Overall[i] < 60) grade[i] <- "D"
  else if (dat$Overall[i] < 70) grade[i] <- "C-"
  else if (dat$Overall[i] < 77.5) grade[i] <- "C"
  else if (dat$Overall[i] < 79.5) grade[i] <- "C+"
  else if (dat$Overall[i] < 82) grade[i] <- "B-"
  else if (dat$Overall[i] < 86) grade[i] <- "B"
  else if (dat$Overall[i] < 88) grade[i] <- "B+"
  else if (dat$Overall[i] < 90) grade[i] <- "A-"
  else if (dat$Overall[i] < 95) grade[i] <- "A"
  else if (dat$Overall[i] > 95) grade[i] <- "A+"}

dat <- dat %>%
  mutate(Grade = grade)

#sink Lab-stats
sink("hw04/output/Lab-stats.txt")
summary_stats(dat$Lab)
print_stats(summary_stats(dat$Lab))
sink()
#sink Homework-stats
sink("hw04/output/Homework-stats.txt")
summary_stats(dat$Homework)
print_stats(summary_stats(dat$Homework))
sink()
#sink Quiz-stats
sink("hw04/output/Quiz-stats.txt")
summary_stats(dat$Quiz)
print_stats(summary_stats(dat$Quiz))
sink()
#sink Test1-stats
sink("hw04/output/Test1-stats.txt")
summary_stats(dat$Test1)
print_stats(summary_stats(dat$Test1))
sink()
#sink Test2-stats
sink("hw04/output/Test2-stats.txt")
summary_stats(dat$Test2)
print_stats(summary_stats(dat$Test2))
sink()
#sink Overall-stats
sink("hw04/output/Overall-stats.txt")
summary_stats(dat$Overall)
print_stats(summary_stats(dat$Overall))
sink()

#sink the summary-cleanscores
sink("hw04/output/summary-cleanscores.txt")
str(dat)
sink()

#sink the cleanscores.csv
sink("hw04/data/cleandata/cleanscores.csv", type = "output")
write.csv(dat)
sink()


