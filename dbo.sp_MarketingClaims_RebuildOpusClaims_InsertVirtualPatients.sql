SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_InsertVirtualPatients]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_InsertVirtualPatients start.'

	INSERT INTO [Enbrel_Production].[dbo].[tblPatientInfo]
		(LastModifedBy,
		CreateBy,
		DateCreated,
		LastModifed,
		ActiveFlag,
		Channel,
		OpusID,
		FirstName,
		LastName,
		Zip,	
		DOB,
		PreferredContactMethod)
	SELECT 'TeradataImport',
		'TeradataImport',
		GETDATE(),
		GETDATE(),
		1, --ActiveFlag,
		'TeradataImport', --Channel,
		ExternalConsumerID,
		'Virtual', -- FirstName,
		'Patient', --LastName,
		'00000', --Zip,	
		'01/01/1900', --DOB
		7
	FROM [dbo].[MarketingClaims_inOpusApprovedClaims_Stage]
	WHERE VendorCode = 'OPU' 
		AND TeradataConsumerID IS NULL
		AND ExternalConsumerID NOT IN
			(
			SELECT OpusID 
			FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
			WHERE OpusID IS NOT NULL
				AND FirstName = 'Virtual' -- FirstName
				AND LastName = 'Patient' --LastName,
			)
	UNION
	SELECT 'TeradataImport',
		'TeradataImport',
		GETDATE(),
		GETDATE(),
		1, --ActiveFlag,
		'TeradataImport', --Channel,
		ExternalConsumerID,
		'Virtual', -- FirstName,
		'Patient', --LastName,
		'00000', --Zip,	
		'01/01/1900', --DOB
		7
	FROM [dbo].[MarketingClaims_inOpusRejectedClaims_Stage]
	WHERE VendorCode = 'OPU' 
		AND TeradataConsumerID IS NULL
		AND ExternalConsumerID NOT IN
			(
			SELECT OpusID 
			FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
			WHERE OpusID IS NOT NULL
				AND FirstName = 'Virtual' -- FirstName
				AND LastName = 'Patient' --LastName,
			)

	print @@rowcount
	print 'This number of rows would be inserted into [Enbrel_Production].[dbo].[tblPatientInfo]'

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_InsertVirtualPatients end.'

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
