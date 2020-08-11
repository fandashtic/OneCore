-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Company_Center 1183, 4, '05-AUG-2020 07:00:00', '06-AUG-2020 06:59:59', 3
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Company_Center')
BEGIN
	DROP PROC GET_Meetings_By_Company_Center
END
GO
CREATE PROC GET_Meetings_By_Company_Center
(
	 @Company_Id INT,
	 @Center_Id INT,
	 @FromDttm DATETIME,
	 @ToDttm DATETIME,
	 @MeetingRequestType TINYINT = 1 -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings
)
AS
BEGIN
	SET DATEFORMAT DMY
	Declare @CenterTimeZoneId INT
	Declare @CenterTimeZoneInfo VARCHAR(255)
	Declare @CenterAlternateTimeZoneInfoId VARCHAR(255)

	Select @CenterTimeZoneId = timezone_id from Center_Details C WITH (NOLOCK) WHERE C.Company_Id = @Company_Id AND C.Center_ID = @Center_Id
	SELECT @CenterAlternateTimeZoneInfoId = T.AlternateTimeZoneInfoId, @CenterTimeZoneInfo = T.TimeZoneInfoId From timezone T WITH (NOLOCK) WHERE T.timezone_id = @CenterTimeZoneId

	DECLARE @SelectedMeetings AS TABLE (SysMeetingId INT)

	IF(@MeetingRequestType = 1)
	BEGIN
		INSERT INTO @SelectedMeetings(SysMeetingId)
		SELECT DISTINCT 
			M.SysMeetingId
		FROM Live_Meetings M WITH (NOLOCK)
		WHERE 
		M.Company_Id = @Company_Id AND
		M.Center_Id = @Center_Id AND
		ISNULL(M.SysVirtualClassroomId, 0) = 0 AND
		M.MeetingStartTime BETWEEN @FromDttm AND @ToDttm
	END
	IF(@MeetingRequestType = 2)
	BEGIN
		INSERT INTO @SelectedMeetings(SysMeetingId)
		SELECT DISTINCT 
			M.SysMeetingId
		FROM Live_Meetings M WITH (NOLOCK)
		WHERE 
		M.Company_Id = @Company_Id AND
		M.Center_Id = @Center_Id AND
		ISNULL(M.SysVirtualClassroomId, 0) = 0 AND
		M.MeetingStartTime > @ToDttm
	END
	IF(@MeetingRequestType = 3)
	BEGIN
		INSERT INTO @SelectedMeetings(SysMeetingId)
		SELECT DISTINCT 
			M.SysMeetingId
		FROM Live_Meetings M WITH (NOLOCK)
		WHERE 
		M.Company_Id = @Company_Id AND
		M.Center_Id = @Center_Id AND
		ISNULL(M.SysVirtualClassroomId, 0) = 0 AND
		M.MeetingStartTime < @FromDttm
	END

	Update M
	SET
	M.ParticipantsCount = dbo.GetParticipantsCountByMeetingId(S.SysMeetingId),
	M.MeetingAttendeesCount = dbo.GetMeetingAttendeesCount(S.SysMeetingId)
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @SelectedMeetings S ON S.SysMeetingId = M.SysMeetingId
 
	SELECT DISTINCT
		M.SysMeetingId,
		H.FirstName [MeetingHostFirstName],
		H.LastName [MeetingHostLastName],
		S.FirstName [StaffFirstName],  
		S.LastName [StaffLastName], 
		M.MeetingName,
		M.MeetingDate,
		M.MeetingStartTime,
		M.MeetingEndTime,
		M.MeetingStatus,
		M.ParticipantsCount,
		''as [MeetingOn], 
		M.TimeZoneId,
		T.TimeZoneInfoId [TimeZoneName]
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @SelectedMeetings X ON X.SysMeetingId = M.SysMeetingId
	LEFT JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
	LEFT JOIN User_Details S WITH (NOLOCK) ON S.User_Id = M.MeetingHostUserId 
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo
END 
GO