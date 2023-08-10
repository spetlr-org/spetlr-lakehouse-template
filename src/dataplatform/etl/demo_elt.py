from spetlr.etl import Orchestrator
from spetlr.etl.extractors import SimpleExtractor
from spetlr.etl.loaders import SimpleLoader
from spetlr.transformers import (
    SelectAndCastColumnsTransformerNC as SelectAndCastColumnsTransformer,
)
from spetlr.transformers import UnionTransformerNC as UnionTransformer

from .demo_params import DemoParams
from .my_filter_transformer import MyFilterTransformer


class DemoEtl(Orchestrator):
    def __init__(self, params: DemoParams = None):
        super().__init__()

        params = params or DemoParams()

        self.extract_from(
            SimpleExtractor(handle=params.source1DeltaHandler, dataset_key="df_source1")
        )

        self.extract_from(
            SimpleExtractor(handle=params.source2DeltaHandler, dataset_key="df_source2")
        )

        self.transform_with(
            MyFilterTransformer(
                dataset_input_keys="df_source1", dataset_output_key="df_source1"
            )
        )

        self.transform_with(
            UnionTransformer(
                dataset_input_keys=["df_source1", "df_source2"],
                dataset_output_key="df_union",
            )
        )

        self.transform_with(
            SelectAndCastColumnsTransformer(
                schema=params.sinkSchema,
                dataset_input_keys="df_union",
                dataset_output_key="df_sink",
            )
        )

        self.load_into(
            SimpleLoader(
                handle=params.sinkDeltaHandler,
                mode="overwrite",
                dataset_input_keys="df_sink",
            )
        )


def run_etl():
    DemoEtl().execute()
