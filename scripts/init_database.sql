/*
Summary:
 This script initializes a SQL Server database named 'DataWarehouse' and sets up a structured schema architecture for data processing. 
It includes three schemas:
  1. Bronze: Raw data storage.
  2. Silver: Cleansed and transformed data.
  3. Gold: Optimized data for reporting and analytics.
*/

--create database
USE master;

CREATE DATABASE DataWarehouse;

USE DataWarehouse;


--create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
