-- SPETLR.CONFIGURATOR key: NycTlcBronzeDb
CREATE DATABASE IF NOT EXISTS {NycTlcBronzeDb}
COMMENT "Bronze Database for NYC TLC"
LOCATION "{NycTlcBronzeDb_path}";

-- SPETLR.CONFIGURATOR key: NycTlcBronzeTable
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
COMMENT "This table contains bronze data for NYC TLC"
LOCATION "{NycTlcBronzeTable_path}";