SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientIDs_Stage](
	[AmgenPatientID] [int] NOT NULL,
	[McKessonID] [varchar](50) NULL,
	[AshfieldID] [varchar](50) NULL,
	[OpusID] [varchar](50) NULL,
	[TeradataID] [varchar](50) NULL
) ON [PRIMARY]
GO

