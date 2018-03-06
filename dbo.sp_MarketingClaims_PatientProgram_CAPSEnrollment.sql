SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Hao>
-- Create date: <1/9/2018>
-- Description:	<This is created based on [EnbrelImportExport_Production]..[sp_ExportToTeraData_ProgramOffer]>
-- =============================================
ALTER PROCEDURE [dbo].[sp_MarketingClaims_PatientProgram_CAPSEnrollment]
AS
BEGIN
		truncate table dbo.MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment

		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
					[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
					[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
					,[OfferActivity] )
		select distinct
				a.PatientID
				, a.TeraPatientID
				, 'PSK' as [VendorCode]
				, case when b.ExportDataType in ( 'Replace', 'Re-Enroll', 'ProgramChange', 'TreatmentChange',
												'CardStatusChange' ) then 'IBECPRP'
					 else 'IBECPYP' end as SourceCode
				, 'CPY' as [ProgramCode]
				, p.OfferCode as [OfferCode]
				, p.RxGroupID as [GroupNumber]
				, p.UpdatedCardType as [ProgramType]
				, b.CardID as [CardIDNumber]
				, b.CardStatus as [CardStatus]  --, case when b.CardStatus is null then a.CardStatus else b.CardStatus end as [CardStatus]
				, convert(varchar(10), a.DateCreated, 101) as [EnrollmentDate]
				, convert(varchar(10), b.ModifiedDate, 101) as [ReEnrollmentDate]	--, convert(varchar(10), a.EnrollmentDate, 101) as [ReEnrollmentDate]
				, case when b.ExportDataType in ( 'Enrollment', 'Opus-Convert' ) then 'Enrollment'
					 when b.ExportDataType in ( 'Replace', 'Re-Enroll', 'ProgramChange', 'TreatmentChange',
												'CardStatusChange' ) then 'Re-enrollment'
					 when b.ExportDataType = 'Terminated' then 'Terminated'
					 else b.ExportDataType end as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		join	Enbrel_production.dbo.tblExport_ProgramOffer b on a.PatientID = b.patientID 
		left join	Enbrel_production.dbo.tblProgram p on b.CurrProgramID = p.ProgramID
		where	b.exportDataType <> 'ProgramChange'
				and b.CardID is not null
				and ltrim(rtrim(b.CardID)) <> ''
				and convert(varchar(8),b.ModifiedDate,112) >= '20171030'

		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
							[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
							[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
							,[OfferActivity] )
		select	distinct a.PatientID
				, a.TeraPatientID
				, 'PSK'
				, case when b.ExportDataType in ( 'Replace', 'Re-Enroll', 'ProgramChange', 'TreatmentChange',
												'CardStatusChange' ) then 'IBECPRP'
					 else 'IBECPYP' end as SourceCode
				, 'CPY'
				, p.OfferCode
				, p.RxGroupID
				, p.UpdatedCardType as [ProgramType]
				, b.PresCardID
				, b.PresCardStatus		--, case when b.PresCardStatus is null then a.CardStatus
										--	 else b.PresCardStatus end
				, convert(varchar(10), a.DateCreated, 101)
				, convert(varchar(10), b.ModifiedDate, 101) as [ReEnrollmentDate]	--, convert(varchar(10), a.EnrollmentDate, 101)
				, case when b.ExportDataType in ( 'Enrollment', 'Opus-Convert' ) then 'Enrollment'
					 when b.ExportDataType in (  'Re-Enroll', 'TreatmentChange',
												'CardStatusChange' ) then 'Re-enrollment'
					 when b.ExportDataType in ('Replace','Terminated', 'ProgramChange') then 'Terminated'
					 else b.ExportDataType
				end as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		join	Enbrel_production.dbo.tblExport_ProgramOffer_ChangeProgram b on a.PatientID = b.patientID
		left join	Enbrel_production.dbo.tblProgram p on b.PresProgramID = p.ProgramID
		where	b.CardID is not null
				and ltrim(rtrim(b.CardID)) <> ''
				and convert(varchar(8),b.ModifiedDate,112) >= '20171030'
		

		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
					[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
					[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
					,[OfferActivity] )	
		select	a.PatientID
				, a.TeraPatientID
				, 'PSK'
				, case when b.ExportDataType in ( 'Replace', 'Re-Enroll', 'ProgramChange', 'TreatmentChange',
												'CardStatusChange' ) then 'IBECPRP'
					 else 'IBECPYP' end as SourceCode
				, 'CPY'
				, p.OfferCode
				, p.RxGroupID
				, p.UpdatedCardType as [ProgramType]
				, b.CardID
				, b.CurrCardStatus	--case when b.CurrCardStatus is null then a.CardStatus
									--else b.CurrCardStatus end
				, convert(varchar(10), a.DateCreated, 101)
				, convert(varchar(10), b.ModifiedDate, 101) as [ReEnrollmentDate] --, convert(varchar(10), a.EnrollmentDate, 101)
				, case when b.ExportDataType in ( 'Enrollment', 'Opus-Convert' ) then 'Enrollment'
					 when b.ExportDataType in ( 'Replace', 'Re-Enroll', 'ProgramChange', 'TreatmentChange',
												'CardStatusChange' ) then 'Re-enrollment'
					 when b.ExportDataType = 'Terminated' then 'Terminated'
					 else b.ExportDataType
				end as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		join	Enbrel_production.dbo.tblExport_ProgramOffer_ChangeProgram b on a.PatientID = b.patientID
		left join	Enbrel_production.dbo.tblProgram p on b.CurrProgramID = p.ProgramID
		where	b.CardID is not null
				and ltrim(rtrim(b.CardID)) <> ''	
				and convert(varchar(8),b.ModifiedDate,112) >= '20171030'
		
		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
					[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
					[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
					,[OfferActivity] )	
		select	a.PatientID
				, a.TeraPatientID
				, 'PSK'
				, 'IBECPRP' as SourceCode
				, 'CPY'
				, p.OfferCode
				, p.RxGroupID
				, p.UpdatedCardType as [ProgramType]
				, a.CardID
				, a.CardStatus
				, convert(varchar(10), a.DateCreated, 101)
				, convert(varchar(10), pp.Lastmodified, 101) as [ReEnrollmentDate] 
				, 'Re-enrollment' as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		left join Enbrel_production.dbo.tblPatientProgram pp on a.PatientID = pp.PatientID and isActive = 'Y'
		left join Enbrel_production.dbo.tblprogram p on pp.ProgramID = p.programID
		where	a.CardID is not null
				and ltrim(rtrim(a.CardID)) <> ''
				and a.ActiveFlag = 1
				and convert(varchar(8),pp.Lastmodified,112) >= '20171030'	--comment out on 2/26/2018
				--and a.CardStatus = 'Active'

		
		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
					[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
					[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
					,[OfferActivity] )	
		select	a.PatientID
				, a.TeraPatientID
				, 'PSK'
				, 'IBECPRP' as SourceCode
				, 'CPY'
				, p.OfferCode
				, p.RxGroupID
				, p.UpdatedCardType as [ProgramType]
				, b.CardID
				, Null as [CardStatus]
				, convert(varchar(10), a.DateCreated, 101) as [EnrollmentDate]
				, convert(varchar(10), b.Date, 101) as [ReEnrollmentDate]
				, 'Re-enrollment' as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		join	Enbrel_production.dbo.tblAccountHistory b on a.PatientID = b.patientID
		left join Enbrel_Production..tblpatientprogram c 
			  on a.PatientID = c.PatientID and c.ProgramID <> 11 
              and datediff(SECOND, b.Date, c.LastModified) between -10 and 10
		left join Enbrel_production.dbo.tblProgram p on c.ProgramID = p.ProgramID
		where	b.CardID is not null
				and ltrim(rtrim(b.CardID)) <> ''	
				and b.Channel = 'Caps Portal'
				and b.ActivityType like 'Patient Program Changed%'


		--Enrollment
		insert	into MarketingClaims_OutputMarketingClaimsPatientEnrollment_CAPSEnrollment ( PatientID, TeraPatientID, [VendorCode], [Sourcecode],
					[ProgramCode], [OfferCode], [GroupNumber],[ProgramType],
					[CardIDNumber], [CardStatus],[EnrollmentDate], [ReEnrollmentDate]
					,[OfferActivity] )	
		select	a.PatientID
				, a.TeraPatientID
				, 'PSK'
				, 'IBECPYP' as SourceCode
				, 'CPY'
				, p.OfferCode
				, p.RxGroupID
				, p.UpdatedCardType as [ProgramType]
				, b.CardID
				, Null as [CardStatus]
				, convert(varchar(10), b.Date, 101) as [EnrollmentDate]
				, NULL as [ReEnrollmentDate]
				, 'Enrollment' as OfferActivity
		from	Enbrel_production.dbo.tblPatientInfo a
		join	Enbrel_production.dbo.tblAccountHistory b on a.PatientID = b.patientID
		left join Enbrel_Production..tblpatientprogram c 
			  on a.PatientID = c.PatientID and c.ProgramID <> 11 
              and datediff(SECOND, b.Date, c.LastModified) between -10 and 10
		left join Enbrel_production.dbo.tblProgram p on c.ProgramID = p.ProgramID
		where	b.CardID is not null
				and ltrim(rtrim(b.CardID)) <> ''	
				and b.Channel = 'Caps Portal'
				and b.ActivityType = 'Patient Enrolled'
		

END
GO


