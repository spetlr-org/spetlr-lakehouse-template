# Code from: https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets

# This is a package in preview.
# You need to pip install azureml-opendatasets in Databricks cluster.
# https://learn.microsoft.com/azure/data-explorer/connect-from-databricks#install-the-python-library-on-your-azure-databricks-cluster
from azureml.opendatasets import NycTlcYellow
from dateutil import parser
from pathlib import Path

# This is used for uploading data to Storage Accounts
# start_date = parser.parse('2018-05-01')
# end_date = parser.parse('2018-06-06')

# This is used for local csv file
start_date = parser.parse('2018-05-01')
end_date = parser.parse('2018-05-02')

nyc_tlc = NycTlcYellow(start_date=start_date, end_date=end_date)
nyc_tlc_df = nyc_tlc.to_pandas_dataframe()
nyc_tlc_df.info()

# Run this from the spetlr-lakehouse-template/data folder
_data_folder_path = Path.cwd()
_file_name = "NYC_TLC_dataset.csv"
_save_to_path = _data_folder_path / _file_name

print(f"Save as csv to {_save_to_path}")
nyc_tlc_df.to_csv(_save_to_path)


