SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MarketingClaims_OutputMarketingClaimsPatientProfile_Stage](
	[AmgenPatientID] [int] NOT NULL,
	[FirstName] [varchar](256) NULL,
	[LastName] [varchar](256) NULL,
	[DOB] [varchar](256) NULL,
	[Gender] [varchar](50) NULL,
	[PrimaryPhone] [varchar](256) NULL,
	[PrimaryPhoneType] [varchar](30) NULL,
	[SecondaryPhone] [varchar](256) NULL,
	[SecondaryPhoneType] [varchar](30) NULL,
	[Email] [varchar](256) NULL,
	[PreferredContactMethod] [varchar](30) NULL,
	[Address1] [varchar](256) NULL,
	[Address2] [varchar](256) NULL,
	[City] [varchar](256) NULL,
	[State] [varchar](256) NULL,
	[Zip] [varchar](256) NULL,
	[Treatment] [varchar](20) NULL,
	[TreatmentStatus] [varchar](20) NULL,
	[DateEnrolled] [varchar](8000) NULL,
	[Territory_Code_1] [varchar](50) NULL,
	[Territory_Name_1] [varchar](50) NULL,
	[Territory_Code_2] [varchar](50) NULL,
	[Territory_Name_2] [varchar](50) NULL,
	[Territory_Code_3] [varchar](50) NULL,
	[Territory_Name_3] [varchar](50) NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

