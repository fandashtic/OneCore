-- ======================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live meeting license by company, center and status
-- Return live license meeting details list
-- ======================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_License_By_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_License_By_Company_Center
END
GO
Create PROC GET_Live_Meeting_License_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@MeetingLicenseStatus BIT = 1
)
AS
BEGIN

	SELECT	DISTINCT 
		L.SysLiveMeetingLicenseId,
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveUserId,
		L.LiveUserName,
		L.LiveMeetingId,
		L.LiveMeetingPassword,
		L.MeetingLicenseStatus,
		L.CreatedBy,
		L.CreatedDttm,
		L.ModifiedBy,
		L.ModifiedDttm
	FROM 
	Live_Meeting_License L WITH (NOLOCK) 
	WHERE (L.Company_Id = @Company_Id OR L.Company_Id = 0) AND
	(L.Center_Id = @Center_Id OR L.Center_Id = 0) AND
	L.MeetingLicenseStatus = @MeetingLicenseStatus

END
GO