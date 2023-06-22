import unittest

from atc.schema_manager import SchemaManager
from atc.utils import DataframeCreator
from atc_tools.testing import DataframeTestCase

from dataplatform.etl import MyFilterTransformer


class Test_MyFilterTransformer(DataframeTestCase):
    def test_measurement_null_filter(self):
        df_input = DataframeCreator.make_partial(
            schema=SchemaManager().get_schema("BronzeDemoTable1"),
            columns=["Measurement"],
            data=[("1234",), (None,)],
        )

        df_transformed = MyFilterTransformer().process(df_input)

        self.assertDataframeMatches(
            df=df_transformed,
            columns=["Measurement"],
            expected_data=[("1234",),],
        )


if __name__ == "__main__":
    unittest.main()
