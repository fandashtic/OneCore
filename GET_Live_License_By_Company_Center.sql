-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live license by company, center and status
-- Return live license details list
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_License_By_Company_Center')
BEGIN
    DROP PROC GET_Live_License_By_Company_Center
END
GO
Create PROC GET_Live_License_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@LicenseStatus BIT = 1
)
AS
BEGIN

	SELECT	DISTINCT 
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveApiKey,
		L.LiveApiSecret,
		L.LicenseStatus,
		L.CreatedBy,
		L.CreatedDttm
	FROM 
	Live_License L WITH (NOLOCK) 
	WHERE (L.Company_Id = @Company_Id OR L.Company_Id = 0) AND
	(L.Center_Id = @Center_Id OR L.Center_Id = 0) AND
	L.LicenseStatus = @LicenseStatus

END
GO