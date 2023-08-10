import unittest

from spetlrtools.testing import DataframeTestCase
from spetlrtools.testing.TestHandle import TestHandle

from dataplatform.etl import DemoEtl, DemoParams


class Test_DemoEtl(DataframeTestCase):
    def test_demo_etl(self):
        testSinkHandle = TestHandle()

        testParams = DemoParams(sinkDeltaHandler=testSinkHandle)

        orchestrator = DemoEtl(params=testParams)

        orchestrator.execute()

        df_overwritten = testSinkHandle.overwritten

        self.assertIsNotNone(df_overwritten)

        self.assertEqualSchema(
            schema1=df_overwritten.schema,
            schema2=testParams.sinkSchema,
        )

        self.assertTrue(df_overwritten.count() > 0)


if __name__ == "__main__":
    unittest.main()
