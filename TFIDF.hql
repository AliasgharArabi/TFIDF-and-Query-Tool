# creating directory for project and copying text files onto HDFS
(1) Hadoop fs -mkdir /user/root/bbc
(2) Hadoop fs -put *.txt /user/root/bbc
TFID.hql
# creating hive table and loading the data into it
(3) create table bbc.football (text string);
(4) load data inpath '/user/root/bbc/*.txt' overwrite into table bbc.data;
# adding a column that contains the full path info of the documents the text is read from using hive virtual variable
(5) create table bbc.data1 as select INPUT_FILE_NAME as docid, text from bbc.data where text != '';
# tokenizing the text into terms
(6) create table bbc.data2 as select * from bbc.data1 LATERAL VIEW explode(split(text,' ')) t as word;
# scrubbing the terms
(7) create table bbc.data3 as select docid, translate(word, "'&#($)-%", '') as word from bbc.data2;
(8) create table bbc.data4 as select docid, translate(word, ",.`[]{}", '') as word from bbc.data3; (9) create table bbc.data5 as select * from bbc.data4 where word REGEXP ‘[A-Za-z]+’;
# keeping file number from the full path and turn all terms into lower case
(10) create table bbc.data6 as select substr(docid, 70, 3) as docid, trim(lower(regexp_replace(word, '"', ""))) as word from bbc.data5;
# removing stop words and keeping only terms with at least 3 characters
(11) create table bbc.data7 as select docid, word from bbc.data6 
where word not in ('able','about','across','after','all','almost','also','among','and','any','are','because','been','but',’can','cannot','could','dear','did','does','either','else','ever','every','for','from','get','got','had','has','have','her','hers','him','his','how','however','into','its','just','least','let','like','likely','may','might','most','must','neither','nor','not','off','often','only','other','our','own','rather','said','say','says','she','should','since','some','than','that','the','their','them','then','there','these','they','this','tis','too','twas','wants','was','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your') 
and length(word) > 2;
# creating inverted index
(12) create table bbc.invrt_indx as select word, concat_ws(",", collect_set(docid)) from bbc.data7 group by word;
# calculating tf, idf, and tfidf score for each term in each document
(13) create table bbc.tf as select docid, word, count(word) as tf from bbc.data7 group by docid, word;
# finding df for each word and joining it to the tf table
(14) create table bbc.df as select word, count(DISTINCT docid) as df from bbc.data7 group by word;
(15) create table bbc.df1 as select t1.*, t2.df from bbc.tf as t1 left join bbc.df as t2 on t1.word=t2.word;
# retrieving the number of documents and adding to the df table
(16) create table bbc.n_docs as select count(DISTINCT docid) as n_docs from bbc.df1;
(17) create table bbc.df2 as select t1.*, t2.n_docs from bbc.df1new as t1 cross join bbc.n_docs as t2; 
# adding idf, tfidf to the table along with tf score
(18) create table bbc.tfidf as 
select docid, word, tf, df, round(log10(n_docs/df),2) as idf, 
round(tf * log10(n_docs/df),2) as tfidf 
from bbc.df2;
