library(shiny)
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

shinyServer(function(input, output) {

    # fill the spot which we created in the ui.R
        api_key <- "DHFmzyy7Vis9UO9cQ6tgQxVLI"
        api_secret <- "dMbR6yGSigc8oKnnNwWNhKpYytoDNVo3aO22Jf4FCWBWZNJ96n"
        access_token <- "68370055-zysA1i9vuvE0mP8l60miIsA8aAmhzQ2p5hW6ghkYB"
        access_token_secret <- "Ctqn1jx2MuVBSk1XwJIkSXOATd7aNoeOaCgeZrRP0lzAq"
        options(httr_oauth_cache=T)
        setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
        # hier kommt immer eine Nachfrage, die muss man 
    output$plot <- renderPlot({
        
        #progressbar
        withProgress(message = 'Creating plot', value = 0.1, {
            Sys.sleep(input$max)
        })
        
        #only when the button is pressed
        input$submit
        
        #make the actual search (we defined it in global.R)
        v <- search_twitter(input$selection, input$max)
        
        #create the wordcloud
        comparison.cloud(v, colors = brewer.pal(ncol(v), "Dark2"),
                        scale = c(4,0.5), random.order = FALSE, title.size = 1.5)
    })
})
