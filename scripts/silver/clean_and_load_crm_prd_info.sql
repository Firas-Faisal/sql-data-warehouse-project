-- Check for Nulls or Duplicates in the Primary Key Column
-- Expectation: No Result
-- SELECT 
-- prd_id,
-- COUNT(*)
-- FROM bronze.crm_prd_info
-- GROUP BY prd_id
-- HAVING COUNT(*) > 1 OR prd_id IS NULL

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(100),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_dt DATETIME DEFAULT GETDATE(),
);
    

--View all the columns in the table
INSERT INTO silver.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5),'-','_' )AS cat_id,
SUBSTRING(prd_key,7,LEN(prd_key))as prd_key,
prd_nm,
ISNULL (prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
     WHEN 'M' THEN 'Mountain'
     WHEN 'R' THEN 'Road'
     WHEN 'S' THEN 'Other Sales'
     WHEN 'T' THEN 'Touring'
     ELSE 'n/a'
END AS prd_line,-- Map product line codes to descriptive values
CAST (prd_start_dt AS DATE) AS prd_start_dt,
CAST(
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
    AS DATE
) AS prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info

-- WHERE SUBSTRING(prd_key,7,LEN(prd_key)) IN
-- (SELECT sls_prd_key FROM bronze.crm_sales_details)

-- WHERE REPLACE(SUBSTRING(prd_key, 1, 5),'-','_' ) NOT IN
-- (SELECT Distinct id FROM bronze.erp_px_cat_g1v2)

-- SELECT
-- prd_id,
-- prd_key,
-- -- REPLACE(SUBSTRING(prd_key, 1, 5),'-','_' )AS cat_id,
-- -- SUBSTRING(prd_key,7,LEN(prd_key))as prd_key,
-- prd_nm,
-- -- ISNULL (prd_cost,0) AS prd_cost,
-- -- CASE UPPER(TRIM(prd_line))
-- --      WHEN 'M' THEN 'Mountain'
-- --      WHEN 'R' THEN 'Road'
-- --      WHEN 'S' THEN 'Other Sales'
-- --      WHEN 'T' THEN 'Touring'
-- --      ELSE 'n/a'
-- -- END AS prd_line,
-- prd_start_dt,
-- prd_end_dt,
-- LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
-- FROM bronze.crm_prd_info
-- WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')