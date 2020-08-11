--06-Aug-2020 Live Meeting Changes:
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
	JOIN @SelectedMeetings S ON S.SysMeetingId = M.SysMeetingId
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo
END 
GO
-- =================================================================================================
-- Author: Gifla
-- Create date: 17th Jun 2020
-- Description: Create new stored procedure to get live meeting details by Participant
-- Return meeting details list
-- ================================================r=================================================
--Exec GET_Meetings_List_For_Parent 1183, 4, '05-AUG-2020 07:00:00', '06-AUG-2020 06:59:59', 3, 398980
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_List_For_Parent')
BEGIN
    DROP PROC GET_Meetings_List_For_Parent
END
GO
CREATE PROCEDURE GET_Meetings_List_For_Parent --1183,4,'2020-08-04',1,398980  
(  
	@Company_Id INT,  
	@Center_Id INT = NULL,  
	@FromDttm DATETIME,  
	@ToDttm DATETIME,  
	@MeetingRequestType TINYINT = 1, -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings  
	@ParentId int  
)  
AS  
BEGIN  
  
	Declare @CenterTimeZoneId INT  
	Declare @CenterTimeZoneInfo VARCHAR(255)  
	Declare @CenterAlternateTimeZoneInfoId VARCHAR(255)  
  
	Select @CenterTimeZoneId = timezone_id from Center_Details C WITH (NOLOCK) WHERE C.Company_Id = @Company_Id AND C.Center_ID = @Center_Id  
	SELECT @CenterAlternateTimeZoneInfoId = T.AlternateTimeZoneInfoId, @CenterTimeZoneInfo = T.TimeZoneInfoId From timezone T WITH (NOLOCK) WHERE T.timezone_id = @CenterTimeZoneId  
	declare @childstatus int  
	set @childstatus = dbo.FN_ChildStatus('Active')  
  
  
	IF EXISTS(SELECT TOP 1 1 FROM sponsor_details S WITH (NOLOCK) WHERE S.sponsor_id = @ParentId AND S.PP_status = 1)  
	BEGIN  
		DECLARE @SelectedMeetings AS TABLE (SysMeetingId INT)  
  
		IF(@MeetingRequestType = 1)  
		BEGIN  
			INSERT INTO @SelectedMeetings(SysMeetingId)  
			SELECT DISTINCT  
				M.SysMeetingId  
			FROM Live_Meetings M WITH (NOLOCK)  
			JOIN Live_Meeting_Participants P WITH (NOLOCK) ON M.SysMeetingId = P.SysMeetingId  
			WHERE  
			M.Company_Id = @Company_Id AND  
			M.Center_Id = @Center_Id AND  
			P.MeetingParticipantUserId = @ParentId AND  
			ISNULL(M.SysVirtualClassroomId, 0) = 0 AND  
			M.MeetingStartTime BETWEEN @FromDttm AND @ToDttm
		END  
		IF(@MeetingRequestType = 2)  
		BEGIN  
			INSERT INTO @SelectedMeetings(SysMeetingId)  
			SELECT DISTINCT  
				M.SysMeetingId  
			FROM Live_Meetings M WITH (NOLOCK)  
			JOIN Live_Meeting_Participants P WITH (NOLOCK) ON M.SysMeetingId = P.SysMeetingId  
			WHERE  
			M.Company_Id = @Company_Id AND  
			M.Center_Id = @Center_Id AND  
			P.MeetingParticipantUserId = @ParentId AND  
			ISNULL(M.SysVirtualClassroomId, 0) = 0 AND  
					M.MeetingStartTime > @ToDttm
		END  
		IF(@MeetingRequestType = 3)  
		BEGIN  
			INSERT INTO @SelectedMeetings(SysMeetingId)  
			SELECT DISTINCT  
				M.SysMeetingId  
			FROM Live_Meetings M WITH (NOLOCK)  
			JOIN Live_Meeting_Participants P WITH (NOLOCK) ON M.SysMeetingId = P.SysMeetingId  
			WHERE  
			M.Company_Id = @Company_Id AND  
			M.Center_Id = @Center_Id AND  
			P.MeetingParticipantUserId = @ParentId AND  
			ISNULL(M.SysVirtualClassroomId, 0) = 0 AND  
					M.MeetingStartTime < @FromDttm 
		END  
	END  
  
	SELECT DISTINCT  
		M.Company_Id,  
		M.Center_Id,  
		M.SysMeetingId,  
		M.MeetingHostUserId,  
		H.FirstName [MeetingHostFirstName],  
		H.LastName [MeetingHostLastName],  
		M.MeetingName,  
		T.TimeZoneInfoId [TimeZoneName],  
		M.MeetingDate,  
		M.MeetingStartTime,  
		M.MeetingEndTime,  
		LMP.ActualMeetingStartTime,  
		LMP.ActualMeetingEndTime,  
		DATEADD(minute, -(L.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
		DATEADD(minute, +((L.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,  
		'' [MeetingOn],  
		L.GraceTime,  
		L.CallDuration,  
		M.MeetingDescription,  
		M.JoinURL,  
		LMP.Family_Id,  
		--(SELECT TOP 1 FIRST_NAME FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) Child_First_Name,  
		--(SELECT TOP 1 LAST_NAME FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) Child_Last_Name,  
		--(SELECT TOP 1 ChildPhoto FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) ChildPhoto,  
		LMP.SysParticipantId,  
		LMP.MeetingParticipantStatus MeetingStatus,  
		'' as ChildName
		--0 as SysVcEnrollmentId  
	FROM Live_Meetings M WITH (NOLOCK)  
	JOIN @SelectedMeetings S ON S.SysMeetingId = M.SysMeetingId  
	JOIN Live_Meeting_Participants LMP WITH (NOLOCK) ON LMP.SysMeetingId = M.SysMeetingId and LMP.MeetingParticipantUserId=@ParentId  
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId  
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId  
	JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId  
	ORDER BY LMP.MeetingParticipantStatus DESC, M.MeetingStartTime ASC  
  
	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo  
  
	SELECT  
		F.Family_Id,  
		C.Child_Id [Child_Id],  
		C.FIRST_NAME [Child_FirstName],  
		C.LAST_NAME [Child_LastName]  
	FROM  
	Family_Details F WITH (NOLOCK)
	JOIN child_details C WITH (NOLOCK) ON C.Family_Id = F.Family_Id  
	WHERE f.company_id=@Company_Id and f.Center_Id=@Center_Id and c.Child_Status=@childstatus  
  
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
	SET D.MeetingParticipantStatus = 6 -- Not Attended Meetings are updated as Expired
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus = 1
	AND D.MeetingParticipantStatus = 1

	DECLARE @Meetings AS TABLE(SysMeetingId INT)

	INSERT INTO @Meetings(SysMeetingId)
	SELECT DISTINCT SysMeetingId 
	FROM Live_Meetings M WITH (NOLOCK)
	WHERE M.MeetingStatus In(2,3) AND
	ISNULL(M.AppJobHistId, 0) = 0 AND
	ISNULL(M.IsJobExecuted, 0) = 0 AND
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
END
GO
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 22nd Jul 2020
-- Description: Create new stored procedure to get meetings list by company and center and staff id
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-05 18:30:00', '2020-08-06 18:29:59', 1
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-05 18:30:00', '2020-08-06 18:29:59', 2
--Exec GET_Meetings_By_Staff 1046, 1, 275199, '2020-08-05 18:30:00', '2020-08-06 18:29:59', 3
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
		H.FirstName [MeetingHostFirstName],
		H.LastName [MeetingHostLastName],
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
	JOIN @SelectedMeetings S ON S.SysMeetingId = M.SysMeetingId
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo
END 
GO