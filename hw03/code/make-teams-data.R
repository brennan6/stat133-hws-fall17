# Title: hw03-Ranking NBA Teams
# Description: The Script is about writting R syntax based answers that regard predominantly dplyr and ggplot
# Input(s): nba2017-teams.csv
# Output(s): make-teams-data.R
# Author: Matt Brennan
# Date: 10/15/1997

library(dplyr)
library(ggplot2)

#loading the data for the project
github <- "https://github.com/ucb-stat133/stat133-fall-2017/raw/master/"
csv <- "data/nba2017-roster.csv"
download.file(url = paste0(github, csv), destfile = 'nba2017-roster.csv')
dat_roster <- read.csv('nba2017-roster.csv', stringsAsFactors = FALSE)

github <- "https://github.com/ucb-stat133/stat133-fall-2017/raw/master/"
csv <- "data/nba2017-stats.csv"
download.file(url = paste0(github, csv), destfile = 'nba2017-stats.csv')
dat_stats <- read.csv('nba2017-stats.csv', stringsAsFactors = FALSE)

setwd("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw03/data")

#1 adding new variables
#missed_fg
dat_stats <- 
  dat_stats %>%
  mutate(missed_fg = dat_stats$field_goals_atts - dat_stats$field_goals_made)

#missed_ft
dat_stats <-
  dat_stats %>%
  mutate(missed_ft = dat_stats$points1_atts - dat_stats$points1_made)

#points
dat_stats <-
  dat_stats %>%
  mutate(points = dat_stats$points1_made + (dat_stats$points2_made*2) +(dat_stats$points3_made*3))

#rebounds
dat_stats <-
  dat_stats %>%
  mutate(rebounds = dat_stats$off_rebounds + dat_stats$def_rebounds)

#efficiency
dat_stats <-
  dat_stats %>%
  mutate(efficiency = (dat_stats$points + dat_stats$rebounds + dat_stats$assists +
         dat_stats$steals + dat_stats$blocks - dat_stats$missed_fg - dat_stats$missed_ft - dat_stats$turnovers)/
         dat_stats$games_played)

setwd("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw03/output")
#creating efficiency_summary.txt
sink(file = "efficiency-summary.txt")
summary(dat_stats$efficiency)
sink()

setwd("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw03/code")

#merging tables
full_merge = dat_roster %>%
  full_join(dat_stats)

#creating nba2017_teams.csv
teams <- full_merge %>%
  group_by(team) %>%
  summarise(experience = sum(round(experience,2)), salary = sum(round(salary/1000000,2)), points3 = sum(points3_made),
            points2 = sum(points2_made), free_throws = sum(points1_made), points = sum(points),
            off_rebounds = sum(off_rebounds), def_rebounds = sum(def_rebounds), assists = sum(assists),
            steals = sum(steals), blocks = sum(blocks), turnovers = sum(turnovers), fouls = sum(fouls),
            effieciency = sum(efficiency))

summary(teams)

#sending file to ouput
sink(file = "teams-summary.txt")
summary(teams)
sink()

setwd("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw03/data")
write.csv(teams, file = "nba2017-teams.csv")

setwd("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw03/images")
#create a star plot
pdf(file = "teams_star_plot.pdf")
stars(teams[,-1], labels = teams$team)
dev.off()

#create scatteplot
pdf(file = "experience_salary.pdf")
ggplot(data=teams, aes(x=experience, y=salary)) + geom_point() + labs(title = "Salary versus Experience for teams")+ geom_text(aes(label = teams$team))
dev.off()


