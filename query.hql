set terms;
set top_n;

DROP TABLE IF EXISTS bbc.user_input ;
DROP TABLE IF EXISTS bbc.user_input1 ;
DROP TABLE IF EXISTS bbc.user_input2 ;
DROP TABLE IF EXISTS bbc.user_input3 ;

CREATE TABLE bbc.user_input (term string);
insert into table bbc.user_input values ('${hiveconf:terms}');
create table bbc.user_input1 as select word from bbc.user_input LATERAL VIEW explode(split(term,',')) t as word;

create table bbc.user_input2 as select count(word) as word_count from bbc.user_input1;


create table bbc.user_input3 as select docid, sum(tfidf)*count(docid) as nn_score
from bbc.tfidfnew
where word in (select word from bbc.user_input1)
group by docid;

select t1.docid, round(t1.nn_score/t2.word_count,2) as score from bbc.user_input3 as t1 cross join bbc.user_input2 as t2
order by score desc
limit ${hiveconf:top_n};

