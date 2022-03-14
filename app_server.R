library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)
require(EpiModel)
#require(dcm)

source("app_ui.R")

#Define server logic
server <- function(input, output) {
  
  #Introduction Page
  url <- a("The Lancet", href="https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)31142-9/fulltext")
  output$tab <- renderUI({
    tagList(url)
  })
  
  url_2 <- a("Statistica", href="https://www.statista.com/chart/21882/chance-of-covid-19-transmission/")
  output$tab_2 <- renderUI({
    tagList(url_2)
  })
  
  #Deterministic Page
  
  output$plot <- renderPlot ({
    ######## Basic SI model
    
    first_column <- c(0.026, 0.031, 0.055)
    second_column <- c(0.128, 0.174, 0.160)
    input_values <- data.frame(first_column, second_column)

    prob <- input_values[as.numeric(input$policy), as.numeric(input$following)]
    
    param <- param.dcm(inf.prob = as.numeric(prob), act.rate = c(2))
    init <- init.dcm(s.num = 999, i.num = 1)
    control <- control.dcm(type = "SI", nsteps = 365)
    
    mod <- dcm(param, init, control)
    plot(mod)
    
  })
  
  
  #Stochastic Page
  
  output$plot_2 <- renderPlot ({

    #### Individual contact model
    
    first_column <- c(0.026, 0.031, 0.055)
    second_column <- c(0.128, 0.174, 0.160)
    input_values <- data.frame(first_column, second_column)

    prob <- input_values[as.numeric(input$policy), as.numeric(input$following)]

    param.icm <- param.icm(inf.prob = as.numeric(prob), act.rate = 2)
    init.icm <- init.icm(s.num = 999, i.num = 1)
    control.icm <- control.icm(type = "SI", nsims = 100, nsteps = 365)
    mod.icm <- icm(param.icm, init.icm, control.icm)
    
    plot(mod.icm)
    
  })
  
  #Analysis page
 
  output$plot_3 <- renderPlot({
    param.dcm <- param.dcm(inf.prob = 0.031, act.rate = 2)
    init.dcm <- init.dcm(s.num = 999, i.num = 1)
    control.dcm <- control.dcm(type = "SI", nsims = 10, nsteps = 300)
    mod.dcm <- dcm(param.dcm, init.dcm, control.dcm)
    #plot(mod.dcm)
    
    param.icm <- param.icm(inf.prob = 0.031, act.rate = 2)
    init.icm <- init.icm(s.num = 999, i.num = 1)
    control.icm <- control.icm(type = "SI", nsims = 100, nsteps = 300)
    mod.icm <- icm(param.icm, init.icm, control.icm)
    #plot(mod.icm)
    
    plot(mod.dcm, alpha = 0.75, lwd = 4, main = "DCM and ICM Comparison")
    plot(mod.icm, qnts = FALSE, sim.lines = FALSE, add = TRUE, mean.lty = 2, legend = FALSE)
    
  }) 
    
}

# Run the app
shinyApp(ui = ui, server = server)
