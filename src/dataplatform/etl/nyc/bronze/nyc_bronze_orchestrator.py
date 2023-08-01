from spetlr.etl import Orchestrator
from spetlr.etl.loaders.simple_loader import SimpleLoader

from src.dataplatform.etl.nyc.bronze.nyc_bronze_parameters import NycBronzeParameters


class NycBronzeOrchestrator(Orchestrator):
    def __init__(self, params: NycBronzeParameters = None):
        super().__init__()

        self.params = params or NycBronzeParameters()

        self.extract_from()

        self.load_into(
            SimpleLoader(
                self.params.dh_target,
            )
        )
