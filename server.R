library(shiny)

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
            })
        })
    })
    
#    # Make the wordcloud drawing predictable during a session
#    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot <- comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                                    scale = c(3,.5), random.order = FALSE, title.size = 1.5)
    })