################### Predictive Text concepts #######################

library(tidyverse)
# Preparing the data
blogs_txt <- readLines("en_US/en_US.blogs.txt", warn = FALSE, encoding = "UTF-8", skipNul = TRUE)
news_txt <- readLines("en_US/en_US.news.txt", warn = FALSE, encoding = "UTF-8", skipNul = TRUE)
twitter_txt <- readLines("en_US/en_US.twitter.txt", warn = FALSE, encoding = "UTF-8", skipNul = TRUE)

profanity_txt <- readLines("en_US/profanity.txt", warn = FALSE, encoding = "UTF-8", skipNul = TRUE)
profanity_df <- tibble(profanity_txt)

## Taking samples of data `blogs_txt`, `news_txt` and `twitter_txt`
# I will take 10% each from the three data sets and then combine then as single
# dataset `sample1_txt`

set.seed(12345)
blogsSample_txt    <- sample(blogs_txt, length(blogs_txt) * 0.05, replace = FALSE)
newsSample_txt     <- sample(news_txt, length(news_txt) * 0.05, replace = FALSE)
twitterSample_txt  <- sample(twitter_txt, length(twitter_txt) * 0.05, replace = FALSE)
sample1_txt = c(blogsSample_txt, newsSample_txt, twitterSample_txt)

# Remove lines with latin1 and ASCII characters.

latin1ASII_func <- grep("latin1ASII", iconv(sample1_txt, "latin1", "ASCII", sub="latin1ASII"))
sample2_txt <- sample1_txt[-latin1ASII_func]

# Remove special characters, digits and extra white space.

sample3_txt <- gsub("&amp", " ", sample2_txt)
sample3_txt <- gsub("RT :|@[a-z,A-Z]*: ", " ", sample3_txt) # remove tweets
sample3_txt <- gsub("@\\w+", " ", sample3_txt)
sample3_txt <- gsub("[[:digit:]]", " ", sample3_txt) # remove digits
sample3_txt <- gsub(" #\\S*"," ", sample3_txt)  # remove hash tags 
sample3_txt <- gsub(" ?(f|ht)tp(s?)://(.*)[.][a-z]+", " ", sample3_txt) # remove url
sample3_txt <- gsub('[[:punct:] ]+', " ", sample3_txt) # Remove punctuation
library(qdapRegex)
sample3_txt <- rm_white(sample3_txt) # remove extra spaces using `qdapRegex` package

## Putting `sample3_txt` in a Dataframe
#I will create a dataframe call `sample_df` as follow.
sample_df <- tibble(line = 1:length(sample3_txt), text = sample3_txt)
head(sample_df, 10)


# N-Grams Analysis

library(tidytext)

## Bigram

### Creating Bigram 

# Remove profane and extra irrelevant words
sampleBigram <- sample_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>% 
  separate(bigram, c("word1", "word2"), sep = " ", 
           extra = "drop", fill = "right") %>%
  filter(!word1 %in% profanity_df$profanity_txt,
         !word2 %in% profanity_df$profanity_txt) %>% # Remove profane words
  drop_na() %>% 
  unite(bigram, word1, word2, sep = " ")

bigram_df <- sampleBigram
head(bigram_df)

### Find Most Frequent Words in the Bigram
# Also, count word to for data visualization.

sampleBigram <- sampleBigram %>% 
  count(bigram, sort = TRUE) 

#head(sampleBigram, 10)

bigram_df <- sampleBigram
head(bigram_df)

### Bigram visualization

#### Histogram
ggplot(subset(sampleBigram, n > 3000)) +
  aes(reorder(bigram, n), n) +
  geom_histogram(stat = "identity", color="darkgray", fill="blueviolet") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_flip() +
  labs(x = "Bigram", y = "Frequency")

#### Line Graph for Bigram

sampleBigram %>% 
  filter(n > 3000) %>% 
  ggplot() +
  aes(n, reorder(bigram, n)) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.3, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = bigram), check_overlap = TRUE, vjust = 1.5) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  theme(legend.position="none") +
  labs(x = "Frequency", y = "Bigram")



#### Word cloud for Bigram
library(wordcloud)
sampleBigram %>%
  with(wordcloud(bigram, n, max.words = 50, colors = brewer.pal(8, "Dark2")))

################## Building the n-grams database #############
#Split each bigram into the first and second words and store them back
#into the same data frame
str(bigram_df)
bigram_df2 <- bigram_df %>%
  separate(bigram, c("word1", "word2"), sep = " ", 
           extra = "drop", fill = "right") %>%
  drop_na() 
head(bigram_df2)  

bigram_df2$bigram <- bigram_df$bigram
head(bigram_df2)

#Query for for second words and frequency where first word = "data", 
# we can suggest the most frequent second words is user types data
bigram_df2[bigram_df2$word1 == "see", c("word2", "n")]


###### Auto-complete for word "ap" - nos mostrará las posibles primeras 
# palabras que comiencen por ap y autocompletarlas.

#filter data frame for rows where column first starts with "ap"
autocomplete_filtered = bigram_df2[
  startsWith(
    as.character(bigram_df2$word1), "ap"), 
  c("word1", "n")]

#Aggregate across duplicate rows
autocomplete_summary = aggregate(n ~ word1, autocomplete_filtered, sum)

#Order in descending order of frequency
autocomplete_ordered = autocomplete_summary[
  with(autocomplete_summary, order(-n)), ]

#The predictive auto complete list.
autocomplete_ordered$word1


###### find next word for "apart" 

#Filter data frame where first word is "good"
nextword_filtered = bigram_df2[
  bigram_df2$word1 == "good", 
  c("n", "word2")]

#Order in descending order of frequency
nextword_ordered = nextword_filtered[
  with(nextword_filtered, order(-n)), ]

#The predicted next words
head(nextword_ordered$word2, 3)

