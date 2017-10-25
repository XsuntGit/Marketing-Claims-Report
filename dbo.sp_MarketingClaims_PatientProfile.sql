SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_PatientProfile]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientProfile start.'

	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage]

	--ALTER INDEX [idx_MarketingClaims_OutputMarketingClaimsPatientProfile_Stage] ON [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage]
	SELECT
		a.PatientID,
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		'_',
		b.TeradataTypeWeb as Treatment,
		CONVERT(varchar(20), 'Not Started') as TreatmentStatus,
		CASE WHEN replace(convert(varchar, convert(datetime, a.DateCreated), 111), '/', '') = '19000101' THEN NULL ELSE replace(convert(varchar, convert(datetime, a.DateCreated), 111), '/', '') END as DateEnrolled,
		c.TerrCode1 as Territory_Code_1,
		c.TerrName1 as Territory_Name_1,
		c.TerrCode2 as Territory_Code_2,
		c.TerrName2 as Territory_Name_2,
		c.TerrCode3 as Territory_Code_3,
		c.TerrName3 as Territory_Name_3
	FROM [Enbrel_Production].[dbo].[tblPatientInfo] a with (nolock)
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblTreatmentList] b with (nolock)
		on a.TreatmentID = b.TreatmentID
	LEFT OUTER JOIN [tblZipAlignment] c  --Cross Reference table,10/20/2017
		on a.zip = c.zipcode			
	WHERE ActiveFlag = 1 

	--ALTER INDEX [idx_MarketingClaims_OutputMarketingClaimsPatientProfile_Stage] ON [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

	ALTER INDEX [idx_ClaimType_INCL_AmgenPatientID_DateOfFill] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)

	-- update treatment status...
	UPDATE a
	SET a.TreatmentStatus = c.TreatStatusName
	FROM [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage] a 
	INNER JOIN
			(
				SELECT AmgenPatientID, 
					MAX(convert(datetime, DateOfFill)) as dt_last_approved 
				FROM [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
				WHERE ClaimType = 'P'
				GROUP BY AmgenPatientID
			) b 
		on a.AmgenPatientID = b.AmgenPatientID, 
		[Enbrel_Production].[dbo].[tblTreatmentStatusList] c with (nolock)
	WHERE DATEDIFF(DAY,dt_last_approved, getdate())  <= c.MaxDateFilled 
		and DATEDIFF(d,dt_last_approved, getdate()) >= c.MinDateFilled

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientProfile end.'                                                        

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


