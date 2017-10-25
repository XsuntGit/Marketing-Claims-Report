SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_PatientIDs]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientIDs start.'

	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage]

	--ALTER INDEX [idx_MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] ON [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage]
	SELECT PatientID,
		McKessonID,
		AshfieldID,
		OpusID,
		TeradataPatientID
	FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
	WHERE ActiveFlag = 1
	GROUP BY PatientID,
		McKessonID,
		AshfieldID,
		OpusID,
		TeradataPatientID

	--ALTER INDEX [idx_MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] ON [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientIDs end.'

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
