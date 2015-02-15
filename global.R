library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

#helping function
getSentiment <- function (text, key){
    
    text <- URLencode(text);
    
    #save all the spaces, then get rid of the weird characters that break the API, then convert back the URL-encoded spaces.
    text <- str_replace_all(text, "%20", " ");
    text <- str_replace_all(text, "%\\d\\d", "");
    text <- str_replace_all(text, " ", "%20");
    
    
    if (str_length(text) > 360){
        text <- substr(text, 0, 359);
    }
    
    data <- getURL(paste("http://api.datumbox.com/1.0/TwitterSentimentAnalysis.json?api_key=", '8de3d1ed491113e15ec9359ab63a6c24', "&text=",text, sep=""))
    
    js <- fromJSON(data, asText=TRUE);
    
    # get mood probability
    sentiment = js$output$result
      
    return(list(sentiment=sentiment))
}

#clean the text for the search
clean.text <- function(some_txt)
{
    some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
    some_txt = gsub("@\\w+", "", some_txt)
    some_txt = gsub("[[:punct:]]", "", some_txt)
    some_txt = gsub("[[:digit:]]", "", some_txt)
    some_txt = gsub("http\\w+", "", some_txt)
    some_txt = gsub("[ \t]{2,}", "", some_txt)
    some_txt = gsub("^\\s+|\\s+$", "", some_txt)
    some_txt = gsub("amp", "", some_txt)
    # define "tolower error handling" function
    try.tolower = function(x)
    {
        y = NA
        try_error = tryCatch(tolower(x), error=function(e) e)
        if (!inherits(try_error, "error"))
            y = tolower(x)
        return(y)
    }
    
    some_txt = sapply(some_txt, try.tolower)
    some_txt = some_txt[some_txt != ""]
    names(some_txt) = NULL
    return(some_txt)
}


#### Input max 355 tweets

search_twitter <- function(a, b) {
    
    ##search
    tweets = searchTwitter(a, b, lang="en")
    
    # get text 
    tweet_txt = sapply(tweets, function(x) x$getText())
    
    # clean text
    tweet_clean = clean.text(tweet_txt)
    tweet_num = length(tweet_clean)
    # data frame (text, sentiment)
    tweet_df = data.frame(text=tweet_clean, sentiment=rep("", tweet_num),stringsAsFactors=FALSE)
    
    print("Getting sentiments...")
    # apply function getSentiment
    sentiment = rep(0, tweet_num)
    for (i in 1:tweet_num)
    {
        tmp = getSentiment(tweet_clean[i], db_key)
        tweet_df$sentiment[i] = tmp$sentiment
        print(paste(i," of ", tweet_num))
    }
    
    # delete rows with no sentiment
    tweet_df <- tweet_df[tweet_df$sentiment!="",]
    
    #separate text by sentiment
    sents = levels(factor(tweet_df$sentiment))
    
    # get the labels and percents
    labels <-  lapply(sents, function(x) paste(x,format(round((length((tweet_df[tweet_df$sentiment ==x,])$text)/length(tweet_df$sentiment)*100),2),nsmall=2),"%"))
    
    nemo = length(sents)
    emo.docs = rep("", nemo)
    for (i in 1:nemo)
    {
        tmp = tweet_df[tweet_df$sentiment == sents[i],]$text
        emo.docs[i] = paste(tmp,collapse=" ")
    }
    
    # remove stopwords
    emo.docs = removeWords(emo.docs, stopwords("german"))
    emo.docs = removeWords(emo.docs, stopwords("english"))
    corpus = Corpus(VectorSource(emo.docs))
    tdm = TermDocumentMatrix(corpus)
    tdm = as.matrix(tdm)
    colnames(tdm) = labels
    return(tdm)
}