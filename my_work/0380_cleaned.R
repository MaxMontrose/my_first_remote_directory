#### Working with 0380

#### Code: (Analysis further below)
######## Loading everything/initial interpretation
library(pdftools)
library(tesseract)
library(tm)
library(tidyverse)
library(tokenizers)
library(cluster)
setwd("~/my_first_remote_directory/stephanie_mudge_strategy/raw_data/chronicling_america_sample/")
pdf <- "./0380.pdf"
text_data <- pdf_text(pdf)
cat(text_data)

######## Turning it into a bag of words
# ocr_output <- ocr(pdf, engine = "eng")
# I immediately ran into an error because the font can't load properly, so I'm 
# going to try using the text the website provides.
library(xml2)
doc_ocr <- "https://chroniclingamerica.loc.gov/lccn/sn95026977/1906-11-21/ed-1/seq-4/ocr/"
ocr_html <- read_html(doc_ocr)
ocr_text <- xml_text(xml_find_all(ocr_html, "//body/div[3]//p"))
ocr_text <- str_replace_all(ocr_text, "[^A-Za-z]", " ")
ocr_split <- str_split(ocr_text, " ")
ocr_split <- lapply(ocr_split, function(x) x[x != ""])
cleaned_ocr <- lapply(ocr_split, function(x) tokenize_words(x, stopwords=stopwords("SMART"), lowercase=TRUE, strip_punct=TRUE, strip_numeric=TRUE))
str(cleaned_ocr)
ocr_cleaned <- cleaned_ocr[[1]]
ocr_corp <- Corpus(VectorSource(ocr_cleaned))
str(ocr_corp)
ocr_corp$content
ocr_table <- table(ocr_corp$content)
length(ocr_table)
head(ocr_table, 30)
ocr_frame <- data.frame(ocr_table)

# final product
ocr_sorted <- arrange(ocr_frame, desc(ocr_frame$Freq))
head(ocr_sorted, 30)

######## Attempt to find bigrams
ocr_bigram <- tokenize_ngrams(ocr_corp$content, 
                              n = 2, 
                              stopwords = stopwords("SMART"))
table(ocr_bigram)
# Didn't work at all, I'm assuming because the nature of the text makes it so that
# no sets of two consecutive strings would ever be the same. 

#### Analysis:
# 1) It would be pretty much impossible with my current capabilities to maintain
#    this text as anything other than a bag of words, or possibly a bigram. The
#    columns of the newspaper make it so that when the text actually does read
#    properly, it is chopped up and non-consecutive. 
# 2) Standard OCR does not work on this file (PDF error: Couldn't find a font for 
#    'Times-Roman'; PDF error: No current point in closepath). I tried messing
#    around with different variations on the code to solve this issue by specifying
#    a font, but couldn't figure it out. 
# 3) Using the text from the website gives a worse product:
#     a. Many of the words are repeated seemingly at random
#     b. Very few words are spelled properly, which means that it will be very
#        difficult to calculate word frequencies
# 4) Because I pulled the text from the website, I was unable to run ocr_data, 
#    which I would have liked so that I could see the confidence scores. However,
#    in this case, I think it would be safe to simply assume that it would not be
#    great. 
# 5) In terms of the project, this exercise makes me worried about how possible 
#    it is to identify helpful words, as most of my work was technically executable,
#    but not relatively useful. 


