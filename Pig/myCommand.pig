-- Only work for compact Json format
json_business_jsonLoader = LOAD '/user/cloudera/pighive/yelp_training_set_business_small.json' USING JsonLoader('business_id:chararray,full_address:chararray,open:boolean,categories:(chararray),city:chararray,review_count:int,name:chararray,longitude:double,state:chararray,stars:double,latitude:double');

-- load data
hadoop fs -put /media/sf_DE_June/Week9\&10_Project/RawData/yelp_training_set_business_small.json /user/cloudera/pighive
cd /media/sf_DE_June/Week12/Pig-Hive/Pig
hadoop fs -put elephant-bird-core-4.14-RC2.jar elephant-bird-pig-4.14-RC2.jar json-simple-1.1.1.jar /user/cloudera/pighive
hadoop fs -rm /user/cloudera/pighive/yelp_training_set_business_small.json

hadoop fs -get pigHive/pigOutput/json_business_table
hadoop fs -rm -R /user/cloudera/pighive/pigOutput

-- Get jar files from Maven repository
-- load before any further operations, otherwise there will be problems (See https://github.com/twitter/elephant-bird/issues/385)
REGISTER 'elephant-bird-core-4.14-RC2.jar';
REGISTER 'elephant-bird-pig-4.14-RC2.jar';
REGISTER 'json-simple-1.1.1.jar';
REGISTER 'elephant-bird-hadoop-compat-4.14-RC2.jar';

-- schema is json:map [], otherwise we can use $0# instead of json#
json_business_data = LOAD '/user/cloudera/pighive/yelp_training_set_business_small.json' USING com.twitter.elephantbird.pig.load.JsonLoader('-nestedLoad') AS (json:map []);
-- Need to replace /n in full_address to avoid formatting potential problems
json_business_row = FOREACH json_business_data GENERATE
    (chararray)json#'business_id' As business_id,
    (chararray)REPLACE(json#'full_address', '\\n', ', ') As full_address,
    (boolean)json#'open' As open, json#'categories' As categories,
    (chararray)json#'city' As city, (int)json#'review_count' As review_count,
    (chararray)json#'name' As name, (double)json#'longitude' As longitude,
    (chararray)json#'state' As state, (double)json#'stars' As stars,
    (double)json#'latitude' As latitude;
STORE json_business_row INTO 'hdfs:///user/cloudera/pighive/pigOutput/json_business_table' USING PigStorage();
-- get business with rating above 3.0
SPLIT json_business_row INTO group_business_bad IF stars < 3.0, group_business_good IF stars >= 3.0;
DUMP group_business_good;
