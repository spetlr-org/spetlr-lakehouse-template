from spetlr.etl import Orchestrator
from spetlr.etl.loaders.simple_loader import SimpleLoader

from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_parameters import NycTlcGoldParameters
from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_transformer import NycTlcGoldTransfomer


class NycTlcGoldOrchestrator(Orchestrator):
    def __init__(self, params: NycTlcGoldParameters = None):
        super().__init__()

        self.params = params or NycTlcGoldParameters()

        self.extract_from(self.params.dh_source)

        self.transform_with(NycTlcGoldTransfomer)

        self.load_into(
            SimpleLoader(
                self.params.dh_target,
            )
        )
