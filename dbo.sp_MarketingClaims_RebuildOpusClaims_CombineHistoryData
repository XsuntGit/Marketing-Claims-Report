SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_CombineHistoryData]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_CombineHistoryData start.'
	-- approved/reversed claims...
	TRUNCATE TABLE [dbo].[MarketingClaims_inOpusApprovedClaims_Stage]

	--ALTER INDEX [idx_MarketingClaims_inOpusApprovedClaims_Stage_VendorCode_TeradataConsID_ExternalConsID] ON [dbo].[MarketingClaims_inOpusApprovedClaims_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_inOpusApprovedClaims_Stage]
		([ExternalConsumerID]
		,[TeradataConsumerID]
		,[VendorCode]
		,[Sourcecode]
		,[ProgramCode]
		,[OfferCode]
		,[ClaimType]
		,[RxNumber]
		,[DateOfFill]
		,[DateClaimsReceivedOrProcessed]
		,[CarrierGroupNumber]
		,[CarrierBINNumber]
		,[CarrierPCNNumber]
		,[CardIDNumber]
		,[OtherCoverageCode]
		,[NewRefillCode]
		,[NumberofRefillsAuthorized]
		,[NDC]
		,[DrugName]
		,[DrugDosageForm]
		,[DrugStrength]
		,[PaidQuantity]
		,[DaysSupply]
		,[DispensingFeePaid]
		,[OutOfPocketCostOOPBeforeCoPaySupport]
		,[CopaysupportBenefitAmount]
		,[OutOfPocketCostOOPAfterCoPaySupport]
		,[IncentiveFeePaid]
		,[PriorAuthorizationCode]
		,[ClaimReferenceNumber]
		,[PharmacyNCPDPNumber]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZipCode]
		,[PrescriberIDNPI]
		,[PrescriberIDDEA]
		,[MedicalEducationNumber]
		,[PhysicianFullNameOrLastname]
		,[PhysicianFirstname]
		,[PhysicianMiddlename]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZipCode]
		,[Specialty]
		,[ImportFileName]
		,[ImportDate])
	SELECT
		[ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		'HistoryDump',
		'20170101'
	FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportAllApprovedClaims]
	WHERE VendorCode = 'OPU'
	GROUP BY [ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty]

	INSERT INTO [dbo].[MarketingClaims_inOpusApprovedClaims_Stage]
		([ExternalConsumerID]
		,[TeradataConsumerID]
		,[VendorCode]
		,[Sourcecode]
		,[ProgramCode]
		,[OfferCode]
		,[ClaimType]
		,[RxNumber]
		,[DateOfFill]
		,[DateClaimsReceivedOrProcessed]
		,[CarrierGroupNumber]
		,[CarrierBINNumber]
		,[CarrierPCNNumber]
		,[CardIDNumber]
		,[OtherCoverageCode]
		,[NewRefillCode]
		,[NumberofRefillsAuthorized]
		,[NDC]
		,[DrugName]
		,[DrugDosageForm]
		,[DrugStrength]
		,[PaidQuantity]
		,[DaysSupply]
		,[DispensingFeePaid]
		,[OutOfPocketCostOOPBeforeCoPaySupport]
		,[CopaysupportBenefitAmount]
		,[OutOfPocketCostOOPAfterCoPaySupport]
		,[IncentiveFeePaid]
		,[PriorAuthorizationCode]
		,[ClaimReferenceNumber]
		,[PharmacyNCPDPNumber]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZipCode]
		,[PrescriberIDNPI]
		,[PrescriberIDDEA]
		,[MedicalEducationNumber]
		,[PhysicianFullNameOrLastname]
		,[PhysicianFirstname]
		,[PhysicianMiddlename]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZipCode]
		,[Specialty]
		,[ImportFileName]
		,[ImportDate])
	SELECT  
		[ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		MAX(ImportFileName) AS ImportFileName,
		CONVERT(VARCHAR(10), MAX(ImportDate), 112) AS ImportDate
	FROM [EnbrelImportExport_Production].[dbo].[tblImportAllApprovedClaimsHistory]
	WHERE VendorCode = 'OPU'
	GROUP BY [ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty]

	--ALTER INDEX [idx_MarketingClaims_inOpusApprovedClaims_Stage_VendorCode_TeradataConsID_ExternalConsID] ON [dbo].[MarketingClaims_inOpusApprovedClaims_Stage] REBUILD PARTITION = ALL

	TRUNCATE TABLE [dbo].[MarketingClaims_inOpusRejectedClaims_Stage]

	--ALTER INDEX [idx_iMarketingClaims_inOpusRejectedClaims_Stage_VendorCode_TeradataConsID_ExternalConsID] ON [dbo].[MarketingClaims_inOpusRejectedClaims_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_inOpusRejectedClaims_Stage]
		([ExternalConsumerID]
		,[TeradataConsumerID]
		,[VendorCode]
		,[Sourcecode]
		,[ProgramCode]
		,[OfferCode]
		,[ClaimType]
		,[RxNumber]
		,[DateOfFill]
		,[DateClaimsReceivedOrProcessed]
		,[CarrierGroupNumber]
		,[CarrierBINNumber]
		,[CarrierPCNNumber]
		,[CardIDNumber]
		,[OtherCoverageCode]
		,[NewRefillCode]
		,[NumberofRefillsAuthorized]
		,[NDC]
		,[DrugName]
		,[DrugDosageForm]
		,[DrugStrength]
		,[PaidQuantity]
		,[DaysSupply]
		,[DispensingFeePaid]
		,[OutOfPocketCostOOPBeforeCoPaySupport]
		,[CopaysupportBenefitAmount]
		,[OutOfPocketCostOOPAfterCoPaySupport]
		,[IncentiveFeePaid]
		,[PriorAuthorizationCode]
		,[ClaimReferenceNumber]
		,[PharmacyNCPDPNumber]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZipCode]
		,[PrescriberIDNPI]
		,[PrescriberIDDEA]
		,[MedicalEducationNumber]
		,[PhysicianFullNameOrLastname]
		,[PhysicianFirstname]
		,[PhysicianMiddlename]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZipCode]
		,[Specialty]
		,[RejectedCode]
		,[RejectedDescription]
		,[ImportFileName]
		,[ImportDate])
	SELECT  
		[ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		[RejectedCode],
		[RejectedDescription],
		'HistoryDump',
		'20170101'
	FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportAllRejectedClaims]
	WHERE VendorCode = 'OPU'
	GROUP BY [ExternalConsumerID],
		[TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		[RejectedCode],
		[RejectedDescription]

	INSERT INTO [dbo].[MarketingClaims_inOpusRejectedClaims_Stage]
		([ExternalConsumerID]
		,[TeradataConsumerID]
		,[VendorCode]
		,[Sourcecode]
		,[ProgramCode]
		,[OfferCode]
		,[ClaimType]
		,[RxNumber]
		,[DateOfFill]
		,[DateClaimsReceivedOrProcessed]
		,[CarrierGroupNumber]
		,[CarrierBINNumber]
		,[CarrierPCNNumber]
		,[CardIDNumber]
		,[OtherCoverageCode]
		,[NewRefillCode]
		,[NumberofRefillsAuthorized]
		,[NDC]
		,[DrugName]
		,[DrugDosageForm]
		,[DrugStrength]
		,[PaidQuantity]
		,[DaysSupply]
		,[DispensingFeePaid]
		,[OutOfPocketCostOOPBeforeCoPaySupport]
		,[CopaysupportBenefitAmount]
		,[OutOfPocketCostOOPAfterCoPaySupport]
		,[IncentiveFeePaid]
		,[PriorAuthorizationCode]
		,[ClaimReferenceNumber]
		,[PharmacyNCPDPNumber]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZipCode]
		,[PrescriberIDNPI]
		,[PrescriberIDDEA]
		,[MedicalEducationNumber]
		,[PhysicianFullNameOrLastname]
		,[PhysicianFirstname]
		,[PhysicianMiddlename]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZipCode]
		,[Specialty]
		,[RejectedCode]
		,[RejectedDescription]
		,[ImportFileName]
		,[ImportDate])
	SELECT  
		[ExternalConsumerID],
		RMDBConsumerID as [TeradataConsumerID],
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		[RejectedCode],
		[RejectedDescription],
		MAX(ImportFileName) AS ImportFileName,
		CONVERT(VARCHAR(10), MAX(ImportDate), 112) AS ImportDate
	FROM [EnbrelImportExport_Production].[dbo].[tblImportAllRejectedClaimsHistory]
	WHERE VendorCode = 'OPU'
	GROUP BY [ExternalConsumerID],
		RMDBConsumerID,
		[VendorCode],
		[Sourcecode],
		[ProgramCode],
		[OfferCode],
		[ClaimType],
		[RxNumber],
		[DateOfFill],
		CASE WHEN [DateClaimsReceivedOrProcessed] IS NULL THEN [DateOfFill] ELSE [DateClaimsReceivedOrProcessed] END,
		[CarrierGroupNumber],
		[CarrierBINNumber],
		[CarrierPCNNumber],
		[CardIDNumber],
		[OtherCoverageCode],
		[NewRefillCode],
		[NumberofRefillsAuthorized],
		[NDC],
		[DrugName],
		[DrugDosageForm],
		[DrugStrength],
		[PaidQuantity],
		[DaysSupply],
		[DispensingFeePaid],
		[OutOfPocketCostOOPBeforeCoPaySupport],
		[CopaysupportBenefitAmount],
		[OutOfPocketCostOOPAfterCoPaySupport],
		[IncentiveFeePaid],
		[PriorAuthorizationCode],
		[ClaimReferenceNumber],
		[PharmacyNCPDPNumber],
		[PharmacyName],
		[PharmacyAddress1],
		[PharmacyAddress2],
		[PharmacyCity],
		[PharmacyState],
		[PharmacyZipCode],
		[PrescriberIDNPI],
		[PrescriberIDDEA],
		[MedicalEducationNumber],
		[PhysicianFullNameOrLastname],
		[PhysicianFirstname],
		[PhysicianMiddlename],
		[PhysicianAddress1],
		[PhysicianAddress2],
		[PhysicianCity],
		[PhysicianState],
		[PhysicianZipCode],
		[Specialty],
		[RejectedCode],
		[RejectedDescription]


	--ALTER INDEX [idx_iMarketingClaims_inOpusRejectedClaims_Stage_VendorCode_TeradataConsID_ExternalConsID] ON [dbo].[MarketingClaims_inOpusRejectedClaims_Stage] REBUILD PARTITION = ALL

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_CombineHistoryData end.'

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
