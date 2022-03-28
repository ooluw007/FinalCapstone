
################ Sentiment Analysis ##########################

news_txt <- readLines("en_US/en_US.news.txt", warn = FALSE, encoding = "UTF-8", 
                      skipNul = TRUE)
news_txt

newsSample_txt     <- sample(news_txt, length(news_txt) * 0.01, replace = FALSE)

install.packages("syuzhet")
library(syuzhet)
newsSample_txt2 <- get_sentences(newsSample_txt) 
newsSample_txt2

install.packages("SentimentAnalysis")
library(SentimentAnalysis, warn.conflicts = FALSE)

sentiment_df <- analyzeSentiment(newsSample_txt2)
str(sentiment_df)

# Extract dictionary-based sentiment according to the QDAP dictionary
SentimentQDAP_df <- sentiment_df$SentimentQDAP

# View sentiment direction (i.e. positive, neutral and negative)
sentimentDirection_char <- convertToDirection(SentimentQDAP_df)
sentimentDirection_df <- data.frame("SentimentDirection" = sentimentDirection_char)
head(sentimentDirection_df)

# Combine sentiment direction with SentimentQDAP in a data set
sentimentDirection_df$SentimentQDAP <- sentiment_df$SentimentQDAP
str(sentimentDirection_df)
head(sentimentDirection_df, 10)

#Draw a pie chart
library(tidyverse)
sentimentDirection_df %>% 
  drop_na() %>% 
  ggplot(., aes(x = "", y = SentimentDirection, fill = SentimentDirection)) +
  geom_col() +
  coord_polar(theta = "y") +
  labs(x = "", y = "Sentiment Direction")


sentimentDirection_df %>% 
  drop_na() %>% 
  ggplot(., aes(x = "", y = SentimentDirection, fill = SentimentDirection)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  theme_void()

################## Emotion Analysis ##############################

#Create a dataframe for emotions by review
library(sentimentr)
# OR
library(data.table)
# Run
# newsSample_txt2 <- get_sentences(newsSample_txt) 
str(newsSample_txt2)

emotion_df <- setDF(emotion_by(newsSample_txt2))
str(emotion_df)
head(emotion_df)

emotion_df2 <- emotion_df %>% 
  filter(!str_detect(emotion_type, "_negated"))
head(emotion_df2)


emotion_df2 %>% 
  drop_na() %>% 
  ggplot(., aes(x = "", y = emotion_type, fill = emotion_type)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  theme_void()

