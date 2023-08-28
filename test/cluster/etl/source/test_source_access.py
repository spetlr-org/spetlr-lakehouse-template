import unittest
from test.env.debug_configurator import debug_configurator

from py4j.java_gateway import java_import
from spetlr.spark import Spark

from dataplatform.etl.nyc_tlc.bronze.nyc_tlc_bronze_parameters import (
    NycTlcBronzeParameters,
)


class TestSource(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        debug_configurator()
        cls.params = NycTlcBronzeParameters()
        java_import(Spark.get()._jvm, "org.apache.hadoop.fs.Path")
        cls.fs = Spark.get()._jvm.FileSystem.get(Spark.get()._jsc.hadoopConfiguration())
        cls.path = cls.params.nyc_tlc_path

    def test_01_source_path_exists(self):
        """
        This method tests if the csv source path exists in the abfs file system
        """
        assert self.fs.exists(Spark.get()._jvm.Path(self.path))
