from dataplatform.environment.init_configurator import init_configurator
from dataplatform.environment.setup_environment import setup_environment
from dataplatform.etl.nyc_tlc.gold.nyc_tlc_gold_orchestrator import (
    NycTlcGoldOrchestrator,
)


def main():
    print("NYC TCL main job")
    init_configurator()

    setup_environment()

    print("NYC TLC Bronze Orchestrator")
    NycTlcGoldOrchestrator().execute()
