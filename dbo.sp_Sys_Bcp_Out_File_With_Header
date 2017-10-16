SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Sys_Bcp_Out_File_With_Header]
(
	@sDBName varchar(256),
	@FileType varchar(256),
	@sSourceTable varchar(256),
	@sOutputPath varchar(256),
	@sOutPutFileName varchar(256)
)
AS
SET NOCOUNT ON;
BEGIN TRY

	DECLARE @sFileDate varchar(14),
		@iRecordCount int,
		@sSql varchar(8000),
		@serverName varchar(50),
		@sSourceTableHeader varchar(4000),
		@sSourceTableColumns varchar(4000),
		@sys_msg varchar(250),
		@cmd nvarchar(4000),
		@CSVFilePath nvarchar(256)
		

	SET @sys_msg = 'sp_Sys_Bcp_Out_File_With_Header for table ' + @sDBName + '.dbo.' + @sSourceTable + ' start.'
	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] @sys_msg
		
	SET @sFileDate = (select convert(varchar, getdate(), 112)) + (select replace(convert(varchar, getdate(), 108), ':', ''))
	SET @iRecordCount = (select distinct b.rows from sys.tables a, sys.partitions b where a.name = @sSourceTable and a.object_id = b.object_id)
	SET @serverName = @@SERVERNAME
            
	SELECT @sSourceTableHeader = COALESCE(@sSourceTableHeader+',', '')+ ''''+ column_name +'''' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @sSourceTable
	SELECT @sSourceTableColumns = COALESCE(@sSourceTableColumns+',cast([', 'cast([')+ ''+ column_name +'] as varchar(1024))' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @sSourceTable

	SET @sSql = 'bcp "select ' + @sSourceTableHeader + ' union all select ' + @sSourceTableColumns + ' from ' + @sDBName + '.dbo.' + @sSourceTable + '" queryout '
		+ ' "' + @sOutputPath + @sOutPutFileName + '_' + @sFileDate + '_' + convert(varchar, @iRecordCount) +'.txt'
		+ ' " /t "|" -T -c -C ACP -S "' + @serverName + '"'
	EXEC master..xp_cmdshell @sSql

	SET @CSVFilePath = 'F:\EnbrelFiles\FromXSUNT\Marketing\Templates' + '\csv_' + (select convert(varchar, getdate(), 112)) + '.csv'
	SET @cmd = 'powershell C:\XsuntScripts\Files_Attributes_New.ps1 -FilePath ' + '''' + @sOutputPath + @sOutPutFileName + '_' + @sFileDate + '_' + convert(varchar, @iRecordCount) +'.txt' + '''' + ' -CSVFilePath ' + '''' + @CSVFilePath + '''' + ' -Alias ' + '''' + @FileType + '''' + ' -RecordCount ' + '''' + cast(@iRecordCount as varchar(50)) + ''''
	EXEC master..xp_cmdshell @cmd

	SET @sys_msg = 'sp_Sys_Bcp_Out_File_With_Header for table ' + @sDBName + '.dbo.' + @sSourceTable + ' end.'
	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] @sys_msg

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


