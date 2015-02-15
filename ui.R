
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
shinyUI(
    fluidPage(
    # Application title
    titlePanel("Twitter Word Cloud"),
    
    # Sidebar with a slider and selection inputs
    sidebarLayout(
        sidebarPanel(width = 4,
                     textInput("selection", "Please enter your searchterm and wait until the wordcloud is drawn (could take some time)","subject"),
                     actionButton("submit","search"),
                     hr(),
                     sliderInput("max", "number of tweets", min = 1,  max = 50,  value = 5)
                ),
    #placeholder for the wordcloud
    mainPanel(plotOutput("plot"))
    )
)
)