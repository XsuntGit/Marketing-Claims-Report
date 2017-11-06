SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_MarketingClaims_PatientProgram]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientProgram start.'

	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage]

	--ALTER INDEX [idx_MarketingClaims_MarketingClaimsPatientProgram_Stage] ON [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage]
		([TeradataID]
		,[ExternalConsumerID]
		,[VendorCode]
		,[SourceCode]
		,[ProgramCode]
		,[MinEnrollmentDate]
		,[OfferCode]
		,[GroupNumber]
		,[CardIDNumber]
		,[EnrollmentDate]
		,[ReEnrollmentDate]
		,[CardExpirationDate]
		,[AnniversaryDate]
		,[OfferStartDate]
		,[OfferEndDate])
	SELECT [TeradataID]
      ,[ExternalConsumerID]
      ,[VendorCode]
      ,[SourceCode]
      ,CASE WHEN c.ProgramValue = 'MPRS-OPUS' THEN 'RETAIL-MPRS' ELSE c.ProgramValue END [ProgramCode]
      ,b.MinEnrollmentDate as [MinEnrollmentDate]
      ,a.[OfferCode]
      ,[GroupNumber]
      ,[CardIDNumber]
      ,[EnrollmentDate]
      ,[ReEnrollmentDate]
      ,[CardExpirationDate]
      ,[AnniversaryDate]
      ,[OfferStartDate]
      ,[OfferEndDate] 
	FROM
	(
		SELECT 
			TeradataConsumerID as TeradataID, 
			ExternalConsumerID,
			CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
			SourceCode,
			OfferCode,
			GroupNumber,
			CardIDNumber,
			EnrollmentDate,
			ReEnrollmentDate,
			CardExpirationDate,
			AnniversaryDate,
			OfferStartDate,
			OfferEndDate 
		FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportPatientProgramOffer]
		WHERE  not(VendorCode = 'psk' 
			and GroupNumber not in ('ED12702001','ED12702002','ED12702003','ED12702007','EX12702005','ED12702006'))
		UNION
		SELECT 
			RMDBConsumerID as TeradataID, 
			ExternalConsumerID,
			CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
			SourceCode,
			OfferCode,
			GroupNumber,
			CardIDNumber,
			EnrollmentDate,
			ReEnrollmentDate,
			CardExpirationDate,
			AnniversaryDate,
			OfferStartDate,
			OfferEndDate
		FROM [EnbrelImportExport_Production].[dbo].[tblImportPatientProgramOfferHistory]
		WHERE not(VendorCode = 'psk' 
			and GroupNumber not in ('ED12702001','ED12702002','ED12702003','ED12702007','EX12702005','ED12702006'))
		UNION  --Hao 11/6/2017
		SELECT 
			[TeradataID]
			,[ExternalConsumerID]
			,case when offerCD = 'MPRS' then 'MCK' else [VendorCD] end as VendorCode
			,[SourceCD]
			,[OfferCD]
			,[GroupNum]
			,[CardID]
			,[EnrollDate]
			,[ReEnrollDate]
			,[CardExpDate]
			,NULL as [AnniversaryDate]
			,NULL as [OfferStartDate]
			,NULL as [OfferEndDate]
		  FROM [EnbrelImportExport_Production].[dbo].[tblImportOPUSPatientProgramOfferHistory]
		  WHERE  not([VendorCD] = 'psk' 
					and [GroupNum] not in ('ED12702001','ED12702002','ED12702003','ED12702007','EX12702005','ED12702006'))
	
	) a
	LEFT OUTER JOIN (
				SELECT TeradataPatientID, 
				MIN(convert(datetime, datecreated)) as MinEnrollmentDate 
				FROM [Enbrel_Production].[dbo].[tblPatientInfo] with (nolock)
				GROUP BY TeradataPatientID
				) b
	ON b.TeradataPatientID = a.TeradataID
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblProgram] as c with (nolock)
	ON c.OfferCode = a.OfferCode
		AND c.RxGroupID = a.GroupNumber

	--ALTER INDEX [idx_MarketingClaims_MarketingClaimsPatientProgram_Stage] ON [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

	UPDATE a
	SET a.AmgenPatientID = b.AmgenPatientID
	FROM [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] a 
	INNER JOIN [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] b
		on a.TeradataID = b.TeradataID

	-- virtual patients...
	UPDATE a
	SET a.AmgenPatientID = b.AmgenPatientID
	FROM [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] a 
	INNER JOIN [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage] b
		on a.ExternalConsumerID = b.OpusID
	WHERE a.AmgenPatientID is null


	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientEnrollment_Stage]

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaimsPatientEnrollment_Stage]
	SELECT DISTINCT
		AmgenPatientID,
		VendorCode,
		CASE WHEN VendorCode = 'PSK' THEN 'IBECPYP' ELSE SourceCode END SourceCode,
		ProgramCode,
		GroupNumber,
		CardIDNumber,
		replace(convert(varchar, convert(datetime, EnrollmentDate), 111), '/', '') as CopayEnrollmentDate, --Hao, 10/15/2017
		--replace(convert(varchar, convert(datetime, MinEnrollmentDate), 111), '/', '') as CopayEnrollmentDate,
		left(OfferStartDate, 17) as ProgramStartDate
	FROM [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] 
	WHERE EnrollmentDate is not null 
		and AmgenPatientID is not null

	
	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientReEnrollment_Stage]

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaimsPatientReEnrollment_Stage]
	SELECT DISTINCT
		AmgenPatientID,
		VendorCode,
		CASE WHEN VendorCode = 'PSK' THEN 'IBECPRP' ELSE SourceCode END as SourceCode,
		ProgramCode,
		GroupNumber,
		CardIDNumber,
		replace(convert(varchar, convert(datetime, ReEnrollmentDate), 111), '/', '') as CopayReenrollmentDate
	FROM [dbo].[MarketingClaims_MarketingClaimsPatientProgram_Stage] 
	WHERE ReEnrollmentDate is not null
		and AmgenPatientID is not null
		

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PatientProgram end.'

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
