-- ===========================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for validate the given participants are already scheduled with any other meeting for the same time.
-- Return bit value
-- ===========================================================================================================================================
--select dbo.IsMeetingParticipantsTimeOverLap(1183, 4, '313492,327635', '233876,247993', '255836,270983', '2020-07-29 11:12:00.000', '2020-07-29 11:13:00.000', 94)
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'IsMeetingParticipantsTimeOverLap')
BEGIN
    DROP FUNCTION dbo.IsMeetingParticipantsTimeOverLap
END
GO
Create FUNCTION dbo.IsMeetingParticipantsTimeOverLap(@Company_Id INT, @Center_Id INT, @ParentIds NVARCHAR(1000), @FamilyIds NVARCHAR(1000), @ChildIds NVARCHAR(1000), @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT = 0)  
Returns BIT
AS  
BEGIN 
	DECLARE @IsMeetingParticipantsTimeOverLap BIT;
	DECLARE @ParentId INT;
	DECLARE @FamilyId INT;
	DECLARE @ChildId INT;
	DECLARE @Id INT;
	DECLARE @P_Id INT;
	Declare @P_SysMeetingId INT = 0
	SET @IsMeetingParticipantsTimeOverLap = 0;
	SET @Id = 1;
	SET @P_Id = 1;

	DECLARE @TempParents AS TABLE(Id INT IDENTITY(1,1), ParentId INT)
	INSERT INTO @TempParents(ParentId)
	SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ParentIds, ',')

	DECLARE @TempFamily AS TABLE(Id INT IDENTITY(1,1), FamilyId INT)
	INSERT INTO @TempFamily(FamilyId)
	SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@FamilyIds, ',')

	DECLARE @TempChilds AS TABLE(Id INT IDENTITY(1,1), ChildId INT)
	INSERT INTO @TempChilds(ChildId)
	SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ChildIds, ',')

	WHILE(@Id <= (SELECT MAX(Id) FROM @TempParents))
	BEGIN
		SELECT @ParentId = ParentId FROM @TempParents WHERE Id = @Id;
		SELECT @FamilyId = FamilyId FROM @TempFamily WHERE Id = @Id;
		SELECT @ChildId = ChildId FROM @TempChilds WHERE Id = @Id;

		DECLARE @TempParticipant_Meetings AS TABLE(P_Id INT IDENTITY(1,1), SysMeetingId INT)
		INSERT INTO @TempParticipant_Meetings(SysMeetingId)
		SELECT DISTINCT SysMeetingId FROM Live_Meeting_Participants L WITH (NOLOCK) 
		WHERE L.MeetingParticipantUserId = @ParentId AND L.Family_Id = @FamilyId AND L.Child_Id = @ChildId  AND MeetingParticipantStatus In(1, 2)
		AND Company_Id = @Company_Id AND Center_Id = @Center_Id
		AND SysMeetingId <> @SysMeetingId

		DELETE @TempParticipant_Meetings WHERE SysMeetingId IN(SELECT DISTINCT SysMeetingId FROM Live_Meetings WITH (NOLOCK) WHERE MeetingStatus > 2)

		SET @P_Id = 1;

		WHILE(@P_Id <= (SELECT MAX(P_Id) FROM @TempParticipant_Meetings))
		BEGIN

			SELECT @P_SysMeetingId = SysMeetingId FROM @TempParticipant_Meetings WHERE P_Id = @P_Id;

			IF(@P_SysMeetingId > 0)
			BEGIN
				IF EXISTS (SELECT TOP 1 1 
							FROM Live_Meetings L WITH (NOLOCK) 
							WHERE L.MeetingStatus <= 2 AND
							@MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
							AND SysMeetingId = @P_SysMeetingId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)
				BEGIN
					SET @IsMeetingParticipantsTimeOverLap = 1;
					BREAK; 
				END

				IF EXISTS (SELECT TOP 1 1 
							FROM Live_Meetings L WITH (NOLOCK) 
							WHERE L.MeetingStatus <= 2 AND
							@MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
							AND SysMeetingId = @P_SysMeetingId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)						
				BEGIN
					SET @IsMeetingParticipantsTimeOverLap = 1;
					BREAK; 
				END
			END

			SET @P_Id = @P_Id + 1;
		END

		SET @Id = @Id + 1;
	END

	RETURN @IsMeetingParticipantsTimeOverLap;
END
GO
-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Company_Center 1183, 4, '31-JUL-2020', 3
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Company_Center')
BEGIN
    DROP PROC GET_Meetings_By_Company_Center
END
GO
CREATE PROC GET_Meetings_By_Company_Center        
(        
 @Company_Id INT,        
 @Center_Id INT,        
 @TransactionDttm DateTime,        
 @MeetingRequestType TINYINT = 1 -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings        
)        
AS        
BEGIN        
 SET DATEFORMAT DMY        
 Declare @CenterTimeZoneId INT          
 Declare @CenterTimeZoneInfo VARCHAR(255)          
 Declare @CenterAlternateTimeZoneInfoId VARCHAR(255)          
          
 Select @CenterTimeZoneId = timezone_id from Center_Details C WITH (NOLOCK) WHERE C.Company_Id = @Company_Id AND C.Center_ID = @Center_Id          
 SELECT @CenterAlternateTimeZoneInfoId = T.AlternateTimeZoneInfoId, @CenterTimeZoneInfo = T.TimeZoneInfoId From timezone T  WITH (NOLOCK) WHERE T.timezone_id = @CenterTimeZoneId              
    
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
   M.MeetingDate = @TransactionDttm    
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
   M.MeetingDate > @TransactionDttm    
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
   M.MeetingDate < @TransactionDttm    
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
 Order By M.MeetingStartTime ASC     
    
 SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo          
        
END 
GO

-- =================================================================================================
-- Author: Gifla
-- Create date: 17th Jun 2020
-- Description: Create new stored procedure to get live meeting details by Participant
-- Return meeting details list
-- ================================================r=================================================
--Exec GET_Meetings_List_For_Parent 1183, 4, '31-Jul-2020', 3, 398980
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_List_For_Parent')
BEGIN
    DROP PROC GET_Meetings_List_For_Parent
END
GO
Create PROCEDURE GET_Meetings_List_For_Parent
(           
	@Company_Id INT,          
	@Center_Id INT = NULL,          
	@TransactionDttm DATE, 
	@MeetingRequestType TINYINT = 1, -- 1 = Today's Meetings, 2 = Upcoming Meetings, 3 = Past Meetings       
	@ParentId int        
)          
AS          
BEGIN    
	
	Declare @CenterTimeZoneId INT    
	Declare @CenterTimeZoneInfo VARCHAR(255)    
	Declare @CenterAlternateTimeZoneInfoId VARCHAR(255)    
    
	Select @CenterTimeZoneId = timezone_id from Center_Details C WITH (NOLOCK) WHERE C.Company_Id = @Company_Id AND C.Center_ID = @Center_Id    
	SELECT @CenterAlternateTimeZoneInfoId = T.AlternateTimeZoneInfoId, @CenterTimeZoneInfo = T.TimeZoneInfoId From timezone T  WITH (NOLOCK) WHERE T.timezone_id = @CenterTimeZoneId     
    
	
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
				M.MeetingDate = @TransactionDttm
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
				M.MeetingDate > @TransactionDttm
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
				M.MeetingDate < @TransactionDttm
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
		(SELECT TOP 1 FIRST_NAME FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) Child_First_Name,    
		(SELECT TOP 1 LAST_NAME FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) Child_Last_Name,    
		(SELECT TOP 1 ChildPhoto FROM Child_Details WITH (NOLOCK) WHERE Child_Id = LMP.Child_Id) ChildPhoto,    
		LMP.SysParticipantId,       
		LMP.MeetingParticipantStatus MeetingStatus      
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @SelectedMeetings S ON S.SysMeetingId = M.SysMeetingId
	JOIN Live_Meeting_Participants LMP WITH (NOLOCK) ON LMP.SysMeetingId = M.SysMeetingId
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId     
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId        
	JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo      
	
END
GO
-- ===============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the meeting details and participants
-- Return meeting id  as INT
-- ===============================================================================================
/*
Exec SAVE_Live_Meeting 1183, 4, 35709, '29-07 Meeting', 6, '28-Jul-2020 22:42:00', '28-Jul-2020 22:43:00', 1, 'sadf', '331657,321548,327611,327626,313492,327635',
'252015,241920,247971,247985,233876,247993', '342394,262900,270958,270974,255836,270983', '85600068749', 
'https://us02web.zoom.us/s/85600068749?zak=eyJ6bV9za20iOiJ6bV9vMm0iLCJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJjbGllbnQiLCJ1aWQiOiJ6MDZ0dDhXYlFkcWItUEUyX1JleGt3IiwiaXNzIjoid2ViIiwic3R5IjoxMDAsIndjZCI6InVzMDIiLCJjbHQiOjAsInN0ayI6IjdQUEFVR0JqZnFKb3RnM2kzWEcxWkJZWFpsZlByT09qeVc2TmhLb1pZV28uQmdVc01IZEJNVkEwYlZWdFNrMXVjVXAyTDBjNFJtSnJXbkp2WTNGeVNEaFFVVXROUmpac1NFNXdXV2Q0UVQxQVlqZGlNR0prT0RGaVpERmtNRGd5T1RnM1pHWXlaVEl4TUdJd01HWTNOR1ZpWXpZMlpqZzNPV0UzWVRreE1qWXhaR1ZqTldVellqWXlNRFprWWpNelpRQWdOMmw2YUZoNFFWZ3hSVnBqVFZocVIxRjVRVFl6WTFWWmJVdDZSRlZPZFhFQUJIVnpNREkiLCJleHAiOjE1OTU5NTA0NzEsImlhdCI6MTU5NTk0MzI3MSwiYWlkIjoiV1p2MHdGT1ZUNmFrQjJrV25mM2pSQSIsImNpZCI6IiJ9.a-z7TMLatKgeqGBRH4-bBZnCOrgwQNMFoSomTa8WHMg',
'https://us02web.zoom.us/j/85600068749', 'iWnOYo6FTsCScKEN2r/+Cg==',
0,0,0,1, 35709, '6/17/2020 10:52:00', 94
*/
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_Meeting')
BEGIN
    DROP PROC SAVE_Live_Meeting
END
GO
Create PROC SAVE_Live_Meeting  
(   
 @Company_Id INT,  
 @Center_Id INT,  
 @MeetingHostUserId INT,  
 @MeetingName NVARCHAR(100),  
 @TimeZoneId INT,  
 @MeetingStartTime DATETIME,  
 @MeetingEndTime DATETIME,  
 @MeetingTypeId INT,  
 @MeetingDescription VARCHAR(1000) = '',  
 @ParentIds NVARCHAR(1000) = '',  
 @FamilyIds NVARCHAR(1000) = '',  
 @ChildIds NVARCHAR(1000) = '',  
 @MeetingId VARCHAR(50),  
 @StartURL VARCHAR(4000),  
 @JoinURL VARCHAR(1000),  
 @Uuid VARCHAR(1000),  
 @IsSendReminderHost BIT,  
 @IsSendReminderParticipants BIT,  
 @IsRecordSession  BIT,  
 @MeetingStatus TINYINT,  
 @UserId INT,  
 @TransactionDttm DATETIME,  
 @SysMeetingId INT = 0  
)  
AS  
BEGIN  
 --set dateformat dmy  
 DECLARE @SysLiveLicenseId INT;  
 DECLARE @SysLiveMeetingLicenseId INT;  
 DECLARE @IsMeetingHostUserTimeOverLap BIT;  
 DECLARE @IsMeetingParticipantsTimeOverLap BIT;  
 DECLARE @Error VARCHAR(255);  
  
 SET @IsMeetingHostUserTimeOverLap = 0;  
 SET @IsMeetingParticipantsTimeOverLap = 0;  
 SET @Error = '';   
   
 -- Is meeting host user time overlap  
 SET @IsMeetingHostUserTimeOverLap = dbo.IsMeetingHostUserTimeOverLap(@MeetingHostUserId, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)  
  
 -- Is any meeting participants time Overlap  
 SET @IsMeetingParticipantsTimeOverLap = dbo.IsMeetingParticipantsTimeOverLap(@Company_Id, @Center_Id, @ParentIds, @FamilyIds, @ChildIds, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)  
  
 IF(@IsMeetingHostUserTimeOverLap = 0 AND @IsMeetingParticipantsTimeOverLap = 0)  
 BEGIN  
  
  IF(@MeetingTypeId = 0)  
  BEGIN  
   SET @MeetingTypeId = (SELECT TOP 1 T.SysMeetingTypeId FROM Live_Meeting_Type T WITH (NOLOCK) WHERE (T.Company_Id = @Company_Id OR T.Company_Id = 1) AND (T.Center_Id = @Center_Id OR T.Center_Id = 1))     
  END  
  
  IF(@SysMeetingId = 0)  
  BEGIN  
   SET @SysLiveLicenseId = 1  
   SET @SysLiveMeetingLicenseId = 0  
  END  
  ELSE  
  BEGIN  
   SELECT @SysLiveLicenseId = SysLiveLicenseId, @SysLiveMeetingLicenseId = SysLiveMeetingLicenseId FROM Live_Meetings WITH (NOLOCK) WHERE [SysMeetingId] = @SysMeetingId  
  END  
  
  IF(@SysMeetingId = 0 AND @SysLiveLicenseId = 0)  
  BEGIN  
   SET @SysLiveLicenseId = (SELECT TOP 1 L.SysLiveLicenseId FROM Live_License L WITH (NOLOCK) WHERE (L.Company_Id = @Company_Id OR L.Company_Id = 1) AND (L.Center_Id = @Center_Id OR L.Center_Id = 1))  
  END  
  
  IF(@SysMeetingId = 0 AND @SysLiveMeetingLicenseId = 0)  
  BEGIN  
   SET @SysLiveMeetingLicenseId = dbo.Get_Availalbe_Live_Meeting_License(@SysLiveLicenseId, @MeetingStartTime, @MeetingEndTime)  
  END  
  
  IF(@SysLiveLicenseId > 0 AND @SysLiveMeetingLicenseId > 0 AND @MeetingTypeId > 0)  
  BEGIN  
   --Delete All Existing Participants for the meeting id.  
   DELETE D FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId  
  
   IF(@SysMeetingId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_Meetings WITH (NOLOCK) WHERE [SysMeetingId] = @SysMeetingId))  
   BEGIN  
    UPDATE L  
    SET        
     L.MeetingHostUserId = @MeetingHostUserId,  
     L.MeetingName = @MeetingName,  
     L.TimeZoneId = @TimeZoneId,  
     L.MeetingDate = @MeetingStartTime,  
     L.MeetingStartTime = @MeetingStartTime,  
     L.MeetingEndTime = @MeetingEndTime,  
     L.MeetingTypeId = @MeetingTypeId,  
     L.MeetingDescription = @MeetingDescription,  
     L.IsSendReminderHost = @IsSendReminderHost,  
     L.MeetingId = @MeetingId,  
     L.StartURL = @StartURL,  
     L.JoinURL = @JoinURL,  
     L.Uuid = @Uuid,  
     L.IsSendReminderParticipants = @IsSendReminderParticipants,  
     L.IsRecordSession = @IsRecordSession,  
     L.MeetingStatus = @MeetingStatus,  
     L.ModifiedBy = @UserId,  
     L.ModifiedDttm = @TransactionDttm  
    FROM Live_Meetings L WITH (NOLOCK)  
    WHERE [SysMeetingId] = @SysMeetingId  
   END  
   ELSE  
   BEGIN  
    INSERT INTO Live_Meetings(      
     [SysLiveLicenseId],  
     [SysLiveMeetingLicenseId],  
     [Company_Id],  
     [Center_Id],  
     [MeetingHostUserId],  
     [MeetingName],  
     [TimeZoneId],  
     [MeetingDate],  
     [MeetingStartTime],  
     [MeetingEndTime],  
     [MeetingTypeId],  
     [MeetingDescription],  
     [MeetingId],  
     [StartURL],  
     [JoinURL],  
     [Uuid],  
     [IsSendReminderHost],  
     [IsSendReminderParticipants],  
     [IsRecordSession],  
     [MeetingStatus],  
     [CreatedBy],  
     [CreatedDttm])  
    SELECT   
     @SysLiveLicenseId,  
     @SysLiveMeetingLicenseId,  
     @Company_Id,  
     @Center_Id,  
     @MeetingHostUserId,  
     @MeetingName,  
     @TimeZoneId,  
     @MeetingStartTime,  
     @MeetingStartTime,  
     @MeetingEndTime,  
     @MeetingTypeId,  
     @MeetingDescription,  
     @MeetingId,  
     @StartURL,  
     @JoinURL,  
     @Uuid,  
     @IsSendReminderHost,  
     @IsSendReminderParticipants,  
     @IsRecordSession,  
     @MeetingStatus,  
     @UserId,  
     @TransactionDttm  
  
    SET @SysMeetingId = (SELECT @@IDENTITY)  
   END  
  
   IF (@SysMeetingId > 0 AND @ParentIds <> '')  
   BEGIN  
     
    DECLARE @P_Id INT;  
    DECLARE @MeetingParticipantStatus TINYINT  
    DECLARE @ParentId INT;  
    DECLARE @Family_Id AS INT  
    DECLARE @Child_Id AS INT  
  
    SET @P_Id = 1;  
    SET @MeetingParticipantStatus = @MeetingStatus;  
  
    DECLARE @TempParentIds AS TABLE(Id INT IDENTITY(1,1), ParentId INT)  
    INSERT INTO @TempParentIds(ParentId)  
    SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ParentIds, ',')  
  
    DECLARE @TempFamilyIds AS TABLE(Id INT IDENTITY(1,1), FamilyId INT)  
    INSERT INTO @TempFamilyIds(FamilyId)  
    SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@FamilyIds, ',')  
  
    DECLARE @TempChildIds AS TABLE(Id INT IDENTITY(1,1), ChildId INT)  
    INSERT INTO @TempChildIds(ChildId)  
    SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ChildIds, ',')  
      
    WHILE(@P_Id <= (SELECT MAX(Id) FROM @TempParentIds))  
    BEGIN  
     SELECT @ParentId = ParentId FROM @TempParentIds WHERE Id = @P_Id;  
     SELECT @Family_Id = FamilyId FROM @TempFamilyIds WHERE Id = @P_Id;  
     SELECT @Child_Id = ChildId FROM @TempChildIds WHERE Id = @P_Id;        
  
     ----EXEC SAVE_Live_Meeting_Participant 8, 1046, 1, 92436, 132716, 162449, 1, 1, '2020-06-17 10:52:00.000', NULL  
     EXEC SAVE_Live_Meeting_Participant @SysMeetingId, @Company_Id, @Center_Id, @ParentId, @Family_Id, @Child_Id, @MeetingParticipantStatus, @UserId, @TransactionDttm, NULL  
  
     SET @P_Id = @P_Id + 1;  
    END  
  
   END  
  END  
  
  UPDATE Live_Meetings SET ParticipantsCount = dbo.GetParticipantsCountByMeetingId(@SysMeetingId) WHERE SysMeetingId = @SysMeetingId  
 END  
 ELSE  
 BEGIN  
  IF(@IsMeetingHostUserTimeOverLap = 1) SET @Error ='Meeting Host User Time Overlap';  
  IF(@IsMeetingParticipantsTimeOverLap = 1) SET @Error = @Error + (CASE WHEN dbo.IsHasValue(@Error) = 1 THEN ' And ' ELSE ' ' END) + 'Meeting Participants Time Overlap';  
 END   
  
 SELECT @SysMeetingId [SysMeetingId], @Error [Error];  
END 
GO
-- ======================================================================
-- Author: Manickam.G
-- Create date: 07th Jul 2020
-- Description: Create new stored procedure for update the meeting status from zoom web hooks.
-- Return null
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_End_Meeting_Status')
BEGIN
    DROP PROC Update_End_Meeting_Status
END
GO
Create PROC Update_End_Meeting_Status
(
	@MeetingId VARCHAR(1000),
	@MeetingStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@ActualMeetingStartTime DATETIME = null,
	@ActualMeetingEndTime DATETIME = null
)
AS
BEGIN
	DECLARE @SysMeetingId INT = 0
	SELECT @SysMeetingId = SysMeetingId FROM Live_Meetings L WITH (NOLOCK) WHERE L.MeetingId = @MeetingId

	IF(@SysMeetingId > 0)
	BEGIN		
		EXEC UPDATE_Live_Meeting_Status @SysMeetingId, @MeetingStatus, @UserId, @TransactionDttm, @ActualMeetingStartTime, @ActualMeetingEndTime
	END

	SELECT 'Success' [Status], '' [Error], Company_Id, Center_Id, SysMeetingId, MeetingHostUserId, TimeZoneId FROM Live_Meetings L WITH (NOLOCK) WHERE L.MeetingId = @MeetingId
END
GO
-- ======================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for update the meeting status
-- Return meeting id  as INT
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'UPDATE_Live_Meeting_Status')
BEGIN
    DROP PROC UPDATE_Live_Meeting_Status
END
GO
Create PROC UPDATE_Live_Meeting_Status
(
	@SysMeetingId INT = 0, 
	@MeetingStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@ActualMeetingStartTime DATETIME = null,
	@ActualMeetingEndTime DATETIME = null
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN		
		-- Update Meeting Participants Status

		IF(@MeetingStatus = 3) -- Update End Status.
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingStatus,
				D.ActualMeetingStartTime = ISNULL(D.ActualMeetingStartTime, @ActualMeetingStartTime),
				D.ActualMeetingEndTime = ISNULL(D.ActualMeetingEndTime, @ActualMeetingEndTime),
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysMeetingId = @SysMeetingId
			AND D.MeetingParticipantStatus = 2
		END
		ELSE
		BEGIN
			IF(@MeetingStatus = 6) -- Update End Status.
			BEGIN
				UPDATE D 
				SET D.MeetingParticipantStatus = @MeetingStatus,
					D.ModifiedDttm = @TransactionDttm
				FROM Live_Meeting_Participants D WITH (NOLOCK) 
				WHERE D.SysMeetingId = @SysMeetingId
				AND D.MeetingParticipantStatus = 1
			END
			ELSE IF(@MeetingStatus <> 2)
				BEGIN
					UPDATE D 
					SET D.MeetingParticipantStatus = @MeetingStatus,
						D.ModifiedBy = @UserId,
						D.ModifiedDttm = @TransactionDttm
					FROM Live_Meeting_Participants D WITH (NOLOCK) 
					WHERE D.SysMeetingId = @SysMeetingId
				END
			END

		UPDATE L
		SET 
			L.MeetingStatus = @MeetingStatus,
			L.ActualMeetingStartTime = ISNULL(L.ActualMeetingStartTime, @ActualMeetingStartTime),
			L.ActualMeetingEndTime = @ActualMeetingEndTime,
			L.ParticipantsCount = dbo.GetParticipantsCountByMeetingId(@SysMeetingId),
			L.MeetingAttendeesCount = dbo.GetMeetingAttendeesCount(@SysMeetingId),
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE L.SysMeetingId = @SysMeetingId
	END
END
GO
-- ===============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jul 2020
-- Description: Create new stored procedure for add / update the meeting participants
-- Return meeting id  as INT
-- ===============================================================================================
--Exec Update_Participants 94, '313492,327635', '233876,247993', '255836,270983', 35709, '7/28/2020 11:55:21 AM'
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_Participants')
BEGIN
    DROP PROC Update_Participants
END
GO
Create PROC Update_Participants
(	
	@SysMeetingId INT,
	@ParentIds NVARCHAR(1000) = '',
	@FamilyIds NVARCHAR(1000) = '',
	@ChildIds NVARCHAR(1000) = '',
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	
	DECLARE @IsMeetingParticipantsTimeOverLap BIT;
	DECLARE @Error VARCHAR(255);
	DECLARE	@Company_Id INT
	DECLARE @Center_Id INT
	DECLARE @MeetingStartTime DATETIME
	DECLARE @MeetingEndTime DATETIME

	SET @IsMeetingParticipantsTimeOverLap = 0;
	SET @Error = '';

	SELECT @Company_Id = Company_Id, @Center_Id = Center_Id, @MeetingStartTime = MeetingStartTime , @MeetingEndTime = MeetingEndTime FROM Live_Meetings WITH (NOLOCK) WHERE SysMeetingId = @SysMeetingId
	
	-- Is any meeting participants time Overlap
	SET @IsMeetingParticipantsTimeOverLap = dbo.IsMeetingParticipantsTimeOverLap(@Company_Id,@Center_Id, @ParentIds, @FamilyIds, @ChildIds, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
	
	IF(@IsMeetingParticipantsTimeOverLap = 0)
	BEGIN
		--Delete All Existing Participants for the meeting id.
		DELETE D FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId

		IF (@SysMeetingId > 0 AND @ParentIds <> '')
		BEGIN
			
			DECLARE @P_Id INT;
			DECLARE @MeetingParticipantStatus TINYINT
			DECLARE @ParentId INT;
			DECLARE @Family_Id AS INT
			DECLARE @Child_Id AS INT

			SET @P_Id = 1;
			SET @MeetingParticipantStatus = 1;

			DECLARE @TempParentIds AS TABLE(Id INT IDENTITY(1,1), ParentId INT)
			INSERT INTO @TempParentIds(ParentId)
			SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ParentIds, ',')

			DECLARE @TempFamilyIds AS TABLE(Id INT IDENTITY(1,1), FamilyId INT)
			INSERT INTO @TempFamilyIds(FamilyId)
			SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@FamilyIds, ',')

			DECLARE @TempChildIds AS TABLE(Id INT IDENTITY(1,1), ChildId INT)
			INSERT INTO @TempChildIds(ChildId)
			SELECT ItemValue FROM dbo.SplitIn2Rows_Int(@ChildIds, ',')
				
			WHILE(@P_Id <= (SELECT MAX(Id) FROM @TempParentIds))
			BEGIN
				SELECT @ParentId = ParentId FROM @TempParentIds WHERE Id = @P_Id;
				SELECT @Family_Id = FamilyId FROM @TempFamilyIds WHERE Id = @P_Id;
				SELECT @Child_Id = ChildId FROM @TempChildIds WHERE Id = @P_Id;						

				----EXEC SAVE_Live_Meeting_Participant 8, 1046, 1, 92436, 132716, 162449, 1, 1, '2020-06-17 10:52:00.000', NULL
				EXEC SAVE_Live_Meeting_Participant @SysMeetingId, @Company_Id, @Center_Id, @ParentId, @Family_Id, @Child_Id, @MeetingParticipantStatus, @UserId, @TransactionDttm, NULL

				SET @P_Id = @P_Id + 1;
			END

		END

		UPDATE Live_Meetings SET ParticipantsCount = dbo.GetParticipantsCountByMeetingId(@SysMeetingId) WHERE SysMeetingId = @SysMeetingId
	END
	ELSE
	BEGIN
		IF(@IsMeetingParticipantsTimeOverLap = 1) SET @Error = 'Meeting Participants Time Overlap';
	END

	SELECT @SysMeetingId [SysMeetingId], @Error [Error];
END
GO
