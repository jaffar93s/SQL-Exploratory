/*
===============================================================================
(استكشاف المقاييس (المؤشرات الرئيسية
Measures Exploration (Key Metrics)
===============================================================================
الغرض:
.حساب المقاييس المجمعة (مثل الإجماليات، المتوسطات) للحصول على رؤى سريعة -
                                  .تحديد الاتجاهات العامة أو رصد الشذوذ -
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.
SQL الدوال المستخدمة في
SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- العثور على إجمالي المبيعات
-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- اعثر على عدد العناصر المباعة
-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- ابحث عن متوسط سعر البيع
-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- العثور على العدد الإجمالي للطلبات
-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- ابحث عن العدد الإجمالي للمنتجات
-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- العثور على العدد الإجمالي للعملاء
-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- ابحث عن العدد الإجمالي للعملاء الذين قاموا بتقديم طلب
-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- إنشاء تقرير يوضح جميع المقاييس الرئيسية للأعمال
-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
