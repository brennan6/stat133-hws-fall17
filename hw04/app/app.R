#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

source("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/code/functions.R")
dat <- read.csv("/Users/matthewbrennan/stat133/stat133-hws-fall17/hw04/data/cleandata/cleanscores.csv")

dat$Grade = factor(dat$Grade,
                           levels = c('A+', 'A', 'A-',
                                      'B+', 'B', 'B-',
                                      'C+', 'C', 'C-',
                                      'D', 'F'))

proportions = dat %>% group_by(Grade) %>% summarise(count = n())
binded = proportions
binded['Prop'] = round(as.numeric(binded$count)/sum(as.numeric(binded$count)), 2)
binded['Freq'] = as.numeric(binded$count)

vector = names(dat)[names(dat)!= 'Grade']
ui = fluidPage(
  titlePanel(title = 'Grade Visualizer'),
  sidebarLayout(
    
    sidebarPanel( 
      
      conditionalPanel(condition = "input.tabselected == 1",
                       tableOutput('table')),
      
      conditionalPanel(condition = "input.tabselected==2",
                       selectizeInput('assignment', 'X-axis variable', vector, 
                                      'HW1'),
                       sliderInput('values', 'Bin Width', min = 1, max = 10, value = 10)),
      conditionalPanel(condition = "input.tabselected == 3",
                       selectizeInput('x', 'X-axis variable', vector, 'Test1'),
                       selectizeInput('y', 'Y-axis variable', vector, 'Overall'),
                       sliderInput('sliders', 'Opacity', min = 0, max = 1, value = 0.5),
                       radioButtons('radios', 'Show line', list('none', 'lm', 'loess'), "")
      )),
    mainPanel(
      tabsetPanel(
        tabPanel('Barchart', value = 1, plotOutput('bar')),
        tabPanel('Histogram', value = 2,
                 fluidRow(column(11,plotOutput('histogram')),
                  column(12, verbatimTextOutput('summary')))),
        tabPanel('Scatterplot', value = 3, plotOutput('scatter'),
              h3('Correlation'), textOutput('correlation')),
        id = ("tabselected")
    )
    
  )
)
)


server = function(input, output){
  output$histogram = renderPlot({
    col = input$assignment
    hist(dat[ , col], xlab = col, ylab = 'count', breaks=seq(-5,105,input$values), col = 'gray', 
         border = 'white', include.lowest = TRUE, main = '')
    axis(side=1,at=seq(-10,110,input$values),labels=seq(-10,110,input$values))
  })
  
  output$summary = renderPrint({
    col = select(dat, input$assignment)[[1]]
    print_stats(summary_stats(col))
    
  })
  
  output$table = renderTable({
    proportions = dat %>% group_by(Grade) %>% summarise(count = n())
    binded = proportions
    binded['Freq'] = as.numeric(binded$count)
    binded$Freq <- as.integer(binded$Freq)
    binded['Prop'] = round(as.numeric(binded$count)/sum(as.numeric(binded$count)), 2)
    binded = binded[-c(2)]
    
  })
  
  output$bar = renderPlot({
    ggplot(binded, aes(Grade, Freq)) + geom_bar(stat = 'identity', fill = 'steelblue') +
      labs(x = "Grade", y = "frequency")
  })
  
  output$scatter = renderPlot({
    plot(dat[ , input$x], dat[ , input$y],
         xlim = c(-1, 101), ylim = c(-1,101), cex = input$sliders, panel.first = grid(col = 'blue'),
         xlab = input$x, ylab = input$y, pch = 1)
    if (input$radios == 'lm'){
      abline(lm(dat[ , input$y] ~ dat[ , input$x]), col = 'red', lwd = 3)}
    else if (input$radios == 'loess'){
      data = lowess(dat[ , input$x] , y = dat[ , input$y])
      lines(data, lwd = 3, col = 'blue')}
  })
    
    output$correlation = renderText({
      print(cor(dat[ , input$x], dat[, input$y]))
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)

