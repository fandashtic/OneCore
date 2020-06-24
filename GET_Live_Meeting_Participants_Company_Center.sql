-- =================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting participant's details by company and center
-- Return parent / user details list
-- =================================================================================================
--Exec GET_Live_Meeting_Participants_Company_Center 1046, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Participants_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Participants_Company_Center
END
GO
Create PROC GET_Live_Meeting_Participants_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = 0
)
AS
BEGIN
	SELECT	DISTINCT
		S.sponsor_id [Parent_Id], 
		U.FirstName [Parent_FirstName],
		U.LastName [Parent_LastName],

		F.Family_Id,
		F.FIRST_NAME [Family_FirstName],
		F.LAST_NAME [Family_LastName],	
		
		F.Family_Account_No,	
		F.Family_Status,
		F.parent2_first_name,	
		F.parent2_last_name,
		'' Parent1Name,	
		'' Parent2Name,	
		F.PARENT1_CELL_PHONE,	
		F.HOME_PHONE,	
		F.PARENT2_CELL_PHONE,	
		F.HOME_PHONE2,	
		F.ledger_type,
		PRIMARY_EMAIL, 
		SECONDARY_EMAIL,

		C.Child_Id [Child_Id],		
		C.FIRST_NAME [Child_FirstName],
		C.LAST_NAME [Child_LastName]
	FROM sponsor_details S WITH (NOLOCK) 
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = S.userId
	JOIN Family_Details F WITH (NOLOCK) ON F.Family_Id = S.Family_id
	JOIN child_details C WITH (NOLOCK) ON C.Family_Id = F.Family_Id
	WHERE (S.Company_id = @Company_Id) AND
	(S.center_id = @Center_id) AND
	S.PP_status = 1 AND
	S.userId > 0 AND	
	(F.Center_Id = @Center_Id) AND
	(S.Center_Id = @Center_Id) AND
	F.Family_Status = 1
	ORDER BY F.Family_Account_No ASC

END
GO