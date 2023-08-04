from test.env.CleanupTestDatabases import CleanupTestDatabases
from test.env.debug_configurator import debug_configurator

from spetlr.sql.SqlExecutor import SqlExecutor
from spetlr.utils import DataframeCreator
from spetlrtools.testing import DataframeTestCase

from dataplatform.environment import databases
from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_orchestrator import (
    NycTlcGoldOrchestrator,
)
from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_parameters import NycTlcGoldParameters
from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_transformer import NycTlcGoldTransfomer


class SilverOrchestratorTests(DataframeTestCase):
    @classmethod
    def setUpClass(cls) -> None:
        debug_configurator()
        SqlExecutor(base_module=databases).execute_sql_file("nyc_tlc_gold.sql")

        cls.params = NycTlcGoldParameters()
        cls.sut = NycTlcGoldTransfomer(cls.params)

        cls.df_silver = DataframeCreator.make_partial(
            cls.source.read().schema,
            [
                "vendorID",
                "passengerCount",
                "tripDistance",
                "paymentType",
                "tipAmount",
                "totalAmount",
            ],
            [
                # row 1
                (
                    "1",  # vendorID
                    1,  # passengerCount
                    10.1,  # tripDistance
                    "Credit",  # paymentType
                    10.1,  # tipAmount
                    100.1,  # totalAmount
                ),
                # row 2
                (
                    "1",  # vendorID
                    2,  # passengerCount
                    20.2,  # tripDistance
                    "Credit",  # paymentType
                    0.0,  # tipAmount
                    200.2,  # totalAmount
                ),
                # row 3
                (
                    "2",  # vendorID
                    3,  # passengerCount
                    30.3,  # tripDistance
                    "Cash",  # paymentType
                    30.0,  # tipAmount
                    300.3,  # totalAmount
                ),
            ],
        )

    @classmethod
    def tearDownClass(cls) -> None:
        CleanupTestDatabases()

    def test_01_can_orchestrate_gold(self):
        NycTlcGoldOrchestrator(self.params).execute()
        self.assertGreater(self.params.dh_target.read().count(), 0)

    def test_02_transfomer_gold(self):
        df = self.sut.process(self.df_silver)

        self.assertDataframeMatches(
            df,
            [
                "VendorID",
                "TotalPassengers",
                "TotalTripDistance",
                "TotalTipAmount",
                "TotalPaidAmount",
            ],
            [
                # row 1
                (
                    "1",  # VendorID
                    3,  # TotalPassengers
                    30.3,  # TotalTripDistance
                    10.1,  # TotalTipAmount
                    300.3,  # TotalPaidAmount
                ),
            ],
        )
