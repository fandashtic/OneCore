-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_LiveUserAccountDetails 0, 0, 0, 1825, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_LiveUserAccountDetails')
BEGIN
    DROP PROC GET_LiveUserAccountDetails
END
GO
Create PROC GET_LiveUserAccountDetails 
(
	@UserId INT,
	@TimeZoneId INT,
	@SysMeetingId INT = 0,
	@Company_Id INT = 1,
	@Center_Id INT = 1 
)  
AS  
BEGIN 

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id)
	BEGIN
		SET @Company_Id = 1
	END

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id AND Center_Id = @Center_Id)
	BEGIN
		SET @Center_Id = 1
	END

	IF(ISNULL(@UserId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @UserId = MeetingHostUserId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	IF(ISNULL(@TimeZoneId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @TimeZoneId = TimeZoneId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE OneCoreUserId = @UserId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)
	BEGIN		
		Update Live_Meeting_License set OneCoreUserId = @UserId, Company_Id = @Company_Id, Center_Id = @Center_Id WHERE SysLiveMeetingLicenseId = (
			SELECT TOP 1 ISNULL(SysLiveMeetingLicenseId, 1) FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id
		)
	END

	SELECT DISTINCT TOP 1 L.LiveApiKey, L.LiveApiSecret, LC.LiveUserName, LC.LiveMeetingPassword, 
	T.TimeZoneInfoId [TimeZoneInfoId],
	M.SysMeetingId, M.MeetingId, M.Uuid
	FROM Live_License L WITH (NOLOCK)
	JOIN Live_Meeting_License LC WITH (NOLOCK) ON LC.SysLiveLicenseId = L.SysLiveLicenseId AND LC.Company_Id = @Company_Id AND LC.Center_Id = @Center_Id
	LEFT JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = @SysMeetingId AND LC.SysLiveMeetingLicenseId = M.SysLiveMeetingLicenseId AND L.SysLiveLicenseId = M.SysLiveLicenseId
	LEFT JOIN timezone T WITH (NOLOCK) ON T.timezone_id = @TimeZoneId
	WHERE LC.OneCoreUserId = @UserId
END
GO