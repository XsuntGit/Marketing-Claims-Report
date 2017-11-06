SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_MarketingClaims_PSKWClaims]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PSKWClaims start.'

	ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)

	DELETE FROM [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
	WHERE VendorCode = 'PSK'

	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingPSKWClaims_Stage]
	-- PSKW claims...
	INSERT INTO [dbo].[MarketingClaims_MarketingPSKWClaims_Stage]
	SELECT DISTINCT
		Status,
		convert(varchar(50), 'PSK') as VendorCode,
		convert(varchar(50), tblClaimID) as ClaimNumber,
		convert(varchar(50), null) as ClaimTransactionNumber,
		case Status when 'Approved' then 'P'
			when 'Reversal' then 'X'
			when 'Rejected' then 'R'
		end as ClaimType,
		convert(varchar(50), a.PatientID) as PatientID,
		convert(varchar(50), b.TeradataPatientID) as TeradataID,
		f.OfferCode as OfferCode,
		a.RxNumber,
		convert(varchar(8), null) as DateWritten,
		replace(convert(varchar, convert(datetime, a.DatePrescriptionFilled), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, a.LastModified), 111), '/', '') as DateProcessed,
		case when a.QuantityDispensed = 1 then 7
			when a.QuantityDispensed = 2 then 28
			when a.QuantityDispensed = 3 then 84
			end as DaysOfSupply,
		ndc.NDCName as NDC,
		ndc.DrugName,
		convert(varchar(50), null) as DrugDesc,
		ndc.DrugDosageForm as DrugForm,
		ndc.DrugDosageForm as DrugDosage,
		ndc.DrugStrength,
		convert(varchar(50), null) as NewRefillCode,
		convert(int, null) as ReFills,
		convert(varchar(50), null) as Quantity,
		convert(varchar(10), 'Portal') as SubmissionMethod,
		convert(varchar(50), null) as PriorAuthorizationCode,
		convert(varchar(50), null) OtherCoverageCode,
		f.RxGroupID as GroupNumber,
		a.CardID as CardID,
		case when d.NPINumber = 'unk' then '' else d.NPINumber end as PharmacyNPI,
		convert(varchar(50), null) as PharmacyNCPDP,
		convert(varchar(50), null) as PharmacyChainNumber,
		convert(varchar(50), null) as PharmacyChain,
		d.Name as PharmacyName,
		d.Address as PharmacyAddress1,
		d.Address2 as PharmacyAddress2,
		d.City as PharmacyCity,
		d.State as PharmacyState,
		d.Zip as PharmacyZip,
		convert(varchar(50), null) as PharmacyPhone,
		convert(varchar(50), null) as PhysicianNPI,
		convert(varchar(50), null) as PhysicianDEA,
		e.FirstName as PhysicianFirstName,
		e.LastName as PhysicianLastName,
		e.Logist as PhysicianSpecialty,
		e.Address1 as PhysicianAddress1,
		e.Address2 as PhysicianAddress2,
		e.City as PhysicianCity,
		e.State as PhysicianState,
		e.Zip as PhysicianZip,
		a.ApprovedAmount as PatientBenefit,
		case when a.VerifiedClaimAmount is not null then a.VerifiedClaimAmount
			else a.FinalCost
		end - a.ApprovedAmount as PatientOOP,
		case when a.VerifiedClaimAmount is not null then a.VerifiedClaimAmount
			else a.FinalCost
		end as Copay,
		convert(varchar(50), null) as DispensingFee,
		convert(decimal(10, 2), null) as CalculatedAWP,
		convert(varchar(50), null) as Payer,
		convert(varchar(100), a.RejectedReason) as RejectionCode		  
	FROM [Enbrel_Production].[dbo].[tblClaims] a with (nolock)
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		on a.PatientID = b.PatientID
	LEFT JOIN [Enbrel_Production].[dbo].[tblPharmacies] d with (nolock)
		on a.PharmacyID = d.tblPharmaciesID
	LEFT JOIN [Enbrel_Production].[dbo].[tblDoctors] e with (nolock)
		on a.DoctorID = e.tblDoctorsID
	JOIN [Enbrel_Production].[dbo].[tblProgram] f with (nolock)
		on a.PatientProgramType = f.ProgramID
	LEFT JOIN [Enbrel_Production].[dbo].[tblNDCList] ndc with (nolock)
		on a.NDC = ndc.NDCCode
	WHERE (a.CreatedAt in ('Patient Portal','Customer Service Portal') or a.CreatedAt is null)		--Hao 11/6/2017
		--(a.CreatedAt <> 'TeradataImport' or a.CreatedAt is null)
		and a.Status in ('Approved', 'Reversal', 'Rejected')
		--and year(a.DatePrescriptionFilled) = '2017'
		and a.PatientID not in ('50491','46631','50492','51757','51758')
		and a.cardid is not null

	--find when the approved date of reversed claims...
	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage]

	INSERT INTO [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage]
		([Status]
		,[VendorCode]
		,[ClaimNumber]
		,[ClaimTransactionNumber]
		,[ClaimType]
		,[PatientID]
		,[TeradataID]
		,[OfferCode]
		,[RxNumber]
		,[DateWritten]
		,[DateOfFill]
		,[DateProcessed]
		,[DaysOfSupply]
		,[NDC]
		,[DrugName]
		,[DrugDesc]
		,[DrugForm]
		,[DrugDosage]
		,[DrugStrength]
		,[NewRefillCode]
		,[ReFills]
		,[Quantity]
		,[SubmissionMethod]
		,[PriorAuthorizationCode]
		,[OtherCoverageCode]
		,[GroupNumber]
		,[CardID]
		,[PharmacyNPI]
		,[PharmacyNCPDP]
		,[PharmacyChainNumber]
		,[PharmacyChain]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZip]
		,[PharmacyPhone]
		,[PhysicianNPI]
		,[PhysicianDEA]
		,[PhysicianFirstName]
		,[PhysicianLastName]
		,[PhysicianSpecialty]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZip]
		,[PatientBenefit]
		,[PatientOOP]
		,[Copay]
		,[DispensingFee]
		,[CalculatedAWP]
		,[Payer]
		,[RejectionCode])
	SELECT [Status]
		,[VendorCode]
		,[ClaimNumber]
		,[ClaimTransactionNumber]
		,'P'
		,[PatientID]
		,[TeradataID]
		,[OfferCode]
		,[RxNumber]
		,[DateWritten]
		,[DateOfFill]
		,[DateProcessed]
		,[DaysOfSupply]
		,[NDC]
		,[DrugName]
		,[DrugDesc]
		,[DrugForm]
		,[DrugDosage]
		,[DrugStrength]
		,[NewRefillCode]
		,[ReFills]
		,[Quantity]
		,[SubmissionMethod]
		,[PriorAuthorizationCode]
		,[OtherCoverageCode]
		,[GroupNumber]
		,[CardID]
		,[PharmacyNPI]
		,[PharmacyNCPDP]
		,[PharmacyChainNumber]
		,[PharmacyChain]
		,[PharmacyName]
		,[PharmacyAddress1]
		,[PharmacyAddress2]
		,[PharmacyCity]
		,[PharmacyState]
		,[PharmacyZip]
		,[PharmacyPhone]
		,[PhysicianNPI]
		,[PhysicianDEA]
		,[PhysicianFirstName]
		,[PhysicianLastName]
		,[PhysicianSpecialty]
		,[PhysicianAddress1]
		,[PhysicianAddress2]
		,[PhysicianCity]
		,[PhysicianState]
		,[PhysicianZip]
		,[PatientBenefit]
		,[PatientOOP]
		,[Copay]
		,[DispensingFee]
		,[CalculatedAWP]
		,[Payer]
		,[RejectionCode]
	FROM [dbo].[MarketingClaims_MarketingPSKWClaims_Stage]
	WHERE ClaimType = 'X'

	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingPSKWReversedClaimsApprovedDate_Stage]

	INSERT INTO [dbo].[MarketingClaims_MarketingPSKWReversedClaimsApprovedDate_Stage]
	SELECT tblClaimID as ClaimNumber, 
		MIN(LastModified) as FirstApprovedDate
	FROM [Enbrel_Production].[dbo].[tblClaimsHistory] with (nolock)
	WHERE tblClaimID in (SELECT ClaimNumber FROM [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage])
		and Status = 'Approved'
	GROUP BY tblClaimID

	UPDATE a
	SET a.DateProcessed = replace(convert(varchar, convert(datetime, b.FirstApprovedDate), 111), '/', '')
	FROM [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage] a
	INNER JOIN [dbo].[MarketingClaims_MarketingPSKWReversedClaimsApprovedDate_Stage] b
		on a.ClaimNumber = b.ClaimNumber
		and b.FirstApprovedDate is not null

	DELETE [dbo].[MarketingClaims_MarketingPSKWClaims_Stage]
	WHERE ClaimNumber in (SELECT ClaimNumber FROM [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage])
		and ClaimType = 'P'

	INSERT INTO [dbo].[MarketingClaims_MarketingPSKWClaims_Stage]
	SELECT * 
	FROM [dbo].[MarketingClaims_MarketingPSKWReversedClaims_Stage]

	ALTER INDEX [idx_ClaimType_INCL_AmgenPatientID_DateOfFill] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE
	ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
		(VendorCode,
		ClaimNumber,
		ClaimTransactionNumber,
		ClaimType,
		AmgenPatientID,
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
		ReturnColumn -- splitted reason code...
	FROM [dbo].[MarketingClaims_MarketingPSKWClaims_Stage] (nolock)
	CROSS APPLY dbo.BreakStringIntoRows(RejectionCode)

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_PSKWClaims end.'

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
