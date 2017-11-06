SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_MarketingTeradataClaims_Stage](
	[VendorCode] [varchar](50) NULL,
	[ClaimNumber] [varchar](50) NULL,
	[ClaimTransactionNumber] [varchar](50) NULL,
	[ClaimType] [varchar](50) NULL,
	[PatientID] [varchar](50) NULL,
	[TeradataID] [varchar](50) NULL,
	[OfferCode] [varchar](50) NULL,
	[RxNumber] [varchar](50) NULL,
	[DateWritten] [varchar](8) NULL,
	[DateOfFill] [varchar](8000) NULL,
	[DateProcessed] [varchar](8000) NULL,
	[DaysOfSupply] [int] NULL,
	[NDC] [varchar](50) NULL,
	[DrugName] [varchar](50) NULL,
	[DrugDesc] [varchar](50) NULL,
	[DrugForm] [varchar](50) NULL,
	[DrugDosage] [varchar](50) NULL,
	[DrugStrength] [varchar](50) NULL,
	[NewRefillCode] [varchar](50) NULL,
	[Refills] [varchar](50) NULL,
	[Quantity] [varchar](50) NULL,
	[SubmissionMethod] [varchar](10) NULL,
	[PriorAuthorizationCode] [varchar](50) NULL,
	[OtherCoverageCode] [varchar](50) NULL,
	[GroupNumber] [varchar](50) NULL,
	[CardID] [varchar](50) NULL,
	[PharmacyNPI] [varchar](10) NULL,
	[PharmacyNCPDP] [varchar](50) NULL,
	[PharmacyChainNumber] [varchar](50) NULL,
	[PharmacyChain] [varchar](50) NULL,
	[PharmacyName] [varchar](150) NULL,
	[PharmacyAddress1] [varchar](500) NULL,
	[PharmacyAddress2] [varchar](500) NULL,
	[PharmacyCity] [varchar](50) NULL,
	[PharmacyState] [varchar](50) NULL,
	[PharmacyZip] [varchar](50) NULL,
	[PharmacyPhone] [varchar](50) NULL,
	[PhysicianNPI] [varchar](50) NULL,
	[PhysicianDEA] [varchar](50) NULL,
	[PhysicianFirstName] [varchar](100) NULL,
	[PhysicianLastName] [varchar](100) NULL,
	[PhysicianSpecialty] [varchar](50) NULL,
	[PhysicianAddress1] [varchar](500) NULL,
	[PhysicianAddress2] [varchar](500) NULL,
	[PhysicianCity] [varchar](50) NULL,
	[PhysicianState] [varchar](50) NULL,
	[PhysicianZip] [varchar](50) NULL,
	[PatientBenefit] [varchar](50) NULL,
	[PatientOOP] [varchar](50) NULL,
	[Copay] [varchar](50) NULL,
	[DispensingFee] [varchar](50) NULL,
	[CalculatedAWP] [decimal](10, 2) NULL,
	[Payer] [varchar](50) NULL,
	[RejectionCode] [varchar](100) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

