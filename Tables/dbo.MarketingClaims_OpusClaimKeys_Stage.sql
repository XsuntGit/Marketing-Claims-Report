SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OpusClaimKeys_Stage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorCode] [varchar](50) NULL,
	[CardID] [varchar](50) NULL,
	[ClaimReferenceNumber] [varchar](50) NULL,
	[ClaimIDX] [varchar](50) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [idx_ClaimIDX_VendorCode_CardID_ClaimReferenceNumber]    Script Date: 10/16/2017 12:14:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_ClaimIDX_VendorCode_CardID_ClaimReferenceNumber] ON [dbo].[MarketingClaims_OpusClaimKeys_Stage]
(
	[ClaimIDX] ASC,
	[VendorCode] ASC,
	[CardID] ASC,
	[ClaimReferenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

