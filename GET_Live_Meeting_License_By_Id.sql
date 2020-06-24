-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live meeting license by id
-- Return live license meeting details list
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_License_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_License_By_Id
END
GO
Create PROC GET_Live_Meeting_License_By_Id
(	
	@SysLiveMeetingLicenseId INT
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
	WHERE L.SysLiveMeetingLicenseId = @SysLiveMeetingLicenseId

END
GO