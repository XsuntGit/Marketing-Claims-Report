SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OpusApprovedClaims_Stage](
	[ClaimKey] [varchar](200) NULL,
	[PatientID] [int] NULL,
	[DoctorID] [varchar](10) NULL,
	[PharmacyID] [varchar](10) NULL,
	[PatientProgramType] [int] NULL,
	[AmgenClaimID] [bigint] NULL,
	[FinalStatus] [varchar](20) NULL,
	[ExternalConsumerID] [varchar](50) NULL,
	[TeradataConsumerID] [varchar](50) NULL,
	[VendorCode] [varchar](50) NULL,
	[Sourcecode] [varchar](50) NULL,
	[ProgramCode] [varchar](50) NULL,
	[OfferCode] [varchar](50) NULL,
	[ClaimType] [varchar](50) NULL,
	[RxNumber] [varchar](50) NULL,
	[DateOfFill] [varchar](50) NULL,
	[DateClaimsReceivedOrProcessed] [varchar](50) NULL,
	[CarrierGroupNumber] [varchar](50) NULL,
	[CarrierBINNumber] [varchar](50) NULL,
	[CarrierPCNNumber] [varchar](50) NULL,
	[CardIDNumber] [varchar](50) NULL,
	[OtherCoverageCode] [varchar](50) NULL,
	[NewRefillCode] [varchar](50) NULL,
	[NumberofRefillsAuthorized] [varchar](50) NULL,
	[NDC] [varchar](50) NULL,
	[DrugName] [varchar](50) NULL,
	[DrugDosageForm] [varchar](50) NULL,
	[DrugStrength] [varchar](50) NULL,
	[PaidQuantity] [varchar](50) NULL,
	[DaysSupply] [int] NULL,
	[DispensingFeePaid] [varchar](50) NULL,
	[OutOfPocketCostOOPBeforeCoPaySupport] [varchar](50) NULL,
	[CopaysupportBenefitAmount] [varchar](50) NULL,
	[OutOfPocketCostOOPAfterCoPaySupport] [varchar](50) NULL,
	[IncentiveFeePaid] [varchar](50) NULL,
	[PriorAuthorizationCode] [varchar](50) NULL,
	[ClaimReferenceNumber] [varchar](50) NULL,
	[PharmacyNCPDPNumber] [varchar](50) NULL,
	[PharmacyName] [varchar](50) NULL,
	[PharmacyAddress1] [varchar](500) NULL,
	[PharmacyAddress2] [varchar](500) NULL,
	[PharmacyCity] [varchar](50) NULL,
	[PharmacyState] [varchar](50) NULL,
	[PharmacyZipCode] [varchar](50) NULL,
	[PrescriberIDNPI] [varchar](50) NULL,
	[PrescriberIDDEA] [varchar](50) NULL,
	[MedicalEducationNumber] [varchar](50) NULL,
	[PhysicianFullNameOrLastname] [varchar](100) NULL,
	[PhysicianFirstname] [varchar](100) NULL,
	[PhysicianMiddlename] [varchar](100) NULL,
	[PhysicianAddress1] [varchar](500) NULL,
	[PhysicianAddress2] [varchar](500) NULL,
	[PhysicianCity] [varchar](50) NULL,
	[PhysicianState] [varchar](50) NULL,
	[PhysicianZipCode] [varchar](50) NULL,
	[Specialty] [varchar](200) NULL,
	[ImportFileName] [varchar](200) NULL,
	[ImportDate] [varchar](30) NULL,
	[RankID] [bigint] NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

