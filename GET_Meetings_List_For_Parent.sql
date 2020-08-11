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
