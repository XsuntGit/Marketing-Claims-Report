SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_ClaimPharmacies_Stage](
	[PharmacyID] [int] NULL,
	[PharmacyName] [varchar](150) NULL,
	[Address1] [varchar](500) NOT NULL,
	[Address2] [varchar](500) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[Zip] [varchar](50) NOT NULL,
	[NPINumber] [varchar](100) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
