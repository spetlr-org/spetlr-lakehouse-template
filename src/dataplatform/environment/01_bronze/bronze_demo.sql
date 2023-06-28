-- atc.configurator key: BronzeDemoDB
CREATE DATABASE IF NOT EXISTS bronze_demo{ID};

-- atc.configurator key: BronzeDemoTable1
CREATE TABLE IF NOT EXISTS {BronzeDemoDB_name}.bronze_demo_1(
  Id STRING,
  EventTimestamp STRING,
  Measurement STRING,
  Metadata STRING
)
USING delta
COMMENT "This table contains demo bronze data"
LOCATION "/tmp/demo/bronze{ID}/bronze_demo_1";

-- atc.configurator key: BronzeDemoTable2
CREATE TABLE IF NOT EXISTS {BronzeDemoDB_name}.bronze_demo_2(
  Id STRING,
  EventTimestamp STRING,
  Measurement STRING,
  Metadata STRING
)
USING delta
COMMENT "This table contains demo bronze data"
LOCATION "/tmp/demo/bronze{ID}/bronze_demo_2";