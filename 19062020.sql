-- ===============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the meeting details and participants
-- Return meeting id  as INT
-- ===============================================================================================
--Exec SAVE_Live_Meeting 1046, 1, 247, 'DBS', 7, '6/17/2020 2:04:00 AM', '6/17/2020 4:06:00 AM', 1, 'SFG', '92436', '132716', '162449',  0, 1, 0, 0, '6/17/2020 10:52:00', 0
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
	
	DECLARE @SysLiveLicenseId INT;
	DECLARE @SysLiveMeetingLicenseId INT;
	DECLARE @IsMeetingHostUserTimeOverLap BIT;
	DECLARE @IsMeetingParticipantsTimeOverLap BIT;
	DECLARE @Error VARCHAR(255);

	SET @IsMeetingHostUserTimeOverLap = 0;
	SET @IsMeetingParticipantsTimeOverLap = 0;
	SET @Error = '';	
	
	-- Is meeting host user time overlap
	--SET @IsMeetingHostUserTimeOverLap = dbo.IsMeetingHostUserTimeOverLap(@MeetingHostUserId, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)

	-- Is any meeting participants time Overlap
	--SET @IsMeetingParticipantsTimeOverLap = dbo.IsMeetingParticipantsTimeOverLap(@ParentIds, @FamilyIds, @ChildIds, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
	
	IF(@IsMeetingHostUserTimeOverLap = 0 AND @IsMeetingParticipantsTimeOverLap = 0)
	BEGIN

		IF(@MeetingTypeId = 0)
		BEGIN
			SET @MeetingTypeId = (SELECT TOP 1 T.SysMeetingTypeId FROM Live_Meeting_Type T WITH (NOLOCK) WHERE (T.Company_Id = @Company_Id OR T.Company_Id = 1) AND (T.Center_Id = @Center_Id OR T.Center_Id = 1))			
		END

		IF(@SysMeetingId = 0)
		BEGIN
			SET @SysLiveLicenseId = 0
			SET @SysLiveMeetingLicenseId = 0
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
					--L.SysLiveLicenseId = @SysLiveLicenseId,
					--L.SysLiveMeetingLicenseId = @SysLiveMeetingLicenseId,
					--L.Company_Id = @Company_Id,
					--L.Center_Id = @Center_Id,				
					L.MeetingHostUserId = @MeetingHostUserId,
					L.MeetingName = @MeetingName,
					L.TimeZoneId = @TimeZoneId,
					L.MeetingStartTime = @MeetingStartTime,
					L.MeetingEndTime = @MeetingEndTime,
					L.MeetingTypeId = @MeetingTypeId,
					L.MeetingDescription = @MeetingDescription,
					L.IsSendReminderHost = @IsSendReminderHost,
					L.IsSendReminderParticipants = @IsSendReminderParticipants,
					L.IsRecordSession = @IsRecordSession,
					L.MeetingsStatus = @MeetingStatus,
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
					[MeetingStartTime],
					[MeetingEndTime],
					[MeetingTypeId],
					[MeetingDescription],
					[IsSendReminderHost],
					[IsSendReminderParticipants],
					[IsRecordSession],
					[MeetingsStatus],
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
					@MeetingEndTime,
					@MeetingTypeId,
					@MeetingDescription,
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
	END
	ELSE
	BEGIN
		IF(@IsMeetingHostUserTimeOverLap = 1) SET @Error = @Error + (CASE WHEN dbo.IsHasValue(@Error) = 1 THEN ' ,' ELSE '' END) + 'Meeting Host User Time Overlap';
		IF(@IsMeetingParticipantsTimeOverLap = 1) SET @Error = @Error + (CASE WHEN dbo.IsHasValue(@Error) = 1 THEN ' ,' ELSE '' END) + 'Meeting Participants Time Overlap';
	END

	SELECT @SysMeetingId [SysMeetingId], @Error [Error];
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
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN
		UPDATE L
		SET 
			L.MeetingsStatus = @MeetingStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE L.SysMeetingId = @SysMeetingId
		
		-- Update Meeting Participants Status

		UPDATE D 
		SET D.MeetingParticipantStatus = @MeetingStatus,
			D.ModifiedBy = @UserId,
			D.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId

	END
END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting license details by meeting id
-- Return live license details list
-- ==============================================================================================
--Exec GET_Live_Meeting_LicenseDetails_By_MeetingId 1,0
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
    DROP PROC GET_Live_Meeting_LicenseDetails_By_MeetingId
END
GO
Create PROC GET_Live_Meeting_LicenseDetails_By_MeetingId
(	
	@SysMeetingId INT,
	@ParentId INT = 0
)
AS
BEGIN
	DECLARE @DisplayNameFirstName AS varbinary(800)
	DECLARE @DisplayNameLastName AS varbinary(800)
	DECLARE @MeetingRole AS INT
	DECLARE @MeetingUserId AS INT

	IF(@ParentId > 0)
	BEGIN
		SET @MeetingRole = 0
		SET @MeetingUserId = @ParentId
	END
	ELSE
	BEGIN
		SET @MeetingRole = 1
		SET @MeetingUserId = (SELECT TOP 1 L.MeetingHostUserId FROM Live_Meetings L WITH (NOLOCK) WHERE L.SysMeetingId = @SysMeetingId)
	END

	SELECT @DisplayNameFirstName = U.FirstName, @DisplayNameLastName = U.LastName FROM User_Details U WITH (NOLOCK) WHERE User_Id = @MeetingUserId

	SELECT	DISTINCT 
		L.LiveApiKey,
		L.LiveApiSecret,		
		ML.LiveUserId,
		ML.LiveUserName,
		ML.LiveMeetingId,
		ML.LiveMeetingPassword,
		T.CallDuration,
		'' [LeaveUrl],
		@DisplayNameFirstName DisplayNameFirstName,
		@DisplayNameLastName DisplayNameLastName,
		@MeetingRole MeetingRole,
		T.SysMeetingTypeId,
		M.IsRecordSession
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN Live_Meeting_License ML WITH (NOLOCK) ON ML.SysLiveMeetingLicenseId = M.SysLiveMeetingLicenseId 
	JOIN Live_License L WITH (NOLOCK) ON L.SysLiveLicenseId = M.SysLiveLicenseId
	JOIN Live_Meeting_Type T WITH (NOLOCK) ON T.SysMeetingTypeId = M.MeetingTypeId
	WHERE M.SysMeetingId = @SysMeetingId

END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Company_Center 1046, 1, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Company_Center')
BEGIN
    DROP PROC GET_Meetings_By_Company_Center
END
GO
Create PROC GET_Meetings_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@MeetingStatus TINYINT = 1
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
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
	--JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)
	JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id
	JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId
	WHERE (M.Company_Id = @Company_Id OR M.Company_Id = 0) AND
	(M.Center_Id = @Center_Id OR M.Center_Id = 0) AND
	(M.MeetingsStatus = @MeetingStatus OR M.MeetingsStatus = 0)

END
GO

-- =================================================================================================
-- Author: Gifla
-- Create date: 17th Jun 2020
-- Description: Create new stored procedure to get live meeting details by Participant
-- Return meeting details list
-- =================================================================================================
--Exec GET_Meetings_List_For_Parent 1046, 1, 1, 92436
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
	JOIN Live_Meeting_Participants LMP  WITH (NOLOCK) ON LMP.SysMeetingId = LMP.SysMeetingId
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = M.CreatedBy
	JOIN User_Details H WITH (NOLOCK) ON H.User_Id = M.MeetingHostUserId
	--JOIN User_Details MU WITH (NOLOCK) ON (MU.User_Id = M.ModifiedBy OR MU.User_Id = 0)
	JOIN Company_Details C WITH (NOLOCK) ON C.Company_Id = M.Company_Id
	JOIN Center_Details CE WITH (NOLOCK) ON CE.Company_Id = M.Company_Id AND CE.Center_ID = M.Center_Id
	JOIN timezone T WITH (NOLOCK) ON T.timezone_id = M.TimeZoneId
	JOIN Live_Meeting_Type L WITH (NOLOCK) ON L.SysMeetingTypeId = M.MeetingTypeId
	WHERE LMP.MeetingParticipantUserId =  @ParentId 
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (81, 'http://localhost:4255/#/live/close', 'Meeting Leave PP Url')
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (81, 'http://localhost:4255/#/live/close', 'Meeting Leave PP Url')
END
GO