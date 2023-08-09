CREATE DATABASE IF NOT EXISTS {DemoBronzeDb};

CREATE TABLE IF NOT EXISTS {DemoBronzeTable} (
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
LOCATION "{DemoBronzeTable_path}";