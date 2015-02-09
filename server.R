library(shiny)
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

shinyServer(function(input, output) {

    # fill the spot which we created in the ui.R
    output$plot <- renderPlot({
        
        #only when the button is pressed
        input$submit
        
        #make the actual search (we defined it in global.R)
        v <- search_twitter(input$selection, input$max)
        
        #create the wordcloud
        comparison.cloud(v, colors = brewer.pal(ncol(v), "Dark2"),
                        scale = c(4,0.5), random.order = FALSE, title.size = 1.5)
    })
})
