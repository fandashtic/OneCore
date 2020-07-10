-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_LiveUserAccountDetails 35709, 69
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_LiveUserAccountDetails')
BEGIN
    DROP PROC GET_LiveUserAccountDetails
END
GO
Create PROC GET_LiveUserAccountDetails 
(   
	@UserId INT,
	@TimeZoneId INT
)  
AS  
BEGIN 
	Update Live_Meeting_License set OneCoreUserId = @UserId

	SELECT DISTINCT L.LiveApiKey, L.LiveApiSecret, M.LiveUserName, M.LiveMeetingPassword, T.AlternateTimeZoneInfoId [TimeZoneInfoId] 
	FROM Live_License L WITH (NOLOCK)
	JOIN Live_Meeting_License M WITH (NOLOCK) ON M.SysLiveLicenseId = L.SysLiveLicenseId
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = @timeZoneId
	WHERE M.OneCoreUserId = @UserId
END
GO

--Update Live_Meeting_License set OneCoreUserId = 260192