
library(shiny)

ui <- shinyUI(fixedPage(
    titlePanel(h2(strong("JHU/Coursera Data Science Course Final Project"), align = "center", 
                          h4(strong("N-grams Words Prediction Based on News, Blogs 
                             and Twitter Text Data"), align = "center"))),
    wellPanel(img(src = "logo2.png", height = 100, width = 860, align = "center"),
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
                     titlePanel(h5(strong("Word or Phrase Input"))),
                     helpText("The box below take a word or a phrase you enter
                              and predict the next most likely word in the box 
                              on the right.",
                              br(),
                              "For example, you can entered the phrase:", 
                              strong(div(HTML("<em>It is good to see...</em>"))),
                             "then, the app will predict next word as:", 
                              strong(div(HTML("<em>you.</em>")))),
                     br(),
                     textInput("inputString", strong("Enter a word or a phrase"),
                               value = ""),
                     helpText("Once you finished typing your word or phrase, 
                              please click on the blue button below for 
                              suggested next word"),
                     submitButton('Click for next word')
                 ),
                 mainPanel(
                     h4(strong("About the App")),
                     h4("The app demonstrate backoff predictive model using text 
                     data to predict possible next English word with good 
                     accuracy when a word or phrase is entered. We used twitter,
                     news and blogs combined text data provided by Cousera and 
                     SwiftKey.", 
                     "From the data, we developed N-grams (2 to 4) library from 
                     which possible next word are drawn."),
                     #br(),
                     tags$h4(strong("More Info")),
                     tags$a(href="https://github.com/ooluw007/FinalCapstone", 
                            strong("GitHub for data and codes")),
                     br(),
                     tags$a(href="https://rpubs.com/Olu/883001", 
                            strong("RPub for more instruction on the App")),
                     br(),
                     br(),
                     h4(strong("Your Most Likely Next Word Shows Here"), 
                        align = "center"),
                     verbatimTextOutput("prediction"),
                     br(),
                     h4("This project is the final capstone for data science 
                     course offered jointly by Cousera and John Hopkins 
                     University. Data were sourced from SwiftKey"),
                     img(src = "logo3.png", height = 85, width = 600, align = "center")
                 )
             )
    )
             
))


