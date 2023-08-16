CREATE DATABASE IF NOT EXISTS {NycTlcGoldDb}
COMMENT "Gold Database for NYC TLC"
LOCATION "{NycTlcGoldDb_path}";

CREATE TABLE IF NOT EXISTS {NycTlcGoldTable}
(
  VendorID INTEGER,
  TotalPassengers INTEGER,
  TotalTripDistance DECIMAL(10, 1),
  TotalTipAmount DECIMAL(10, 1),
  TotalPaidAmount DECIMAL(10, 1)
)
USING delta
COMMENT "This table contains gold NYC TLC data, that are paid by credit cards and grouped by VendorId"
LOCATION "{NycTlcGoldTable_path}";