from spetlr import Configurator

from dataplatform.environment import config


def init_configurator():
    c = Configurator()
    c.add_resource_path(config)
    return c


def cli():
    init_configurator().cli()
