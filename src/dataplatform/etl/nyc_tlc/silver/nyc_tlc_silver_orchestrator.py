from spetlr.etl import Orchestrator
from spetlr.etl.loaders.simple_loader import SimpleLoader

from dataplatform.etl.nyc_tlc.silver.nyc_tlc_silver_parameters import (
    NycTlcSilverParameters,
)
from dataplatform.etl.nyc_tlc.silver.nyc_tlc_silver_transformer import (
    NycTlcSilverTransfomer,
)


class NycTlcSilverOrchestrator(Orchestrator):
    def __init__(self, params: NycTlcSilverParameters = None):
        super().__init__()

        self.params = params or NycTlcSilverParameters()

        self.extract_from(self.params.dh_source)

        self.transform_with(NycTlcSilverTransfomer)

        self.load_into(
            SimpleLoader(
                self.params.dh_target,
            )
        )
