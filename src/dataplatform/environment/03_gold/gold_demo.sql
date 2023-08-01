-- spetlr.configurator key: GoldDemoDB
CREATE DATABASE IF NOT EXISTS gold_demo{ID};

-- spetlr.configurator key: GoldDemoTable
CREATE TABLE IF NOT EXISTS {GoldDemoDB_name}.gold_demo(
  Id BIGINT,
  EventTimestamp TIMESTAMP,
  Measurement DOUBLE
)
USING delta
COMMENT "This table contains demo gold data"
LOCATION "/tmp/demo/gold{ID}/gold_demo";