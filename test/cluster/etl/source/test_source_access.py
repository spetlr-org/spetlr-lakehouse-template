import unittest

from spetlr.spark import Spark

from dataplatform.etl.nyc_tlc.bronze.nyc_tlc_bronze_parameters import (
    NycTlcBronzeParameters,
)


class TestSource(unittest.TestCase):
    @classmethod
    def setup_method(cls):
        cls.params = NycTlcBronzeParameters()
        cls.path = cls.params.nyc_tlc_path
        cls.sc = Spark.get().sparkContext
        cls.fs = cls.sc._jvm.org.apache.hadoop.fs.FileSystem.get(
            cls.sc._jsc.hadoopConfiguration()
        )

    def test_01_source_path_exists(self):
        """
        This method tests if the csv source path exists in the abfs file system
        """
        assert self.fs.exists(self.sc._jvm.org.apache.hadoop.fs.Path(self.path))
