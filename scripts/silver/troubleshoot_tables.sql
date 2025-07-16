-- Troubleshooting script to check database objects

-- 1. Check what database you're connected to
SELECT DB_NAME() AS current_database;

-- 2. Check if bronze schema exists
SELECT name AS schema_name
FROM sys.schemas
WHERE name = 'bronze';

-- 3. List all schemas in the database
SELECT name AS schema_name
FROM sys.schemas
ORDER BY name;

-- 4. Check if the table exists in bronze schema
SELECT 
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'bronze'
    AND name = 'crm_cust_info';

-- 5. List all tables in bronze schema (if it exists)
SELECT 
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'bronze'
ORDER BY name;

-- 6. If bronze schema doesn't exist, check for tables with 'crm' in the name
SELECT 
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name
FROM sys.tables
WHERE name LIKE '%crm%'
ORDER BY schema_name, name;
