# Pig and Hive ETL

## Intro
Data source: [Kaggle Yelp Recruiting Competition](https://www.kaggle.com/c/yelp-recruiting])

Extract business information from *yelp_training_set_business.json* on a cluster with Pig and Hive Beeline CLI respectively.
Select good business with star > 3 in Beeline.
Then transform data from Hive to Hbase.

Commands and in-line comments see *myCommand.pig* and *myCommand.hql*.
