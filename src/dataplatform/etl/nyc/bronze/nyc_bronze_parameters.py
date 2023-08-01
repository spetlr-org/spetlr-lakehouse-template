from spetlr import Configurator
from spetlr.delta import DeltaHandle


class NycBronzeParameters:
    def __init__(
        self,
        dh_target: str = None,
    ) -> None:
        self.nyc_csv_path = Configurator().get("DemoSource", "path")

        self.dh_target = dh_target or DeltaHandle.from_tc("DemoBronzeTable")
