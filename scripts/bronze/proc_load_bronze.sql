/*

=====================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================
Script Purpose:
	This stored procedure loads data into the 'bronze' schema from external csv file.
	It performs the following actions:
	- Truncate the bronze tables before loading data
	- Uses the 'BULK INSERT' commmand to load data from csv Files to bronze tables.

Parameters:
	None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC bronze.load_bronze;
=====================================================================
*/
-- GO is used to separate SQL batches in SSMS (SQL Server Management Studio)
GO

/* 
CREATE OR ALTER will create the stored procedure if it doesn't exist, 
or update it if it does � without needing a DROP PROCEDURE.
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME ;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		-- Logging start of Bronze Layer load
		PRINT '=======================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=======================================';

		-- SECTION: CRM DATA --
		PRINT '---------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------';

		-- TABLE: bronze.crm_cust_info --
		/* 
		Kosongkan semua data dalam table crm_cust_info sebelum load data baru.
		TRUNCATE lebih cepat dan jimat log berbanding DELETE.
		*/
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		-- Load CSV data using BULK INSERT
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2, -- Skip header row
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		-- TABLE: bronze.crm_prd_info --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		-- TABLE: bronze.crm_sales_details --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		-- SECTION: ERP DATA --
		PRINT '---------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------';

		-- TABLE: bronze.erp_cust_az12 --
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		-- TABLE: bronze.erp_loc_a101 --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		-- TABLE: bronze.erp_px_cat_g1v2 --
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\offic\Documents\GitHub\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------';
		SET @batch_end_time = GETDATE();
		PRINT '=======================================';
		PRINT 'Bronze Layer Load - COMPLETE';
		PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=======================================';
	END TRY

	BEGIN CATCH
		-- If error occurs, log the error info
		PRINT '=======================================';
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';

		/* 
		ERROR_MESSAGE()    - Tunjuk mesej error SQL Server.
		ERROR_NUMBER()     - Nombor error yang spesifik.
		ERROR_STATE()      - Status error (berguna untuk debug).
		*/
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=======================================';
	END CATCH

END;
GO
-- Execute the stored procedure

EXEC bronze.load_bronze;