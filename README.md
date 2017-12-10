# TFIDF-Elastic-Search
Implementation of TFIDF and Elastic Search using Hive for the "big data tool" course as part of Master of Sience in Data Science program.
My program creates Inverted index, TFID score for every word in each document, and finally retrieve documents with highest score containing the provided search words.

Highlights:
•	I used Apache HIVE 
•	As the input I used “football” folder in BBC articles collection provided as part of the exam.
- There are two files:
  •	TFIDF.hql: for making inverted index and calculating TFIDF scores
  •	Query.hql: One can easily search for any word(s) by calling hive and specifying search terms (separated by comma) and number of matching documents to retrieve on screen and executing Query.hql file from command line
