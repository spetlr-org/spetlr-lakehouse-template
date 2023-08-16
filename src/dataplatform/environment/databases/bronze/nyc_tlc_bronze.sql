-- SPETLR.CONFIGURATOR
CREATE DATABASE IF NOT EXISTS {NycTlcBronzeDb}
COMMENT "Bronze Database of NYC TLC Records"
LOCATION "{NycTlcBronzeDb_path}";

-- SPETLR.CONFIGURATOR
CREATE TABLE IF NOT EXISTS {NycTlcBronzeTable} (
  vendorID INTEGER,
  tpepPickupDateTime TIMESTAMP,
  tpepDropoffDateTime TIMESTAMP,
  passengerCount INTEGER,
  tripDistance DOUBLE,
  puLocationId STRING,
  doLocationId STRING,
  startLon DOUBLE,
  startLat DOUBLE,
  endLon DOUBLE,
  endLat DOUBLE,
  rateCodeId INTEGER,
  storeAndFwdFlag STRING,
  paymentType STRING,
  fareAmount DOUBLE,
  extra DOUBLE,
  mtaTax DOUBLE,
  improvementSurcharge STRING,
  tipAmount DOUBLE,
  tollsAmount DOUBLE,
  totalAmount DOUBLE
)
USING delta
COMMENT "This table contains demo bronze data"
LOCATION "{NycTlcBronzeTable_path}";