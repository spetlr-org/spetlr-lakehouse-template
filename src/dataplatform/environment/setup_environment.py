from spetlr.sql.SqlExecutor import SqlExecutor

from dataplatform.environment.databases import bronze, gold, silver


def setup_environment():
    print("Creating bronze database")
    SqlExecutor(base_module=bronze).execute_sql_file("*")
    print("Creating silver database")
    SqlExecutor(base_module=silver).execute_sql_file("*")
    print("Creating gold database")
    SqlExecutor(base_module=gold).execute_sql_file("*")
