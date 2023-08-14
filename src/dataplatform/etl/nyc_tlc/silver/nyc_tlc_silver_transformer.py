import pyspark.sql.functions as f
from pyspark.sql import DataFrame
from spetlr.etl import Transformer

from dataplatform.etl.nyc_tlc.silver.nyc_tlc_silver_parameters import (
    NycTlcSilverParameters,
)


class NycTlcSilverTransfomer(Transformer):
    def __init__(self, params: NycTlcSilverParameters = None):
        super().__init__()
        self.params = params or NycTlcSilverParameters()

    def process(self, df: DataFrame) -> DataFrame:
        df = df.withColumn(
            "paymentType",
            f.when(f.col("paymentType") == "1", "Credit")
            .when(f.col("paymentType") == "2", "Cash")
            .when(f.col("paymentType") == "3", "No charge")
            .when(f.col("paymentType") == "4", "Dispute")
            .when(f.col("paymentType") == "5", "Unknown")
            .when(f.col("paymentType") == "6", "Voided trip")
            .otherwise("Undefined"),
        )

        df_final = df.select(
            f.col("vendorID"),
            f.col("passengerCount"),
            f.col("tripDistance"),
            f.col("paymentType").cast("string"),
            f.col("tipAmount"),
            f.col("totalAmount"),
        )

        return df_final
