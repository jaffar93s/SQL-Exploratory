/*
===============================================================================
استكشاف نطاق التواريخ
Date Range Exploration 
===============================================================================
الغرض:
.تحديد الحدود الزمنية لنقاط البيانات الرئيسية -
                 .فهم نطاق البيانات التاريخية -
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL الدوال المستخدمة في
SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- تحديد تاريخ الطلب الأول والأخير والإجمالي الكلي للمدة بالأشهر
-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- ابحث عن أصغر وأكبر عميل استنادًا إلى تاريخ الميلاد
-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
