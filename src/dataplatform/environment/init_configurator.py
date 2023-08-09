from spetlr import Configurator

from dataplatform.environment import config
from dataplatform.environment.databases import bronze, gold, silver


def init_configurator():
    c = Configurator()
    c.add_resource_path(config)
    c.add_sql_resource_path(bronze)
    c.add_sql_resource_path(silver)
    c.add_sql_resource_path(gold)
    return c


def cli():
    init_configurator().cli()
