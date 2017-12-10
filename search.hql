# on the command line we run the following commands by specifying the terms separate by comma and top_n 
#value to specify how many matching result to show on screen for each search

# search for champions,allegations
hive -hiveconf terms=champions,allegations -hiveconf top_n=1 -f query.hql
hive -hiveconf terms=champions,allegations -hiveconf top_n=3 -f query.hql
hive -hiveconf terms=champions,allegations -hiveconf top_n=5 -f query.hql

# search for advantage,football
hive -hiveconf terms=advantage,football -hiveconf top_n=1 -f query.hql
hive -hiveconf terms=advantage,football -hiveconf top_n=3 -f query.hql
hive -hiveconf terms=advantage,football -hiveconf top_n=5 -f query.hql

