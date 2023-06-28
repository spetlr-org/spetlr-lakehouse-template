from atc import Configurator

from dataplatform.environment import bronze, silver


def initConfigurator():
    tc = Configurator()
    tc.register("ENV", "prod")

    tc.add_sql_resource_path(bronze)
    tc.add_sql_resource_path(silver)
