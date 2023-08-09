CREATE DATABASE IF NOT EXISTS {DemoSilverDb};

CREATE TABLE IF NOT EXISTS {DemoSilverTable} (
  vendorID STRING,
  passengerCount INTEGER,
  tripDistance DOUBLE,
  paymentType STRING,
  tipAmount DOUBLE,
  totalAmount DOUBLE
)
USING delta
COMMENT "This table contains demo silver data"
LOCATION "{DemoSilverTable_path}";