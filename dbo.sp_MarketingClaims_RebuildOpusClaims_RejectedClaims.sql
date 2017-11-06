SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_MarketingClaims_RebuildOpusClaims_RejectedClaims] 
AS
SET NOCOUNT ON;
BEGIN TRY

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_RejectedClaims start.'

	-- Teradata has duplicate records for one claims...
	TRUNCATE TABLE [dbo].[MarketingClaims_OpusRejectedClaims_Stage]

	--ALTER INDEX [idx_MarketingClaims_OpusRejectedClaims_Stage_ColumnStore] ON [dbo].[MarketingClaims_OpusRejectedClaims_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
		([ClaimKey]
		,[FinalStatus]
		,[ExternalConsumerID]
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
		,[ImportDate]
		,[RankID])
	SELECT VendorCode + ClaimReferenceNumber + CardIDNumber + DateOfFill as ClaimKey
		,CONVERT(VARCHAR(20), 'R') AS FinalStatus
		,[ExternalConsumerID]
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
		,[ImportDate]
		,ROW_NUMBER() OVER
		(
			PARTITION BY VendorCode, ClaimReferenceNumber, CardIDNumber, DateOfFill
			ORDER BY DateClaimsReceivedOrProcessed DESC, ImportDate DESC
		) AS RankID
	FROM [dbo].[MarketingClaims_inOpusRejectedClaims_Stage]

	--ALTER INDEX [idx_MarketingClaims_OpusRejectedClaims_Stage_ColumnStore] ON [dbo].[MarketingClaims_OpusRejectedClaims_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

	-- exception records...
	TRUNCATE TABLE [dbo].[MarketingClaims_OpusRejectedClaimExceptions_Stage]

	INSERT INTO [dbo].[MarketingClaims_OpusRejectedClaimExceptions_Stage]
		([ClaimKey]
		,[PatientID]
		,[DoctorID]
		,[PharmacyID]
		,[PatientProgramType]
		,[AmgenClaimID]
		,[FinalStatus]
		,[ExternalConsumerID]
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
		,[ImportDate]
		,[RankID]
		,[FilterDate]
		,[FilterMsg])
	SELECT [ClaimKey]
		,[PatientID]
		,[DoctorID]
		,[PharmacyID]
		,[PatientProgramType]
		,[AmgenClaimID]
		,[FinalStatus]
		,[ExternalConsumerID]
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
		,[ImportDate]
		,[RankID]
		,GETDATE() as FilterDate
		,CONVERT(VARCHAR(200), 'PSKW records.') as FilterMsg
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE VendorCode = 'PSK'

	DELETE [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE VendorCode = 'PSK' 

	INSERT INTO [dbo].[MarketingClaims_OpusRejectedClaimExceptions_Stage]
	SELECT *, 
		GETDATE() as FilterDate, 
		CONVERT(VARCHAR(200), 'Test patient records.') as FilterMsg
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE TeradataConsumerID in
	(
		SELECT TeradataConsumerID FROM [dbo].[MarketingClaims_TestTeradataIDs_Stage]
	)

	DELETE [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE TeradataConsumerID in
	(
		SELECT TeradataConsumerID FROM [dbo].[MarketingClaims_TestTeradataIDs_Stage]
	)

	-- get program ID...
	UPDATE [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	SET PatientProgramType = 
		(
			SELECT ProgramID 
			FROM [Enbrel_Production].[dbo].[tblProgram] with (nolock)
			WHERE RxGroupID = [dbo].[MarketingClaims_OpusRejectedClaims_Stage].CarrierGroupNumber
				and OfferCode = [dbo].[MarketingClaims_OpusRejectedClaims_Stage].OfferCode
		)
		
	-- when virtual patient converts, the same claim is sent again...
	-- use Opus ID to populate Teradata ID...
	UPDATE a 
	SET a.TeradataConsumerID = b.TeradataPatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] as b with (nolock)
		ON a.ExternalConsumerID = b.OpusID
	WHERE b.ActiveFlag = 1
		and b.OpusID is not null 
		and b.OpusID <> ''

	-- get patientID... 
	UPDATE a 
	SET a.PatientID = b.PatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] as b with (nolock)
		ON a.TeradataConsumerID = b.TeradataPatientID
	WHERE b.ActiveFlag = 1

	UPDATE a 
	SET a.PatientID = b.ToPatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [dbo].[MarketingClaims_MergedTeradataIDs_Stage] as b 
		ON a.TeradataConsumerID = b.FromTeradataID
	WHERE a.PatientID is null

	-- get patientID from OpusID  --Hao, 11/5/2017
	UPDATE a 
	SET a.PatientID = b.PatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] as b with (nolock)
		ON a.ExternalConsumerID = b.OpusID
	WHERE a.PatientID is null
		and b.FirstName <> 'Virtual' -- FirstName,      
		and b.LastName <> 'Patient' --LastName			 
		and b.OpusID is not null
		and b.ActiveFlag = 1							 

	-- get patientID for virtual claims...
	UPDATE a 
	SET a.PatientID = b.PatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [Enbrel_Production].[dbo].[tblPatientInfo] as b with (nolock)
		ON a.ExternalConsumerID = b.OpusID
	WHERE a.PatientID is null
		and b.FirstName = 'Virtual' -- FirstName,     
		and b.LastName = 'Patient' --LastName			 
		and b.OpusID is not null

	-- get the patient IDs from the exception tables
	UPDATE a 
	SET a.PatientID = b.ExternalConsumerID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] a
	INNER JOIN (
				SELECT ExternalConsumerID, TeradataConsumerID 
				FROM [EnbrelImportExport_Production].[dbo].[tblTeradataProfileExceptionHistory]
				WHERE ExternalConsumerID is not null
				UNION
				SELECT ExternalConsumerID, TeradataConsumerID 
				FROM [EnbrelImportExport_HistoryImport].[dbo].[tblTeradataProfileException]
				WHERE ExternalConsumerID is not null
				) b
		ON a.TeradataConsumerID = b.TeradataConsumerID
	WHERE PatientID is null 
		AND a.TeradataConsumerID is not null

	-- manually updated TeradataIDs...
	-- this is a hot fix on 06/30/2017... should be decided whether it is needed later
	TRUNCATE TABLE [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage]

	--ALTER INDEX [idx_MarketingClaims_AllTeradataConsumerIDs_Stage_TeradataConsumerID] ON [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage] DISABLE

	INSERT INTO [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage]
		(TeradataConsumerID)
	SELECT TeradataConsumerID 
	FROM [EnbrelImportExport_Production].[dbo].[tblImportConsumerCustomerProfileInfoHistory]
	WHERE TeradataConsumerID is not null
	UNION
	SELECT TeradataConsumerID 
	FROM [TeradataHistory_DoNotDelete].[dbo].[tblImportConsumerCustomerProfileInfo]
	WHERE TeradataConsumerID is not null

	--ALTER INDEX [idx_MarketingClaims_AllTeradataConsumerIDs_Stage_TeradataConsumerID] ON [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)

	TRUNCATE TABLE [dbo].[MarketingClaims_ManualOverwrittenTeradataIDs_Stage]

	INSERT INTO [dbo].[MarketingClaims_ManualOverwrittenTeradataIDs_Stage]
		(PatientID,
		TeradataPatientID)
	SELECT PatientID,
		TeradataPatientID
	FROM [Enbrel_Production].[dbo].[tblPatientHistoryInfo] with (nolock)
	WHERE TeradataPatientID in 
	(
		SELECT TeradataConsumerID
		FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
		WHERE patientid is null
		and TeradataConsumerID in 
			(
			SELECT TeradataConsumerID 
			FROM [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage]
			)
		GROUP BY TeradataConsumerID
	)
	GROUP BY PatientID,
		TeradataPatientID

	UPDATE a
	SET a.PatientID = b.PatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] a
	INNER JOIN [dbo].[MarketingClaims_ManualOverwrittenTeradataIDs_Stage] b
		ON a.TeradataConsumerID = b.TeradataPatientID
	WHERE a.PatientID is null

	UPDATE a 
	SET a.PatientID = b.ToPatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] a
	INNER JOIN [dbo].[MarketingClaims_MergedTeradataIDs_Stage] b
		ON a.PatientID = b.FromPatientID

	-- make sure the PatientID is consistent and based on the last record received...
	UPDATE a
	SET a.PatientID = b.PatientID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] a
	INNER JOIN [dbo].[MarketingClaims_OpusRejectedClaims_Stage] b
		ON a.ClaimKey = b.ClaimKey
	WHERE a.RankID <> 1 and b.RankID = 1
		and a.PatientID <> b.PatientID

	-- map NDC code...
	UPDATE a 
	SET a.NDC = b.NDCCode
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a
	INNER JOIN [EnbrelImportExport_Production].[dbo].[tblNDCCodeMapping] as b 
		ON a.NDC = b.ImportNDCCode

	TRUNCATE TABLE [dbo].[MarketingClaims_ClaimPhysicians_Stage]

	INSERT INTO [dbo].[MarketingClaims_ClaimPhysicians_Stage]
		([FirstName]
		,[LastName]
		,[Address1]
		,[Address2]
		,[City]
		,[State]
		,[Zip])
	SELECT
		ltrim(rtrim(PhysicianFirstname)) as FirstName,
		ltrim(rtrim(substring(PhysicianFullNameOrLastname, CHARINDEX(physicianFirstName, PhysicianFullNameOrLastname) + len(physicianFirstName), len(PhysicianFullNameOrLastname)))) as LastName,
		isnull(ltrim(rtrim(PhysicianAddress1)), '') as Address1, 
		isnull(ltrim(rtrim(PhysicianAddress2)), '') as Address2, 
		isnull(ltrim(rtrim(PhysicianCity)), '') as City, 
		isnull(ltrim(rtrim(PhysicianState)), '') as State, 
		isnull(ltrim(rtrim(PhysicianZipCode)), '') as Zip
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE (PhysicianFirstname is not NULL OR ltrim(rtrim(PhysicianFirstname)) != '')
		and PhysicianFirstname <> 'NA' and PhysicianFirstname <> 'N/A'
	GROUP BY ltrim(rtrim(PhysicianFirstname)),
		ltrim(rtrim(substring(PhysicianFullNameOrLastname, CHARINDEX(physicianFirstName, PhysicianFullNameOrLastname) + len(physicianFirstName), len(PhysicianFullNameOrLastname)))),
		isnull(ltrim(rtrim(PhysicianAddress1)), ''), 
		isnull(ltrim(rtrim(PhysicianAddress2)), ''), 
		isnull(ltrim(rtrim(PhysicianCity)), ''), 
		isnull(ltrim(rtrim(PhysicianState)), ''), 
		isnull(ltrim(rtrim(PhysicianZipCode)), '')

	TRUNCATE TABLE [dbo].[MarketingClaims_ClaimPharmacies_Stage]

	INSERT INTO [dbo].[MarketingClaims_ClaimPharmacies_Stage]
		([PharmacyName]
		,[Address1]
		,[Address2]
		,[City]
		,[State]
		,[Zip])
	SELECT
		ltrim(rtrim(PharmacyName)) as PharmacyName,
		isnull(ltrim(rtrim(PharmacyAddress1)), '') as Address1, 
		isnull(ltrim(rtrim(PharmacyAddress2)), '') as Address2, 
		isnull(ltrim(rtrim(PharmacyCity)), '') as City, 
		isnull(ltrim(rtrim(PharmacyState)), '') as State, 
		isnull(ltrim(rtrim(PharmacyZipCode)), '') as Zip
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE PharmacyName is not NULL OR ltrim(rtrim(PharmacyName)) != ''
	GROUP BY ltrim(rtrim(PharmacyName)),
		isnull(ltrim(rtrim(PharmacyAddress1)), ''), 
		isnull(ltrim(rtrim(PharmacyAddress2)), ''), 
		isnull(ltrim(rtrim(PharmacyCity)), ''), 
		isnull(ltrim(rtrim(PharmacyState)), ''), 
		isnull(ltrim(rtrim(PharmacyZipCode)), '')


	----------------------------------------------------------------------------------------------------
	-- insert new physicians...
	UPDATE a
	SET a.DoctorID = b.tblDoctorsID
	FROM [dbo].[MarketingClaims_ClaimPhysicians_Stage] a,
		[Enbrel_Production].[dbo].[tblDoctors] b with (nolock)
	WHERE a.FirstName = isnull(ltrim(rtrim(b.FirstName)), '')
		and a.LastName = isnull(ltrim(rtrim(b.LastName)), '')
		and a.Address1 = isnull(ltrim(rtrim(b.Address1)), '')
		and a.Address2 = isnull(ltrim(rtrim(b.Address2)), '')
		and a.City = isnull(ltrim(rtrim(b.City)), '')
		and a.State = isnull(ltrim(rtrim(b.State)), '')
		and a.Zip = isnull(ltrim(rtrim(b.Zip)), '')

    INSERT INTO [Enbrel_Production].[dbo].[tblDoctors]
    (   
        FirstName,
		LastName,
		Address1,
		Address2,
		City,
		State,
		Zip,
		Logist,
		LogistTxt,
		CreatedBy
    )
    SELECT 
		FirstName,
		LastName,
		Address1,
		Address2,
		City,
		State,
		Zip,
		null,
		null,
		'OpusdataImport'             --Hao, 11/5/2017 'TeradataImport'
	FROM [dbo].[MarketingClaims_ClaimPhysicians_Stage]
	WHERE DoctorID is null
		and FirstName <> '' and FirstName is not null
		and LastName <> '' and LastName is not null
	GROUP BY FirstName,
		LastName,
		Address1,
		Address2,
		City,
		State,
		Zip

	print @@rowcount
	print 'This number of rows would be inserted into [Enbrel_Production].[dbo].[tblDoctors]'

	-- get newly inserted doctor IDs...
	UPDATE a
	SET a.DoctorID = b.tblDoctorsID
	FROM [dbo].[MarketingClaims_ClaimPhysicians_Stage] a,
		[Enbrel_Production].[dbo].[tblDoctors] b with (nolock)
	WHERE a.FirstName = b.FirstName
		and a.LastName = b.LastName
		and a.Address1 = b.Address1
		and a.Address2 = b.Address2
		and a.City = b.City
		and a.State = b.State
		and a.Zip = b.Zip
		and DoctorID is null
            
	-- add doctor ID to claims...
	UPDATE a 
	SET a.DoctorID = b.DoctorID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] as a,
		[dbo].[MarketingClaims_ClaimPhysicians_Stage] b 
	WHERE a.PhysicianFirstname = b.FirstName 
		and rtrim(ltrim(substring(a.PhysicianFullNameOrLastname, CHARINDEX(a.physicianFirstName, a.PhysicianFullNameOrLastname) + len(a.physicianFirstName), len(a.PhysicianFullNameOrLastname)))) = b.LastName
		and isnull(a.PhysicianAddress1, '') = b.Address1
		and isnull(a.PhysicianAddress2, '') = b.Address2
		and isnull(a.PhysicianCity, '') =  b.City
		and isnull(a.PhysicianState, '') =  b.State
		and isnull(a.PhysicianZipCode, '') =  b.Zip
					

	-- insert new pharmacies...
	UPDATE a
	SET a.PharmacyID = b.tblPharmaciesID
	FROM [dbo].[MarketingClaims_ClaimPharmacies_Stage] a,
		[Enbrel_Production].[dbo].[tblPharmacies] b with (nolock)
	WHERE a.PharmacyName = b.Name
		and a.Address1 = b.Address
		and a.Address2 = b.Address2
		and a.City = b.City
		and a.State = b.State
		and a.Zip = b.Zip

    INSERT INTO [Enbrel_Production].[dbo].[tblPharmacies]
    (   
        Name,
		Address,
		Address2,
		City,
		State,
		Zip,
		ManuallyAdded,
		NPINumber,
		CreatedBy
    )
    SELECT 
		PharmacyName,
		Address1,
		Address2,
		City, 
		State,
		Zip,
		null,
		NPINumber,
		'OpusdataImport'             --Hao, 11/5/2017 'TeradataImport'
	FROM [dbo].[MarketingClaims_ClaimPharmacies_Stage]
	WHERE PharmacyID is null
		and PharmacyName <> '' and PharmacyName is not null
	GROUP BY PharmacyName,
		Address1,
		Address2,
		City, 
		State,
		Zip,
		NPINumber

	print @@rowcount
	print 'This number of rows would be inserted into [Enbrel_Production].[dbo].[tblPharmacies]'

	-- get newly inserted Pharmacy IDs...
	UPDATE a
	SET a.PharmacyID = b.tblPharmaciesID
	FROM [dbo].[MarketingClaims_ClaimPharmacies_Stage] a,
		[Enbrel_Production].[dbo].[tblPharmacies] b with (nolock)
	WHERE a.PharmacyName = b.Name
		and a.Address1 = b.Address
		and a.Address2 = b.Address2
		and a.City = b.City
		and a.State = b.State
		and a.Zip = b.Zip
		and PharmacyID is null
            
	-- add pharmacy ID to claims...
	UPDATE a 
	SET a.PharmacyID = b.PharmacyID
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage] a,
		[dbo].[MarketingClaims_ClaimPharmacies_Stage] b 
	WHERE a.PharmacyName = b.PharmacyName 
		and ISNULL(a.PharmacyAddress1, '') = b.Address1
		and ISNULL(a.PharmacyAddress2, '') = b.Address2
		and ISNULL(a.PharmacyCity, '') =  b.City
		and ISNULL(a.PharmacyState, '') =  b.State
		and ISNULL(a.PharmacyZipCode, '') =  b.Zip


	ALTER INDEX [idx_TeradataVendorCode_CardID_TeradataClaimReferenceNumber] ON [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage] DISABLE

	TRUNCATE TABLE [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage]
	-----------------------------------------------------------------------
	-- insert the last status tblClaims ...
	INSERT INTO [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage]
	( 	
		PatientID,
		DoctorID,
		PharmacyID,
		QuantityDispensed,
		RefillNumber,
		DatePrescriptionFilled,
		LastModified,
		FinalCost,  
		CopayAmount,
		DateCreated,
		Status,
		PaidAmount,
		NDC,
		PatientProgramType,
		PaymentType,
		ApprovedAmount,
		CardID,
		CreatedAt,
		ClaimSource,
		VerifiedClaimAmount,
		CreateBy,
		RxNumber,
		CopayApplied,
		TeradataVendorCode,
		TeradataSourceCode,
		TeradataProgramCode,
		TeradataOtherCoverageCode,
		TeradataCarrierGroupNumber,
		TeradataCarrierBIN,
		TeradataCarrierPCN,
		TeradataNumberOfRefillsAuthorized,
		TeradataDrugName,
		TeradataDrugDosage,
		TeradataDrugStrength,
		TeradataPaidQuantity,
		TeradataDispensingFeePaid,
		TeradataIncentiveFeePaid,
		TeradataPriorAuthorizationCode,
		TeradataClaimReferenceNumber,
		TeradataPharmacyNCPDPNumber,
		TeradataPrescriberNPI,
		TeradataPrescriberDEA,
		TeradataPrescriberMENumber,
		TeradataRejectionCode,
		TeradataRejectionDescription,
		TeradataDaysSupply
	)
	SELECT
		PatientID,
		DoctorID,
		PharmacyID,
		null,
		NewRefillCode,
		DateOfFill,
		DateClaimsReceivedOrProcessed,
		OutOfPocketCostOOPBeforeCoPaySupport, 
		OutOfPocketCostOOPAfterCoPaySupport,
		DateClaimsReceivedOrProcessed, 
		'Rejected',
		CopaysupportBenefitAmount,NDC,
		PatientProgramType,
		null,
		CopaysupportBenefitAmount,
		CardIDNumber,
		'OpusdataImport',             --Hao, 11/5/2017 'TeradataImport'
		null, 
		OutOfPocketCostOOPBeforeCoPaySupport,
		1,
		RxNumber,
		'Y',
		VendorCode,
		SourceCode,
		ProgramCode,
		OtherCoverageCode,
		CarrierGroupNumber,
		CarrierBINNumber,
		CarrierPCNNumber,
		NumberOfRefillsAuthorized,
		DrugName,
		DrugDosageForm,
		DrugStrength,
		PaidQuantity,
		DispensingFeePaid,
		IncentiveFeePaid,
		PriorAuthorizationCode,
		ClaimReferenceNumber,
		PharmacyNCPDPNumber,
		PrescriberIDNPI,
		PrescriberIDDEA,
		MedicalEducationNumber,
		RejectedCode,
		RejectedDescription, 
		DaysSupply
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE RankID = 1
		and PatientID is not null 
		and ISNUMERIC(PatientID) = 1

	ALTER INDEX [idx_TeradataVendorCode_CardID_TeradataClaimReferenceNumber] ON [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage] REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90)
			
	--insert into TempRetailRejectedClaimsHistory
	TRUNCATE TABLE [EnbrelImportExport_Production].[dbo].[OutputRetailRejectedClaimsHistory]
	----------------------------------------------------------------------
	-- insert the last status tblClaims ...
	INSERT INTO [EnbrelImportExport_Production].[dbo].[OutputRetailRejectedClaimsHistory] 
	( 	
		PatientID,
		DoctorID,
		PharmacyID,
		QuantityDispensed,
		RefillNumber,
		DatePrescriptionFilled,LastModified,
		FinalCost,  
		CopayAmount,
		DateCreated,
		Status,
		PaidAmount,
		NDC,
		PatientProgramType,
		PaymentType,
		ApprovedAmount,
		CardID,
		CreatedAt,
		ClaimSource,
		VerifiedClaimAmount,
		CreateBy,
		RxNumber,
		CopayApplied,
		TeradataVendorCode,
		TeradataSourceCode,
		TeradataProgramCode,
		TeradataOtherCoverageCode,
		TeradataCarrierGroupNumber,
		TeradataCarrierBIN,
		TeradataCarrierPCN,
		TeradataNumberOfRefillsAuthorized,
		TeradataDrugName,
		TeradataDrugDosage,
		TeradataDrugStrength,
		TeradataPaidQuantity,
		TeradataDispensingFeePaid,
		TeradataIncentiveFeePaid,
		TeradataPriorAuthorizationCode,
		TeradataClaimReferenceNumber,
		TeradataPharmacyNCPDPNumber,
		TeradataPrescriberNPI,
		TeradataPrescriberDEA,
		TeradataPrescriberMENumber,
		TeradataRejectionCode,
		TeradataRejectionDescription,
		TeradataDaysSupply
	)
	SELECT
		PatientID,
		DoctorID,
		PharmacyID,
		null,
		NewRefillCode,
		DateOfFill,
		DateClaimsReceivedOrProcessed,
		OutOfPocketCostOOPBeforeCoPaySupport, 
		OutOfPocketCostOOPAfterCoPaySupport,
		DateClaimsReceivedOrProcessed, 
		'Rejected',
		CopaysupportBenefitAmount,NDC,
		PatientProgramType,
		null,
		CopaysupportBenefitAmount,
		CardIDNumber,
		'OpusdataImport',             --Hao, 11/5/2017 'TeradataImport'
		null, 
		OutOfPocketCostOOPBeforeCoPaySupport, 
		1,
		RxNumber,
		'Y',
		VendorCode,
		SourceCode,
		ProgramCode,
		OtherCoverageCode,
		CarrierGroupNumber,
		CarrierBINNumber,
		CarrierPCNNumber,
		NumberOfRefillsAuthorized,
		DrugName,
		DrugDosageForm,
		DrugStrength,
		PaidQuantity,
		DispensingFeePaid,
		IncentiveFeePaid,
		PriorAuthorizationCode,
		ClaimReferenceNumber,
		PharmacyNCPDPNumber,
		PrescriberIDNPI,
		PrescriberIDDEA,
		MedicalEducationNumber,
		RejectedCode,
		RejectedDescription, 
		DaysSupply
	FROM [dbo].[MarketingClaims_OpusRejectedClaims_Stage]
	WHERE PatientID is not null 
		and ISNUMERIC(PatientID) = 1

	EXEC [dbo].[sp_sys_MarketingClaims_ProcessLog] 'sp_MarketingClaims_RebuildOpusClaims_RejectedClaims end.'                                                        

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
