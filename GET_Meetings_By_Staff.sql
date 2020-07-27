-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 22nd Jul 2020
-- Description: Create new stored procedure to get meetings list by company and center and staff id
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Staff 1154, 47, 55478, '2020-07-23 13:33:47.363','2020-07-23 13:33:47.363', 1
--Exec GET_Meetings_By_Staff 1154, 47, 55478, '2020-07-23 13:33:47.363','2020-07-23 13:33:47.363', 2
--Exec GET_Meetings_By_Staff 1154, 47, 55478, '2020-07-23 13:33:47.363','2020-07-23 13:33:47.363', 3
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Staff')
BEGIN
    DROP PROC GET_Meetings_By_Staff
END
GO
Create PROC GET_Meetings_By_Staff
(	
	@Company_Id INT,
	@Center_Id INT,
	@MeetingHostUserId INT,
	@TransactionDttm DateTime,
	@ServerUTCDttm DATETIME,
	@MeetingRequestType TINYINT = 1 -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings	
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
			M.SysVcEnrollmentId,
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
			M.ActualMeetingStartTime,
			M.ActualMeetingEndTime,
			dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
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
			0 Family_Id,
			0 Child_Id,
			0 MeetingParticipantUserId,
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
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
		--JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId
		WHERE (M.Company_Id = @Company_Id OR M.Company_Id = 0) AND
		(M.Center_Id = @Center_Id OR M.Center_Id = 0) AND
		M.SysVcEnrollmentId > 0 AND
		M.MeetingHostUserId = @MeetingHostUserId AND
		(dbo.StripDateFromTime(M.MeetingStartTime) = dbo.StripDateFromTime(@TransactionDttm) OR dbo.StripDateFromTime(M.MeetingEndTime) = dbo.StripDateFromTime(@TransactionDttm))
		Order By M.MeetingStartTime ASC
	END

	IF(@MeetingRequestType = 2)
	BEGIN
		SELECT DISTINCT
			M.SysMeetingId,
			M.SysLiveLicenseId,
			M.SysLiveMeetingLicenseId,
			M.SysVcEnrollmentId,
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
			M.ActualMeetingStartTime,
			M.ActualMeetingEndTime,
			dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
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
			0 Family_Id,
			0 Child_Id,
			0 MeetingParticipantUserId,
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
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
		--JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId
		WHERE (M.Company_Id = @Company_Id OR M.Company_Id = 0) AND
		(M.Center_Id = @Center_Id OR M.Center_Id = 0) AND
		M.SysVcEnrollmentId > 0 AND
		M.MeetingHostUserId = @MeetingHostUserId AND
		dbo.StripDateFromTime(M.MeetingStartTime) > dbo.StripDateFromTime(@TransactionDttm)
		Order By M.MeetingStartTime ASC
	END

	IF(@MeetingRequestType = 3)
	BEGIN
		SELECT DISTINCT
			M.SysMeetingId,
			M.SysLiveLicenseId,
			M.SysLiveMeetingLicenseId,
			M.SysVcEnrollmentId,
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
			M.ActualMeetingStartTime,
			M.ActualMeetingEndTime,
			dbo.GetDayOn(@ServerUTCDttm, M.MeetingStartTime) [MeetingOn],
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
			0 Family_Id,
			0 Child_Id,
			0 MeetingParticipantUserId,
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
		JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy
		JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
		--JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)
		JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id
		JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id
		JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
		JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId
		WHERE (M.Company_Id = @Company_Id OR M.Company_Id = 0) AND
		(M.Center_Id = @Center_Id OR M.Center_Id = 0) AND
		M.SysVcEnrollmentId > 0 AND
		M.MeetingHostUserId = @MeetingHostUserId AND
		dbo.StripDateFromTime(M.MeetingEndTime) < dbo.StripDateFromTime(@TransactionDttm)
		Order By M.MeetingStartTime ASC
	END
END
GO