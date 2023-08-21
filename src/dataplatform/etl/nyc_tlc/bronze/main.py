from dataplatform.environment import init_configurator
from dataplatform.environment.setup_environment import setup_environment
from dataplatform.etl.nyc_tlc.bronze.nyc_tlc_bronze_orchestrator import (
    NycTlcBronzeOrchestrator,
)


def main():
    print("NYC TCL main job")
    init_configurator()

    setup_environment()

    print("NYC TLC Bronze Orchestrator")
    NycTlcBronzeOrchestrator().execute()
