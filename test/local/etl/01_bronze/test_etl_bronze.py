import unittest

from spetlr.schema_manager import SchemaManager
from spetlr.spark import Spark
from spetlr_tools.testing import DataframeTestCase
from spetlr_tools.testing.TestHandle import TestHandle

from dataplatform.etl import DemoEtl, DemoParams

"""class Test_DemoEtl(DataframeTestCase):
    def test_demo_etl(self):
        data_source_1 = [
            ("1", "2023-01-01T10:00:00.000Z", "1.1", "temp"),
            ("1", "2023-01-01T11:00:00.000Z", None, "temp"),
        ]

        df_source_1 = Spark.get().createDataFrame(
            data=data_source_1,
            schema=SchemaManager().get_schema("BronzeDemoTable1"),
        )

        testSource1Handle = TestHandle(provides=df_source_1)

        data_source_2 = [
            ("2", "2023-01-01T10:00:00.000Z", "2.2", "temp"),
        ]

        df_source_2 = Spark.get().createDataFrame(
            data=data_source_2,
            schema=SchemaManager().get_schema("BronzeDemoTable2"),
        )

        testSource2Handle = TestHandle(provides=df_source_2)

        testSinkHandle = TestHandle()

        testParams = DemoParams(
            source1DeltaHandler=testSource1Handle,
            source2DeltaHandler=testSource2Handle,
            sinkDeltaHandler=testSinkHandle,
        )

        orchestrator = DemoEtl(params=testParams)

        orchestrator.execute()

        df_overwritten = testSinkHandle.overwritten

        self.assertIsNotNone(df_overwritten)

        self.assertEqualSchema(
            schema1=df_overwritten.schema,
            schema2=testParams.sinkSchema,
        )

        self.assertTrue(df_overwritten.count() == 2)


if __name__ == "__main__":
    local.main()
"""
