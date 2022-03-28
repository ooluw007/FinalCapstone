# Install tm package
install.packages("tm")

# Load require package: NPL
library(tm)

# Create Corpus (Collection of documents)
docs <- Corpus(DirSource("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US"))

str(docs)
# Inspect documents
# inspect(docs)

# Loading text data: en_us.blog, en_us.news and en_us.twitter
blog <- file("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.blogs.txt", "r")

# Number of lines in blog data
readSizeOfBlog <- 20000
noOfLinesBlog <- 0
( while((blogLinesRead <- length(readLines(blog,readSizeOfBlog))) > 0 )
  noOfLinesBlog <- noOfLinesBlog + blogLinesRead )
close(blog)
noOfLinesBlog
# OR
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.blogs.txt"))


news <- file("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.news.txt", "r")

# Number of lines in news data
readSizeOfNews <- 20000
noOfLinesNews <- 0
( while((newsLinesRead <- length(readLines(news,readSizeOfNews))) > 0 )
  noOfLinesNews <- noOfLinesNews + newsLinesRead )
close(news)
noOfLinesNews
# OR
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.news.txt"))

twitter <- file("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.twitter.txt", "r")

# Number of lines in twitter data
readSizeOfTwitter <- 20000
noOfLinesTwitter <- 0
( while((twitterLinesRead <- length(readLines(twitter,readSizeOfTwitter))) > 0 )
  noOfLinesTwitter <- noOfLinesTwitter + twitterLinesRead )
close(twitter)
noOfLinesTwitter
# OR
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.twitter.txt"))

## Read the first line of text 
readLines(blog, 1)  

## Read in the next 5 lines of text 
readLines(blog, 5)  


# Number of lines in blog file
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.blogs.txt"))




close(blog)

# Number of lines in news file
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.news.txt"))
close(blog)

# Number of lines in the twitter file
length(readLines("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US/en_US.twitter.txt"))
close(blog)

#testcon <- file("xyzfile.csv",open="r")
#readsizeof <- 20000
#nooflines <- 0
#( while((linesread <- length(readLines(testcon,readsizeof))) > 0 )
#  nooflines <- nooflines+linesread )
#close(testcon)
#nooflines


#testcon <- file("xyzfile.csv.bz2",open="r")
#readsizeof <- 20000
#nooflines <- 0
#( while((linesread <- length(readLines(testcon,readsizeof))) > 0 )
#  nooflines <- nooflines+linesread )
#close(testcon)
#nooflines

###############################################################################

con <- file("C:/Users/justi/Desktop/final/en_US/en_US.twitter.txt", "r")

## Read the first line of text 
readLines(blog, 1)  

## Read in the next 5 lines of text 
readLines(con, 5)  

## It's important to close the connection when you are done.
close(con)