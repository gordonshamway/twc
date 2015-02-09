library(shiny)
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

shinyServer(function(input, output, session) {
    # Define a reactive expression for the document term matrix
    terms <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            withProgress(session, {
                setProgress(message = "Processing corpus...")
                search_twitter(input$selection, input$max)
                #nur zum testen
                #test <- search_twitter("Medion", 10)
            })
        })
    })
    output$plot <- renderPlot({
        v <- terms()
        comparison.cloud(v, colors = brewer.pal(nemo, "Dark2"),
                                    scale = c(3,.5), random.order = FALSE, title.size = 1.5)
    })
})
