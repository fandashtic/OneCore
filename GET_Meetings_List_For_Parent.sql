-- =================================================================================================
-- Author: Gifla
-- Create date: 17th Jun 2020
-- Description: Create new stored procedure to get live meeting details by Participant
-- Return meeting details list
-- ================================================r=================================================
--Exec GET_Meetings_List_For_Parent 1183, 4, '2020-07-07 07:44:34','2020-07-07 07:44:34', 3, 398980
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_List_For_Parent')
BEGIN
    DROP PROC GET_Meetings_List_For_Parent
END
GO
Create PROCEDURE GET_Meetings_List_For_Parent      
(       
 @Company_Id INT,      
 @Center_Id INT = NULL,      
 @TransactionDttm DATETIME,
 @ServerUTCDttm DATETIME,
 @MeetingRequestType TINYINT = 1, -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings   
 @ParentId int    
)      
AS      
BEGIN 

	SET DATEFORMAT DMY

	IF(@MeetingRequestType = 1)
	BEGIN
		SELECT DISTINCT    
		M.SysMeetingId,    
		M.SysLiveLicenseId,    
		M.SysLiveMeetingLicenseId,    
		M.Company_Id,    
		M.Center_Id,    
		M.MeetingHostUserId,    
		H.FirstName [MeetingHostFirstName],    
		H.LastName [MeetingHostLastName],    
		M.MeetingName,    
		M.TimeZoneId,    
		T.TimeZoneInfoId [TimeZoneName],    
		M.MeetingStartTime,    
		M.MeetingEndTime,  
		DATEADD(minute, -(L.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
		DATEADD(minute, +((L.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,
		dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
		M.MeetingTypeId,    
		L.MeetingTypeName,      
		L.GraceTime,    
		L.CallDuration,    
		M.MeetingDescription,    
		dbo.GetParticipantsByMeetingId(M.SysMeetingId) Participants,    
		dbo.GetParticipantsCountByMeetingId(M.SysMeetingId) ParticipantsCount,    
		LMP.Family_Id,  
		LMP.Child_Id,  
		LMP.MeetingParticipantUserId,
		LMP.SysParticipantId,
		M.IsSendReminderHost,    
		M.IsSendReminderParticipants,    
		M.IsRecordSession,    
		M.MeetingsStatus [MeetingStatus],      
		CE.Center_Name,    
		C.Company_Name,    
		M.CreatedBy,     
		U.FirstName [CreatedByFirstName],    
		U.LastName [CreatedByLastName],    
		M.CreatedDttm,    
		M.ModifiedBy,    
		'' [ModifiedByFirstName],    
		'' [ModifiedByLastName],      
		M.ModifiedDttm    
		FROM Live_Meetings M WITH (NOLOCK)    
		JOIN (SELECT SysMeetingId, MeetingParticipantStatus, Max(SysParticipantId) SysParticipantId, MAX(Family_Id) Family_Id, MAX(Child_Id) Child_Id, MAX(MeetingParticipantUserId) MeetingParticipantUserId FROM Live_Meeting_Participants WITH (NOLOCK) WHERE MeetingParticipantUserId = @ParentId GROUP BY SysMeetingId, MeetingParticipantStatus) LMP ON LMP.SysMeetingId = M.SysMeetingId AND LMP.MeetingParticipantStatus IN (1,2)
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy    
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId 
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id    
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id    
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId    
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId    
		WHERE LMP.MeetingParticipantUserId = @ParentId  AND
		M.MeetingsStatus IN (1,2) AND 
		(dbo.StripDateFromTime(M.MeetingStartTime) = dbo.StripDateFromTime(@TransactionDttm) OR dbo.StripDateFromTime(M.MeetingEndTime) = dbo.StripDateFromTime(@TransactionDttm))
	END

	IF(@MeetingRequestType = 2)
	BEGIN
		SELECT DISTINCT    
		M.SysMeetingId,    
		M.SysLiveLicenseId,    
		M.SysLiveMeetingLicenseId,    
		M.Company_Id,    
		M.Center_Id,    
		M.MeetingHostUserId,    
		H.FirstName [MeetingHostFirstName],    
		H.LastName [MeetingHostLastName],    
		M.MeetingName,    
		M.TimeZoneId,    
		T.TimeZoneInfoId [TimeZoneName],    
		M.MeetingStartTime,    
		M.MeetingEndTime, 
		DATEADD(minute, -(L.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
		DATEADD(minute, +((L.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,
		dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
		M.MeetingTypeId,    
		L.MeetingTypeName,      
		L.GraceTime,    
		L.CallDuration,    
		M.MeetingDescription,    
		dbo.GetParticipantsByMeetingId(M.SysMeetingId) Participants,    
		dbo.GetParticipantsCountByMeetingId(M.SysMeetingId) ParticipantsCount,    
		LMP.Family_Id,  
		LMP.Child_Id,  
		LMP.MeetingParticipantUserId,
		LMP.SysParticipantId,
		M.IsSendReminderHost,    
		M.IsSendReminderParticipants,    
		M.IsRecordSession,    
		M.MeetingsStatus [MeetingStatus],        
		CE.Center_Name,    
		C.Company_Name,    
		M.CreatedBy,     
		U.FirstName [CreatedByFirstName],    
		U.LastName [CreatedByLastName],    
		M.CreatedDttm,    
		M.ModifiedBy,    
		'' [ModifiedByFirstName],    
		'' [ModifiedByLastName],      
		M.ModifiedDttm    
		FROM Live_Meetings M WITH (NOLOCK)    
		JOIN (SELECT SysMeetingId, MeetingParticipantStatus, Max(SysParticipantId) SysParticipantId, MAX(Family_Id) Family_Id, MAX(Child_Id) Child_Id, MAX(MeetingParticipantUserId) MeetingParticipantUserId FROM Live_Meeting_Participants WITH (NOLOCK) WHERE MeetingParticipantUserId = @ParentId GROUP BY SysMeetingId, MeetingParticipantStatus) LMP ON LMP.SysMeetingId = M.SysMeetingId AND LMP.MeetingParticipantStatus IN (1,2)
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy    
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId 
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id    
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id    
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId    
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId    
		WHERE LMP.MeetingParticipantUserId = @ParentId  AND
		M.MeetingsStatus IN (1,2) AND 
		dbo.StripDateFromTime(M.MeetingStartTime) > dbo.StripDateFromTime(@TransactionDttm)
	END

	IF(@MeetingRequestType = 3)
	BEGIN
		SELECT DISTINCT    
		M.SysMeetingId,    
		M.SysLiveLicenseId,    
		M.SysLiveMeetingLicenseId,    
		M.Company_Id,    
		M.Center_Id,    
		M.MeetingHostUserId,    
		H.FirstName [MeetingHostFirstName],    
		H.LastName [MeetingHostLastName],    
		M.MeetingName,    
		M.TimeZoneId,    
		T.TimeZoneInfoId [TimeZoneName],    
		M.MeetingStartTime,    
		M.MeetingEndTime, 
		DATEADD(minute, -(L.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
		DATEADD(minute, +((L.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,
		dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
		M.MeetingTypeId,    
		L.MeetingTypeName,      
		L.GraceTime,    
		L.CallDuration,    
		M.MeetingDescription,    
		dbo.GetParticipantsByMeetingId(M.SysMeetingId) Participants,    
		dbo.GetParticipantsCountByMeetingId(M.SysMeetingId) ParticipantsCount,    
		LMP.Family_Id,  
		LMP.Child_Id,  
		LMP.MeetingParticipantUserId,
		LMP.SysParticipantId,
		M.IsSendReminderHost,    
		M.IsSendReminderParticipants,    
		M.IsRecordSession,    
		M.MeetingsStatus [MeetingStatus],        
		CE.Center_Name,    
		C.Company_Name,    
		M.CreatedBy,     
		U.FirstName [CreatedByFirstName],    
		U.LastName [CreatedByLastName],    
		M.CreatedDttm,    
		M.ModifiedBy,    
		'' [ModifiedByFirstName],    
		'' [ModifiedByLastName],      
		M.ModifiedDttm    
		FROM Live_Meetings M WITH (NOLOCK)    
		JOIN (SELECT SysMeetingId, MeetingParticipantStatus, Max(SysParticipantId) SysParticipantId, MAX(Family_Id) Family_Id, MAX(Child_Id) Child_Id, MAX(MeetingParticipantUserId) MeetingParticipantUserId FROM Live_Meeting_Participants WITH (NOLOCK) WHERE MeetingParticipantUserId = @ParentId GROUP BY SysMeetingId, MeetingParticipantStatus) LMP ON LMP.SysMeetingId = M.SysMeetingId AND LMP.MeetingParticipantStatus NOT IN (1,2)
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy    
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId 
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id    
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id    
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId    
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId    
		WHERE LMP.MeetingParticipantUserId = @ParentId  AND
		M.MeetingsStatus NOT IN (1,2) AND 
		dbo.StripDateFromTime(M.MeetingEndTime) < dbo.StripDateFromTime(@TransactionDttm)
	END

END  
GO