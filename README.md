# Pig and Hive ETL

## Intro
Data source: [Kaggle Yelp Recruiting Competition](https://www.kaggle.com/c/yelp-recruiting])

Extract business information from *yelp_training_set_business.json* on a cluster with Pig and Hive Beeline CLI respectively.
Select good business with star > 3 in Beeline.
Then transform data from Hive to Hbase.

Commands and in-line comments see *myCommand.pig* and *myCommand.hql*.

## Asides
1. Built-in JsonLoader can only handle compact Json file, which cannot satisfy general use cases http://stackoverflow.com/questions/31594652/jsonloader-throws-error-in-pig  
2. So we need to turn to elephant-bird https://github.com/twitter/elephant-bird
3. How to load Json into pig using elephant-bird https://github.com/twitter/elephant-bird/tree/master/examples/src/main/pig
4. Hive read/write SerDe for JSON Data https://github.com/rcongiu/Hive-JSON-Serde
5. Load data into Hive (Chinese) https://www.iteblog.com/archives/899
6. Tutorials on internal and external tables https://www.dezyre.com/hadoop-tutorial/apache-hive-tutorial-tables
7. Hive to Hbase https://cwiki.apache.org/confluence/display/Hive/HBaseIntegration
8. ERROR: Can't get master address from ZooKeeper; znode data == null; Try to restart the whole system (https://community.cloudera.com/t5/Storage-Random-Access-HDFS/HBase-Can-t-get-master-address-from-ZooKeeper-I-am-getting-this/td-p/29935 http://www.cnblogs.com/suddoo/p/4986094.html)
