
/****** Object:  StoredProcedure [dbo].[sp_Surveyandpoolschart_get]    Script Date: 4/8/2023 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: Pebri
-- Create date	: 2023-04-06
-- Description	: 
-- =============================================
ALTER PROCEDURE [dbo].[sp_Surveyandpoolschart_get] 
--DECLARE
	 @SurveyID		integer = 2
	,@questionID	integer = 4
AS
BEGIN
	SELECT DISTINCT
		  A.SurveyID
		 ,A.QuestionID
		 ,A.QuestionDesc
		 ,B.AnswerSeqNo
		 ,C.AnswerDesc
		 ,B.Sub_total
		 ,B.Total
	FROM 
		M_SurveyPolls_Detail A
	INNER 
		JOIN 
			(
				SELECT 
					 A.SurveyID
					,A.QuestionID
					,A.AnswerSeqNo
					,COUNT(A.AnswerSeqNo) Sub_total
					,B.Total
				FROM 
					M_SurveyPolls_Answer_Staff A 
				INNER 
					JOIN
						(
							SELECT TOP 100 percent SurveyID, QuestionID, COUNT(AnswerSeqNo) Total FROM M_SurveyPolls_Answer_Staff GROUP BY SurveyID, QuestionID
						) B ON B.SurveyID = A.SurveyID and B.QuestionID = A.QuestionID
				GROUP BY A.SurveyID, A.QuestionID, A.AnswerSeqNo, B.Total
			) B ON B.SurveyID = A.SurveyID AND B.QuestionID = A.QuestionID
	INNER 
		JOIN
			M_SurveyPolls_Answer C ON C.SurveyID = A.SurveyID and C.QuestionID = A.QuestionID and C.AnswerSeqNo = B.AnswerSeqNo
	where 
		A.SurveyID = @SurveyID
	AND A.QuestionID = @questionID
	AND A.AnswerType = 0
	
END
