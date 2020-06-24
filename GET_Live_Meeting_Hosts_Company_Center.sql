-- =================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting host's details by company and center
-- Return user details list
-- =================================================================================================
--Exec GET_Live_Meeting_Hosts_Company_Center 1046, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Hosts_Company_Center
END
GO
Create PROC GET_Live_Meeting_Hosts_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL
)
AS
BEGIN

	SELECT	DISTINCT 
		U.User_Id,
		U.FirstName,
		U.LastName		
	FROM app_role AR WITH (NOLOCK)
	JOIN company_app_role  CAR WITH (NOLOCK) ON CAR.app_role_id = AR.app_role_id
	JOIN user_role UR WITH (NOLOCK) ON UR.company_app_role_id = CAR.company_app_role_id
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = UR.user_id
	WHERE (CAR.company_id = @Company_Id OR CAR.Company_Id = 1) AND	
	AR.app_role_id IN (1,2,3,4)

END
GO