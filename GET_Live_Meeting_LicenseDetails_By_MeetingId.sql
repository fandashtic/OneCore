-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting license details by meeting id
-- Return live license details list
-- ==============================================================================================
--Exec GET_Live_Meeting_LicenseDetails_By_MeetingId 1,398980,342182
--Exec GET_Live_Meeting_LicenseDetails_By_MeetingId 1,0,0
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
    DROP PROC GET_Live_Meeting_LicenseDetails_By_MeetingId
END
GO
CREATE PROC GET_Live_Meeting_LicenseDetails_By_MeetingId      
(       
 @SysMeetingId INT,      
 @SysParticipantId INT = 0
)      
AS      
BEGIN      
 DECLARE @DisplayNameFirstName AS varbinary(800)      
 DECLARE @DisplayNameLastName AS varbinary(800)      
 DECLARE @MeetingRole AS INT 
 DECLARE @ChildId AS INT 
 DECLARE @MeetingUserId AS INT      
      
 IF(@SysParticipantId > 0)      
 BEGIN      
  SET @MeetingRole = 0     
  
  select @MeetingUserId = MeetingParticipantUserId, @ChildId = Child_Id from Live_Meeting_Participants WITH (NOLOCK) WHERE SysParticipantId = @SysParticipantId

  SELECT @DisplayNameFirstName =FIRST_NAME, @DisplayNameLastName = LAST_NAME    
  FROM Child_Details  WITH (NOLOCK) WHERE child_id=@ChildId    
     
 END      
 ELSE      
 BEGIN      
  SET @MeetingRole = 1      
  SET @MeetingUserId = (SELECT TOP 1 L.MeetingHostUserId FROM Live_Meetings L WITH (NOLOCK) WHERE L.SysMeetingId = @SysMeetingId)      
 END      
      
 SELECT @DisplayNameFirstName = U.FirstName, @DisplayNameLastName = U.LastName FROM User_Details U WITH (NOLOCK) WHERE User_Id = @MeetingUserId      
      
 SELECT DISTINCT       
  L.LiveApiKey,      
  L.LiveApiSecret,        
  ML.LiveUserId,      
  ML.LiveUserName,      
  ISNULL(M.MeetingId, ML.LiveMeetingId) LiveMeetingId,      
  ML.LiveMeetingPassword,      
  T.CallDuration,      
  '' [LeaveUrl],      
  @DisplayNameFirstName DisplayNameFirstName,      
  @DisplayNameLastName DisplayNameLastName,      
  @MeetingRole MeetingRole,      
  T.SysMeetingTypeId,      
  M.IsRecordSession,  
  T.MeetingTypeName,  
  M.MeetingName,  
  M.MeetingStartTime,  
  M.MeetingEndTime,  
  DATEADD(minute, -(T.GraceTime), M.MeetingStartTime) MeetingStartTimeWithGraceTime,  
  DATEADD(minute, +((T.CallDuration - 1)), M.MeetingStartTime) MeetingEndTimeWithCallDuration,  
  TT.TimeZoneInfoId [TimeZoneName]  
 FROM Live_Meetings M WITH (NOLOCK)      
 JOIN Live_Meeting_License ML WITH (NOLOCK) ON ML.SysLiveMeetingLicenseId = M.SysLiveMeetingLicenseId       
 JOIN Live_License L WITH (NOLOCK) ON L.SysLiveLicenseId = M.SysLiveLicenseId      
 JOIN Live_Meeting_Type T WITH (NOLOCK) ON T.SysMeetingTypeId = M.MeetingTypeId     
 JOIN timezone TT WITH (NOLOCK) ON TT.timezone_id = M.TimeZoneId  
 WHERE M.SysMeetingId = @SysMeetingId      
      
END      
GO
