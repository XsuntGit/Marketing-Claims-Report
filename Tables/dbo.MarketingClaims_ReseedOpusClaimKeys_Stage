SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_ReseedOpusClaimKeys_Stage](
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

/****** Object:  Index [idx_ID]    Script Date: 10/16/2017 12:19:07 AM ******/
CREATE NONCLUSTERED INDEX [idx_ID] ON [dbo].[MarketingClaims_ReseedOpusClaimKeys_Stage]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

