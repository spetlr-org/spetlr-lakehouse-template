from spetlr.sql.SqlExecutor import SqlExecutor

from dataplatform.environment import databases


def setup_environment():
    print("Creating bronze NYC TLC databases and tables")
    SqlExecutor(base_module=databases).execute_sql_file("nyc_tlc_bronze.sql")
    print("Creating silver NYC TLC databases and tables")
    SqlExecutor(base_module=databases).execute_sql_file("nyc_tlc_silver.sql")
    print("Creating gold NYC TLC databases and tables")
    SqlExecutor(base_module=databases).execute_sql_file("nyc_tlc_gold.sql")
