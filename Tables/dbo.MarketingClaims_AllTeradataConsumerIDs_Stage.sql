SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_AllTeradataConsumerIDs_Stage](
	[TeradataConsumerID] [varchar](50) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

