-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live license by id
-- Return live license details list
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_License_By_Id')
BEGIN
    DROP PROC GET_Live_License_By_Id
END
GO
Create PROC GET_Live_License_By_Id
(	
	@SysLiveLicenseId INT
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
	WHERE L.SysLiveLicenseId = @SysLiveLicenseId

END
GO