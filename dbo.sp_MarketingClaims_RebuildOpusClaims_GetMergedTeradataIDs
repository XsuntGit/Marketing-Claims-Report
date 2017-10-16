SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_GetMergedTeradataIDs]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_GetMergedTeradataIDs start.'

	-- get Teradata IDs of the merged records...
	TRUNCATE TABLE [dbo].[MarketingClaims_MergedTeradataIDs_Stage]

	INSERT INTO [dbo].[MarketingClaims_MergedTeradataIDs_Stage]
		([FromPatientID]
		,[ToPatientID])
	SELECT FromPatientID, 
		ToPatientID
	FROM [Enbrel_Production].[dbo].[tblPatientMergeHistory] with (nolock)
	GROUP BY FromPatientID, 
		ToPatientID

	UPDATE [dbo].[MarketingClaims_MergedTeradataIDs_Stage]
	SET FromTeradataID = 
		(
			SELECT TeradataPatientID 
			FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
			WHERE PatientID = [dbo].[MarketingClaims_MergedTeradataIDs_Stage].FromPatientID
		)

	UPDATE [dbo].[MarketingClaims_MergedTeradataIDs_Stage]
	SET ToTeradataID = 
		(
			SELECT TeradataPatientID 
			FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
			WHERE PatientID = [dbo].[MarketingClaims_MergedTeradataIDs_Stage].ToPatientID
		)

	DELETE [dbo].[MarketingClaims_MergedTeradataIDs_Stage]
	WHERE FromTeradataID = ToTeradataID

	DELETE [dbo].[MarketingClaims_MergedTeradataIDs_Stage]
	WHERE LEN(FromTeradataID) = 0 
		OR FromTeradataID IS NULL
		OR LEN(ToTeradataID) = 0 
		OR ToTeradataID IS NULL

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_GetMergedTeradataIDs end.'

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
