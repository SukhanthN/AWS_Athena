CREATE EXTERNAL TABLE IF NOT EXISTS default.cloudfront_logs (
  `date` DATE,
  time STRING,
  location STRING,
  bytes BIGINT,
  request_ip STRING,
  method STRING,
  host STRING,
  uri STRING,
  status INT,
  referrer STRING,
  user_agent STRING,
  query_string STRING,
  cookie STRING,
  result_type STRING,
  request_id STRING,
  host_header STRING,
  request_protocol STRING,
  request_bytes BIGINT,
  time_taken FLOAT,
  xforwarded_for STRING,
  ssl_protocol STRING,
  ssl_cipher STRING,
  response_result_type STRING,
  http_version STRING,
  fle_status STRING,
  fle_encrypted_fields INT,
  c_port INT,
  time_to_first_byte FLOAT,
  x_edge_detailed_result_type STRING,
  sc_content_type STRING,
  sc_content_len BIGINT,
  sc_range_start BIGINT,
  sc_range_end BIGINT
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
LOCATION 's3://resumesukhanthlogs/'   
TBLPROPERTIES ( 'skip.header.line.count'='2' )

------------------------------------------------------------------------------------------------


-- **EXAMPLE QUERIES  FOR CLOUD FRONT** --

-- number of bytes served by CloudFront between 2018-06-09 and 2018-06-11 --

SELECT SUM(bytes) AS total_bytes
FROM cloudfront_logs
WHERE "date" BETWEEN DATE '2018-06-09' AND DATE '2018-06-11'
LIMIT 100;

--**Run the query for the all statements**--

SELECT DISTINCT * 
FROM cloudfront_logs 
LIMIT 10;

--** List clients in descending order, by the number of times that each client visited a specified IP **--

SELECT request_ip, location, count(*) as count from cloudfront_logs
GROUP by request_ip, location
ORDER by count DESC;

--** List clients in descending order, by the number of times that each client visited a specified IP, location, data, URL **--

SELECT request_ip, location, date, user_agent, count(*) as count from cloudfront_logs  
WHERE user_agent LIKE '%Chrome%'
GROUP by request_ip, location, date, user_agent
ORDER by count DESC;


--** View the first 100 access log entries in chronological order **--

SELECT *
FROM cloudfront_logs
ORDER by time ASC
LIMIT 100;

-- Shows the URLs visited by Chrome browser users:

SELECT request_url
FROM cloudfront_logs
WHERE user_agent LIKE '%Chrome%'
LIMIT 10;

