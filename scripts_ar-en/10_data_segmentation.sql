/*
===============================================================================
-- تحليل تقسيم البيانات
Data Segmentation Analysis
===============================================================================
:الغرض
.لتجميع البيانات في فئات ذات معنى من أجل الحصول على رؤى مستهدفة -
            .لتقسيم العملاء أو تصنيف المنتجات أو التحليل الإقليمي -
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL الدوال المستخدمة
SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/* قسّم المنتجات إلى نطاقات تكلفة 
واحسب عدد المنتجات التي تقع في كل نطاق
Segment products into cost ranges and 
count how many products fall into each segment*/
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*                              :قسّم العملاء إلى ثلاثة فئات بناءً على سلوك الإنفاق الخاص بهم
.العملاء المميزون: العملاء الذين لديهم تاريخ لا يقل عن 12 شهرًا وينفقون أكثر من 5000 يورو -
 .العملاء العاديون: العملاء الذين لديهم تاريخ لا يقل عن 12 شهرًا وينفقون 5000 يورو أو أقل -
                                .العملاء الجدد: العملاء الذين تقل مدة حياتهم عن 12 شهرًا -
                                                   .وابحث عن إجمالي عدد العملاء في كل فئة
Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;