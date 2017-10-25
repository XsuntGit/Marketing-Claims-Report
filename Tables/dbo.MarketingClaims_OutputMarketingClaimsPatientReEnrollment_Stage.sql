SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientReEnrollment_Stage](
	[AmgenPatientID] [varchar](50) NULL,
	[VendorCode] [varchar](20) NULL,
	[SourceCode] [varchar](50) NULL,
	[ProgramCode] [varchar](20) NULL,
	[GroupNumber] [varchar](50) NULL,
	[CardIDNumber] [varchar](50) NULL,
	[CopayReenrollmentDate] [varchar](20) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

