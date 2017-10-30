SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputMarketingClaims_Stage](
	[AmgenRecordID] [int] IDENTITY(1,1) NOT NULL,
	[AmgenPatientID] [int] NULL,
	[VendorCode] [varchar](20) NULL,
	[ClaimNumber] [varchar](20) NULL,
	[ClaimTransactionNumber] [varchar](20) NULL,
	[ClaimType] [varchar](8) NULL,
	[OfferCode] [varchar](50) NULL,
	[RxNumber] [varchar](50) NULL,
	[DateWritten] [varchar](58) NULL,
	[DateOfFill] [varchar](8) NULL,
	[DateProcessed] [varchar](8) NULL,
	[DaysOfSupply] [int] NULL,
	[NDC] [varchar](20) NULL,
	[DrugName] [varchar](50) NULL,
	[DrugDesc] [varchar](50) NULL,
	[DrugForm] [varchar](50) NULL,
	[DrugDosage] [varchar](50) NULL,
	[DrugStrength] [varchar](50) NULL,
	[NewRefillCode] [varchar](10) NULL,
	[Refills] [int] NULL,
	[Quantity] [int] NULL,
	[SubmissionMethod] [varchar](20) NULL,
	[PriorAuthorizationCode] [varchar](50) NULL,
	[OtherCoverageCode] [varchar](20) NULL,
	[GroupNumber] [varchar](20) NULL,
	[CardID] [varchar](20) NULL,
	[PharmacyNPI] [varchar](20) NULL,
	[PharmacyNCPDP] [varchar](20) NULL,
	[PharmacyChainNumber] [varchar](10) NULL,
	[PharmacyChain] [varchar](50) NULL,
	[PharmacyName] [varchar](150) NULL,
	[PharmacyAddress1] [varchar](100) NULL,
	[PharmacyAddress2] [varchar](100) NULL,
	[PharmacyCity] [varchar](50) NULL,
	[PharmacyState] [varchar](2) NULL,
	[PharmacyZip] [varchar](5) NULL,
	[PharmacyPhone] [varchar](20) NULL,
	[PhysicianNPI] [varchar](20) NULL,
	[PhysicianDEA] [varchar](20) NULL,
	[PhysicianFirstName] [varchar](50) NULL,
	[PhysicianLastName] [varchar](50) NULL,
	[PhysicianSpecialty] [varchar](50) NULL,
	[PhysicianAddress1] [varchar](100) NULL,
	[PhysicianAddress2] [varchar](100) NULL,
	[PhysicianCity] [varchar](50) NULL,
	[PhysicianState] [varchar](2) NULL,
	[PhysicianZip] [varchar](5) NULL,
	[PatientBenefit] [decimal](10, 2) NULL,
	[PatientOOP] [decimal](10, 2) NULL,
	[Copay] [decimal](10, 2) NULL,
	[DispensingFee] [decimal](10, 2) NULL,
	[CalculatedAWP] [decimal](10, 2) NULL,
	[Payer] [varchar](50) NULL,
	[RejectionCode] [varchar](100) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [idx_ClaimType_INCL_AmgenPatientID_DateOfFill]    Script Date: 10/16/2017 12:16:08 AM ******/
CREATE NONCLUSTERED INDEX [idx_ClaimType_INCL_AmgenPatientID_DateOfFill] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
(
	[ClaimType] ASC
)
INCLUDE ( 	[AmgenPatientID],
	[DateOfFill]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [idx_VendorCode]    Script Date: 10/16/2017 12:16:08 AM ******/
CREATE NONCLUSTERED INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage]
(
	[VendorCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

ALTER INDEX [idx_VendorCode] ON [dbo].[MarketingClaims_OutputMarketingClaims_Stage] DISABLE
GO

