from dataplatform.etl.nyc_tlc.bronze.nyc_tlc_bronze_orchestrator import (
    NycTlcBronzeOrchestrator,
)
from src.dataplatform.environment.setup_environment import setup_environment
from src.dataplatform.environment.table_names import init_configurator


def main():
    print("NYC TCL main job")
    init_configurator()

    setup_environment()

    print("NYC TLC Bronze Orchestrator")
    NycTlcBronzeOrchestrator().execute()
