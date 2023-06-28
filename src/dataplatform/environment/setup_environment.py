from atc.sql.SqlExecutor import SqlExecutor

from dataplatform.environment import bronze, silver


def setup_environment():
    print("Creating 01_bronze")
    SqlExecutor(base_module=bronze).execute_sql_file("*")
    print("Creating 02_silver")
    SqlExecutor(base_module=silver).execute_sql_file("*")
