SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage](
	[tblClaimID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[DoctorID] [int] NULL,
	[PharmacyID] [int] NULL,
	[Prescription] [varchar](50) NULL,
	[Lasts] [int] NULL,
	[RefillNumber] [int] NULL,
	[DatePrescriptionFilled] [datetime] NULL,
	[FinalCost] [decimal](10, 2) NULL,
	[QuantityDispensed] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[CheckNumber] [varchar](30) NULL,
	[PaidDate] [varchar](10) NULL,
	[CheckClearedDate] [datetime] NULL,
	[PaidAmount] [decimal](10, 2) NULL,
	[NESSCEImportDate] [datetime] NULL,
	[NDC] [varchar](20) NULL,
	[Method] [varchar](50) NULL,
	[OpenedBy] [varchar](50) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PatientProgramType] [int] NULL,
	[RejectedReason] [varchar](100) NULL,
	[OpenedTime] [datetime] NULL,
	[PaymentType] [varchar](50) NULL,
	[ApprovedAmount] [decimal](10, 2) NULL,
	[NPINumber] [varchar](50) NULL,
	[CardID] [varchar](50) NULL,
	[TraceNumber] [varchar](50) NULL,
	[ManualCheck] [varchar](1) NULL,
	[CreatedAt] [varchar](50) NULL,
	[ClaimSource] [varchar](100) NULL,
	[ReversalReason] [int] NULL,
	[PatientReversalCheckNumber] [varchar](100) NULL,
	[CopayApplied] [varchar](1) NULL,
	[DateCopayApplied] [datetime] NULL,
	[TrueUpClaimID] [varchar](500) NULL,
	[VerifiedClaimAmount] [decimal](18, 2) NULL,
	[AdminCopayOverride] [varchar](1) NULL,
	[CopayAmount] [decimal](18, 2) NULL,
	[ClaimIDCopayApplied] [int] NULL,
	[ReimburseNote] [varchar](max) NULL,
	[CreateBy] [varchar](50) NULL,
	[RxNumber] [varchar](50) NULL,
	[NESSCEImportTime] [datetime] NULL,
	[TeradataVendorCode] [varchar](50) NULL,
	[TeradataSourceCode] [varchar](50) NULL,
	[TeradataProgramCode] [varchar](50) NULL,
	[TeradataOtherCoverageCode] [varchar](50) NULL,
	[TeradataCarrierGroupNumber] [varchar](50) NULL,
	[TeradataCarrierBIN] [varchar](50) NULL,
	[TeradataCarrierPCN] [varchar](50) NULL,
	[TeradataNumberOfRefillsAuthorized] [varchar](50) NULL,
	[TeradataDrugName] [varchar](50) NULL,
	[TeradataDrugDosage] [varchar](50) NULL,
	[TeradataDrugStrength] [varchar](50) NULL,
	[TeradataPaidQuantity] [varchar](50) NULL,
	[TeradataDispensingFeePaid] [varchar](50) NULL,
	[TeradataIncentiveFeePaid] [varchar](50) NULL,
	[TeradataPriorAuthorizationCode] [varchar](50) NULL,
	[TeradataClaimReferenceNumber] [varchar](50) NULL,
	[TeradataPharmacyNCPDPNumber] [varchar](50) NULL,
	[TeradataPrescriberNPI] [varchar](50) NULL,
	[TeradataPrescriberDEA] [varchar](50) NULL,
	[TeradataPrescriberMENumber] [varchar](50) NULL,
	[TeradataRejectionCode] [varchar](50) NULL,
	[TeradataRejectionDescription] [varchar](100) NULL,
	[TeradataDaysSupply] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [idx_TeradataVendorCode_CardID_TeradataClaimReferenceNumber]    Script Date: 10/16/2017 12:18:45 AM ******/
CREATE NONCLUSTERED INDEX [idx_TeradataVendorCode_CardID_TeradataClaimReferenceNumber] ON [dbo].[MarketingClaims_OutputRetailRejectedClaims_Stage]
(
	[TeradataVendorCode] ASC,
	[CardID] ASC,
	[TeradataClaimReferenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

