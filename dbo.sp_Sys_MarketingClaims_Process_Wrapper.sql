SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_Sys_MarketingClaims_Process_Wrapper]
(
	@sDBName varchar(256),
	@sExportPath varchar(256)
)
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'Marketing Claims process start.'

	--Rebuild Claim Data
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_CombineHistoryData]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_InsertVirtualPatients]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_GetMergedTeradataIDs]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_GetTestTeradataIDs]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_RejectedClaims]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_ApprovedClaims]
	--EXEC [dbo].[sp_MarketingClaims_RebuildOpusClaims_MapMasterClaimID]
	
	--Marketing Claims
	EXEC [dbo].[sp_MarketingClaims_ExtractClaims]
	--EXEC [dbo].[sp_MarketingClaims_ExtractTeradataClaims]

	EXEC [dbo].[sp_MarketingClaims_MapMasterClaimID]

	EXEC [dbo].[sp_MarketingClaims_PSKWClaims]
	EXEC [dbo].[sp_MarketingClaims_OPUCRXClaims]
	--EXEC [dbo].[sp_MarketingClaims_OPUMCKClaims]
	EXEC [dbo].[sp_MarketingClaims_PatientIDs]
	EXEC [dbo].[sp_MarketingClaims_PatientProfile]
	
	EXEC [dbo].[sp_MarketingClaims_PatientProgram]

	--Prepare Excel file
	DECLARE @sFileDate varchar(14),
		@cmd nvarchar(4000),
		@ExcelFileTemplatePath nvarchar(256),
		@ExcelFilePath nvarchar(256),
		@TemplatesPath nvarchar(256)

	SET @TemplatesPath = 'F:\EnbrelFiles\FromXSUNT\Marketing\Templates'
	SET @sFileDate = (select convert(varchar, getdate(), 112))
	SET @ExcelFileTemplatePath = 'F:\EnbrelFiles\FromXSUNT\Marketing\Templates\Control_File_Template.xlsx' 
	SET @ExcelFilePath = @sExportPath + '\Control_File_' + @sFileDate + '.xlsx'
	SET @cmd = 'powershell Copy-Item ''' + @ExcelFileTemplatePath + ''' -Destination ''' + @ExcelFilePath + '''' 
	EXEC master..xp_cmdshell @cmd
	--Export
	EXEC [dbo].[sp_Sys_Bcp_Out_File_With_Header] @sDBName, 'Claims File', 'MarketingClaims_OutputMarketingClaims_Stage', @sExportPath, 'AMGN_ENB_CLAIM'
	EXEC [dbo].[sp_Sys_Bcp_Out_File_With_Header] @sDBName, 'Patient Info File', 'MarketingClaims_OutputMarketingClaimsPatientProfile_Stage', @sExportPath, 'AMGN_ENB_CUST'
	EXEC [dbo].[sp_Sys_Bcp_Out_File_With_Header] @sDBName, 'Patient Vendor ID Cross Reference File', 'MarketingClaims_OutputMarketingClaimsPatientIDs_Stage', @sExportPath, 'AMGN_ENB_CUSTXREFID'
	EXEC [dbo].[sp_Sys_Bcp_Out_File_With_Header] @sDBName, 'Patient Program Enrollment File', 'MarketingClaims_OutputMarketingClaimsPatientEnrollment_Stage', @sExportPath, 'AMGN_ENB_CUSTENROLL'
	EXEC [dbo].[sp_Sys_Bcp_Out_File_With_Header] @sDBName, 'Patient Program Re Enrollment File', 'MarketingClaims_OutputMarketingClaimsPatientReEnrollment_Stage', @sExportPath, 'AMGN_ENB_CUSTREENROLL'

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'Marketing Claims Excel Report processing start.'

	DECLARE @CSVFilePath nvarchar(256)
	SET @CSVFilePath =  @TemplatesPath + '\csv_' + @sFileDate + '.csv'

	SET @cmd = 'INSERT INTO OPENROWSET(''Microsoft.ACE.OLEDB.16.0'', ''Excel 8.0;Database=' + @ExcelFilePath + ';'', ''SELECT [File Type], [File Name], [Total Record Count],[Total File Size KB], [MD5] FROM [Control$A1:E1]'')' + CHAR(13) +
	'SELECT [FileType] as [File Type], [FileName] as [File Name],[RecordCount] as [Total Record Count], [FileSize] as [Total File Size KB], [MD5]' + CHAR(13) +
	'FROM OPENROWSET (BULK ''' + @CSVFilePath + ''', FORMATFILE = ''' + @TemplatesPath + '\ControlFile.xml'', FIRSTROW = 2) AS ControlFile;'

	EXEC sp_executesql @cmd

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'Marketing Claims Excel Report processing end.'

	--Amazon S3 Uploader code launch will be here
	

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'Marketing Claims process end.'

END TRY
BEGIN CATCH

	DECLARE @errmsg   nvarchar(2048),
			@severity tinyint,
			@state    tinyint,
			@errno    int,
			@proc     sysname,
			@lineno   int
           
	SELECT @errmsg = error_message(), @severity = error_severity(),
			@state  = error_state(), @errno = error_number(),
			@proc   = error_procedure(), @lineno = error_line()
       
	IF @errmsg NOT LIKE '***%'
	BEGIN
		SELECT @errmsg = '*** ' + coalesce(quotename(@proc), '<dynamic SQL>') + 
						', Line ' + ltrim(str(@lineno)) + '. Errno ' + 
						ltrim(str(@errno)) + ': ' + @errmsg
	END
	RAISERROR('%s', @severity, @state, @errmsg)

END CATCH
GO


