SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_ExtractTeradataClaims]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_ExtractTeradataClaims start.'
	
	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]

	---------------------------------- approved OPUS claims...
	INSERT INTO [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]
	SELECT DISTINCT
		CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
		ClaimReferenceNumber as ClaimNumber,
		convert(varchar(50), null) as ClaimTransactionNumber,
		ClaimType,
		b.PatientID as PatientID,
		a.TeradataConsumerID as TeradataID,
		OfferCode,
		RxNumber,
		convert(varchar(8), null) as DateWritten,
		replace(convert(varchar, convert(datetime, DateOfFill), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, DateClaimsReceivedOrProcessed), 111), '/', '') as DateProcessed,
		DaysSupply as DaysOfSupply,
		NDC,
		DrugName,
		convert(varchar(50), null) as DrugDesc,
		DrugDosageForm as DrugForm,
		DrugDosageForm as DrugDosage,
		DrugStrength,
		convert(varchar(50), null) as NewRefillCode,
		NumberofRefillsAuthorized as Refills,
		PaidQuantity as Quantity,
		convert(varchar(10), 'Electronic') as SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		CarrierGroupNumber as GroupNumber,
		CardIDNumber as CardID,
		convert(varchar(10), null) as PharmacyNPI,
		PharmacyNCPDPNumber as PharmacyNCPDP,
		convert(varchar(50), null) as PharmacyChainNumber,
		convert(varchar(50), null) as PharmacyChain,
		ltrim(rtrim(PharmacyName)) as PharmacyName,
		ltrim(rtrim(PharmacyAddress1)) as PharmacyAddress1,
		ltrim(rtrim(PharmacyAddress2)) as PharmacyAddress2,
		ltrim(rtrim(PharmacyCity)) as PharmacyCity,
		ltrim(rtrim(PharmacyState)) as PharmacyState,
		ltrim(rtrim(PharmacyZipCode)) as PharmacyZip,
		convert(varchar(50), null) as PharmacyPhone,
		PrescriberIDNPI as PhysicianNPI,
		PrescriberIDDEA as PhysicianDEA,
		ltrim(rtrim(a.PhysicianFirstname)) as PhysicianFirstName,
		ltrim(rtrim(substring(a.PhysicianFullNameOrLastname, CHARINDEX(a.PhysicianFirstName, a.PhysicianFullNameOrLastname) + len(a.PhysicianFirstName), len(a.PhysicianFullNameOrLastname)))) as PhysicianLastName,
		convert(varchar(50), Specialty) as PhysicianSpecialty,
		ltrim(rtrim(a.PhysicianAddress1)) as PhysicianAddress1,
		ltrim(rtrim(a.PhysicianAddress2)) as PhysicianAddress2,
		ltrim(rtrim(a.PhysicianCity)) as PhysicianCity,
		ltrim(rtrim(a.PhysicianState)) as PhysicianState,
		ltrim(rtrim(a.PhysicianZipCode)) as PhysicianZip,
		CopaysupportBenefitAmount as PatientBenefit,
		OutOfPocketCostOOPAfterCoPaySupport as PatientOOP,
		OutOfPocketCostOOPBeforeCoPaySupport as Copay,
		DispensingFeePaid as DispensingFee,
		convert(decimal(10, 2), null) as CalculatedAWP,
		convert(varchar(50), null) as Payer,
		convert(varchar(100), null) as RejectionCode
	FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportAllApprovedClaims] a
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.TeradataConsumerID = b.TeradataPatientID
			and b.ActiveFlag = 1
	WHERE left (dateoffill, 4) = '2017'
			and VendorCode <> 'PSK'

	INSERT INTO [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]
	SELECT DISTINCT
		CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
		ClaimReferenceNumber as ClaimNumber,
		convert(varchar(50), null) as ClaimTransactionNumber,
		ClaimType,
		b.PatientID as PatientID,
		a.TeradataConsumerID as TeradataID,
		OfferCode,
		RxNumber,
		convert(varchar(8), null) as DateWritten,
		replace(convert(varchar, convert(datetime, DateOfFill), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, DateClaimsReceivedOrProcessed), 111), '/', '') as DateProcessed,
		DaysSupply as DaysOfSupply,
		NDC,
		DrugName,
		convert(varchar(50), null) as DrugDesc,
		DrugDosageForm as DrugForm,
		DrugDosageForm as DrugDosage,
		DrugStrength,
		convert(varchar(50), null) as NewRefillCode,
		NumberofRefillsAuthorized as Refills,
		PaidQuantity as Quantity,
		convert(varchar(10), 'Electronic') as SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		CarrierGroupNumber as GroupNumber,
		CardIDNumber as CardID,
		convert(varchar(10), null) as PharmacyNPI,
		PharmacyNCPDPNumber as PharmacyNCPDP,
		convert(varchar(50), null) as PharmacyChainNumber,
		convert(varchar(50), null) as PharmacyChain,
		ltrim(rtrim(PharmacyName)) as PharmacyName,
		ltrim(rtrim(PharmacyAddress1)) as PharmacyAddress1,
		ltrim(rtrim(PharmacyAddress2)) as PharmacyAddress2,
		ltrim(rtrim(PharmacyCity)) as PharmacyCity,
		ltrim(rtrim(PharmacyState)) as PharmacyState,
		ltrim(rtrim(PharmacyZipCode)) as PharmacyZip,
		convert(varchar(50), null) as PharmacyPhone,
		PrescriberIDNPI as PhysicianNPI,
		PrescriberIDDEA as PhysicianDEA,
		ltrim(rtrim(a.PhysicianFirstname)) as PhysicianFirstName,
		ltrim(rtrim(substring(a.PhysicianFullNameOrLastname, CHARINDEX(a.PhysicianFirstName, a.PhysicianFullNameOrLastname) + len(a.PhysicianFirstName), len(a.PhysicianFullNameOrLastname)))) as PhysicianLastName,
		convert(varchar(50), Specialty) as PhysicianSpecialty,
		ltrim(rtrim(a.PhysicianAddress1)) as PhysicianAddress1,
		ltrim(rtrim(a.PhysicianAddress2)) as PhysicianAddress2,
		ltrim(rtrim(a.PhysicianCity)) as PhysicianCity,
		ltrim(rtrim(a.PhysicianState)) as PhysicianState,
		ltrim(rtrim(a.PhysicianZipCode)) as PhysicianZip,
		CopaysupportBenefitAmount as PatientBenefit,
		OutOfPocketCostOOPAfterCoPaySupport as PatientOOP,
		OutOfPocketCostOOPBeforeCoPaySupport as Copay,
		DispensingFeePaid as DispensingFee,
		convert(decimal(10, 2), null) as CalculatedAWP,
		convert(varchar(50), null) as Payer,
		convert(varchar(100), null) as RejectionCode
	FROM [EnbrelImportExport_Production].[dbo].[tblImportAllApprovedClaimsHistory] a
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.TeradataConsumerID = b.TeradataPatientID
			and b.ActiveFlag = 1
	WHERE left (dateoffill, 4) = '2017'
			and VendorCode <> 'PSK'

	-------------------------------- rejected OPUS claims...
	INSERT INTO [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]
	SELECT DISTINCT 
		CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
		ClaimReferenceNumber as ClaimNumber,
		convert(varchar(50), null) as ClaimTransactionNumber,
		ClaimType,
		b.PatientID as PatientID,
		TeradataConsumerID as TeradataID,
		OfferCode,
		RxNumber,
		convert(varchar(8), null) as DateWritten,
		replace(convert(varchar, convert(datetime, DateOfFill), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, DateClaimsReceivedOrProcessed), 111), '/', '') as DateProcessed,
		DaysSupply as DaysOfSupply,
		NDC,
		DrugName,
		convert(varchar(50), null) as DrugDesc,
		DrugDosageForm as DrugForm,
		DrugDosageForm as DrugDosage,
		DrugStrength,
		convert(varchar(50), null) as NewRefillCode,
		NumberofRefillsAuthorized as Refills,
		PaidQuantity as Quantity,
		convert(varchar(10), 'Electronic') as SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		CarrierGroupNumber as GroupNumber,
		CardIDNumber as CardID,
		convert(varchar(10), null) as PharmacyNPI,
		PharmacyNCPDPNumber as PharmacyNCPDP,
		convert(varchar(50), null) as PharmacyChainNumber,
		convert(varchar(50), null) as PharmacyChain,
		ltrim(rtrim(PharmacyName)) as PharmacyName,
		ltrim(rtrim(PharmacyAddress1)) as PharmacyAddress1,
		ltrim(rtrim(PharmacyAddress2)) as PharmacyAddress2,
		ltrim(rtrim(PharmacyCity)) as PharmacyCity,
		ltrim(rtrim(PharmacyState)) as PharmacyState,
		ltrim(rtrim(PharmacyZipCode)) as PharmacyZip,
		convert(varchar(50), null) as PharmacyPhone,
		PrescriberIDNPI as PhysicianNPI,
		PrescriberIDDEA as PhysicianDEA,
		ltrim(rtrim(a.PhysicianFirstname)) as PhysicianFirstName,
		ltrim(rtrim(substring(a.PhysicianFullNameOrLastname, CHARINDEX(a.PhysicianFirstName, a.PhysicianFullNameOrLastname) + len(a.PhysicianFirstName), len(a.PhysicianFullNameOrLastname)))) as PhysicianLastName,
		convert(varchar(50), Specialty) as PhysicianSpecialty,
		ltrim(rtrim(a.PhysicianAddress1)) as PhysicianAddress1,
		ltrim(rtrim(a.PhysicianAddress2)) as PhysicianAddress2,
		ltrim(rtrim(a.PhysicianCity)) as PhysicianCity,
		ltrim(rtrim(a.PhysicianState)) as PhysicianState,
		ltrim(rtrim(a.PhysicianZipCode)) as PhysicianZip,
		CopaysupportBenefitAmount as PatientBenefit,
		OutOfPocketCostOOPAfterCoPaySupport as PatientOOP,
		OutOfPocketCostOOPBeforeCoPaySupport as Copay,
		DispensingFeePaid as DispensingFee,
		convert(decimal(10, 2), null) as CalculatedAWP,
		convert(varchar(50), null) as Payer,
		RejectedCode as RejectionCode
	FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportAllRejectedClaims] a
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.TeradataConsumerID = b.TeradataPatientID
			and b.ActiveFlag = 1
	WHERE left (dateoffill, 4) = '2017'
			and VendorCode <> 'PSK'

	INSERT INTO [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]
	SELECT DISTINCT 
		CASE WHEN OfferCode = 'MPRS' THEN 'MCK' ELSE VendorCode END as VendorCode,
		ClaimReferenceNumber as ClaimNumber,
		convert(varchar(50), null) as ClaimTransactionNumber,
		ClaimType,
		b.PatientID as PatientID,
		RMDBConsumerID as TeradataID,
		OfferCode,
		RxNumber,
		convert(varchar(8), null) as DateWritten,
		replace(convert(varchar, convert(datetime, DateOfFill), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, DateClaimsReceivedOrProcessed), 111), '/', '') as DateProcessed,
		DaysSupply as DaysOfSupply,
		NDC,
		DrugName,
		convert(varchar(50), null) as DrugDesc,
		DrugDosageForm as DrugForm,
		DrugDosageForm as DrugDosage,
		DrugStrength,
		convert(varchar(50), null) as NewRefillCode,
		NumberofRefillsAuthorized as Refills,
		PaidQuantity as Quantity,
		convert(varchar(10), 'Electronic') as SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		CarrierGroupNumber as GroupNumber,
		CardIDNumber as CardID,
		convert(varchar(10), null) as PharmacyNPI,
		PharmacyNCPDPNumber as PharmacyNCPDP,
		convert(varchar(50), null) as PharmacyChainNumber,
		convert(varchar(50), null) as PharmacyChain,
		ltrim(rtrim(PharmacyName)) as PharmacyName,
		ltrim(rtrim(PharmacyAddress1)) as PharmacyAddress1,
		ltrim(rtrim(PharmacyAddress2)) as PharmacyAddress2,
		ltrim(rtrim(PharmacyCity)) as PharmacyCity,
		ltrim(rtrim(PharmacyState)) as PharmacyState,
		ltrim(rtrim(PharmacyZipCode)) as PharmacyZip,
		convert(varchar(50), null) as PharmacyPhone,
		PrescriberIDNPI as PhysicianNPI,
		PrescriberIDDEA as PhysicianDEA,
		ltrim(rtrim(a.PhysicianFirstname)) as PhysicianFirstName,
		ltrim(rtrim(substring(a.PhysicianFullNameOrLastname, CHARINDEX(a.PhysicianFirstName, a.PhysicianFullNameOrLastname) + len(a.PhysicianFirstName), len(a.PhysicianFullNameOrLastname)))) as PhysicianLastName,
		convert(varchar(50), Specialty) as PhysicianSpecialty,
		ltrim(rtrim(a.PhysicianAddress1)) as PhysicianAddress1,
		ltrim(rtrim(a.PhysicianAddress2)) as PhysicianAddress2,
		ltrim(rtrim(a.PhysicianCity)) as PhysicianCity,
		ltrim(rtrim(a.PhysicianState)) as PhysicianState,
		ltrim(rtrim(a.PhysicianZipCode)) as PhysicianZip,
		CopaysupportBenefitAmount as PatientBenefit,
		OutOfPocketCostOOPAfterCoPaySupport as PatientOOP,
		OutOfPocketCostOOPBeforeCoPaySupport as Copay,
		DispensingFeePaid as DispensingFee,
		convert(decimal(10, 2), null) as CalculatedAWP,
		convert(varchar(50), null) as Payer,
		RejectedCode as RejectionCode
	FROM [EnbrelImportExport_Production].[dbo].[tblImportAllRejectedClaimsHistory] a
	LEFT OUTER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.RMDBConsumerID = b.TeradataPatientID
			and b.ActiveFlag = 1
	WHERE left (dateoffill, 4) = '2017'
			and VendorCode <> 'PSK'


	ALTER INDEX [idx_ClaimType_INCL_AmgenPatientID_DateOfFill] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE
	ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE

	TRUNCATE TABLE [dbo].[MarketingClaims_OutputMarketingClaims_Stage]

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
		(VendorCode,
		ClaimNumber,
		ClaimTransactionNumber,
		ClaimType,
		AmgenPatientID,  --Hao, 7/12/2017
		OfferCode,
		RxNumber,
		DateWritten,
		DateOfFill,
		DateProcessed,
		DaysOfSupply,
		NDC,
		DrugName,
		DrugDesc,
		DrugForm,
		DrugDosage,
		DrugStrength,
		NewRefillCode,
		Refills,
		Quantity,
		SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		GroupNumber,
		CardID,
		PharmacyNPI,
		PharmacyNCPDP,
		PharmacyChainNumber,
		PharmacyChain,
		PharmacyName,
		PharmacyAddress1,
		PharmacyAddress2,
		PharmacyCity,
		PharmacyState,
		PharmacyZip,
		PharmacyPhone,
		PhysicianNPI,
		PhysicianDEA,
		PhysicianFirstName,
		PhysicianLastName,
		PhysicianSpecialty,
		PhysicianAddress1,
		PhysicianAddress2,
		PhysicianCity,
		PhysicianState,
		PhysicianZip,
		PatientBenefit,
		PatientOOP,
		Copay,
		DispensingFee,
		CalculatedAWP,
		Payer,
		RejectionCode)
	SELECT VendorCode,
		ClaimNumber,
		ClaimTransactionNumber,
		ClaimType,
		PatientID,
		OfferCode,
		RxNumber,
		DateWritten,
		DateOfFill,
		DateProcessed,
		DaysOfSupply,
		NDC,
		DrugName,
		DrugDesc,
		DrugForm,
		DrugDosage,
		DrugStrength,
		NewRefillCode,
		Refills,
		Quantity,
		SubmissionMethod,
		PriorAuthorizationCode,
		OtherCoverageCode,
		GroupNumber,
		CardID,
		PharmacyNPI,
		PharmacyNCPDP,
		PharmacyChainNumber,
		PharmacyChain,
		PharmacyName,
		PharmacyAddress1,
		PharmacyAddress2,
		PharmacyCity,
		PharmacyState,
		left(PharmacyZip, 5),
		PharmacyPhone,
		PhysicianNPI,
		PhysicianDEA,
		PhysicianFirstName,
		PhysicianLastName,
		PhysicianSpecialty,
		PhysicianAddress1,
		PhysicianAddress2,
		PhysicianCity,
		PhysicianState,
		left(PhysicianZip, 5),
		PatientBenefit,
		PatientOOP,
		Copay,
		DispensingFee,
		CalculatedAWP,
		Payer,
		RejectionCode
	FROM [dbo].[MarketingClaims_MarketingTeradataClaims_Stage]

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_ExtractTeradataClaims end.'

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
