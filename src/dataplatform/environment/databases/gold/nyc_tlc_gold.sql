CREATE DATABASE IF NOT EXISTS {NycTlcGoldDb};

CREATE TABLE IF NOT EXISTS {NycTlcGoldTable} (
  VendorID INTEGER,
  TotalPassengers INTEGER,
  TotalTripDistance DECIMAL(10, 1),
  TotalTipAmount DECIMAL(10, 1),
  TotalPaidAmount DECIMAL(10, 1)
)
USING delta
COMMENT "This table contains demo gold data, that are paid by credit cards and grouped by VendorId"
LOCATION "{NycTlcGoldTable_path}";