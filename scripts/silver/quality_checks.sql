-- Checks For Nulls or Duplicates in the Primary Key Column
-- Expectation: No Result
SELECT sls_ord_num, 
COUNT(*)  
FROM silver.crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative Numbers
-- Expectation: No Result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check For invalid date order
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt> sls_due_dt;

-- Check All Columns
SELECT *
FROM silver.crm_cust_info;

-- Negative numbers or zeros can't be cast to a date
SELECT 
sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0;

-- check for invalid date
SELECT 
NULLIF(sls_due_dt,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt >20500101
OR sls_due_dt < 19000101;

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL,zero or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price;
--

SELECT *
FROM silver.crm_sales_details