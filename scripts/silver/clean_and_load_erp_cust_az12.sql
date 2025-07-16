SELECT
cid,       
bdate,
gen
FROM bronze.erp_cust_az12
WHERE cid LIKE'%AW00011020%'
SELECT * FROM [silver].[crm_cust_info]
