SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblZipAlignment](
	[DataWeek] [varchar](8) NULL,
	[BU] [varchar](50) NULL,
	[FFCode] [varchar](10) NULL,
	[FFName] [varchar](50) NULL,
	[ZipCode] [varchar](5) NULL,
	[RepName] [varchar](100) NULL,
	[TerrCode1] [varchar](10) NULL,
	[TerrName1] [varchar](50) NULL,
	[TerrCode2] [varchar](10) NULL,
	[TerrName2] [varchar](50) NULL,
	[TerrCode3] [varchar](10) NULL,
	[TerrName3] [varchar](50) NULL,
	[TerrCode4] [varchar](10) NULL,
	[TerrName4] [varchar](50) NULL,
	[ImportDate] [datetime] NULL
) ON [PRIMARY]
GO


