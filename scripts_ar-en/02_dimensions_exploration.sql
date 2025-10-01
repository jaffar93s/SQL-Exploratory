
/*
===============================================================================
استكشاف الأبعاد
Dimensions Exploration
===============================================================================
الهدف:
استكشاف بنية جداول الأبعاد -
Purpose:
    - To explore the structure of dimension tables.
	
SQL الدوال المستخدمة في
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- استرجع قائمة بالدول الفريدة التي ينحدر منها العملاء
-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- استرجاع قائمة بالفئات الفريدة والفئات الفرعية والمنتجات 
-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
