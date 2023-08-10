import pyspark.sql.functions as F
from spetlr.etl import TransformerNC
from pyspark.sql import DataFrame


class MyFilterTransformer(TransformerNC):
    def process(self, df: DataFrame) -> DataFrame:
        # Business logic
        df = df.where(F.col("Measurement").isNotNull())

        return df
