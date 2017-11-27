#Tests
source("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/code/functions.R")
a <- c(1, 2, 3, NA, 4)
b <- c(1, 4, 7, NA, 10)
c <- c(1, NA, 100, NA, 2)
d <- c(5, 4)
e <- c(1, 2, 3, 4)
f <- c(1, 4, 7, 10)
g <- c(1, 100, 2)



context("remove_missing")
expect_equal(remove_missing(a), c(1, 2, 3, 4))
expect_equal(remove_missing(b), c(1, 4, 7, 10))
expect_equal(remove_missing(c), c(1, 100, 2))
expect_equal(remove_missing(d), c(5, 4))

context("get_minimum")
expect_equal(get_minimum(a, na.rm = T), 1)
expect_equal(get_minimum(b, na.rm = T), 1)
expect_equal(get_minimum(c, na.rm = T), 1)
expect_equal(get_minimum(d, na.rm = T), 4)

context("get_maximum")
expect_equal(get_maximum(a, na.rm = TRUE), 4)
expect_equal(get_maximum(b, na.rm = TRUE), 10)
expect_equal(get_maximum(c, na.rm = TRUE), 100)
expect_equal(get_maximum(d, na.rm = TRUE), 5)

context("get_range")
expect_equal(get_range(a, na.rm = T), 3)
expect_equal(get_range(b, na.rm = T), 9)
expect_equal(get_range(c, na.rm = T), 99)
expect_equal(get_range(d, na.rm = T), 1)

context("get_percentile10")
expect_equal(get_percentile10(a, na.rm = T), 1.3)
expect_equal(get_percentile10(b, na.rm = T), 1.9)
expect_equal(get_percentile10(c, na.rm = T), 1.2)
expect_equal(get_percentile10(c(3, 4, 5), na.rm = T), 3.2)

context("get_percentile90")
expect_equal(get_percentile90(a, na.rm = T), 3.7)
expect_equal(get_percentile90(b, na.rm = T), 9.1)
expect_equal(get_percentile90(c, na.rm = T), 80.4)
expect_equal(get_percentile90(c(3, 4, 5), na.rm = T), 4.8)

context("get_quartile1")
expect_equal(get_quartile1(a, na.rm = T), 1.75)
expect_equal(get_quartile1(b, na.rm = T), 3.25)
expect_equal(get_quartile1(c, na.rm = T), 1.5)
expect_equal(get_quartile1(d, na.rm = T), 4.25)

context("get_quartile3")
expect_equal(get_quartile3(a, na.rm = T), 3.25)
expect_equal(get_quartile3(b, na.rm = T), 7.75)
expect_equal(get_quartile3(c, na.rm = T), 51)
expect_equal(get_quartile3(d, na.rm = T), 4.75)

context("get_median")
expect_equal(get_median(a, na.rm = T), median(a, na.rm = T))
expect_equal(get_median(b, na.rm = T), median(b, na.rm = T))
expect_equal(get_median(c, na.rm = T), median(c, na.rm = T))
expect_equal(get_median(d, na.rm = T), median(d, na.rm = F))

context("get_average")
expect_equal(get_average(a, na.rm = T), mean(a, na.rm = T))
expect_equal(get_average(b, na.rm = T), mean(b, na.rm = T))
expect_equal(get_average(c, na.rm = T), mean(c, na.rm = T))
expect_equal(get_average(d, na.rm = T), mean(d, na.rm = F))

context("get_stdev")
expect_equal(get_stdev(a, na.rm = T), sd(a, na.rm = T))
expect_equal(get_stdev(b, na.rm = T), sd(b, na.rm = T))
expect_equal(get_stdev(c, na.rm = T), sd(c, na.rm = T))
expect_equal(get_stdev(d, na.rm = T), sd(d, na.rm = F))

context("count_missing")
expect_equal(count_missing(a), 1)
expect_equal(count_missing(b), 1)
expect_equal(count_missing(c), 2)
expect_equal(count_missing(d), 0)

context("summary_stats")
expect_equal(unname(summary_stats(a)[11]), 1)
expect_equal(unname(summary_stats(a)[1]), 1)
expect_equal(unname(summary_stats(a)[8]), 4)
expect_equal(unname(summary_stats(a)[4]), 2.5)

context("rescale100")
expect_equal(rescale100(c(100, 20, 3, 4, 15), xmin = 0, xmax = 20), c(
  500, 100, 15, 20, 75))
expect_equal(rescale100(c(11, 20, 9, 8, 15), xmin = 0, xmax = 20), c(
  55, 100, 45, 40, 75))
expect_equal(rescale100(c(2, 3, 4, 5, 6), xmin = 0, xmax = 20), c(
  10, 15, 20, 25, 30))
expect_equal(rescale100(c(18, 15, 16, 4, 17, 9), xmin = 0, xmax = 20), c(
  90, 75, 80, 20, 85, 45))

context("drop_lowest")
expect_equal(drop_lowest(e), c(2, 3, 4))
expect_equal(drop_lowest(f), c(4, 7, 10))
expect_equal(drop_lowest(g), c(2, 100))
expect_equal(drop_lowest(d), 5)

context("score_homework")
expect_equal(score_homework(e, drop = F), mean(e))
expect_equal(score_homework(f, drop = T), mean(drop_lowest(f)))
expect_equal(score_homework(g, drop = F), mean(g))
expect_equal(score_homework(d, drop = F), mean(d))

context("score_quiz")
expect_equal(score_quiz(e, drop = F), mean(e))
expect_equal(score_quiz(f, drop = T), mean(drop_lowest(f)))
expect_equal(score_quiz(g, drop = F), mean(g))
expect_equal(score_quiz(d, drop = F), mean(d))

context("score_lab")
expect_equal(score_lab(12), 100)
expect_equal(score_lab(4), 0)
expect_equal(score_lab(9), 60)
expect_equal(score_lab(7), 20)
