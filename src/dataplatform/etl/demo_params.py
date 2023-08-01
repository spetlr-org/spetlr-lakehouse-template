from dataclasses import dataclass

import pyspark.sql.types as T
from spetlr.delta.delta_handle import DeltaHandle
from spetlr.schema_manager import SchemaManager
from spetlr.tables import TableHandle


@dataclass
class DemoParams:
    source1DeltaHandler: TableHandle = DeltaHandle.from_tc("BronzeDemoTable1")
    source2DeltaHandler: TableHandle = DeltaHandle.from_tc("BronzeDemoTable2")

    sinkSchema: T.StructType = SchemaManager().get_schema("SilverDemoTable")
    sinkDeltaHandler: TableHandle = DeltaHandle.from_tc("SilverDemoTable")
