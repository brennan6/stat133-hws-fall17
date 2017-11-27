#functions

#removes any NA from the vector
remove_missing <- function(x) {
      x <- x[!is.na(x)]
}

#receieves the minimum value from the vector
get_minimum <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- sort(remove_missing(x))
    return(y[1])
  } else {
    warning('x is not a numeric vector')
  }
}

#receieves the maximum value from the vector
get_maximum <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- sort(remove_missing(x), decreasing = TRUE)
    return(y[1])
  } else {
    warning('x is not a numeric vector')
  }
}

#receieves the range value from the vector
get_range <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- get_minimum(sort(remove_missing(x)), TRUE)
    z <- get_maximum(sort(remove_missing(x), decreasing = TRUE), TRUE)
    return(z - y)
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the ten percent value from the vector
get_percentile10 <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    quan <- quantile(y, .1)
    return(unname(quan))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the ninety percent value from the vector
get_percentile90 <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    quan <- quantile(y, .9)
    return(unname(quan))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the median value from the vector
get_median <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- sort(remove_missing(x))
    len <- length(y)
    if (len %% 2 == 0) {
      return(sum(y[len/2], y[(len/2) + 1])/2)
    } else {
      return(y[len%/%2 + 1])
    }
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the average value from the vector
get_average <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    count <- 0
    for (i in y) {
      count <- count + i
    }
    return(count/length(y))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the standard deviation value from the vector
get_stdev <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    count <- 0
    for (i in y) {
      count <- count + (i - get_average(y, TRUE))^2
    }
    return(sqrt(count/(length(y) - 1)))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the first quartile value from the vector
get_quartile1 <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    return(unname(quantile(y)[2]))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the third quartile value from the vector
get_quartile3 <- function(x, na.rm) {
  if (na.rm == TRUE) {
    y <- remove_missing(x)
    return(unname(quantile(y)[4]))
  } else {
    warning('x is not a numeric vector')
  }
}

#receives the amount of NA values from the vector
count_missing <- function(x) {
  count <- 0
  for (i in 1:length(x)) {
    if (is.na(x[i])) {
      count <- count + 1
    }
  }
  return(count)
}

#A printed version of a plethora of statistical values
summary_stats <- function(x) {
  y <- remove_missing(x)
  lst <- c(get_minimum(y, TRUE), get_percentile10(y, TRUE),
           get_quartile1(y, TRUE), get_median(y, TRUE),
           get_average(y, TRUE), get_quartile3(y, TRUE),
           get_percentile90(y, TRUE), get_maximum(y, TRUE),
           get_range(y, TRUE), get_stdev(y, TRUE))
  lst[11] <- count_missing(x)
  names(lst) <- c("minimum", "percent10", "quartile1", "median", "mean",
                  "quartile3", "percent90", "maximum", "range",
                  "stdev", "missing")
  return(lst)
}

#An organized, printed version of statistical values
print_stats <- function(x) {
  for (i in 1:length(x)) {
    name <- names(x)[i]
    name1 <- paste0(name, paste(rep(' ', 9-nchar(name)), collapse = ''))
    print(paste0(name1, sep = ": ", format(round(x[i], 4), nsmall = 4)))
  }
}

#Dropping the lowest value from a vector
drop_lowest <- function(x) {
  x <- sort(x, decreasing = FALSE)
  x <- x[-1]
  return(x)
}

#A rescaled version of the vector
rescale100 <- function(x, xmin, xmax) {
  z <- 100*((x - xmin)/(xmax - xmin))
  return(z)
}

#The overall score of the HWs
score_homework <- function(x, drop) {
  if (drop == TRUE) {
    return(get_average(drop_lowest(x), na.rm = TRUE))
  } else {
    return(get_average(x, na.rm = TRUE))
  }
}

#The overall score of the Quizzes
score_quiz <- function(x, drop) {
  if (drop == TRUE) {
    return(get_average(drop_lowest(x), na.rm = TRUE))
  } else {
    return(get_average(x, na.rm = TRUE))
  }
}

#The overall score of the labs
score_lab <- function(x) {
  if (x == 12 | x == 11) {
    return(100)
  } else if (x == 10) {
    return(80)
  } else if (x == 9) {
    return(60)
  } else if (x == 8) {
    return(40)
  } else if (x == 7) {
    return(20)
  } else {
    return(0)
  }
}


