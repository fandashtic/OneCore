-- =================================================================================================
-- Author: Gifla
-- Create date: 17th Jun 2020
-- Description: Create new stored procedure to get live meeting details by Participant
-- Return meeting details list
-- =================================================================================================
--Exec GET_Meetings_List_For_Parent 1183, 4, 1, 398980
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_List_For_Parent')
BEGIN
    DROP PROC GET_Meetings_List_For_Parent
END
GO
Create PROCEDURE GET_Meetings_List_For_Parent      
(       
 @Company_Id INT,      
 @Center_Id INT = NULL,      
 @MeetingStatus TINYINT = 1 ,    
 @ParentId int    
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
  M.ModifiedDttm    
 FROM Live_Meetings M WITH (NOLOCK)    
 JOIN Live_Meeting_Participants LMP  WITH (NOLOCK) ON LMP.SysMeetingId = LMP.SysMeetingId AND LMP.MeetingParticipantStatus = @MeetingStatus  
 JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy    
 JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId    
 --JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)    
 JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id    
 JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id    
 JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId    
 JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId    
 WHERE LMP.MeetingParticipantUserId =  @ParentId  
 AND M.MeetingsStatus = @MeetingStatus  
END  
GO
