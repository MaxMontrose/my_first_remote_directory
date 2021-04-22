# load in the pdf
library(pdftools)
library(tesseract)
library(tm)
library(tidyverse)
library(tokenizers)
library(cluster)
getwd()
setwd("~/my_first_remote_directory/stephanie_mudge_strategy/raw_data/chronicling_america_sample/")
pdf <- "./0380.pdf"
pdf2 <- "./0034.pdf"
text_data2 <- pdf_text(pdf2)
cat(text_data2)

ocr_output2 <- ocr(pdf2, engine = "eng")
head(ocr_output2)

pdf2_data <- ocr_data(pdf2)
head(pdf2_data)

con_scores2 <- pdf2_data$confidence
mean(con_scores2)
median(con_scores2)

pdf2_data

table(pdf2_data$word)

ocr_output2_a <- str_replace_all(ocr_output2, "[^A-Za-z]", " ")
ocr_output2_b <- str_split(ocr_output2_a, " ")
ocr_output2_c <- lapply(ocr_output2_b, function(x) x[x != ""])
length(ocr_output2_c[[1]])
stopwords(ocr_output2_c)

### Problems I see with 0380: 
##### 1) Huge random spaces
##### 2) missing large portions of the text
##### 3) issue w initial read - PDF error: Couldn't find a font for 'Times-Roman'

### Problems with 0034: 
##### 1) random strings of letters
##### 2) comes back with some spanish text, even after specifying english
##### 3) really low mean confidence score (51.93), median is 50.51
##### 4) almost no actual words (when I clean it and add up words, many of which 
#####    aren't even coherent, it's only 3782)
##### 5) when I ran stopwords(ocr_output2_c), I got return "no stopwords available"



