/*
===============================================================================
تقرير المنتج
Product Report
===============================================================================
										 										   :الغرض
			  				يقوم هذا التقرير بتوحيد مقاييس المنتج والسلوكيات الرئيسية -		

																			 :أبرز النقاط
				 .يجمع الحقول الأساسية مثل اسم المنتج والفئة والفئة الفرعية والتكلفة .A
.تقسيم المنتجات حسب الإيرادات لتحديد المنتجات ذات الأداء العالي أو المتوسط ​​أو المنخفض .B
		 										      :يجمع مقاييس على مستوى المنتج .C
																إجمالي الطلبات -
															   إجمالي المبيعات -
														إجمالي الكمية المشتراة -
															   إجمالي المنتجات -
													   (العمر الافتراضي (بالأشهر -
	   											 .يحسب مؤشرات الأداء الرئيسية القيمة .D
												 (حداثة (عدد الأشهر منذ آخر طلب -
															  متوسط قيمة الطلب -
														   متوسط الإنفاق الشهري -
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    A. Gathers essential fields such as product name, category, subcategory, and cost.
    B. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    C. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    D. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- :إنشاء تقرير
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
الاستعلام الأساسي: استرداد الأعمدة الأساسية من
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL  -- only consider valid sales dates
),

product_aggregations AS (
/*---------------------------------------------------------------------------
تجميعات المنتجات: يلخص المقاييس الرئيسية على مستوى المنتج
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  الاستعلام النهائي: يجمع جميع نتائج المنتجات في مخرج واحد
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)    متوسط إيرادات الطلب
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue     متوسط الإيرادات الشهرية
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations 