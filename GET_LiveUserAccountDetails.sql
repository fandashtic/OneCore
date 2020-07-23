-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_LiveUserAccountDetails 35833, 3, 66
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_LiveUserAccountDetails')
BEGIN
    DROP PROC GET_LiveUserAccountDetails
END
GO
Create PROC GET_LiveUserAccountDetails 
(   
	@UserId INT,
	@TimeZoneId INT,
	@SysMeetingId INT = 0
)  
AS  
BEGIN 

	IF(ISNULL(@UserId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @UserId = MeetingHostUserId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	IF(ISNULL(@TimeZoneId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @TimeZoneId = TimeZoneId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	--TODO: Comment this line, when move to Production
	Update Live_Meeting_License set OneCoreUserId = @UserId

	SELECT DISTINCT L.LiveApiKey, L.LiveApiSecret, LC.LiveUserName, LC.LiveMeetingPassword, T.TimeZoneInfoId [TimeZoneInfoId],
	M.SysMeetingId, M.MeetingId, M.Uuid
	FROM Live_License L WITH (NOLOCK)
	JOIN Live_Meeting_License LC WITH (NOLOCK) ON LC.SysLiveLicenseId = L.SysLiveLicenseId
	LEFT JOIN timezone T WITH (NOLOCK) ON T.timezone_id = @TimeZoneId
	LEFT JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = @SysMeetingId
	WHERE LC.OneCoreUserId = @UserId
END
GO

--Update Live_Meeting_License set OneCoreUserId = 260192