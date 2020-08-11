-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 22nd Jul 2020
-- Description: Create new stored procedure to get meetings list by company and center and staff id
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-09 18:30:00', '2020-08-10 18:29:59', 1
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-09 18:30:00', '2020-08-10 18:29:59', 2
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-09 18:30:00', '2020-08-10 18:29:59', 3

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Staff')
BEGIN
	DROP PROC GET_Meetings_By_Staff
END
GO
CREATE PROC GET_Meetings_By_Staff
(
	 @Company_Id INT,
	 @Center_Id INT,
	 @MeetingHostUserId INT,
	 @FromDttm DATETIME,
	 @ToDttm DATETIME,
	 @MeetingRequestType TINYINT = 1 -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings
)
AS
BEGIN
	SET DATEFORMAT DMY
	Declare @StaffTimeZoneId INT
	Declare @StaffTimeZoneInfo VARCHAR(255)
	Declare @StaffAlternateTimeZoneInfoId VARCHAR(255)

	Select @StaffTimeZoneId = StaffTimeZone 
	from TBL_CC21_CLASSROOM_TEACHERS T WITH (NOLOCK) 
	JOIN User_Details U WITH (NOLOCK) ON U.User_Original_Id = T.SYSTEACHERID AND U.User_Id = @MeetingHostUserId
	WHERE T.COMPANY_ID = @Company_Id AND T.Center_ID = @Center_Id

	SELECT @StaffAlternateTimeZoneInfoId = T.AlternateTimeZoneInfoId, @StaffTimeZoneInfo = T.TimeZoneInfoId From timezone T WITH (NOLOCK) WHERE T.timezone_id = @StaffTimeZoneId

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
		M.MeetingHostUserId = @MeetingHostUserId AND
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
		M.MeetingHostUserId = @MeetingHostUserId AND
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
		M.MeetingHostUserId = @MeetingHostUserId AND
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
		H.FirstName [StaffFirstName],  
		H.LastName [StaffLastName], 
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
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @StaffTimeZoneId CenterTimeZoneId, @StaffAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @StaffTimeZoneInfo CenterTimeZoneInfo
END 
GO