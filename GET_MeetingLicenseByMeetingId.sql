-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_MeetingLicenseByMeetingId 276
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_MeetingLicenseByMeetingId')
BEGIN
    DROP PROC GET_MeetingLicenseByMeetingId
END
GO
Create PROC GET_MeetingLicenseByMeetingId (@SysMeetingId INT)
AS  
BEGIN
	SELECT
		L.LiveApiKey, L.LiveApiSecret, 20 [TokenExpiry]
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN Live_License L ON L.SysLiveLicenseId = M.SysLiveLicenseId
	WHERE M.SysMeetingId = @SysMeetingId
END
GO