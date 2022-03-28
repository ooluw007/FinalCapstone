
library(shiny)

ui <- shinyUI(fluidPage(
    titlePanel(h2(strong("JHU/Coursera Data Science Course Final Project", align = "center"), 
                          h4(strong("N-grams Words Prediction Based on News, Blogs 
                             and Twitter Text Data", align = "center")))),
    wellPanel(img(src = "logo2.png", height = 100, width = 700),
                 h4("Most people today use smartphone and/or other smart computer 
                     devices to send messages. For these devices to be more 
                     effective in sending messages, statement auto-completion 
                     functions have been built into them. As the users type a 
                     word or a phrase, the next possible words show. In this 
                     application, you will be able to predict next word by 
                     entering a word or a phrase into the box provided on the 
                     left panel below.")),
    tabPanel("Predicting the next word",
             sidebarLayout(
                 sidebarPanel(
                     titlePanel(h5("Word or Phrase Input")),
                     helpText("The box below take a word or a phrase you enter
                              and predict the next most likely word in the box 
                              on the right.",
                              br(),
                              "For example, you can entered the phrase: 
                              It is good to see...,
                              then, the app will predict next word as:you."),
                     br(),
                     textInput("inputString", "Enter a word or a phrase",
                               value = ""),
                     helpText("Once you finished typing your word or phrase, 
                              please click on the blue button below for 
                              suggested next word"),
                     submitButton('Click for next word')
                 ),
                 mainPanel(
                     h4("About the App"),
                     h4("The app demonstrate backoff predictive model using text 
                     data to predict possible next English word with good 
                     accuracy when a word or phrase is entered. We used twitter,
                     news and blogs combined text data provided by Cousera and 
                     SwiftKey.", 
                     "From the data, we developed N-grams (2 to 4) library from 
                     which possible next word are drawn."),
                     tags$h4("More Info"),
                     tags$a(href="https://github.com/ooluw007/Capstone", 
                            "GitHub for data and codes"),
                     br(),
                     tags$a(href="https://github.com/ooluw007/Capstone", 
                            "RPub for more instruction on the App"),
                     h4("Your Most Likely Next Word Shows Here"),
                     verbatimTextOutput("prediction"),
                     br(),
                     h4("This project is the final capstone for data science 
                     course offered jointly by Cousera and John Hopkins 
                     University. Data were sourced from SwiftKey"),
                     img(src = "logo3.png", height = 90, width = 500)
                 )
             )
    )
             
))


