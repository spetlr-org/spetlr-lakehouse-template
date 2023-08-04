import pyspark.sql.functions as f
from pyspark.sql import DataFrame
from spetlr.etl import Transformer

from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_parameters import NycTlcGoldParameters


class NycTlcGoldTransfomer(Transformer):
    def __init__(self, params: NycTlcGoldParameters):
        super().__init__()
        self.params = params or NycTlcGoldParameters()

    def process(self, df: DataFrame) -> DataFrame:
        df = (
            df.filter(f.col("paymentType") == "Credit")
            .groupBy("vendorId")
            .agg(
                f.sum("passengerCount").alias("TotalPassengers"),
                f.sum("tripDistance").alias("TotalTripDistance"),
                f.sum("tipAmount").alias("TotalTipAmount"),
                f.sum("totalAmount").alias("TotalPaidAmount"),
            )
        )
        df_final = df.select(
            f.col("vendorID").alias("VendorID"),
            f.col("TotalPassengers"),
            f.col("TotalTripDistance"),
            f.col("TotalTipAmount"),
            f.col("TotalPaidAmount"),
        )

        return df_final
