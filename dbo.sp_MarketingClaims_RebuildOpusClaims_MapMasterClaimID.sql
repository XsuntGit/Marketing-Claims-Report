SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_MapMasterClaimID]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_MapMasterClaimID start.'

	TRUNCATE TABLE [dbo].[MarketingClaims_OpusClaimKeys_Stage]

	INSERT INTO [dbo].[MarketingClaims_OpusClaimKeys_Stage] 
		(VendorCode
		,CardID
		,ClaimReferenceNumber
		,ClaimIDX)
	SELECT a.TeradataVendorCode,
		a.CardID,
		a.TeradataClaimReferenceNumber,
		b.ClaimIDX
	FROM
	(
		SELECT TeradataVendorCode, CardID, TeradataClaimReferenceNumber
		FROM [dbo].[MarketingClaims_OutputRetailApprovedClaims_Stage] 
		UNION
		SELECT TeradataVendorCode, CardID, TeradataClaimReferenceNumber
		FROM [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage]
	) a
	LEFT OUTER JOIN [EnbrelImportExport_Production].[dbo].[tblClaimIDMaster] b
	ON a.TeradataVendorCode = b.VendIDS
		and a.CardID = b.CardIDs
		and a.TeradataClaimReferenceNumber = b.ClaimIDS


	TRUNCATE TABLE [dbo].[MarketingClaims_ReseedOpusClaimKeys_Stage]
	DECLARE @iReseed int
	SET @iReseed = (SELECT MIN(ID) FROM [EnbrelImportExport_Production].[dbo].[tblClaimIDMaster] WHERE ClaimIDS is null)

	DBCC CHECKIDENT('dbo.MarketingClaims_ReseedOpusClaimKeys_Stage', RESEED, @iReseed)

	INSERT INTO [dbo].[MarketingClaims_ReseedOpusClaimKeys_Stage]
		(VendorCode
		,CardID
		,ClaimReferenceNumber)
	SELECT VendorCode,
		CardID,
		ClaimReferenceNumber
	FROM [dbo].[MarketingClaims_OpusClaimKeys_Stage]
	WHERE ClaimIDX is null
		and VendorCode is not null
		and CardID is not null
		and ClaimReferenceNumber is not null
	
	UPDATE a
	SET a.VendIDS = b.VendorCode,
		a.CardIDs = b.CardID,
		a.ClaimIDS = b.ClaimReferenceNumber
	FROM [EnbrelImportExport_Production].[dbo].[tblClaimIDMaster] a with (TABLOCKX)
	INNER JOIN [dbo].[MarketingClaims_ReseedOpusClaimKeys_Stage] b
		on a.ID = b.ID
	WHERE a.VendIDS is null 
		and a.CardIDs is null
		and a.ClaimIDS is null

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_MapMasterClaimID end.'


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
