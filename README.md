## 📌 Building the Data Warehouse (Data Engineering)

### 🎯 Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

### 📝 Specifications
- **Data Sources:** Import data from two source systems (**ERP** and **CRM**) provided as **CSV files**.
- **Data Quality:** Cleanse and resolve **data quality issues** prior to analysis.
- **Integration:** Combine both sources into a **single, user-friendly data model** designed for analytical queries.
- **Scope:** Focus on the **latest dataset only**; historization of data is **not required**.
- **Documentation:** Provide **clear documentation** of the data model to support both business stakeholders and analytics teams.

## 📊 BI: Analytics & Reporting (Data Analysis)

### 🎯 Objective
Develop **SQL-based analytics** to deliver detailed insights into:

- 📌 **Customer Behavior**
- 📌 **Product Performance**
- 📌 **Sales Trends**

These insights empower stakeholders with **key business metrics**, enabling **strategic decision-making**.

# 🚀 Project Requirements

## 🏗️ Data Architecture  
The data architecture for this project follows the **Medallion Architecture** with Bronze, Silver, and Gold layers:

- **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into a SQL Server database.  
- **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.  
- **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.  

---

## 🛠️ Building the Data Warehouse (Data Engineering)  

### **Objective**  
Develop a modern data warehouse using **SQL Server** to consolidate sales data, enabling analytical reporting and informed decision-making.  

### **Specifications**  
- **Data Sources**: Import data from two source systems (**ERP and CRM**) provided as CSV files.  
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.  
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.  
- **Scope**: Focus on the latest dataset only; historization of data is not required.  
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.  

---

## 📊 BI: Analytics & Reporting (Data Analysis)  

### **Objective**  
Develop SQL-based analytics to deliver detailed insights into:  

- **Customer Behavior**  
- **Product Performance**  
- **Sales Trends**  

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  


