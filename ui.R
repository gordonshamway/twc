
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(

    
    # Application title
    headerPanel("Twitter Word Cloud"),
    
    # Sidebar with a slider and selection inputs
    sidebarPanel(width = 5,
                 textInput("selection", "Geben Sie einen Suchbegriff ein","Begriff"),
                 actionButton("update", "Change"),
                 hr(),
                 sliderInput("max", "Anzahl Tweets", min = 1,  max = 355,  value = 10)
    ),
    
    # Show Word Cloud
    mainPanel(
        plotOutput("plot")
    )
))
