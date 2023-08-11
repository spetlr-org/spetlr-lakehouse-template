# spetlr-lakehouse-template

## Introduction
Welcome to the SPETLR Databricks Lakehouse Platform Template project! This project is designed to provide you with a fully unit and integration tested template for creating a robust lakehouse platform in Databricks. The template is built upon the best practices of data engineering and aims to streamline your development process, ensuring a reliable and scalable data platform.

Utilizing the popular NYC taxi dataset as example data, we've structured the template to showcase three simple ETL (Extract, Transform, Load) processes that demonstrate the power of a lakehouse platform. Each ETL process corresponds to a different layer in the data lake architecture: Bronze, Silver, and Gold. By following this tiered approach, you'll be able to efficiently transform raw data into valuable insights for your business needs.

**Key Features**
 

* Fully unit and integration tested: SPETLR's template includes a comprehensive suite of tests that ensure the reliability and accuracy of the codebase.
* NYC Taxi dataset example: Learn how to work with a real-world dataset that demonstrates the power of Databricks and the lakehouse platform.
* Three ETL processes: Experience the Bronze, Silver, and Gold layers of a data lake architecture through our well-documented ETL processes.
* Best practices implementation: Benefit from a template that follows best practices in data engineering for a scalable and maintainable platform.

Get started with the SPETLR Databricks Lakehouse Platform Template and accelerate your path to building a reliable, scalable, and efficient lakehouse platform in Databricks!


## Medallion architecture
The diagram illustrates the Medallion Architecture followed in the SPETLR Databricks Lakehouse Platform Template. It provides a visual representation of the flow of data through the Bronze, Silver, and Gold layers of the data lake, showcasing the ETL processes and transformations at each stage.

![medallion-architecture](medallion_architecture.drawio.png)





## Source

### NYC Taxi & Limousine Commission - yellow taxi trip records

In the spetlr lakehouse template storage account, a copy of the NYC TLC dataset in uploaded. A smaller version of the file is located in `/data` folder.

*"The yellow taxi trip records include fields capturing pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and driver-reported passenger counts."* - [learn.microsoft.com](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets)

[Link to original dataset location](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

## Bronze
The table structures in this layer correspond to the source system table structures "as-is". Saved as a delta table.

| vendorID | tpepPickupDateTime    | tpepDropoffDateTime  | passengerCount | tripDistance | puLocationId | doLocationId | rateCodeId | storeAndFwdFlag | paymentType | fareAmount | extra | mtaTax | improvementSurcharge | tipAmount | tollsAmount | totalAmount |
|----------|-----------------------|----------------------|----------------|--------------|--------------|--------------|------------|-----------------|-------------|------------|-------|--------|----------------------|-----------|-------------|-------------|
| 2        | 1/24/2088 12:25:39 AM | 1/24/2088 7:28:25 AM | 1              | 4.05         | 24           | 162          | 1          | N               | 2           | 14.5       | 0     | 0.5    | 0.3                  | 0         | 0           | 15.3        |

## Silver
The data from the Bronze layer is conformed and cleansed so that the Silver layer only consists of the columns of interests with paymentType converted to easy-to-understand string values.

| vendorID | passengerCount | tripDistance | paymentType | tipAmount | totalAmount |
|----------|----------------|--------------|-------------|-----------|-------------|
|   2       |    1  | 4.05            |     Credit        |   0        |      15.3       |

## Gold
The silver data is used for presenting a consumption-ready gold table. In this demo project, the gold table consists of column aggregates for credit card payments grouped by vendors.


| VendorID | TotalPassengers | TotalTripDistance | TotalTipAmount | TotalPaidAmount |
|----------|-----------------|-------------------|----------------|-----------------|
|     1     |    5083             |      1109             |  7100              |  90023               |

# Azure Architeture
The Bicep-generated Azure Architecture Cloud Diagram below presents a visualization of the various Azure resources deployed within a single resource group. These resources are used in supporting the SPETLR Databricks Lakehouse Platform Template. Here is a brief overview of the Azure resources:

* Key Vault: This is a secure and centralized store for managing secrets, keys, and certificates. It helps protect sensitive information and ensures secure access to resources.
* Databricks Workspace: The core component of the template. Azure Databricks is a fully managed first-party service that enables an open data lakehouse in Azure.
* Storage Account: This is a scalable and durable cloud storage service that provides the ability to store and manage file shares, blobs, tables, and queues.
* Containers: Utilized within the Storage Account, containers are used to store and organize large volumes of data in the form of blobs - one container for each layer in the medallion architecture. 

![az_arch](/azure_arhitecture.png)
