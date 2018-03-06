SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_MarketingClaims_ExtractClaims]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_ExtractClaims start.'

	--Time: 10mins
	truncate table MarketingClaims_MarketingClaimsRaw
	insert into MarketingClaims_MarketingClaimsRaw(
		[tblClaimID]
      ,[PatientID]
      ,[DoctorID]
      ,[PharmacyID]
      ,[Prescription]
      ,[Lasts]
      ,[RefillNumber]
      ,[DatePrescriptionFilled]
      ,[FinalCost]
      ,[QuantityDispensed]
      ,[DateCreated]
      ,[LastModified]
      ,[Status]
      ,[CheckNumber]
      ,[PaidDate]
      ,[CheckClearedDate]
      ,[PaidAmount]
      ,[NESSCEImportDate]
      ,[NDC]
      ,[Method]
      ,[OpenedBy]
      ,[LastModifiedBy]
      ,[PatientProgramType]
      ,[RejectedReason]
      ,[OpenedTime]
      ,[PaymentType]
      ,[ApprovedAmount]
      ,[NPINumber]
      ,[CardID]
      ,[TraceNumber]
      ,[ManualCheck]
      ,[CreatedAt]
      ,[ClaimSource]
      ,[ReversalReason]
      ,[PatientReversalCheckNumber]
      ,[CopayApplied]
      ,[DateCopayApplied]
      ,[TrueUpClaimID]
      ,[VerifiedClaimAmount]
      ,[AdminCopayOverride]
      ,[CopayAmount]
      ,[ClaimIDCopayApplied]
      ,[ReimburseNote]
      ,[CreateBy]
      ,[RxNumber]
      ,[NESSCEImportTime]
      ,[TeradataVendorCode]
      ,[TeradataSourceCode]
      ,[TeradataProgramCode]
      ,[TeradataOtherCoverageCode]
      ,[TeradataCarrierGroupNumber]
      ,[TeradataCarrierBIN]
      ,[TeradataCarrierPCN]
      ,[TeradataNumberOfRefillsAuthorized]
      ,[TeradataDrugName]
      ,[TeradataDrugDosage]
      ,[TeradataDrugStrength]
      ,[TeradataPaidQuantity]
      ,[TeradataDispensingFeePaid]
      ,[TeradataIncentiveFeePaid]
      ,[TeradataPriorAuthorizationCode]
      ,[TeradataClaimReferenceNumber]
      ,[TeradataPharmacyNCPDPNumber]
      ,[TeradataPrescriberNPI]
      ,[TeradataPrescriberDEA]
      ,[TeradataPrescriberMENumber]
      ,[TeradataRejectionCode]
      ,[TeradataRejectionDescription]
	  )
	select 	[tblClaimID]
      ,[PatientID]
      ,[DoctorID]
      ,[PharmacyID]
      ,[Prescription]
      ,[Lasts]
      ,[RefillNumber]
      ,[DatePrescriptionFilled]
      ,[FinalCost]
      ,[QuantityDispensed]
      ,[DateCreated]
      ,[LastModified]
      ,[Status]
      ,[CheckNumber]
      ,[PaidDate]
      ,[CheckClearedDate]
      ,[PaidAmount]
      ,[NESSCEImportDate]
      ,[NDC]
      ,[Method]
      ,[OpenedBy]
      ,[LastModifiedBy]
      ,[PatientProgramType]
      ,[RejectedReason]
      ,[OpenedTime]
      ,[PaymentType]
      ,[ApprovedAmount]
      ,[NPINumber]
      ,[CardID]
      ,[TraceNumber]
      ,[ManualCheck]
      ,[CreatedAt]
      ,[ClaimSource]
      ,[ReversalReason]
      ,[PatientReversalCheckNumber]
      ,[CopayApplied]
      ,[DateCopayApplied]
      ,[TrueUpClaimID]
      ,[VerifiedClaimAmount]
      ,[AdminCopayOverride]
      ,[CopayAmount]
      ,[ClaimIDCopayApplied]
      ,[ReimburseNote]
      ,[CreateBy]
      ,[RxNumber]
      ,[NESSCEImportTime]
      ,[TeradataVendorCode]
      ,[TeradataSourceCode]
      ,[TeradataProgramCode]
      ,[TeradataOtherCoverageCode]
      ,[TeradataCarrierGroupNumber]
      ,[TeradataCarrierBIN]
      ,[TeradataCarrierPCN]
      ,[TeradataNumberOfRefillsAuthorized]
      ,[TeradataDrugName]
      ,[TeradataDrugDosage]
      ,[TeradataDrugStrength]
      ,[TeradataPaidQuantity]
      ,[TeradataDispensingFeePaid]
      ,[TeradataIncentiveFeePaid]
      ,[TeradataPriorAuthorizationCode]
      ,[TeradataClaimReferenceNumber]
      ,[TeradataPharmacyNCPDPNumber]
      ,[TeradataPrescriberNPI]
      ,[TeradataPrescriberDEA]
      ,[TeradataPrescriberMENumber]
      ,[TeradataRejectionCode]
      ,[TeradataRejectionDescription]
	from (
		select ROW_NUMBER() over(partition by tblclaimID, PatientID, [status] order by logDate desc) as [RankID],*
		from Enbrel_Production..tblClaimsHistory a with (nolock)
		where exists (select * from Enbrel_Production..tblClaims b with (nolock) where a.tblClaimID = b.tblClaimID)
			and CreatedAt in ('CRXDataImport','OpusDataImport','TeradataException','SwipeDataImport','TeradataImport')
			and [Status] in ('Approved','Reversal','Rejected')
		) t
	where t.[RankID] = 1

	--select top 100 * from MarketingClaims_MarketingClaimsRaw

	--Output table
	ALTER INDEX [idx_ClaimType_INCL_AmgenPatientID_DateOfFill] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE
	ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE

	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaims_Stage]


	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_ExtractClaims end.'

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


