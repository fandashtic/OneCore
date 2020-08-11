IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_License_By_Company_Center')
BEGIN
    DROP PROC GET_Live_License_By_Company_Center
END
GO
Create PROC GET_Live_License_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@LicenseStatus BIT = 1
)
AS
BEGIN

	SELECT	DISTINCT 
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveApiKey,
		L.LiveApiSecret,
		L.LicenseStatus,
		L.CreatedBy,
		L.CreatedDttm
	FROM 
	Live_License L WITH (NOLOCK) 
	WHERE (L.Company_Id = @Company_Id OR L.Company_Id = 0) AND
	(L.Center_Id = @Center_Id OR L.Center_Id = 0) AND
	L.LicenseStatus = @LicenseStatus

END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_License_By_Id')
BEGIN
    DROP PROC GET_Live_License_By_Id
END
GO
Create PROC GET_Live_License_By_Id
(	
	@SysLiveLicenseId INT
)
AS
BEGIN

	SELECT	DISTINCT 
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveApiKey,
		L.LiveApiSecret,
		L.LicenseStatus,
		L.CreatedBy,
		L.CreatedDttm
	FROM 
	Live_License L WITH (NOLOCK) 
	WHERE L.SysLiveLicenseId = @SysLiveLicenseId

END
GO

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
  --ML.LiveMeetingId,
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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_LiveUserAccountDetails')
BEGIN
    DROP PROC GET_LiveUserAccountDetails
END
GO
Create PROC GET_LiveUserAccountDetails 
(
	@UserId INT,
	@TimeZoneId INT,
	@SysMeetingId INT = 0,
	@Company_Id INT = 1,
	@Center_Id INT = 1 
)  
AS  
BEGIN 

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id)
	BEGIN
		SET @Company_Id = 1
	END

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id AND Center_Id = @Center_Id)
	BEGIN
		SET @Center_Id = 1
	END

	IF(ISNULL(@UserId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @UserId = MeetingHostUserId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	IF(ISNULL(@TimeZoneId, 0) = 0 AND ISNULL(@SysMeetingId, 0) > 0)
	BEGIN
		SELECT @TimeZoneId = TimeZoneId FROM Live_Meetings M WITH (NOLOCK) WHERE M.SysMeetingId = @SysMeetingId
	END

	IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE OneCoreUserId = @UserId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)
	BEGIN		
		Update Live_Meeting_License set OneCoreUserId = @UserId, Company_Id = @Company_Id, Center_Id = @Center_Id WHERE SysLiveMeetingLicenseId = (
			SELECT TOP 1 ISNULL(SysLiveMeetingLicenseId, 1) FROM Live_Meeting_License WITH (NOLOCK) WHERE Company_Id = @Company_Id
		)
	END

	SELECT DISTINCT TOP 1 L.LiveApiKey, L.LiveApiSecret, LC.LiveUserName, LC.LiveMeetingPassword, 
	T.TimeZoneInfoId [TimeZoneInfoId],
	M.SysMeetingId, M.MeetingId, M.Uuid
	FROM Live_License L WITH (NOLOCK)
	JOIN Live_Meeting_License LC WITH (NOLOCK) ON LC.SysLiveLicenseId = L.SysLiveLicenseId AND LC.Company_Id = @Company_Id AND LC.Center_Id = @Center_Id
	LEFT JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = @SysMeetingId AND LC.SysLiveMeetingLicenseId = M.SysLiveMeetingLicenseId AND L.SysLiveLicenseId = M.SysLiveLicenseId
	LEFT JOIN timezone T WITH (NOLOCK) ON T.timezone_id = @TimeZoneId
	WHERE LC.OneCoreUserId = @UserId
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_MeetingLicenseByMeetingId')
BEGIN
    DROP PROC GET_MeetingLicenseByMeetingId
END
GO
Create PROC GET_MeetingLicenseByMeetingId (@SysMeetingId INT)
AS  
BEGIN
	SELECT
		L.LiveApiKey, L.LiveApiSecret, 20 [TokenExpiry]
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN Live_License L ON L.SysLiveLicenseId = M.SysLiveLicenseId
	WHERE M.SysMeetingId = @SysMeetingId
END
GO

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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Meeting_Recordings_By_MeetingId')
BEGIN
    DROP PROC Get_Meeting_Recordings_By_MeetingId
END
GO
Create PROC Get_Meeting_Recordings_By_MeetingId 
(   
	@SysMeetingId INT
)  
AS  
BEGIN 
	SELECT 
		R.SysMeetingId,
		Duration,
		Recording_Count,
		Share_Url,
		Start_Time,
		(SELECT TOP 1 t.TimeZoneInfoId FROM timezone t WITH (NOLOCK) WHERE timezone_id = M.TimeZoneId) Timezone,
		R.Uuid,
		Download_Url,
		File_Size,
		File_Type,
		Recording_Id,
		Play_Url,
		Recording_End,
		Recording_Start,
		Recording_Type,
		[Password]
	FROM Live_Meeting_Recordings R WITH (NOLOCK)
	JOIN Live_Meetings M ON M.SysMeetingId = R.SysMeetingId
	WHERE R.SysMeetingId = @SysMeetingId
END
GO

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
	LEFT JOIN User_Details S WITH (NOLOCK) ON S.User_Original_Id = M.MeetingHostUserId 
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo
END 
GO

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
	LEFT JOIN User_Details S WITH (NOLOCK) ON S.User_Original_Id = M.MeetingHostUserId  
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	Order By M.MeetingStatus ASC, M.MeetingStartTime ASC 

	SELECT @CenterTimeZoneId CenterTimeZoneId, @CenterAlternateTimeZoneInfoId CenterAlternateTimeZoneInfoId, @CenterTimeZoneInfo CenterTimeZoneInfo
END 
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_License_By_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_License_By_Company_Center
END
GO
Create PROC GET_Live_Meeting_License_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@MeetingLicenseStatus BIT = 1
)
AS
BEGIN

	IF NOT EXISTS (SELECT TOP 1 1 FROM Live_Meeting_License L WITH (NOLOCK) WHERE Company_Id = @Company_Id)
	BEGIN
		SET @Company_Id = 1
	END

		IF NOT EXISTS (SELECT TOP 1 1 FROM Live_Meeting_License L WITH (NOLOCK) WHERE Company_Id = @Company_Id AND Center_Id = @Center_Id)
	BEGIN
		SET @Center_Id = 1
	END

	SELECT	DISTINCT TOP 1
		L.SysLiveMeetingLicenseId,
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveUserId,
		L.LiveUserName,
		L.LiveMeetingId,
		L.LiveMeetingPassword,
		L.MeetingLicenseStatus,
		L.CreatedBy,
		L.CreatedDttm,
		L.ModifiedBy,
		L.ModifiedDttm
	FROM 
	Live_Meeting_License L WITH (NOLOCK) 
	WHERE L.Company_Id = @Company_Id AND
	L.Center_Id = @Center_Id AND
	L.MeetingLicenseStatus = @MeetingLicenseStatus

END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_License_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_License_By_Id
END
GO
Create PROC GET_Live_Meeting_License_By_Id
(	
	@SysLiveMeetingLicenseId INT
)
AS
BEGIN

	SELECT	DISTINCT 
		L.SysLiveMeetingLicenseId,
		L.SysLiveLicenseId,
		L.Company_Id,
		L.Center_Id,
		L.LiveUserId,
		L.LiveUserName,
		L.LiveMeetingId,
		L.LiveMeetingPassword,
		L.MeetingLicenseStatus,
		L.CreatedBy,
		L.CreatedDttm,
		L.ModifiedBy,
		L.ModifiedDttm
	FROM 
	Live_Meeting_License L WITH (NOLOCK)	
	WHERE L.SysLiveMeetingLicenseId = @SysLiveMeetingLicenseId

END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Live_Eqs')
BEGIN
    DROP PROC Get_Live_Eqs
END
GO
CREATE PROC Get_Live_Eqs      
(  
 @SysParticipantId INT
)      
AS      
BEGIN 
	SELECT TOP 1 Eqs FROM Live_Meeting_Participants WITH (NOLOCK) WHERE SysParticipantId = @SysParticipantId
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_By_Id
END
GO
Create PROC GET_Live_Meeting_By_Id
(	
	@Company_Id INT,
	@Center_Id INT,
	@LiveMeetingType INT
)
AS
BEGIN
	
	DECLARE @TransactionDttm DATETIME
	SET @TransactionDttm = GETDATE();

	IF NOT EXISTS(SELECT TOP 1 1 
		FROM Live_Meeting_Type T WITH (NOLOCK) WHERE 
		T.Company_Id = @Company_Id)
	BEGIN
		EXEC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type @Company_Id, @Center_Id, 0, @TransactionDttm
	END

	IF NOT EXISTS(SELECT TOP 1 1 
		FROM Live_Meeting_Type T WITH (NOLOCK) WHERE 
		T.Company_Id = @Company_Id AND
		T.Center_Id = @Center_Id)
	BEGIN
		EXEC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type @Company_Id, @Center_Id, 0, @TransactionDttm
	END

	SELECT	DISTINCT 
		T.Company_Id,
		T.Center_Id,
		T.SysMeetingTypeId,
		T.MeetingTypeName,
		T.MaxParticipants,
		T.GraceTime,
		T.CallDuration,
		T.IsShowHostVideo,
		T.IsShowParticipantsVideo,
		T.IsMuteParticipant,
		T.IsViewOtherParticipants,
		T.IsJoinbeforeHost,
		T.IsChat,
		T.IsPrivateChat,
		T.IsFileTransfer,
		T.IsScreenSharingByHost,
		T.IsScreenSharingByParticipants,
		T.IsWhiteboard,
		T.MeetingTypeStatus,
		T.ModifiedDttm,
		T.ModifiedBy,
		T.CreatedBy,
		T.CreatedDttm,
		T.IsSendReminderHost,
		T.IsSendReminderParticipants,
		T.IsRecordSession,
		T.AppLiveMeetingId
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE 
		T.Company_Id = @Company_Id AND
		T.Center_Id = @Center_Id AND
		T.AppLiveMeetingId = @LiveMeetingType
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Type_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_Type_By_Id
END
GO
Create PROC GET_Live_Meeting_Type_By_Id  
(   
 @SysMeetingTypeId INT  
)  
AS  
BEGIN  
  
 SELECT DISTINCT   
  T.Company_Id,  
  T.Center_Id,  
  T.SysMeetingTypeId,  
  T.MeetingTypeName,  
  T.MaxParticipants,  
  T.GraceTime,  
  T.CallDuration,  
  T.IsShowHostVideo,  
  T.IsShowParticipantsVideo,  
  T.IsMuteParticipant,  
  T.IsViewOtherParticipants,  
  T.IsJoinbeforeHost,  
  T.IsChat,  
  T.IsPrivateChat,  
  T.IsFileTransfer,  
  T.IsScreenSharingByHost,  
  T.IsScreenSharingByParticipants,  
  T.IsWhiteboard,  
  T.MeetingTypeStatus,  
  T.ModifiedDttm,  
  T.ModifiedBy,  
  T.CreatedBy,  
  T.CreatedDttm,  
  T.IsSendReminderHost,  
  T.IsSendReminderParticipants,  
  T.IsRecordSession,  
  T.AppLiveMeetingId,
  T.MeetingEndBufferTime  
 FROM Live_Meeting_Type T WITH (NOLOCK)  
 WHERE T.SysMeetingTypeId = @SysMeetingTypeId  
  
END  
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Types_By_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Types_By_Company_Center
END
GO
Create PROC GET_Live_Meeting_Types_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL
)
AS
BEGIN

	SELECT	DISTINCT 
		T.Company_Id,
		T.Center_Id,
		T.SysMeetingTypeId,
		T.MeetingTypeName,
		T.MaxParticipants,
		T.GraceTime,
		T.CallDuration,
		T.IsShowHostVideo,
		T.IsShowParticipantsVideo,
		T.IsMuteParticipant,
		T.IsViewOtherParticipants,
		T.IsJoinbeforeHost,
		T.IsChat,
		T.IsPrivateChat,
		T.IsFileTransfer,
		T.IsScreenSharingByHost,
		T.IsScreenSharingByParticipants,
		T.IsWhiteboard,
		T.MeetingTypeStatus,
		T.ModifiedDttm,
		T.ModifiedBy,
		T.CreatedBy,
		T.CreatedDttm,
		T.IsSendReminderHost,
		T.IsSendReminderParticipants,
		T.IsRecordSession,
		T.AppLiveMeetingId
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE (T.Company_Id = @Company_Id OR T.Company_Id = 1) AND
	(T.Center_Id = @Center_Id OR T.Center_Id = 1)

END
GO

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
	 LEFT JOIN User_Details S WITH (NOLOCK) ON S.User_Original_Id = M.MeetingHostUserId  
	 --JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)  
	 JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id  
	 JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id  
	 JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId  
	 JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId  
	 WHERE M.SysMeetingId = @SysMeetingId  
  
END  
GO

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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type')
BEGIN
    DROP PROC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type
END
GO
Create PROC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type  
(   
 @Company_Id INT = 0,  
 @Center_Id INT = 0,  
 @UserId INT,  
 @TransactionDttm DATETIME  
)  
AS  
BEGIN  
 IF(@Company_Id > 0)  
 BEGIN  
  
  IF(@Center_Id > 0)  
  BEGIN  
   Delete C From Live_Meeting_Type C WITH (NOLOCK) WHERE Company_Id = @Company_Id AND Center_Id = @Center_Id AND MeetingTypeName IN (SELECT DISTINCT MeetingTypeName FROM App_Live_Meeting_Type WITH (NOLOCK) WHERE MeetingTypeStatus = 1)  
  END  
  ELSE  
  BEGIN  
   Delete C From Live_Meeting_Type C WITH (NOLOCK) WHERE Company_Id = @Company_Id AND MeetingTypeName IN (SELECT DISTINCT MeetingTypeName FROM App_Live_Meeting_Type WITH (NOLOCK) WHERE MeetingTypeStatus = 1)  
  END  
  
  INSERT INTO Live_Meeting_Type  
   (  
    MeetingTypeName,  
    Company_Id,  
    Center_Id,  
    MaxParticipants,  
    GraceTime,  
    CallDuration,  
    IsShowHostVideo,  
    IsShowParticipantsVideo,  
    IsMuteParticipant,  
    IsViewOtherParticipants,  
    IsJoinbeforeHost,  
    IsChat,  
    IsPrivateChat,  
    IsFileTransfer,  
    IsScreenSharingByHost,  
    IsScreenSharingByParticipants,  
    IsWhiteboard,  
    MeetingTypeStatus,  
    CreatedBy,  
    CreatedDttm,  
    IsSendReminderHost,  
    IsSendReminderParticipants,  
    IsRecordSession,  
    AppLiveMeetingId,
	MeetingEndBufferTime
   )  
   SELECT   
    MeetingTypeName,  
    @Company_Id,  
    @Center_Id,  
    MaxParticipants,  
    GraceTime,  
    CallDuration,  
    IsShowHostVideo,  
    IsShowParticipantsVideo,  
    IsMuteParticipant,  
    IsViewOtherParticipants,  
    IsJoinbeforeHost,  
    IsChat,  
    IsPrivateChat,  
    IsFileTransfer,  
    IsScreenSharingByHost,  
    IsScreenSharingByParticipants,  
    IsWhiteboard,  
    MeetingTypeStatus,  
    @UserId,  
    @TransactionDttm,  
    IsSendReminderHost,  
    IsSendReminderParticipants,  
    IsRecordSession,  
    SysMeetingTypeId,
	MeetingEndBufferTime
  FROM App_Live_Meeting_Type L WITH (NOLOCK)  
  WHERE L.MeetingTypeStatus = 1  
 END  
END  
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_LiveMeeting_Job_Status')
BEGIN
    DROP PROC Update_LiveMeeting_Job_Status
END
GO
Create PROC Update_LiveMeeting_Job_Status (@SysMeetingId INT, @LastJobExecutedOn DATETIME)
AS  
BEGIN

	DECLARE @MeetingEndBufferTime INT
	
	SELECT @MeetingEndBufferTime = T.MeetingEndBufferTime FROM Live_Meeting_Type T WITH (NOLOCK) 
	JOIN Live_Meetings L WITH (NOLOCK) ON L.MeetingTypeId = T.SysMeetingTypeId
	WHERE L.SysMeetingId = @SysMeetingId

	IF(ISNULL(@MeetingEndBufferTime, 0) = 0) SET @MeetingEndBufferTime = 30; -- Default Meeting End buffer time is 30 Minuite.
	
	IF EXISTS(
		SELECT TOP 1 1 
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE SysMeetingId = @SysMeetingId AND
		L.MeetingStatus = 3 AND 
		DATEADD(MINUTE, +(@MeetingEndBufferTime), L.ActualMeetingEndTime) <= @LastJobExecutedOn
	)
	BEGIN
		UPDATE L
			SET L.IsJobExecuted = 1, L.LastJobExecutedOn = @LastJobExecutedOn
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE SysMeetingId = @SysMeetingId
	END
	ELSE
	BEGIN
		UPDATE L
			SET L.IsJobExecuted = 0, L.AppJobHistId = 0
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE SysMeetingId = @SysMeetingId
	END
END
GO

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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'UPDATE_Live_Meeting_Participant_Status')
BEGIN
    DROP PROC UPDATE_Live_Meeting_Participant_Status
END
GO
Create PROC UPDATE_Live_Meeting_Participant_Status
(
	@SysParticipantId INT = 0,
	@MeetingParticipantStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@ActualMeetingStartTime DATETIME = null,
	@ActualMeetingEndTime DATETIME = null,
	@Eqs VARCHAR(4000) = null
)
AS
BEGIN
	IF(@SysParticipantId > 0)
	BEGIN
		IF(@MeetingParticipantStatus = 2) -- Update InProgress Status.
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.ActualMeetingStartTime = ISNULL(D.ActualMeetingStartTime, @ActualMeetingStartTime),
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
		ELSE IF(@MeetingParticipantStatus = 3) -- Update End Status.
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.ActualMeetingStartTime = ISNULL(D.ActualMeetingStartTime, @ActualMeetingStartTime),
				D.ActualMeetingEndTime = @ActualMeetingEndTime,
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
		ELSE
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
	END

	Update M 
	SET M.ParticipantsCount = dbo.GetParticipantsCountByMeetingId(M.SysMeetingId),
	M.MeetingAttendeesCount = dbo.GetMeetingAttendeesCount(M.SysMeetingId)
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN Live_Meeting_Participants LP WITH (NOLOCK) ON LP.SysMeetingId = M.SysMeetingId
	WHERE LP.SysParticipantId = @SysParticipantId

END
GO

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

			UPDATE D 
			SET D.MeetingParticipantStatus = 6, -- Not Attended Meetings are updated as Expired
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysMeetingId = @SysMeetingId
			AND D.MeetingParticipantStatus = 1
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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_Meeting_Eqs')
BEGIN
    DROP PROC Update_Meeting_Eqs
END
GO
Create PROC Update_Meeting_Eqs
(
	@SysParticipantId INT,
	@Eqs VARCHAR(4000)
)
AS
BEGIN	
	IF(@SysParticipantId > 0)
	BEGIN		
		Update L 
		SET L.Eqs = @Eqs
		FROM Live_Meeting_Participants L WITH (NOLOCK)
		WHERE L.SysParticipantId = @SysParticipantId
	END

	SELECT 'Success';
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_Meeting_Recording_PassCode')
BEGIN
    DROP PROC Update_Meeting_Recording_PassCode
END
GO
Create PROC Update_Meeting_Recording_PassCode
(
	@MeetingId VARCHAR(100),
	@Password VARCHAR(10)
)
AS
BEGIN
	IF(ISNULL(@MeetingId, '') <> '' AND ISNULL(@Password, '') <> '')
	BEGIN		
		UPDATE Live_Meeting_Recordings SET [Password] = @Password WHERE Id = @MeetingId
	END
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Save_Actual_Meeting_Participants')
BEGIN
    DROP PROC Save_Actual_Meeting_Participants
END
GO
Create PROC Save_Actual_Meeting_Participants 
(   
	@SysMeetingId INT,
	@Next_Page_Token VARCHAR(255),
	@Page_Count INT,
	@Page_Size INT,
	@Total_Records  INT,
	@Participant_Id VARCHAR(255),
	@Participant_Name VARCHAR(255),
	@Participant_Email VARCHAR(255),
	@Index INT = 0
)  
AS  
BEGIN 
	IF(@Index = 0)
	BEGIN
		DELETE Actual_Meeting_Participants WHERE @SysMeetingId = @SysMeetingId
	END

	INSERT Actual_Meeting_Participants 
	(
		SysMeetingId,
		Next_Page_Token,
		Page_Count,
		Page_Size,
		Total_Records,
		Participant_Id,
		Participant_Name,
		Participant_Email,
		CreatedBy,
		CreatedDttm
	)

	SELECT 
		@SysMeetingId,
		@Next_Page_Token,
		@Page_Count,
		@Page_Size,
		@Total_Records,
		@Participant_Id,
		@Participant_Name,
		@Participant_Email,
		0,
		GETDATE()
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_License')
BEGIN
    DROP PROC SAVE_Live_License
END
GO
Create PROC SAVE_Live_License
(
	@Company_Id INT,
	@Center_Id INT,
	@LiveApiKey VARCHAR(100),
	@LiveApiSecret  VARCHAR(255),
	@LicenseStatus TINYINT,
	@UserId INT,
	@SysLiveLicenseId INT = 0
)
AS
BEGIN
	IF(@SysLiveLicenseId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_License WITH (NOLOCK) WHERE [SysLiveLicenseId] = @SysLiveLicenseId))
	BEGIN
		UPDATE L
		SET 
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
			L.LiveApiKey = @LiveApiKey,
			L.LiveApiSecret = @LiveApiSecret,
			L.LicenseStatus = @LicenseStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = GETDATE()
		FROM Live_License L WITH (NOLOCK)
		WHERE [SysLiveLicenseId] = @SysLiveLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_License([Company_Id],	[Center_Id], [LiveApiKey], [LiveApiSecret], [LicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @Company_Id,	@Center_Id, @LiveApiKey, @LiveApiSecret, @LicenseStatus, @UserId, GETDATE()

		SET @SysLiveLicenseId = @@IDENTITY
	END
	
	RETURN @SysLiveLicenseId;
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_App_Live_Meeting_Type')
BEGIN
    DROP PROC SAVE_App_Live_Meeting_Type
END
GO
Create PROC SAVE_App_Live_Meeting_Type
(	
	@MeetingTypeName VARCHAR(100),
	@MaxParticipants SMALLINT,
	@GraceTime INT,
	@CallDuration INT,
	@IsShowHostVideo BIT,
	@IsShowParticipantsVideo BIT,
	@IsMuteParticipant BIT,
	@IsViewOtherParticipants BIT,
	@IsJoinbeforeHost BIT,
	@IsChat BIT,
	@IsPrivateChat BIT,
	@IsFileTransfer BIT,
	@IsScreenSharingByHost BIT,
	@IsScreenSharingByParticipants BIT,
	@IsWhiteboard BIT,
	@MeetingTypeStatus TINYINT,
	@IsSendReminderHost BIT,
	@IsSendReminderParticipants  BIT,
	@IsRecordSession  BIT,
	@MeetingEndBufferTime INT,
	@UserId INT,
	@SysMeetingTypeId INT = 0
)
AS
BEGIN
	IF(@SysMeetingTypeId > 0 AND EXISTS(SELECT TOP 1 1 FROM App_Live_Meeting_Type WITH (NOLOCK) WHERE SysMeetingTypeId = @SysMeetingTypeId))
	BEGIN
		Update L
		SET 
			L.MeetingTypeName = @MeetingTypeName,
			L.MaxParticipants = @MaxParticipants,
			L.GraceTime= @GraceTime,
			L.CallDuration= @CallDuration,
			L.IsShowHostVideo= @IsShowHostVideo,
			L.IsShowParticipantsVideo= @IsShowParticipantsVideo,
			L.IsMuteParticipant= @IsMuteParticipant,
			L.IsViewOtherParticipants= @IsViewOtherParticipants,
			L.IsJoinbeforeHost= @IsJoinbeforeHost,
			L.IsChat= @IsChat,
			L.IsPrivateChat= @IsPrivateChat,
			L.IsFileTransfer= @IsFileTransfer,
			L.IsScreenSharingByHost= @IsScreenSharingByHost,
			L.IsScreenSharingByParticipants= @IsScreenSharingByParticipants,
			L.IsWhiteboard= @IsWhiteboard,
			L.MeetingTypeStatus= @MeetingTypeStatus,
			L.IsSendReminderHost = @IsSendReminderHost,
			L.IsSendReminderParticipants = @IsSendReminderParticipants,
			L.IsRecordSession = @IsRecordSession,
			L.MeetingEndBufferTime = @MeetingEndBufferTime,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = GETDATE()
		FROM App_Live_Meeting_Type L WITH (NOLOCK)
		WHERE L.SysMeetingTypeId = @SysMeetingTypeId
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 1 FROM App_Live_Meeting_Type L WITH (NOLOCK) WHERE L.SysMeetingTypeId = @SysMeetingTypeId)
		BEGIN
			INSERT INTO App_Live_Meeting_Type
			(
				MeetingTypeName,
				MaxParticipants,
				GraceTime,
				CallDuration,
				IsShowHostVideo,
				IsShowParticipantsVideo,
				IsMuteParticipant,
				IsViewOtherParticipants,
				IsJoinbeforeHost,
				IsChat,
				IsPrivateChat,
				IsFileTransfer,
				IsScreenSharingByHost,
				IsScreenSharingByParticipants,
				IsWhiteboard,
				MeetingTypeStatus,
				IsSendReminderHost,
				IsSendReminderParticipants,
				IsRecordSession,
				MeetingEndBufferTime,
				CreatedBy,
				CreatedDttm
			)
			SELECT 
				@MeetingTypeName,
				@MaxParticipants,
				@GraceTime,
				@CallDuration,
				@IsShowHostVideo,
				@IsShowParticipantsVideo,
				@IsMuteParticipant,
				@IsViewOtherParticipants,
				@IsJoinbeforeHost,
				@IsChat,
				@IsPrivateChat,
				@IsFileTransfer,
				@IsScreenSharingByHost,
				@IsScreenSharingByParticipants,
				@IsWhiteboard,
				@MeetingTypeStatus,
				@IsSendReminderHost,
				@IsSendReminderParticipants,
				@IsRecordSession,
				@MeetingEndBufferTime,
				@UserId,
				GETDATE()

			SET @SysMeetingTypeId = @@IDENTITY;
		END
	END	

	SELECT @SysMeetingTypeId;
END
GO

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

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_Meeting_Participant')
BEGIN
    DROP PROC SAVE_Live_Meeting_Participant
END
GO
Create PROC SAVE_Live_Meeting_Participant
(		
	@SysMeetingId INT = 0,
	@Company_Id INT,
	@Center_Id INT,
	@MeetingParticipantUserId INT,
	@Family_Id INT,
	@Child_Id INT,
	@MeetingParticipantStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,	
	@SysParticipantId INT = 0
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN
		IF(@SysParticipantId > 0)
		BEGIN
			Update L
			SET 
				L.SysMeetingId = @SysMeetingId,
				L.Company_Id = @Company_Id,
				L.Center_Id = @Center_Id,
				L.MeetingParticipantUserId = @MeetingParticipantUserId,
				L.Family_Id = @Family_Id,
				L.Child_Id = @Child_Id,
				L.MeetingParticipantStatus = @MeetingParticipantStatus,
				L.ModifiedBy = @UserId,
				L.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants L WITH (NOLOCK)
			WHERE L.SysParticipantId = @SysParticipantId
		END
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Participants L WITH (NOLOCK) WHERE L.SysMeetingId = @SysMeetingId AND L.MeetingParticipantUserId = @MeetingParticipantUserId AND L.Family_Id = @Family_Id AND L.Child_Id = @Child_Id)
			BEGIN
				INSERT INTO Live_Meeting_Participants
				(
					SysMeetingId,
					Company_Id,
					Center_Id,
					MeetingParticipantUserId,
					Family_Id,
					Child_Id,
					MeetingParticipantStatus,
					CreatedBy,
					CreatedDttm
				)
				SELECT 
					@SysMeetingId,
					@Company_Id,
					@Center_Id,
					@MeetingParticipantUserId,
					@Family_Id,
					@Child_Id,
					@MeetingParticipantStatus,
					@UserId,
					@TransactionDttm
			END
		END
	END	
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Save_Meeting_Recordings')
BEGIN
    DROP PROC Save_Meeting_Recordings
END
GO
Create PROC Save_Meeting_Recordings 
(   
	@SysMeetingId INT,
	@Account_Id VARCHAR(255),
	@Duration INT,
	@Meeting_Host_Id VARCHAR(255),
	@Id VARCHAR(255),
	@Recording_Count INT,
	@Share_Url VARCHAR(255),
	@Start_Time DATETIME,
	@Timezone VARCHAR(255),
	@Topic VARCHAR(255),
	@Total_Size INT,
	@Type VARCHAR(25),
	@Uuid VARCHAR(255),
	@Download_Url VARCHAR(255),
	@File_Size INT,
	@File_Type VARCHAR(25),
	@Recording_Id VARCHAR(255),
	@Meeting_Id VARCHAR(255),
	@Play_Url VARCHAR(255),
	@Recording_End DATETIME,
	@Recording_Start DATETIME,
	@Recording_Type VARCHAR(50),
	@Status VARCHAR(20),
	@Index INT = 0
)  
AS  
BEGIN 

	DECLARE	@Company_Id AS INT
	DECLARE	@Center_Id AS INT
		
	IF(@Index = 0)
	BEGIN
		DELETE Live_Meeting_Recordings WHERE SysMeetingId = @SysMeetingId
		UPDATE Live_Meetings SET IsRecordSession = 1 WHERE SysMeetingId = @SysMeetingId
	END

	SELECT @Company_Id = Company_Id, @Center_Id = Center_Id FROM Live_Meetings L WITH (NOLOCK) WHERE SysMeetingId = @SysMeetingId

	INSERT Live_Meeting_Recordings 
	(
		SysMeetingId,
		Company_Id,
		Center_Id,
		Account_Id,
		Duration,
		Meeting_Host_Id,
		Id,
		Recording_Count,
		Share_Url,
		Start_Time,
		Timezone,
		Topic,
		Total_Size,
		MeetingType,
		Uuid,
		Download_Url,
		File_Size,
		File_Type,
		Recording_Id,
		Meeting_Id,
		Play_Url,
		Recording_End,
		Recording_Start,
		Recording_Type,
		MeetingStatus,
		CreatedBy,
		CreatedDttm
	)

	SELECT 
		@SysMeetingId,
		@Company_Id,
		@Center_Id,
		@Account_Id,
		@Duration,
		@Meeting_Host_Id,
		@Id,
		@Recording_Count,
		@Share_Url,
		@Start_Time,
		@Timezone,
		@Topic,
		@Total_Size,
		@Type,
		@Uuid,
		@Download_Url,
		@File_Size,
		@File_Type,
		@Recording_Id,
		@Meeting_Id,
		@Play_Url,
		@Recording_End,
		@Recording_Start,
		@Recording_Type,
		@Status,
		0,
		GETDATE()
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_Meeting_License')
BEGIN
    DROP PROC SAVE_Live_Meeting_License
END
GO
Create PROC SAVE_Live_Meeting_License
(
	@SysLiveLicenseId INT,
	@Company_Id INT,
	@Center_Id INT,
	@LiveUserId NVARCHAR(100),
	@LiveUserName  NVARCHAR(100),
	@LiveMeetingId NVARCHAR(100),
	@LiveMeetingPassword NVARCHAR(100),	
	@MeetingLicenseStatus TINYINT,
	@UserId INT,
	@SysLiveMeetingLicenseId INT = 0
)
AS
BEGIN
	IF(@SysLiveMeetingLicenseId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE [SysLiveMeetingLicenseId] = @SysLiveMeetingLicenseId))
	BEGIN
		UPDATE L
		SET 
			L.SysLiveLicenseId = @SysLiveLicenseId,
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
			L.LiveUserId = @LiveUserId,
			L.LiveUserName = @LiveUserName,
			L.LiveMeetingId = @LiveMeetingId,
			L.LiveMeetingPassword = @LiveMeetingPassword,
			L.MeetingLicenseStatus = @MeetingLicenseStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = GETDATE()
		FROM Live_Meeting_License L WITH (NOLOCK)
		WHERE [SysLiveMeetingLicenseId] = @SysLiveMeetingLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @SysLiveLicenseId, @Company_Id,	@Center_Id, @LiveUserId, @LiveUserName, @LiveMeetingId, @LiveMeetingPassword, @MeetingLicenseStatus, @UserId, GETDATE()

		SET @SysLiveMeetingLicenseId = @@IDENTITY
	END

	RETURN @SysLiveMeetingLicenseId;
END
GO

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'CreateAppJob_AppProcess')
BEGIN
    DROP PROC CreateAppJob_AppProcess
END
GO
CREATE PROC CreateAppJob_AppProcess (@app_proc_nm VARCHAR(50), @ExePath VARCHAR(1000) = '', @category_id INT = 1, @app_job_freq Varchar(100) = 'Hourly', @app_job_time_interval INT = 30)
AS  
BEGIN
	DECLARE @app_proc_id INT

	IF NOT EXISTS (SELECT TOP 1 1 FROM app_process WITH (NOLOCK) WHERE app_proc_nm = @app_proc_nm)
	BEGIN
		INSERT INTO app_process(app_proc_nm, app_proc_ver, is_proc_active, created_dttm, updated_dttm, app_proc_exec_nm, category_id)
		SELECT @app_proc_nm , 1 ,1, GETDATE() , GETDATE(),  @ExePath, @category_id

		SET @app_proc_id = SCOPE_IDENTITY();

		INSERT INTO app_job (app_proc_id, app_job_status_id, app_job_start_dttm, app_job_end_dttm, 
		app_job_freq, app_job_last_exec_dttm, app_job_time_interval, created_dttm,updated_dttm)
		SELECT @app_proc_id , 1 ,GETDATE() ,'9999-12-31 00:00:00.000' ,@app_job_freq , GETDATE(), @app_job_time_interval ,GETDATE(), GETDATE()	

		SELECT SCOPE_IDENTITY();
	END
	ELSE
	BEGIN
		SELECT J.app_job_id FROM app_process P WITH (NOLOCK) 
		JOIN app_job J WITH (NOLOCK) ON J.app_proc_id = P.app_proc_id
		WHERE P.app_proc_nm = @app_proc_nm
	END
END
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Hosts_Company_Center
END
GO
Create PROC GET_Live_Meeting_Hosts_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL
)
AS
BEGIN

	SELECT	DISTINCT 
		U.User_Id,
		U.FirstName,
		U.LastName,
		(SELECT TOP 1 timezone_id FROM Center_details C WITH (NOLOCK) WHERE C.Company_Id = @Company_Id AND C.Center_ID = @Center_Id) timezone_id
	FROM app_role AR WITH (NOLOCK)
	JOIN company_app_role  CAR WITH (NOLOCK) ON CAR.app_role_id = AR.app_role_id
	JOIN user_role UR WITH (NOLOCK) ON UR.company_app_role_id = CAR.company_app_role_id
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = UR.user_id
	WHERE (CAR.company_id = @Company_Id OR CAR.Company_Id = 1) AND	
	U.FirstName IS NOT NULL AND
	U.LastName IS NOT NULL AND
	AR.app_role_id IN (1,2,3,4, 5)

END
GO
-- ======================================================================================                     
-- Author :      
-- -------- Change History --------------------------------------------------------------                                                                                        
-- Modfied by         | Modified on       |Change Description                                                                                            
-- --------------------------------------------------------------------------------------                      
-- Arun        17-Sep-2018     Added New Column TimeZoneValue for ClassAPI    
-- ======================================================================================    
-- =================================================================================================
-- Author: Manickam.G
-- Create date: 28th Jul 2020
-- Description: Add AlternateTimeZoneInfoId column
-- Return details list
-- =================================================================================================
--Exec get_Time_Zone 0
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'get_Time_Zone')
BEGIN
    DROP PROC get_Time_Zone
END
GO
CREATE procedure get_Time_Zone           
	@timezone_id int      
AS
SET NOCOUNT ON            
BEGIN        
IF(ISNULL(@timezone_id,0) >0)  
 BEGIN  
	SELECT 
		timezone_id,
		timezone_nm,
		timezone_utc_offset,
		timezone_status,
		abbreviation,  
		offset,TimeZoneInfoId,
		TimeZoneValue,
		AlternateTimeZoneInfoId       
	FROM timezone WITH (NOLOCK) 
	WHERE timezone_id = @timezone_id AND AlternateTimeZoneInfoId IS NOT NULL    
 END  
ELSE  
 BEGIN  
    DECLARE @active_status INT   
	
	SELECT @active_status = dbo.FN_FamilyStatus('ACTIVE')  
	
	SELECT
		timezone_id,
		timezone_nm,
		timezone_utc_offset,
		timezone_status,
		abbreviation,  
		offset,TimeZoneInfoId,
		TimeZoneValue,
		AlternateTimeZoneInfoId
	FROM timezone WITH (NOLOCK)    
	WHERE timezone_status = @active_status  AND AlternateTimeZoneInfoId IS NOT NULL

 END  
END      
GO

