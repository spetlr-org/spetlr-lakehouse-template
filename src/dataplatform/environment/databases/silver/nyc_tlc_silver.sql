CREATE DATABASE IF NOT EXISTS {NycTlcSilverDb};

CREATE TABLE IF NOT EXISTS {NycTlcSilverTable} (
  vendorID INTEGER,
  passengerCount INTEGER,
  tripDistance DOUBLE,
  paymentType STRING,
  tipAmount DOUBLE,
  totalAmount DOUBLE
)
USING delta
COMMENT "This table contains demo silver data"
LOCATION "{NycTlcSilverTable_path}";