-- File preparation
cd /media/sf_DE_June/Week12/Pig-Hive/Hive
hadoop fs -put json-serde-1.3.7-jar-with-dependencies.jar /user/cloudera/pighive/
hadoop fs -mkdir -p pighive/businessExternal
hadoop fs -put /media/sf_DE_June/Week9\&10_Project/RawData/yelp_training_set_business_small.json /user/cloudera/pighive/businessExternal

-- Beeline CLI
beeline
!connect jdbc:hive2://localhost:10000 cloudera cloudera

-- Get jar file from https://github.com/rcongiu/Hive-JSON-Serde
-- Absolute path needed
ADD JAR hdfs:/user/cloudera/pighive/json-serde-1.3.7-jar-with-dependencies.jar；

-- Load data into hive table from Json
CREATE EXTERNAL TABLE Yelp_Business(
    business_id STRING,
    full_address STRING,
    open BOOLEAN,
    categories ARRAY<STRING>,
    city STRING,
    review_count INT,
    name STRING,
    neighborhoods ARRAY<STRING>,
    longitude DOUBLE,
    state STRING,
    stars DOUBLE,
    latitude DOUBLE,
    type STRING
)
COMMENT 'Data of businesss on yelp'
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '/user/cloudera/pighive/businessExternal';

-- Can also load later
LOAD DATA INPATH '/user/cloudera/pighive/yelp_training_set_business_small.json' OVERWRITE INTO TABLE Yelp_Business;

SELECT full_address FROM Yelp_Business LIMIT 1;

-- Map from Hive to Hbase
CREATE TABLE HiveToHBase_Yelp_Business(
    business_id STRING,
    full_address STRING,
    open BOOLEAN,
    categories ARRAY<STRING>,
    city STRING,
    review_count INT,
    name STRING,
    neighborhoods ARRAY<STRING>,
    longitude DOUBLE,
    state STRING,
    stars DOUBLE,
    latitude DOUBLE,
    type STRING
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,businesscf:full_address,businesscf:open,businesscf:categories,businesscf:city,businesscf:review_count,businesscf:name,businesscf:neighborhoods,businesscf:longitude,businesscf:state,businesscf:stars,businesscf:latitude,businesscf:type')
TBLPROPERTIES ('hbase.table.name' = 'Yelp_Business_From_Hive');
-- Use :key to map the first column in Hive as key in Hbase
-- Note: whitespace should not be used in between entries of the comma-delimited
-- hbase.columns.mapping string, since these will be interperted as part of the
-- column name, which is almost certainly not what you want.
-- Since HBase does not associate datatype information with columns, the serde
-- converts everything to string representation before storing it in HBase; there
-- is currently no way to plug in a custom serde per column

FROM Yelp_Business INSERT INTO TABLE HiveToHBase_Yelp_Business SELECT *;
-- Note: If you try to load the data directly into table HiveToHBase_Yelp_Business you will get an error.
