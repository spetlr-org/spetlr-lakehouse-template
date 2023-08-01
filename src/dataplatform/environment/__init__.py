from spetlr import Configurator

from dataplatform.environment import bronze, gold, silver


def initConfigurator():
    tc = Configurator()
    tc.register("ENV", "prod")

    tc.add_sql_resource_path(bronze)
    tc.add_sql_resource_path(silver)
    tc.add_sql_resource_path(gold)
