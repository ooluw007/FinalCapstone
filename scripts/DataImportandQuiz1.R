# Read data file downloaded from coursera
# Data path (folder)
dataPath <- "C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US"

# Function for reading the
dataList <- list.files(path=dataPath, recursive=T, pattern=".*en_.*.txt")
myfunc <- lapply(paste(dataPath, dataList, sep="/"), function(f) {
  fsize <- file.info(f)[1]/1024/1024
  con <- file(f, open="r")
  lines <- readLines(con)
  nchars <- lapply(lines, nchar)
  maxchars <- which.max(nchars)
  nwords <- sum(sapply(strsplit(lines, "\\s+"), length))
  close(con)
  return(c(f, format(round(fsize, 2), nsmall=2), length(lines), maxchars, nwords))
})

# Data characteristics
mydf <- data.frame(matrix(unlist(myfunc), nrow=length(myfunc), byrow=T))
colnames(mydf) <- c("file", "size(MB)", "num.of.lines", "longest.line", "num.of.words")
mydf

setwd("C:/Users/justi/Documents/Olu_Drive/Coursera/Data_Science_Statistics_and_Machine_Learning_Specialization/Capstone/en_US")

# Loading text data: en_us.blog, en_us.news and en_us.twitter
blog <- file("en_US.blogs.txt", "r")
news <- file("en_US.news.txt", "r")
twitter <- file("en_US.twitter.txt", "r")


# Ratio (proportion) of love to hate words
lineswithLove <- (grepl(" love ", readLines("en_US.twitter.txt")))
loveWords <- table(lineswithLove)["TRUE"]
linesWithhate <- (grepl(" hate ", readLines("en_US.twitter.txt")))
hateWords <- table(linesWithhate)["TRUE"]

loveToHate <- loveWords/hateWords

loveToHate

# Extract rest of line that contain "biostats"
readLines("en_US.twitter.txt")[grep("biostats",readLines("en_US.twitter.txt"))]

# How many tweets have the exact characters "A computer once beat me at 
#  chess, but it was no match for me at kickboxing". (I.e. the line matches 
#  those characters exactly.)
exactChar <- (grepl("A computer once beat me at chess, but it was no match for me at kickboxing", 
                    readLines("en_US.twitter.txt")))
numTwitter <- table(exactChar)["TRUE"]
numTwitter



