# Set directory 
#setwd("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/Shiny App") 

# Necessary packages
library(tidytext, warn.conflicts = FALSE)
library(tidyverse, warn.conflicts = FALSE)
library(stringi, warn.conflicts = FALSE)
library(wordcloud, warn.conflicts = FALSE)


## N-grams data
bi_words <- readRDS("bigram.rds")
tri_words  <- readRDS("trigram.rds")
quad_words <- readRDS("quadgram.rds")


## N-grams Matching Functions

# Bigram
bigram_func <- function(inputWords){
    num <- length(inputWords)
    filter(bi_words,
           word1==inputWords[num]) %>%
        top_n(1, n) %>%
        filter(row_number() == 1L) %>%
        select(num_range("word", 2)) %>%
        as.character() -> out
    ifelse(out =="character(0)", "?", return(out))
}

# Trigram
trigram_func <- function(inputWords){
    num <- length(inputWords)
    filter(tri_words,
           word1==inputWords[num-1],
           word2==inputWords[num])  %>%
        top_n(1, n) %>%
        filter(row_number() == 1L) %>%
        select(num_range("word", 3)) %>%
        as.character() -> out
    ifelse(out=="character(0)", bigram_func(inputWords), return(out))
}

# Quadgram
quadgram_func <- function(inputWords){
    num <- length(inputWords)
    filter(quad_words,
           word1==inputWords[num-2],
           word2==inputWords[num-1],
           word3==inputWords[num])  %>%
        top_n(1, n) %>%
        filter(row_number() == 1L) %>%
        select(num_range("word", 4)) %>%
        as.character() -> out
    ifelse(out=="character(0)", trigram_func(inputWords), return(out))
}

## Function for call the N-gram function and clean the input text
ngrams_func <- function(wordInput){
    # Create a dataframe
    wordInput <- data_frame(text = wordInput)
    # Clean the Inpput
    replace_reg <- "[^[:alpha:][:space:]]*"
    wordInput <- wordInput %>%
        mutate(text = str_replace_all(text, replace_reg, ""))
    # Find word count, separate words, lower case
    inputCount <- str_count(wordInput, boundary("word"))
    inputWords <- unlist(str_split(wordInput, boundary("word")))
    inputWords <- tolower(inputWords)
    # Call the matching functions
    nextWord <- ifelse(inputCount == 0, "Next word shows here.",
                       ifelse (inputCount == 1, bigram_func(inputWords),
                               ifelse (inputCount == 2, trigram_func(inputWords), quadgram_func(inputWords))))
    if(nextWord == "?"){
        nextWord = "The application not found the next expected word due to limited size of the training data" 
    }
    return(nextWord)
}

library(shiny)
server <- shinyServer(function(input, output){
    output$prediction <- renderPrint({
        
        # Render 'Enter word or phrase' verbatim.
        next_word <- ngrams_func(input$inputString)
        next_word
    })
    
    # Render next word
    output$nextText1 <- renderText({
        input$inputString
    });
})



