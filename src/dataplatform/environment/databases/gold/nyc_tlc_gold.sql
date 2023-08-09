CREATE DATABASE IF NOT EXISTS {DemoGoldDb};

CREATE TABLE IF NOT EXISTS {DemoGoldTable} (
  VendorID STRING,
  TotalPassengers INTEGER,
  TotalTripDistance DOUBLE,
  TotalTipAmount DOUBLE,
  TotalPaidAmount DOUBLE
)
USING delta
COMMENT "This table contains demo gold data, that are paid by credit cards and grouped by VendorId"
LOCATION "{DemoGoldTable_path}";