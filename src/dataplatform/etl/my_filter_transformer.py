import pyspark.sql.functions as F
from pyspark.sql import DataFrame
from spetlr.etl import TransformerNC


class MyFilterTransformer(TransformerNC):
    def process(self, df: DataFrame) -> DataFrame:
        # Business logic
        df = df.where(F.col("Measurement").isNotNull())

        return df
