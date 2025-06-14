🚀 **End-to-End Business Intelligence & Data Analytics Project | SQL Server + Power BI Integration** 📊![image](https://github.com/user-attachments/assets/4cf7be06-3e70-4115-bbd5-581abe99539a)


# 📊 Sales Reporting and Profitability Analysis Project

## 📝 Project Overview

This project simulates a full professional BI solution for Sales Reporting using:

- **SQL Server** (for data storage, transformation, and modeling)
- **Power BI Desktop** (for data visualization)
- **Power BI Service** (for publishing and user access control)

The project showcases end-to-end steps:
- Data import from CSV to SQL Server
- Data cleansing, preparation, and modeling with Views, Stored Procedures, and KPIs
- Building an advanced Power BI dashboard
- Applying Row-Level Security (RLS) for user-level access control
- Publishing to Power BI Service

---

## 📂 Project Structure

| Folder | Content |
| ------ | ------- |
| `SQL_Scripts/` | Full SQL scripts for table creation, data loading, transformations, KPIs, Views, Procedures, and Security setup |
| `PowerBI_File/` | Power BI report file (.pbix) |
| `Documentation/` | Project documentation files |
| `Sample_Data/` | Sample CSV files used for initial data import |
| `Screenshots/` | Dashboard screenshots |

---

## ⚙️ Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- Power BI Service
- Power Query
- DAX (Data Analysis Expressions)

---

## 🚀 Project Flow

1️⃣ **Data Import**

- Raw CSV files (Transactions 1997, Transactions 1998)
- Imported to SQL Server using `BULK INSERT` and staging tables.

2️⃣ **Data Modeling**

- Database: `SalesReporting`
- Tables: `All_Transactions`, `Product Data`, `Customer Data`, `Store Data`, `Region Data`, etc.
- Views: Analytical Views for Sales, Customers, Products, and Stores.
- Stored Procedures: Profitability Analysis, Period Analysis.
- KPIs: Business Metrics and Performance Indicators.

3️⃣ **Power BI Connection**

- DirectQuery/Import from SQL Server
- Built multiple pages dashboard (Profitability, Customer Segmentation, Sales Trend, Store Performance, Product Analysis)

4️⃣ **Security Layer**

- Row-Level Security (RLS) using Security Table `Clean Data.User_Security`
- Roles: Manager, Analyst, Viewer

5️⃣ **Deployment**

- Published to Power BI Service Workspace
- Created Power BI App for end users
- Applied permissions and monitoring

---

## 🔐 Row-Level Security (RLS)

| Role | Access Control |
| ---- | -------------- |
| **Regional Manager** | Can see only their assigned region |
| **Analyst** | Can access all data except sensitive KPIs |
| **Viewer** | Can only read allowed pages, no export |

---

## 🧮 KPIs Included

- Total Revenue
- Total Profit
- Profit Margin %
- Top Customers
- Top Products
- Store Performance
- Customer Segmentation by Gender, Marital Status, Education, and Family

---

## 📈 Benefits Demonstrated

✅ Full Data Pipeline Development  
✅ Advanced SQL Queries and Optimization  
✅ Clean Data Modeling Best Practices  
✅ Analytical Thinking and KPI Design  
✅ End-to-End BI Architecture  
✅ Row-Level Security Implementation  
✅ Enterprise Level Deployment Workflow

---

## 📩 Contact

Project Developed by:  
**Said Hamed**  
[[LinkedIn Profile]
http://www.linkedin.com/in/said-hamed-39a541291

---
