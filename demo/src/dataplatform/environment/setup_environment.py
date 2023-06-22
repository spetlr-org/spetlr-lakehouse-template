from atc.sql.SqlExecutor import SqlExecutor

from dataplatform.environment import bronze, silver


def setup_environment():
    print("Creating bronze")
    SqlExecutor(base_module=bronze).execute_sql_file("*")
    print("Creating silver")
    SqlExecutor(base_module=silver).execute_sql_file("*")
