﻿/*
===============================================================================
استكشاف قاعدة البيانات
Database Exploration
===============================================================================
:الغرض
.استكشاف هيكل قاعدة البيانات، بما في ذلك قائمة الجداول ومخططاتها -
.فحص الأعمدة والبيانات الوصفية للجداول المحددة -
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

:الجداول المستخدمة
Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- استرجع قائمة بجميع الجداول في قاعدة البيانات
-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- (dim_customers) استرجع جميع الأعمدة لجدول معين 
-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
