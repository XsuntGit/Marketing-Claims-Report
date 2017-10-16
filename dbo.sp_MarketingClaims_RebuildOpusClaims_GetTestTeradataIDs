SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_GetTestTeradataIDs]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_GetTestTeradataIDs start.'

	TRUNCATE TABLE [dbo].[MarketingClaims_TestTeradataIDs_Stage]

	INSERT INTO [dbo].[MarketingClaims_TestTeradataIDs_Stage]
	SELECT TeradataConsumerID
	FROM [EnbrelImportExport_Production].[dbo].[tblTeradataProfileExceptionHistory]
	WHERE filtermsg = 'Non-numeric ExternalConsumerID.'
	GROUP BY TeradataConsumerID

	INSERT INTO [dbo].[MarketingClaims_TestTeradataIDs_Stage]
	SELECT TeradataConsumerID
	FROM [EnbrelImportExport_HistoryImport].[dbo].[tblTeradataProfileException]
	WHERE filtermsg = 'Non-numeric ExternalConsumerID.'
	GROUP BY TeradataConsumerID

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_GetTestTeradataIDs end.'

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
