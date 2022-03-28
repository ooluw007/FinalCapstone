##################### Introduction ##########################
# We will use use twitter data file to illustrated cleaning and modeling of the 
#  the text data for this project.

# First. We will generate a corpus for twitter data using `Corpus(DirSource())` from the 
# `library(tm)`. Then we will clean the corpus and analysis the data.

##################### Loading Package and Data #################
# Load package 'tm' and `NLP`
library("tm")

# Set directory
setwd("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US")

# Load data `twitter`
twitter <- readLines("en_US.twitter.txt", warn = FALSE, encoding = "UTF-8")

# Sample data `twitter` (1%)
sampleTwitter <-sample(twitter,length(twitter)*0.005)

# Remove latin words using `latin1` function
sampleTwitter <-iconv(sampleTwitter,"latin1","ASCII",sub="")

############## Create corpus - `twitterCorpus` #####################
twitterCorpus <- VCorpus(VectorSource(sampleTwitter))

# Inspect `twitterCorpus`
# inspect(twitterCorpus)
# writeLines(as.character(twitterCorpus))

# Twitter preprocessing
### Remove all irrelevant punctuations to ensure that proper cleaning,
### function `content_tranformer` will be first used on 'twitterCorpus` data to
### introduce necessary spacing where required and tranforming word **ex-vice**
### to **ex vice** instead of **exvice**.

##################### Cleaning Corpus #############################
# Write function to apply `content_transformer` function
myTransFunc <- content_transformer(
  function(x, pattern){
    return(gsub(pattern, " ", x))
  }
)

# Remove characters: "-", "'", ":", ";" and " -"
twitterCorpus2 <- tm_map(twitterCorpus, myTransFunc, "-")
twitterCorpus2 <- tm_map(twitterCorpus2, myTransFunc, "'")
twitterCorpus2 <- tm_map(twitterCorpus2, myTransFunc, ":")
twitterCorpus2 <- tm_map(twitterCorpus2, myTransFunc, ";")
twitterCorpus2 <- tm_map(twitterCorpus2, myTransFunc, " -")

# remove punctuations
twitterCorpus3 <- tm_map(twitterCorpus2, removePunctuation) 

# Remove digits (numbers)
twitterCorpus3 <- tm_map(twitterCorpus3, removeNumbers)

# Remove extra white spaces
twitterCorpus3 <- tm_map(twitterCorpus3, stripWhitespace)

# Transform characters to lowercase
twitterCorpus3 <- tm_map(twitterCorpus3, content_transformer(tolower)) 

#removing stop words in English 
twitterCorpus3 <- tm_map(twitterCorpus3, removeWords, stopwords("english"))

# Inspect `twitterCorpus3`
# writeLines(as.character(twitterCorpus3[[1]]))
# writeLines(as.character(twitterCorpus3[[10]]))
# writeLines(as.character(twitterCorpus3[[20]]))

# Remove some certain irrelevant common words
twitterCorpus4 <- tm_map(twitterCorpus3, removeWords, 
                         c("fuck", "rofl", "omg", "s", "luv", "u", "shit",
                           "porn", "pornstar", "n", "vs", "bit", "yay",
                           "oh", "lots", "ha" , "ah", "nigga", "mad", "started",
                           "starting", "saying", "haha", "can", "every", "get",
                           "hey", "didn", "gonna", "don", "lol", "now", "one", 
                           "yeah", "wanna", "just", "like", "will", "two", "dont",
                           "also", "maybe", "guys", "already", "saw", "ass", 
                           "use", "makes", "make", "made", "trying", "done", 
                           "god", "away"))

# Inspect `twitterCorpus4`
# writeLines(as.character(twitterCorpus4[[1]]))
# writeLines(as.character(twitterCorpus4[[10]]))
# writeLines(as.character(twitterCorpus4[[20]]))

#writeCorpus(twitterCorpus3, path = ".", filenames = "twitterCorpus3.txt")

################## Word Stemming ###################################
# For this i will not data, there isn't need for stemming.
# install.packages("SnowballC")
library("SnowballC")
twitterCorpus5 <- tm_map(twitterCorpus4, stemDocument)
#writeLines(as.character(twitterCorpus5[[1]]))

############## Creating Document-term Matrix #######################
twitterCorpus6 <- DocumentTermMatrix(twitterCorpus4)
twitterCorpus_mt <- as.matrix(twitterCorpus6)
# Inspect matrix
# inspect(twitterCorpus6[1:5, 1:5])

twitterCorpus10 <- sort(rowSums(as.matrix(twitterBigramTdm[twitterCorpus6,])), decreasing = TRUE)
# dataframe
twitterCorpus10_df <-data.frame(word = names(twitterCorpus10),frequency = twitterCorpus10) 
head(twitterCorpus10_df)

######## Understand frequencies of words and word pairs ######
# Generate word frequency from twitter document
twitterWordFreq_num1 <- colSums(twitterCorpus_mt)
length(twitterWordFreq_num1)
twitterWordFreq_num1[head(order(twitterWordFreq_num1, decreasing = TRUE))]
twitterWordFreq_num1[tail(order(twitterWordFreq_num1, decreasing = TRUE))]


# Most frequent words
findFreqTerms(twitterCorpus6, lowfreq = 200)
findFreqTerms(twitterCorpus6, lowfreq = 100)
findFreqTerms(twitterCorpus6, lowfreq = 80)
findFreqTerms(twitterCorpus6, lowfreq = 50)

# Find correlation of five most frequent words:
#   love   good    day thanks  today  great
findAssocs(twitterCorpus6, "love", .1)
findAssocs(twitterCorpus6, "good", .1)
findAssocs(twitterCorpus6, "day", .1)
findAssocs(twitterCorpus6, "thanks", .1)
findAssocs(twitterCorpus6, "today", .1)


############# Graphic Visualization of Words #################
# Histogram
library(tidyverse)
#twitterWordFreq_num1 <- sort(twitterWordFreq_num1, decreasing = T)
twitterCorpus6_df <- data.frame(word = names(twitterWordFreq_num1),
                                frequency = twitterWordFreq_num1)

# Create to class to highlight most frequent word
twitterCorpus6_df <- twitterCorpus6_df %>%
  mutate(class = case_when(frequency > 500 ~ "More than 500 words", 
                           frequency <= 500 ~ "Less than 500 words"))

ggplot(subset(twitterCorpus6_df, twitterWordFreq_num1>200)) +
  aes(reorder(word,  frequency), frequency, fill = class) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip()

# WorldCloud
library(wordcloud)
set.seed(12345)
wordcloud(names(twitterWordFreq_num1), twitterWordFreq_num1, min.freq = 70)
wordcloud(names(twitterWordFreq_num1), twitterWordFreq_num1, min.freq = 70,
          colors = brewer.pal(8, "Dark2"))
  





########## N-Grams Analysis ######################
# Tokenizing by n-gram: By seeing how often word X is followed by word Y, we 
#   can then build a model of the relationships between them.

library(tidyverse)
library(tidytext)
library(janeaustenr)

twitter <- file("en_US.twitter.txt")
tidy_books <- twitter %>%
  unnest_tokens(word, text)

tidy_books


# Unigram (1-gram) tokenization
twitterCorpus6_unigrams <- austen_books() %>%
  unnest_tokens(unigram, text, token = "ngrams", n = 1)

twitterCorpus6_unigrams %>%
  count(unigram, sort = TRUE)



# Bigram (2-gram) tokenization
twitterCorpus6_bigrams <- twitter %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

twitterCorpus6_bigrams %>%
  count(bigram, sort = TRUE)

# Remove stop words
bigrams_separated <- austen_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)


# Bigram (3-gram) tokenization
twitterCorpus6_trigrams <- austen_books() %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3)

twitterCorpus6_trigrams %>%
  count(trigram, sort = TRUE)

twitterCorpus6_trigrams





























