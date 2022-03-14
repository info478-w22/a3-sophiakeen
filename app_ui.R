library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
library(rsconnect)

# Define UI

introduction_view <- tabPanel("Home",
  titlePanel("Introduction"),
  h3("Overview of Assignment"), 
  p("In this assignemnt, I will build an interactive diesase modleing simulation of the spread of COVID-19 in a population.
    There will be two interactions in which a user can select policy changes to see the impact it has on COVID-19."),
  p("The policies I intend to use are requiring physical distancing, requiring face masks, and requiring eye protection.
    The values I intend to use are from a study done by The Lancet in which they studied the percentage of risk
    of getting COVID-19 with and without these three mandates. The graphic below from Statistica summarizes the findings."),
  br(),
  tags$img(src = "21882.png", width = 300, length = 300),
  br(),
  uiOutput("tab"),
  uiOutput("tab_2"),
  br(),
  h3("Intention"),
  p("I intend to make two interactive models - a deterministic model and a stochastic model.
    Both models will use the policies above to showcase the difference in transmission rates with the policy and without.
    For both models I assumed that there were 999 people in the population and that each person had 2 acts per unit of time (day)
    With this assignment I also indend to make comparisions between the different policies within each type of model
    and also compare the modeles agaisnt eachother to look at similiarites and differences. ")
)


deterministic_view <- tabPanel("Deterministic Model",
  sidebarPanel(
    radioButtons(inputId = "policy", 
      label = h3("Pick Type of Policy"), 
      choices = list("Physical Distancing" = 1, "Face Masks" = 2, "Eye Protection" = 3),
      selected = 1
    ),
    radioButtons(inputId = "following",
      label = h3("Will The Policy Be Followed?"),
      choices = list("Policy is Enforced" = 1, "Policy is not Enforced" = 2),
      selected = 1
    )
  ),
  mainPanel(h3("What is the Deterministic Model?"),
    p("In the deterministic model, the transmission rates are calculated exactly without
      the involvement of randomness."),
    plotOutput(outputId = "plot")          
  )
)


stochastic_page_view <- tabPanel("Stochastic Model",
  sidebarPanel(
    radioButtons(inputId = "policy", 
      label = h3("Pick Type of Policy"), 
      choices = list("Physical Distancing" = 1, "Face Masks" = 2, "Eye Protection" = 3),
      selected = 1
    ),
    radioButtons(inputId = "following",
      label = h3("Will The Policy Be Followed?"),
      choices = list("Policy is Enforced" = 1, "Policy is not Enforced" = 2),
      selected = 1
    )                                 
  ),
  mainPanel(h3("What is the Stochastic Model?"),
    p("In the stochastic model, there is a random probability distrubution. This is shown
      with the faded colors around the lines, with the darkest part being the most probable."),
    plotOutput("plot_2")
  )
)


interpretation_view <- tabPanel("Conclusion",
  titlePanel("Interpretation Of My Findings"),
  h3("Changing the Parameters"),
  p("Comparing the physical distancing enforced and physical distancing unenforced
  plots in the deterministic model, we can see that if physical distancing is enforced,
  we get an equal amount of people infected and susceptible when time, or the number of 
  days, equal about 130, or roughly 1/3 into the year. When it is not enforced, the time 
  it takes for an equal number of infected people and susceptible people is around 35 days 
  which is significantly shorter of a time span. The time it takes for everyone to get infected
  in the enforced physical distancing plot is around 200 days, or 70 days after the number 
  was equal. This is much longer compared to the physical distancing not enforced plot where
  the time it takes for everyone to get infected is only about 15 or so days. 
  This shows the importance of physical distancing because cases take a longer time to rise. 
  This gives our healthcare services and other business providing care and resources to people 
  impacted time to get the necessary training, personnel, and resources."),
  br(),
  h3("Differences in the Models"),
  plotOutput(outputId = "plot_3"),
  p("This graph combines the deterministic model (solid line) to the stochastic model (dashed line)
    for the face masks were enforced plots. As we can see, the graphs are very similar and show the
    same trend. This is true for all the other policies and enforcments. There is a slight increase in
    where the stochastic graph overlaps its susceptable and infected population compared to the determinisitc
    model. This could mean that if you only looked at one graph, it might make face mask wearing seem more effective
    than it is. This could be due to how each model treats the population/units. "),
  br(),
  h3("Limitations"),
  p("For the deterministic model, I used the most basic of plots, the SI model. 
    This only takes into account susceptible people and infected people. This is not accurate
    in the real world because COVID-19 has been reinfecting people, and also in any population, the 
    number of people is never motionless and people enter and leave over time.")
)


ui <- navbarPage(
  "Assignment 3 - Disease Modeling",
  introduction_view,
  deterministic_view,
  stochastic_page_view,
  interpretation_view
)
