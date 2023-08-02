from spetlr import Configurator

from dataplatform.environment import databases


def init_configurator():
    c = Configurator()
    c.register("ENV", "dev", "test", "prod")
    c.add_sql_resource_path(databases)

    return c
