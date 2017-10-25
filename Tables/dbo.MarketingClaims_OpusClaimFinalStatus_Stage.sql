SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OpusClaimFinalStatus_Stage](
	[ClaimKey] [varchar](200) NULL,
	[DateClaimsReceivedOrProcessed] [varchar](50) NULL,
	[finalclaimtype] [char](1) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

