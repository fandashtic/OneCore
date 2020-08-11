-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for collect all Participants details and return as comma seprated string.
-- Return comma seprated value
-- ==================================================================================================================================
--select dbo.GetParticipantsCountByMeetingId(13)
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GetParticipantsCountByMeetingId')
BEGIN
    DROP FUNCTION dbo.GetParticipantsCountByMeetingId
END
GO
Create FUNCTION dbo.GetParticipantsCountByMeetingId(@SysMeetingId INT)
Returns INT
AS  
BEGIN 
	DECLARE @ParticipantsCount INT
	SET @ParticipantsCount = 0;
	Declare @CountTable As Table(ComboId VARCHAR(255))
	INSERT INTO @CountTable(ComboId)
	SELECT DISTINCT CAST(Family_Id AS VARCHAR) + CAST(Child_Id AS VARCHAR) + CAST(MeetingParticipantUserId AS VARCHAR)
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	WHERE D.SysMeetingId = @SysMeetingId
	AND D.MeetingParticipantStatus NOT IN (4) -- TODO: Except Deleted Participants.

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		SET @ParticipantsCount = (SELECT COUNT(DISTINCT ComboId) FROM @CountTable)
	END

	RETURN @ParticipantsCount;
END
GO
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
		'' [MeetingHostFirstName], 
		'' [MeetingHostLastName], 
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
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Company_Center 1154, 47, '2020-08-10 09:40:00.000', '2020-08-10 10:50:00.000', 1
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
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_InCompleteMeetings 0, 0, 1333
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_InCompleteMeetings')
BEGIN
    DROP PROC GET_InCompleteMeetings
END
GO
Create PROC GET_InCompleteMeetings (@Company_Id INT = 0, @Center_Id INT = 0, @AppJobHistId INT = 0)
AS  
BEGIN
	
	--#region : Start Update Meeting & Participants Status

	--TODO: If any meeting is there with SCHEDULED status and end time is cross the current time then it updated as expired.
	IF EXISTS(SELECT TOP 1 1 FROM Live_Meetings M WITH (NOLOCK) WHERE M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE())
	BEGIN		
		UPDATE P SET P.MeetingParticipantStatus = 6 
		FROM Live_Meeting_Participants P WITH (NOLOCK) 
		JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = P.SysMeetingId AND M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE()
		WHERE P.MeetingParticipantStatus = 1 

		UPDATE M SET M.MeetingStatus = 6 FROM Live_Meetings M WITH (NOLOCK) WHERE M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE()
	END

	UPDATE D 
	SET D.MeetingParticipantStatus = 3,
		D.ActualMeetingEndTime = ISNULL(D.ActualMeetingEndTime, M.ActualMeetingEndTime)
	FROM Live_Meeting_Participants D WITH (NOLOCK)
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus = 3
	AND D.MeetingParticipantStatus = 2

	UPDATE D 
	SET D.MeetingParticipantStatus = M.MeetingStatus -- Not Attended Meetings are updated as Meeting Status like Deleted.
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus > 3
	AND D.MeetingParticipantStatus = 1

	UPDATE D 
	SET D.MeetingParticipantStatus = 6 -- Not Attended Meetings are updated as Expired
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus = 3
	AND D.MeetingParticipantStatus = 1

	--#endregion : End Update Meeting & Participants Status

	--#region : Start Fecth Meetings list for JOB

	DECLARE @MeetingEndBufferTime INT

	IF(ISNULL(@MeetingEndBufferTime, 0) = 0) SET @MeetingEndBufferTime = 30; -- Default Meeting End buffer time is 30 Minuite.


	DECLARE @Meetings AS TABLE(SysMeetingId INT)

	INSERT INTO @Meetings(SysMeetingId)
	SELECT DISTINCT SysMeetingId 
	FROM Live_Meetings M WITH (NOLOCK)
	WHERE M.MeetingStatus In(3) AND
	ISNULL(M.AppJobHistId, 0) = 0 AND
	ISNULL(M.IsJobExecuted, 0) = 0 AND
	DATEADD(MINUTE, +(@MeetingEndBufferTime), M.ModifiedDttm) <= GETUTCDATE() AND
	M.MeetingId IS NOT NULL AND
	M.Uuid IS NOT NULL
	
	UPDATE M
	SET M.AppJobHistId = @AppJobHistId
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @Meetings T ON T.SysMeetingId = M.SysMeetingId

	SELECT
		M.SysMeetingId, 
		M.MeetingId, 
		M.Uuid, 
		M.Company_Id, 
		M.Center_Id,
		M.MeetingHostUserId,
		M.TimeZoneId
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @Meetings T ON T.SysMeetingId = M.SysMeetingId

	--#endregion : END Fecth Meetings list for JOB
END
GO
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 24th Jul 2020
-- Description: Create new stored procedure for update liveMeeting job status
-- ==============================================================================================
--Exec Update_LiveMeeting_Job_Status 4191, '2020-08-04 05:20:04.577'
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_LiveMeeting_Job_Status')
BEGIN
    DROP PROC Update_LiveMeeting_Job_Status
END
GO
Create PROC Update_LiveMeeting_Job_Status (@SysMeetingId INT, @LastJobExecutedOn DATETIME)
AS  
BEGIN

	--DECLARE @MeetingEndBufferTime INT
	
	--SELECT @MeetingEndBufferTime = T.MeetingEndBufferTime FROM Live_Meeting_Type T WITH (NOLOCK) 
	--JOIN Live_Meetings L WITH (NOLOCK) ON L.MeetingTypeId = T.SysMeetingTypeId
	--WHERE L.SysMeetingId = @SysMeetingId

	--IF(ISNULL(@MeetingEndBufferTime, 0) = 0) SET @MeetingEndBufferTime = 30; -- Default Meeting End buffer time is 30 Minuite.
	
	--IF EXISTS(
	--	SELECT TOP 1 1 
	--	FROM Live_Meetings L WITH (NOLOCK)
	--	WHERE SysMeetingId = @SysMeetingId AND
	--	L.MeetingStatus = 3 AND 
	--	DATEADD(MINUTE, +(@MeetingEndBufferTime), L.ActualMeetingEndTime) <= @LastJobExecutedOn
	--)
	--BEGIN
		UPDATE L
			SET L.IsJobExecuted = 1, L.LastJobExecutedOn = @LastJobExecutedOn
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE SysMeetingId = @SysMeetingId
	--END
	--ELSE
	--BEGIN
	--	UPDATE L
	--		SET L.IsJobExecuted = 0, L.AppJobHistId = 0
	--	FROM Live_Meetings L WITH (NOLOCK)
	--	WHERE SysMeetingId = @SysMeetingId
	--END
END
GO
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meeting details by id
-- ==============================================================================================
--Exec GET_Meeting_By_Id 136706
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meeting_By_Id')
BEGIN
    DROP PROC GET_Meeting_By_Id
END
GO
Create PROC GET_Meeting_By_Id  
(   
	@SysMeetingId INT
)
AS  
BEGIN  

	Update M 
	SET M.ParticipantsCount = dbo.GetParticipantsCountByMeetingId(@SysMeetingId),
	M.MeetingAttendeesCount = dbo.GetMeetingAttendeesCount(@SysMeetingId)
	FROM Live_Meetings M WITH (NOLOCK)
	WHERE SysMeetingId =@SysMeetingId

	SELECT DISTINCT  
	  M.SysMeetingId,  
	  M.SysLiveLicenseId,  
	  M.SysLiveMeetingLicenseId,
	  M.Company_Id,  
	  M.Center_Id,  
	  M.MeetingHostUserId,  
	  H.FirstName [MeetingHostFirstName],  
	  H.LastName [MeetingHostLastName],  
	  S.FirstName [StaffFirstName],  
	  S.LastName [StaffLastName], 
	  M.MeetingName,  
	  M.TimeZoneId,  
	  T.TimeZoneInfoId [TimeZoneName],  
	  M.MeetingStartTime,  
	  M.MeetingEndTime,  
	  M.ActualMeetingStartTime,
	  M.ActualMeetingEndTime,
	  DATEADD(minute, -(L.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
	  DATEADD(minute, +((L.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,  
	  M.MeetingTypeId,  
	  L.MeetingTypeName,  
	  L.GraceTime,  
	  L.CallDuration,  
	  M.MeetingDescription,  
	  M.MeetingId,
	  M.StartURL,
	  M.JoinURL,
	  M.Uuid,
	  dbo.GetParticipantsByMeetingId(M.SysMeetingId) Participants,  
	  ISNULL(M.ParticipantsCount, dbo.GetParticipantsCountByMeetingId(M.SysMeetingId)) ParticipantsCount,
	  ISNULL(M.MeetingAttendeesCount, dbo.GetMeetingAttendeesCount(M.SysMeetingId)) MeetingAttendeesCount,
	  M.IsSendReminderHost,  
	  M.IsSendReminderParticipants,  
	  M.IsRecordSession,  
	  M.MeetingStatus,    
	  CE.Center_Name,  
	  C.Company_Name,  
	  M.CreatedBy,   
	  U.FirstName [CreatedByFirstName],  
	  U.LastName [CreatedByLastName],  
	  M.CreatedDttm,  
	  M.ModifiedBy,  
	  '' [ModifiedByFirstName],  
	  '' [ModifiedByLastName],    
	  M.ModifiedDttm,
	  0 SysParticipantId
	 FROM Live_Meetings M WITH (NOLOCK)   
	 LEFT JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy  
	 LEFT JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId  
	 LEFT JOIN User_Details S WITH (NOLOCK) ON S.User_Id = M.MeetingHostUserId  
	 --JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)  
	 JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id  
	 JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id  
	 JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId  
	 JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId  
	 WHERE M.SysMeetingId = @SysMeetingId  
  
END  
GO