from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_orchestrator import (
    NycTlcGoldOrchestrator,
)
from src.dataplatform.environment import init_configurator
from src.dataplatform.environment.setup_environment import setup_environment


def main():
    print("NYC TCL main job")
    init_configurator()

    setup_environment()

    print("NYC TLC Bronze Orchestrator")
    NycTlcGoldOrchestrator().execute()
