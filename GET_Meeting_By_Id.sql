-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meeting details by id
-- ==============================================================================================
--Exec GET_Meeting_By_Id 40, 342338
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
  dbo.GetParticipantsCountByMeetingId(M.SysMeetingId) ParticipantsCount,  
  M.IsSendReminderHost,  
  M.IsSendReminderParticipants,  
  M.IsRecordSession,  
  M.MeetingsStatus,    
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
 WHERE M.SysMeetingId = @SysMeetingId  
  
END  
GO