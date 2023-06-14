USE [PGMEATS_WEB_UAT_20230614]
GO
/****** Object:  StoredProcedure [dbo].[sp_News_List]    Script Date: 06/14/2023 08:00:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Fikri
-- Create date	: 
-- Description	: Get for List News (Web)
-- =============================================
CREATE PROCEDURE [dbo].[sp_News_List]
	@NewsID	As Int = 0, --0 untuk List di Datatable || selain itu untuk Fill Detail (For Mobile & Web)
	@User	As Varchar(Max) = ''
AS
BEGIN
	Declare @Target		as varchar(max) = ISNULL((Select Top 1 Department		from M_UserSetup  where UserID		= @User), '' )
	Declare @Admin		as varchar(max) = ISNULL((Select Top 1 AdminStatus		from M_UserSetup  where UserID		= @User), '0')
	Declare @UserType	as varchar(max) = ISNULL((Select Top 1 UserType			from M_UserSetup  where UserID		= @User), '0')
	Declare	@GroupDept	as varchar(max) = ISNULL((Select Top 1 GroupDepartment	from M_CostCenter where Department	= @User), '')

	select 
		NewsID		= A.NewsID,
		NewsTitle	= A.NewsTitle,
		NewsDescCode= A.NewsDescriptionCode,
		NewsDescText= A.NewsDescriptionText,
		Attachment	= ISNULL(A.FileName,''),
		DateFrom	= FORMAT(A.StartDate,'dd MMM yyy'),
		DateTo		= FORMAT(A.EndDate,	 'dd MMM yyy'),
		TargetPart	= A.TargetParticipant
	From
		M_News A
	Where
		A.NewsID = 
			Case
				When @NewsID = 0 Then A.NewsID
				Else @NewsID
			End 
	and	1 =
			Case
				When @NewsID =  0 And (@Admin = '1' or  @UserType = '1') Then 1 --Jika Super User (Admin) || Jika User Type nya 1 tapi bukan Super User
				When @NewsID =  0 And  @Admin = '0' And @UserType = '0' And A.TargetParticipant in (@GroupDept, 'ALL') Then 1
				When @NewsID <> 0 Then 1
				Else 0
			End 
	Order by
		UpdateDate Desc
END
GO
