SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment](
	[PatientID] [varchar](50) NULL,
	[TeraPatientID] [varchar](50) NULL,
	[VendorCode] [varchar](20) NULL,
	[SourceCode] [varchar](7) NOT NULL,
	[ProgramCode] [varchar](20) NULL,
	[OfferCode] [varchar](20) NULL,
	[GroupNumber] [varchar](50) NULL,
	[ProgramType] [varchar](50) NULL,
	[CardIDNumber] [varchar](50) NULL,
	[CardStatus] [varchar](50) NULL,
	[EnrollmentDate] [varchar](20) NULL,
	[ReEnrollmentDate] [varchar](20) NULL,
	[OfferActivity] [varchar](20) NULL
) ON [PRIMARY]
GO


