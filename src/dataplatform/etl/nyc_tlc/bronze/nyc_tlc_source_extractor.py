from pyspark.sql import DataFrame
from spetlr.etl import Extractor
from spetlr.spark import Spark

from dataplatform.etl.nyc_tlc.bronze.nyc_tlc_bronze_parameters import (
    NycTlcBronzeParameters,
)


class NycTlcSourceExtractor(Extractor):
    def __init__(self, params: NycTlcBronzeParameters):
        super().__init__()
        self.params = params

    def read(self) -> DataFrame:
        return (
            Spark.get()
            .read.format("csv")
            .option("delimiter", ",")
            .option("header", True)
            .load(self.params.nyc_tlc_path)
        )
