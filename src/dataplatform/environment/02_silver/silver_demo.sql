-- atc.configurator key: SilverDemoDB
CREATE DATABASE IF NOT EXISTS silver_demo{ID};

-- atc.configurator key: SilverDemoTable
CREATE TABLE IF NOT EXISTS {SilverDemoDB_name}.silver_demo(
  Id BIGINT,
  EventTimestamp TIMESTAMP,
  Measurement DOUBLE
)
USING delta
COMMENT "This table contains demo silver data"
LOCATION "/tmp/demo/silver{ID}/silver_demo";