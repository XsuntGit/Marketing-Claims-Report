SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_MarketingClaims_OPUMCKClaims]
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_OPUMCKClaims start.'

	ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)
		
	DELETE [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
	WHERE VendorCode in ('OPU', 'MCK')

	TRUNCATE TABLE [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage]

	--ALTER INDEX [idx_MarketingClaims_MarketingOPUMCKClaims_Stage] ON [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage] DISABLE

	-- OPU/MCK claims...
	INSERT INTO [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage]
	SELECT --DISTINCT
		CreatedAt,
		Status,
		TeradataClaimReferenceNumber,
		convert(varchar(50), TeradataVendorCode) as VendorCode,
		null as ClaimNumber,
		null as ClaimTransactionNumber,
		case Status
			when 'Approved' then 'P'
			when 'Reversal' then 'X'
			when 'Rejected' then 'R'
		end as ClaimType,
		convert(varchar(50), a.PatientID) as PatientID,
		convert(varchar(50), b.TeradataPatientID) as TeradataID,
		f.OfferCode as OfferCode,
		a.RxNumber,
		null as DateWritten,
		replace(convert(varchar, convert(datetime, a.DatePrescriptionFilled), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, a.DateCreated), 111), '/', '') as DateProcessed,
		TeradataDaysSupply as DaysOfSupply,
		ndc.NDCName as NDC,
		ndc.DrugName,
		null as DrugDesc,
		ndc.DrugDosageForm as DrugForm,
		ndc.DrugDosageForm as DrugDosage,
		ndc.DrugStrength,
		null as NewRefillCode,
		convert(int, TeradataNumberOfRefillsAuthorized) as ReFills,
		convert(varchar(50), TeradataPaidQuantity) as Quantity,
		'Electronic' as SubmissionMethod,
		convert(varchar(50), TeradataPriorAuthorizationCode) as PriorAuthorizationCode,
		convert(varchar(50), TeradataOtherCoverageCode) OtherCoverageCode,
		f.RxGroupID as GroupNumber,
		a.CardID as CardID,
		case when d.NPINumber = 'unk' then '' else d.NPINumber end as PharmacyNPI,
		convert(varchar(50), TeradataPharmacyNCPDPNumber) as PharmacyNCPDP,
		null as PharmacyChainNumber,
		null as PharmacyChain,
		d.Name as PharmacyName,
		d.Address as PharmacyAddress1,
		d.Address2 as PharmacyAddress2,
		d.City as PharmacyCity,
		d.State as PharmacyState,
		d.Zip as PharmacyZip,
		null as PharmacyPhone,
		convert(varchar(50), TeradataPrescriberNPI) as PhysicianNPI,
		convert(varchar(50), TeradataPrescriberDEA) as PhysicianDEA,
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
		convert(varchar(50), TeradataDispensingFeePaid) as DispensingFee,
		null as CalculatedAWP,
		null as Payer,
		convert(varchar(100), TeradataRejectionCode) as RejectionCode		  
	FROM [EnbrelImportExport_Production].[dbo].[OutputRetailApprovedClaimsHistory] a with (nolock)
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.PatientID = b.PatientID
	LEFT JOIN [Enbrel_Production].[dbo].[tblPharmacies] d with (nolock)
		ON a.PharmacyID = d.tblPharmaciesID
	LEFT JOIN [Enbrel_Production].[dbo].[tblDoctors] e with (nolock)
		ON a.DoctorID = e.tblDoctorsID
	JOIN [Enbrel_Production].[dbo].[tblProgram] f with (nolock)
		ON a.PatientProgramType = f.ProgramID
	LEFT JOIN [Enbrel_Production].[dbo].[tblNDCList] ndc with (nolock)
		ON a.NDC = ndc.NDCCode
	WHERE (CreatedAt = 'TeradataImport')
		AND Status in ('Approved', 'Reversal', 'Rejected')
		--and year(a.DatePrescriptionFilled) = '2017'
		AND a.PatientID not in ('50491','46631','50492','51757','51758')
		AND a.cardid is not null

	-- add rejected claims...
	INSERT INTO [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage]
	SELECT --DISTINCT
		CreatedAt,
		Status,
		TeradataClaimReferenceNumber,
		convert(varchar(50), TeradataVendorCode) as VendorCode,
		null as ClaimNumber,
		null as ClaimTransactionNumber,
		case Status
			when 'Approved' then 'P'
			when 'Reversal' then 'X'
			when 'Rejected' then 'R'
		end as ClaimType,
		convert(varchar(50), a.PatientID) as PatientID,
		convert(varchar(50), b.TeradataPatientID) as TeradataID,
		f.OfferCode as OfferCode,
		a.RxNumber,
		null as DateWritten,
		replace(convert(varchar, convert(datetime, a.DatePrescriptionFilled), 111), '/', '') as DateOfFill,
		replace(convert(varchar, convert(datetime, a.DateCreated), 111), '/', '') as DateProcessed,
		TeradataDaysSupply as DaysOfSupply,
		ndc.NDCName as NDC,
		ndc.DrugName,
		null as DrugDesc,
		ndc.DrugDosageForm as DrugForm,
		ndc.DrugDosageForm as DrugDosage,
		ndc.DrugStrength,
		null as NewRefillCode,
		convert(int, TeradataNumberOfRefillsAuthorized) as ReFills,
		convert(varchar(50), TeradataPaidQuantity) as Quantity,
		'Electronic' as SubmissionMethod,
		convert(varchar(50), TeradataPriorAuthorizationCode) as PriorAuthorizationCode,
		convert(varchar(50), TeradataOtherCoverageCode) OtherCoverageCode,
		f.RxGroupID as GroupNumber,
		a.CardID as CardID,
		case when d.NPINumber = 'unk' then '' else d.NPINumber end as PharmacyNPI,
		convert(varchar(50), TeradataPharmacyNCPDPNumber) as PharmacyNCPDP,
		null as PharmacyChainNumber,
		null as PharmacyChain,
		d.Name as PharmacyName,
		d.Address as PharmacyAddress1,
		d.Address2 as PharmacyAddress2,
		d.City as PharmacyCity,
		d.State as PharmacyState,
		d.Zip as PharmacyZip,
		null as PharmacyPhone,
		convert(varchar(50), TeradataPrescriberNPI) as PhysicianNPI,
		convert(varchar(50), TeradataPrescriberDEA) as PhysicianDEA,
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
		convert(varchar(50), TeradataDispensingFeePaid) as DispensingFee,
		null as CalculatedAWP,
		null as Payer,
		convert(varchar(100), TeradataRejectionCode) as RejectionCode		  
	FROM [EnbrelImportExport_Production].[dbo].[OutputRetailRejectedClaimsHistory] a with (nolock)
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] b with (nolock)
		ON a.PatientID = b.PatientID
	LEFT JOIN [Enbrel_Production].[dbo].[tblPharmacies] d with (nolock)
		ON a.PharmacyID = d.tblPharmaciesID
	LEFT JOIN [Enbrel_Production].[dbo].[tblDoctors] e with (nolock)
		ON a.DoctorID = e.tblDoctorsID
	JOIN [Enbrel_Production].[dbo].[tblProgram] f with (nolock)
		ON a.PatientProgramType = f.ProgramID
	LEFT JOIN [Enbrel_Production].[dbo].[tblNDCList] ndc with (nolock)
		ON a.NDC = ndc.NDCCode
	WHERE (CreatedAt = 'TeradataImport')
		AND Status in ('Approved', 'Reversal', 'Rejected')
		--and year(a.DatePrescriptionFilled) = '2017'
		AND a.PatientID not in ('50491','46631','50492','51757','51758')
		AND a.cardid is not null
	
	UPDATE a
	SET a.ClaimNumber = b.ClaimIDX
	FROM [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage] a
	INNER JOIN [EnbrelImportExport_Production].[dbo].[tblClaimIDMaster] b
		ON a.VendorCode = b.VendIDS
		AND a.CardID = b.CardIDS
		AND a.TeradataClaimReferenceNumber = b.ClaimIDS

	--ALTER INDEX [idx_MarketingClaims_MarketingOPUMCKClaims_Stage] ON [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

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
	FROM [dbo].[MarketingClaims_MarketingOPUMCKClaims_Stage] (nolock) as tbl
	CROSS APPLY dbo.BreakStringIntoRows(RejectionCode)

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_OPUMCKClaims end.'

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
