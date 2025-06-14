create database SalesReportig;



CREATE TABLE All_Transactions (
    id INT IDENTITY(1,1) PRIMARY KEY,  
    transaction_date DATE,
    stock_date DATE,
    product_key INT,
    customer_key INT,
    store_key INT,
    quantity INT
);



INSERT INTO All_Transactions (transaction_date, stock_date, product_key, customer_key, store_key, quantity)
SELECT transaction_date, stock_date, product_key, customer_key, store_key, quantity
FROM [Transactions 1997];



--------------------------------------
-- 1- تحليل المبيعات والتكلفة والربح للمناطق
--------------------------------------

SELECT 
       r.Sales_Region,
       r.Country,
       COUNT(t.id) AS total_transactions,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent

FROM [ALL_Transactions] t
JOIN [Store Data] s ON t.store_key = s.store_id
JOIN [Region Data] r ON s.region_id = r.region_id
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY r.Sales_Region, r.Country
ORDER BY total_profit DESC;


--------------------------------------
-- 2- إجمالي المبيعات والربح حسب أعلى 10 فئات
--------------------------------------

SELECT TOP 10 
       p.category,
       COUNT(t.id) AS total_transactions,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(AVG(t.quantity * p.product_retail_price), 0) AS avg_revenue_per_transaction,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(AVG(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS avg_profit_per_transaction,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent

FROM [ALL_Transactions] t
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;


--------------------------------------
-- 3- تحليل الأداء والربح حسب نوع المتجر
--------------------------------------

SELECT 
       s.store_type,
       COUNT(DISTINCT s.store_id) AS store_count,
       COUNT(t.id) AS total_transaction,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(AVG(t.quantity * p.product_retail_price), 0) AS avg_revenue_per_transaction,
       ROUND(AVG(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS avg_profit_per_transaction,
       ROUND(SUM(t.quantity * p.product_retail_price) / COUNT(DISTINCT s.store_id), 0) AS avg_revenue_per_store,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / COUNT(DISTINCT s.store_id), 0) AS avg_profit_per_store,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent

FROM [Store Data] s
JOIN [ALL_Transactions] t ON s.store_id = t.store_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY s.store_type
ORDER BY total_profit DESC;


--------------------------------------
-- 4- تحليل أفضل 10 عملاء حسب الربح
--------------------------------------

SELECT TOP 10 
       c.customer_id,
       c.name,
             COUNT(t.id) AS total_transactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.customer_id, c.name
ORDER BY total_profit DESC;


--------------------------------------
-- 5- أفضل 10 عملاء حسب عدد المعاملات
--------------------------------------

SELECT TOP 10 
       c.customer_id,
       c.name,
       COUNT(t.id) AS total_transactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.customer_id,  c.name
ORDER BY total_transactions DESC;


--------------------------------------
-- 6- تحليل المبيعات حسب الجنس
--------------------------------------

SELECT 
       c.gender,
       COUNT(DISTINCT c.customer_id) AS UniqueCustomers,
       COUNT(t.id) AS TotalTransactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.gender
ORDER BY total_profit DESC;


--------------------------------------
-- 7- تحليل المبيعات حسب التعليم
--------------------------------------

SELECT 
       c.education,
       COUNT(DISTINCT c.customer_id) AS UniqueCustomers,
       COUNT(t.id) AS TotalTransactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.education
ORDER BY total_profit DESC;


--------------------------------------
-- 8- تحليل المبيعات حسب عدد الأطفال في المنزل
--------------------------------------

SELECT 
       c.num_children_at_home,
       COUNT(DISTINCT c.customer_id) AS UniqueCustomers,
       COUNT(t.id) AS TotalTransactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.num_children_at_home
ORDER BY total_profit DESC;


--------------------------------------
-- 9- تحليل المبيعات حسب امتلاك المنزل
--------------------------------------

SELECT 
       c.homeowner,
       COUNT(DISTINCT c.customer_id) AS UniqueCustomers,
       COUNT(t.id) AS TotalTransactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.homeowner
ORDER BY total_profit DESC;


--------------------------------------
-- 10- تحليل المبيعات حسب الحالة الاجتماعية
--------------------------------------

SELECT 
       c.marital_status,
       COUNT(DISTINCT c.customer_id) AS UniqueCustomers,
       COUNT(t.id) AS TotalTransactions,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit

FROM [Customer Data] c
JOIN [ALL_Transactions] t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id

GROUP BY c.marital_status
ORDER BY total_profit DESC;





-- إنشاء View موحد لتحليل المبيعات الكامل
CREATE VIEW vw_Sales_Analysis AS
SELECT 
       t.id AS transaction_id,
       t.transaction_date,
       t.stock_date,
       t.quantity,
       p.product_id,
       p.product_name,
       p.category,
       p.product_retail_price,
       p.product_cost,
       (p.product_retail_price - p.product_cost) AS unit_profit,
       (t.quantity * p.product_retail_price) AS total_revenue,
       (t.quantity * p.product_cost) AS total_cost,
       (t.quantity * (p.product_retail_price - p.product_cost)) AS total_profit,
       s.store_id,
       s.store_name,
       s.store_type,
       r.Sales_Region,
       r.Country,
       c.customer_id,
       c.name,
       c.gender,
       c.education,
       c.marital_status,
       c.num_children_at_home,
       c.homeowner
FROM [ALL_Transactions] t
JOIN [Product Data] p ON t.product_key = p.product_id
JOIN [Store Data] s ON t.store_key = s.store_id
JOIN [Region Data] r ON s.region_id = r.region_id
JOIN [Customer Data] c ON t.customer_key = c.customer_id;



--إنشاء إجراء مخزن لتحليل الربحية الإجمالية

CREATE PROCEDURE usp_Total_Profitability
AS
BEGIN
   SELECT 
       COUNT(t.id) AS total_transactions,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent
   FROM [ALL_Transactions] t
   JOIN [Product Data] p ON t.product_key = p.product_id;
END;




--تحليل الأداء الشهري
SELECT 
       FORMAT(t.transaction_date, 'yyyy-MM') AS transaction_month,
       COUNT(t.id) AS total_transactions,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent
FROM [ALL_Transactions] t
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY FORMAT(t.transaction_date, 'yyyy-MM')
ORDER BY transaction_month;



--تحليل أفضل 10 منتجات ربحية
SELECT TOP 10 
       p.product_id,
       p.product_name,
       p.category,
       SUM(t.quantity) AS total_quantity_sold,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent
FROM [ALL_Transactions] t
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_profit DESC;






--تحليل الربحية الإجمالية حسب السنة
SELECT 
       YEAR(t.transaction_date) AS transaction_year,
       COUNT(t.id) AS total_transactions,
       SUM(t.quantity) AS total_quantity,
       ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
       ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
       ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)) / NULLIF(SUM(t.quantity * p.product_retail_price),0)*100, 2) AS profit_margin_percent
FROM [ALL_Transactions] t
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY YEAR(t.transaction_date)
ORDER BY transaction_year;




--Monthly_Sales_Summary View

CREATE OR ALTER VIEW Monthly_Sales_Summary AS
SELECT 
    YEAR(transaction_date) AS sale_year,
    MONTH(transaction_date) AS sale_month,
    DATENAME(month, transaction_date) AS month_name,
    COUNT(id) AS transaction_count,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(quantity * product_retail_price), 0) AS total_revenue,
    ROUND(SUM(quantity * product_cost), 0) AS total_cost,
    ROUND(SUM(quantity * (product_retail_price - product_cost)), 0) AS total_profit,
    ROUND(SUM(quantity * (product_retail_price - product_cost)) / NULLIF(SUM(quantity * product_retail_price), 0) * 100, 2) AS profit_margin_percent,
    ROUND(AVG(quantity * product_retail_price), 0) AS avg_transaction_value,
    ROUND(AVG(quantity * (product_retail_price - product_cost)), 0) AS avg_profit_per_transaction
FROM ALL_Transactions t
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY YEAR(transaction_date), MONTH(transaction_date), DATENAME(month, transaction_date);




-- Customer_Analysis_View

CREATE OR ALTER VIEW Customer_Analysis_View AS
SELECT 
    c.customer_id,
    name,
    gender,
    yearly_income,
    education,
    marital_status,
    total_children,
    COUNT(t.id) AS total_transactions,
    SUM(t.quantity) AS total_quantity_purchased,
    ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
    ROUND(SUM(t.quantity * p.product_cost), 0) AS total_cost,
    ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
    ROUND(AVG(t.quantity * p.product_retail_price), 0) AS avg_revenue_per_transaction,
    ROUND(AVG(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS avg_profit_per_transaction,
    MAX(transaction_date) AS last_purchase_date,
    MIN(transaction_date) AS first_purchase_date
FROM [Customer Data] c
JOIN ALL_Transactions t ON c.customer_id = t.customer_key
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY c.customer_id,name, gender, yearly_income, education, marital_status, total_children;




-- Product_Performance_View

CREATE OR ALTER VIEW Product_Performance_View AS
SELECT 
    p.product_id,
    Product_Name,
    category,
    ROUND(product_retail_price, 0) AS product_retail_price,
    ROUND(product_cost, 0) AS product_cost,
    COUNT(t.id) AS times_sold,
    SUM(t.quantity) AS total_quantity_sold,
    ROUND(SUM(t.quantity * product_retail_price), 0) AS total_revenue,
    ROUND(SUM(t.quantity * product_cost), 0) AS total_cost,
    ROUND(SUM(t.quantity * (product_retail_price - product_cost)), 0) AS total_profit,
    ROUND(SUM(t.quantity * (product_retail_price - product_cost)) / NULLIF(SUM(t.quantity * product_retail_price), 0) * 100, 2) AS profit_margin_percent
FROM [Product Data] p
JOIN ALL_Transactions t ON p.product_id = t.product_key
GROUP BY p.product_id, Product_Name, category, product_retail_price, product_cost;





-- Store_Performance_View

CREATE OR ALTER VIEW Store_Performance_View AS
SELECT 
    s.store_id,
    store_name,
    store_type,
    store_city,
    store_state,
    r.Sales_Region,
    r.Country,
    COUNT(t.id) AS total_transactions,
    ROUND(SUM(t.quantity * p.product_retail_price), 0) AS total_revenue,
    ROUND(AVG(t.quantity * p.product_retail_price), 0) AS avg_transaction_value,
    ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) AS total_profit,
    COUNT(DISTINCT t.customer_key) AS unique_customers
FROM [Store Data] s
JOIN [Region Data] r ON s.region_id = r.region_id
JOIN ALL_Transactions t ON s.store_id = t.store_key
JOIN [Product Data] p ON t.product_key = p.product_id
GROUP BY s.store_id, store_name, store_type, store_city, store_state, r.Sales_Region, r.Country;

select * from Store_Performance_View

-- KPIs
SELECT 
    'Business KPIs' as metric_type,
    COUNT(DISTINCT c.customer_id) as total_customers,
    COUNT(DISTINCT s.store_id) as total_stores,
    COUNT(DISTINCT p.product_id) as total_products,
    COUNT(t.id) as total_transactions,
    ROUND(SUM(t.quantity * p.product_retail_price), 0) as total_revenue,
    ROUND(SUM(t.quantity * p.product_cost), 0) as total_cost,
    ROUND(SUM(t.quantity * (p.product_retail_price - p.product_cost)), 0) as total_profit,
    ROUND(AVG(t.quantity * p.product_retail_price), 0) as avg_transaction_value,
    ROUND(SUM(t.quantity * p.product_retail_price) / COUNT(DISTINCT c.customer_id), 0) as avg_customer_value
FROM [All_Transactions] t
JOIN [Customer Data] c ON t.customer_key = c.customer_id
JOIN [Store Data] s ON t.Store_key = s.store_id
JOIN [Product Data] p ON t.product_key = p.product_id;




-- Procedure لتحليل المبيعات حسب الفترة الزمنية

CREATE OR ALTER PROCEDURE AnalyzeSalesByPeriod
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT
        'Period Analysis' as report_type,
        COUNT(t.id) as total_transactions,
        ROUND(SUM(t.quantity), 0) as total_quantity,
        ROUND(SUM(t.quantity * p.product_retail_price), 0) as total_revenue,
        ROUND(AVG(t.quantity * p.product_retail_price), 0) as avg_transaction_value,
        COUNT(DISTINCT t.customer_key) as unique_customers,
        COUNT(DISTINCT t.Store_key) as active_stores
    FROM [All_Transactions] t 
    JOIN [Product Data] p ON t.product_key = p.product_id
    WHERE t.transaction_date BETWEEN @start_date AND @end_date;

    SELECT
        p.category,
        COUNT(t.id) as transactions,
        ROUND(SUM(t.quantity * p.product_retail_price), 0) as revenue
    FROM [Transactions 1997] t
    JOIN [Product Data] p ON t.product_key = p.product_id
    WHERE t.transaction_date BETWEEN @start_date AND @end_date
    GROUP BY p.category
    ORDER BY revenue DESC;
END;

exec AnalyzeSalesByPeriod '1997-11-01','1997-12-31'





-- اضافة بيانات الجدول الجديد

-- عمل جدول مؤقت

CREATE TABLE Temp_Transactions_1998 (
    id INT,
    transaction_date DATE,
    stock_date DATE,
    product_key INT,
    customer_key INT,
    store_key INT,
    quantity INT
);


-- قراءة بيانات الجدول من الكمبيوتر 

BULK INSERT Temp_Transactions_1998
FROM 'E:\SalesReporting\Transactions 1998.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    KEEPNULLS
);

-- نقل بيانات الجدول الى جدول المعاملات
INSERT INTO All_Transactions (transaction_date, stock_date, product_key, customer_key, store_key, quantity)
SELECT transaction_date, stock_date, product_key, customer_key, store_key, quantity
FROM Temp_Transactions_1998;

-- حذف الجدول الموقت
DROP TABLE Temp_Transactions_1998;

select * from 
All_Transactions



--إعداد Row-Level Security (RLS)


-- إنشاء Security Table
CREATE TABLE [Clean Data.User_Security] (
    User_Email NVARCHAR(255) PRIMARY KEY,
    Region_Access NVARCHAR(100),
    Level NVARCHAR(50) -- قيم: Manager / Analyst / Viewer
);


--
INSERT INTO [Clean Data.User_Security] (User_Email, Region_Access, Level)
VALUES 
('said-hamed@outlook.com', 'North', 'Manager'),
('pg_160506@commerce.tanta.edu.eg', 'ALL', 'Analyst'),
('saidhamed5000@gmail.com', 'ALL', 'Viewer');


