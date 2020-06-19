-- =============================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table Live_License
-- =============================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_License')
BEGIN
    DROP TABLE Live_License
END
GO
Create Table Live_License
(
	[SysLiveLicenseId] INT NOT NULL IDENTITY (1,1),
	[Company_Id] INT NOT NULL,
	[Center_Id] INT NULL,
	[LiveApiKey] VARCHAR(100) NOT NULL,
	[LiveApiSecret]  VARCHAR(255) NOT NULL,
	[LicenseStatus] TINYINT NOT NULL DEFAULT 1, -- 1 Active, 0 - InActive
	[CreatedBy] INT NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] INT NULL,
	[ModifiedDttm] [datetime] NULL
)
GO

-- ===================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table Live_Meeting_License
-- ==================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_License')
BEGIN
    DROP TABLE Live_Meeting_License
END
GO
Create Table Live_Meeting_License
(
	[SysLiveMeetingLicenseId] INT NOT NULL IDENTITY (1,1),
	[SysLiveLicenseId] INT NOT NULL,
	[Company_Id] INT NOT NULL,
	[Center_Id] INT NULL,
	[LiveUserId] NVARCHAR(100) NOT NULL,
	[LiveUserName]  NVARCHAR(100) NOT NULL,
	[LiveMeetingId] NVARCHAR(100) NOT NULL,
	[LiveMeetingPassword] NVARCHAR(100) NOT NULL,	
	[MeetingLicenseStatus] TINYINT NOT NULL DEFAULT 1, -- 1 Active, 0 - InActive
	[CreatedBy] INT NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] INT NULL,
	[ModifiedDttm] [datetime] NULL
)
GO

-- ===================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table Live_Meetings
-- ==================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meetings')
BEGIN
    DROP TABLE Live_Meetings
END
GO
Create Table Live_Meetings
(
	[SysMeetingId] INT NOT NULL IDENTITY (1,1),
	[SysLiveLicenseId] INT NOT NULL,
	[SysLiveMeetingLicenseId] INT NOT NULL,
	[Company_Id] INT NOT NULL,
	[Center_Id] INT NULL,
	[MeetingHostUserId] INT NOT NULL,
	[MeetingName] NVARCHAR(100) NOT NULL,
	[TimeZoneId] INT NOT NULL,
	[MeetingStartTime] DATETIME NOT NULL,
	[MeetingEndTime] DATETIME NOT NULL,
	[MeetingTypeId] INT NOT NULL,
	[MeetingDescription] VARCHAR(1000) NULL,	
	[IsSendReminderHost] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
	[IsSendReminderParticipants] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
	[IsRecordSession]  BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
	[MeetingsStatus] TINYINT NOT NULL DEFAULT 1, -- 1 -Pending, 2 - Completed, 3 - Rejected
	[CreatedBy] INT NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] INT NULL,
	[ModifiedDttm] [datetime] NULL
)
GO

-- =======================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table Live_Meeting_Participants
-- =======================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Participants')
BEGIN
	DROP TABLE Live_Meeting_Participants
END
GO
Create Table Live_Meeting_Participants
(
    [SysParticipantId] INT NOT NULL IDENTITY (1,1),
    [SysMeetingId] INT NOT NULL,
    [Company_Id] INT NOT NULL,
    [Center_Id] INT NULL,
    [MeetingParticipantUserId] INT NOT NULL,
    [Family_Id] INT NULL,
    [Child_Id] INT NULL,
    [MeetingParticipantStatus] TINYINT NOT NULL DEFAULT 1, -- 1 Scheduled, 2 Completed, 3 Rejected, 4 Expaired.
    [CreatedBy] INT NULL,
    [CreatedDttm] [datetime] NULL,
    [ModifiedBy] INT NULL,
    [ModifiedDttm] [datetime] NULL
)
GO

-- =======================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table App_Live_Meeting_Type
-- =======================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'App_Live_Meeting_Type')
BEGIN
	DROP TABLE App_Live_Meeting_Type
END
GO
Create Table App_Live_Meeting_Type
(
    [SysMeetingTypeId] INT NOT NULL IDENTITY (1,1),
    [MeetingTypeName] VARCHAR(100) NOT NULL,
    [MaxParticipants] SMALLINT NOT NULL DEFAULT 1,
    [GraceTime] INT NOT NULL DEFAULT 30, -- 30 Min
    [CallDuration] INT NOT NULL DEFAULT 60, -- 1Hr (60 Min)
    [IsShowHostVideo] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsShowParticipantsVideo] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsMuteParticipant] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsViewOtherParticipants] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsJoinbeforeHost] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsChat] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsPrivateChat] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsFileTransfer] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsScreenSharingByHost] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsScreenSharingByParticipants] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsWhiteboard] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [MeetingTypeStatus] TINYINT NOT NULL DEFAULT 1,-- 1Active, 0 - InActive
    [CreatedBy] INT NULL,
    [CreatedDttm] [datetime] NULL,
    [ModifiedBy] INT NULL,
    [ModifiedDttm] [datetime] NULL
)
GO

-- =======================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table Live_Meeting_Type
-- =======================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Type')
BEGIN
	DROP TABLE Live_Meeting_Type
END
GO
Create Table Live_Meeting_Type
(
    [SysMeetingTypeId] INT NOT NULL IDENTITY (1,1),
    [MeetingTypeName] VARCHAR(100) NOT NULL,
    [Company_Id] INT NOT NULL,
    [Center_Id] INT NULL,
    [MaxParticipants] SMALLINT NOT NULL DEFAULT 1,
    [GraceTime] INT NOT NULL DEFAULT 30, -- 30 Min
    [CallDuration] INT NOT NULL DEFAULT 60, -- 1Hr (60 Min)
    [IsShowHostVideo] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsShowParticipantsVideo] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsMuteParticipant] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsViewOtherParticipants] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsJoinbeforeHost] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsChat] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsPrivateChat] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsFileTransfer] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsScreenSharingByHost] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsScreenSharingByParticipants] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [IsWhiteboard] BIT NOT NULL DEFAULT 0, -- 1Active, 0 - InActive
    [MeetingTypeStatus] TINYINT NOT NULL DEFAULT 1,-- 1Active, 0 - InActive
    [CreatedBy] INT NULL,
    [CreatedDttm] [datetime] NULL,
    [ModifiedBy] INT NULL,
    [ModifiedDttm] [datetime] NULL
)
GO


-- General Functions:

-- =================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table-valued function for split string to int rows by separator.
-- Return table object with "ItemValue" column as int.
-- =================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SplitIn2Rows_Int')
BEGIN
    DROP FUNCTION dbo.SplitIn2Rows_Int
END
GO
CREATE FUNCTION dbo.SplitIn2Rows_Int(@Source nvarchar(4000) = NULL, @Separator char(1) = ',')    
	RETURNS @ARRAY TABLE (ItemValue Int )    
AS    
BEGIN    
	DECLARE @CurrentStr nvarchar(2000)    
	DECLARE @ItemStr Int
     
	SET @CurrentStr = @Source    
      
	WHILE Datalength(@CurrentStr) > 0    
	BEGIN    
		IF CHARINDEX(@Separator, @CurrentStr,1) > 0     
		BEGIN    
			SET @ItemStr = cast(SUBSTRING (@CurrentStr, 1, CHARINDEX(@Separator, @CurrentStr,1) - 1)    as Int)
			SET @CurrentStr = SUBSTRING (@CurrentStr, CHARINDEX(@Separator, @CurrentStr,1) + 1, (Datalength(@CurrentStr) - CHARINDEX(@Separator, @CurrentStr,1) + 1))    
			INSERT @ARRAY (ItemValue) VALUES (@ItemStr)    
		END    
		ELSE    
		BEGIN                    
			INSERT @ARRAY (ItemValue) VALUES (cast(@CurrentStr as Int))        
			BREAK;    
		END     
	END    
	RETURN;
END 
GO

-- ===============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for validate the given string variant has value or not. 
-- Return bit value
-- ===============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'IsHasValue')
BEGIN
    DROP FUNCTION dbo.IsHasValue
END
GO
CREATE FUNCTION dbo.IsHasValue(@Data nvarchar(4000) = NULL)    
	RETURNS BIT   
AS    
BEGIN    
	DECLARE @IsHasValue BIT
	SET @IsHasValue = 0;
	
	IF(ISNULL(@IsHasValue, '') <> '') SET @IsHasValue = 1;

	RETURN @IsHasValue;
END 
GO

-- Live Meeting Validation functions:

-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for validate the given host is already scheduled with any other meeting for the same time.
-- Return bit value
-- ==================================================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'IsMeetingHostUserTimeOverLap')
BEGIN
    DROP FUNCTION dbo.IsMeetingHostUserTimeOverLap
END
GO
Create FUNCTION dbo.IsMeetingHostUserTimeOverLap(@MeetingHostUserId INT, @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT)  
Returns BIT
AS  
BEGIN 
	DECLARE @IsMeetingHostUserTimeOverLap BIT;
	SET @IsMeetingHostUserTimeOverLap = 0;

	IF EXISTS (SELECT TOP 1 1 
				FROM Live_Meetings L WITH (NOLOCK) 
				WHERE L.MeetingHostUserId = @MeetingHostUserId AND 
				@MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	IF EXISTS (SELECT TOP 1 1 
				FROM Live_Meetings L WITH (NOLOCK) 
				WHERE L.MeetingHostUserId = @MeetingHostUserId AND 
				@MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	RETURN @IsMeetingHostUserTimeOverLap;
END
GO

-- ===========================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for validate the given participants are already scheduled with any other meeting for the same time.
-- Return bit value
-- ===========================================================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'IsMeetingParticipantsTimeOverLap')
BEGIN
    DROP FUNCTION dbo.IsMeetingParticipantsTimeOverLap
END
GO
Create FUNCTION dbo.IsMeetingParticipantsTimeOverLap(@ParentIds NVARCHAR(1000), @FamilyIds NVARCHAR(1000), @ChildIds NVARCHAR(1000), @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT)  
Returns BIT
AS  
BEGIN 
	DECLARE @IsMeetingParticipantsTimeOverLap BIT;
	DECLARE @ParentId INT;
	DECLARE @FamilyId INT;
	DECLARE @ChildId INT;
	DECLARE @Id INT;
	DECLARE @P_Id INT;
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
		WHERE L.MeetingParticipantUserId = @ParentId AND L.Family_Id = @FamilyId AND L.Child_Id = @ChildId  AND MeetingParticipantStatus = 1

		SET @P_Id = 1;

		WHILE(@P_Id <= (SELECT MAX(P_Id) FROM @TempParticipant_Meetings))
		BEGIN

			SELECT @SysMeetingId = SysMeetingId FROM @TempParticipant_Meetings WHERE P_Id = @P_Id;

			IF EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE @MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))
			BEGIN
				SET @IsMeetingParticipantsTimeOverLap = 1;
				BREAK; 
			END

			IF EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE @MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))						
			BEGIN
				SET @IsMeetingParticipantsTimeOverLap = 1;
				BREAK; 
			END

			SET @P_Id = @P_Id + 1;
		END

		SET @Id = @Id + 1;
	END

	RETURN @IsMeetingParticipantsTimeOverLap;
END
GO

-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for collect all Participants details and return as comma seprated string.
-- Return comma seprated value
-- ==================================================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GetParticipantsByMeetingId')
BEGIN
    DROP FUNCTION dbo.GetParticipantsByMeetingId
END
GO
Create FUNCTION dbo.GetParticipantsByMeetingId(@SysMeetingId INT)
Returns VARCHAR(1000)
AS  
BEGIN 
	DECLARE @Participants VARCHAR(1000);
	SET @Participants = '';

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		DECLARE @TempParticipants AS TABLE(Id INT Identity(1,1), ParticipantId VARCHAR(1000))
		
		INSERT INTO @TempParticipants(ParticipantId)
		SELECT DISTINCT CAST(D.MeetingParticipantUserId AS VARCHAR) + ':' + CAST(D.Family_Id AS VARCHAR) + ':' + CAST(D.Child_Id AS VARCHAR)
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId AND
		D.MeetingParticipantStatus IN (1, 2)

		Declare @Id AS INT
		SET @Id = 1
		WHILE(@Id <= (SELECT Max(Id) From @TempParticipants))
		BEGIN
			IF(ISNULL(@Participants, '') <> '') 
			BEGIN
				SET @Participants = @Participants + ','
			END

			SET @Participants = @Participants + (SELECT TOP 1 ParticipantId From @TempParticipants WHERE Id = @Id)
			
			SET @Id = @Id + 1
		END

	END

	RETURN @Participants;
END
GO

-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for collect all Participants details and return as comma seprated string.
-- Return comma seprated value
-- ==================================================================================================================================
--select dbo.GetParticipantsCountByMeetingId(1)
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GetParticipantsCountByMeetingId')
BEGIN
    DROP FUNCTION dbo.GetParticipantsCountByMeetingId
END
GO
Create FUNCTION dbo.GetParticipantsCountByMeetingId(@SysMeetingId INT)
Returns INT
AS  
BEGIN 
	DECLARE @ParticipantsCount INT
	SET @ParticipantsCount = 0;

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		SET @ParticipantsCount = (SELECT COUNT(DISTINCT MeetingParticipantUserId) FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	END

	RETURN @ParticipantsCount;
END
GO

-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 15th Jun 2020
-- Description: Create new scalar function for get available meeting licence id.
-- Return live meeting license id
-- ==================================================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Availalbe_Live_Meeting_License')
BEGIN
    DROP FUNCTION dbo.Get_Availalbe_Live_Meeting_License
END
GO
Create FUNCTION dbo.Get_Availalbe_Live_Meeting_License(@SysLiveLicenseId INT, @MeetingStartTime DATETIME, @MeetingEndTime DATETIME)
Returns INT
AS  
BEGIN 
	DECLARE @SysLiveMeetingLicenseId INT;
	SET @SysLiveMeetingLicenseId = 0;

	IF EXISTS (SELECT TOP 1 1 FROM Live_License D WITH (NOLOCK) WHERE D.SysLiveLicenseId = @SysLiveLicenseId)
	BEGIN
		DECLARE @TempLiveMeetingLicenses AS TABLE(Id INT Identity(1,1), SysLiveMeetingLicenseId INT)
		
		INSERT INTO @TempLiveMeetingLicenses(SysLiveMeetingLicenseId)
		SELECT DISTINCT SysLiveMeetingLicenseId
		FROM Live_Meeting_License D WITH (NOLOCK) 
		WHERE D.SysLiveLicenseId = @SysLiveLicenseId AND
		D.MeetingLicenseStatus = 1

		Declare @Id AS INT
		SET @Id = 1
		WHILE(@Id <= (SELECT Max(Id) From @TempLiveMeetingLicenses))
		BEGIN			
			SET @SysLiveMeetingLicenseId = (SELECT TOP 1 SysLiveMeetingLicenseId From @TempLiveMeetingLicenses WHERE Id = @Id)
			
			IF NOT EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE @MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND L.SysLiveLicenseId = @SysLiveLicenseId)
			BEGIN
				IF NOT EXISTS (SELECT TOP 1 1 
							FROM Live_Meetings L WITH (NOLOCK)
							WHERE @MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
							AND L.SysLiveLicenseId = @SysLiveLicenseId)						
				BEGIN
					BREAK; 
				END
			END

			SET @Id = @Id + 1
		END

	END

	RETURN @SysLiveMeetingLicenseId;
END
GO

-- Stored Procedures:

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for validate the given host is already scheduled with any other meeting for the same time.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_IsMeetingHostUserTimeOverLap')
BEGIN
    DROP PROC GET_IsMeetingHostUserTimeOverLap
END
GO
Create PROC GET_IsMeetingHostUserTimeOverLap
(
	@MeetingHostUserId INT, @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT
)
AS
BEGIN
	SELECT dbo.IsMeetingHostUserTimeOverLap(@MeetingHostUserId, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
END
GO


-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for validate the given participants are already scheduled with any other meeting for the same time.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_IsMeetingParticipantsTimeOverLap')
BEGIN
    DROP PROC GET_IsMeetingParticipantsTimeOverLap
END
GO
Create PROC GET_IsMeetingParticipantsTimeOverLap
(
	@Participants NVARCHAR(1000), @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT
)
AS
BEGIN
	SELECT dbo.IsMeetingParticipantsTimeOverLap(@Participants, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the live integration details.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
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
	@TransactionDttm DATETIME,
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
			L.ModifiedDttm = @TransactionDttm
		FROM Live_License L WITH (NOLOCK)
		WHERE [SysLiveLicenseId] = @SysLiveLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_License([Company_Id],	[Center_Id], [LiveApiKey], [LiveApiSecret], [LicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @Company_Id,	@Center_Id, @LiveApiKey, @LiveApiSecret, @LicenseStatus, @UserId, @TransactionDttm

		SET @SysLiveLicenseId = @@IDENTITY
	END
	
	RETURN @SysLiveLicenseId;
END
GO

-- =======================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the live meeting integration details.
-- Return SysLiveMeetingLicenseId as INT
-- =======================================================================================
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
	@TransactionDttm DATETIME,
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
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_License L WITH (NOLOCK)
		WHERE [SysLiveMeetingLicenseId] = @SysLiveMeetingLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @SysLiveLicenseId, @Company_Id,	@Center_Id, @LiveUserId, @LiveUserName, @LiveMeetingId, @LiveMeetingPassword, @MeetingLicenseStatus, @UserId, @TransactionDttm

		SET @SysLiveMeetingLicenseId = @@IDENTITY
	END

	RETURN @SysLiveMeetingLicenseId;
END
GO

-- ==========================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the meeting participant details.
-- Return SysParticipantId  as INT
-- ==========================================================================================
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
	@MeetingsStatus TINYINT,
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
					L.MeetingsStatus = @MeetingsStatus,
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
					@MeetingsStatus,
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
				SET @MeetingParticipantStatus = @MeetingsStatus;

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
	@MeetingsStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN
		UPDATE L
		SET 
			L.MeetingsStatus = @MeetingsStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE L.SysMeetingId = @SysMeetingId
		
		-- Update Meeting Participants Status

		UPDATE D 
		SET D.MeetingParticipantStatus = @MeetingsStatus,
			D.ModifiedBy = @UserId,
			D.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId

	END
END
GO

-- ==================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for update the meeting participant status
-- Return meeting id  as INT
-- ==================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'UPDATE_Live_Meeting_Participant_Status')
BEGIN
    DROP PROC UPDATE_Live_Meeting_Participant_Status
END
GO
Create PROC UPDATE_Live_Meeting_Participant_Status
(
	@SysParticipantId INT = 0,
	@FamilyId INT = 0,
	@ChildId INT = 0,
	@MeetingParticipantStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysParticipantId > 0)
	BEGIN
		UPDATE L
		SET 
			L.MeetingParticipantStatus = @MeetingParticipantStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Participants L WITH (NOLOCK)
			WHERE L.SysParticipantId = @SysParticipantId AND
			L.Family_Id = @FamilyId AND
			L.Child_Id = @ChildId

	END
END
GO

-- ==========================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the app level meeting type and details.
-- Return SysMeetingTypeId  as INT
-- ==========================================================================================
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
	@SysMeetingTypeId INT = 0,
	@UserId INT,
	@TransactionDttm DATETIME
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
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
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
				@UserId,
				@TransactionDttm

			SET @SysMeetingTypeId = @@IDENTITY;
		END
	END	

	SELECT @SysMeetingTypeId;
END
GO

-- ==========================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the custom center level meeting type and details.
-- Return SysMeetingTypeId  as INT
-- ==========================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Custom_Live_Meeting_Type')
BEGIN
    DROP PROC SAVE_Custom_Live_Meeting_Type
END
GO
Create PROC SAVE_Custom_Live_Meeting_Type
(	
	@MeetingTypeName VARCHAR(100),
	@Company_Id INT,
	@Center_Id INT,
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
	@SysMeetingTypeId INT = 0,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysMeetingTypeId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Type WITH (NOLOCK) WHERE SysMeetingTypeId = @SysMeetingTypeId))
	BEGIN
		Update L
		SET 
			L.MeetingTypeName = @MeetingTypeName,
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
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
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Type L WITH (NOLOCK)
		WHERE L.SysMeetingTypeId = @SysMeetingTypeId
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Type L WITH (NOLOCK) WHERE L.SysMeetingTypeId = @SysMeetingTypeId)
		BEGIN
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
				CreatedDttm
			)
			SELECT 
				@MeetingTypeName,
				@Company_Id,
				@Center_Id,
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
				@UserId,
				@TransactionDttm

			SET @SysMeetingTypeId = @@IDENTITY;
		END
	END	

	SELECT @SysMeetingTypeId;
END
GO

-- ====================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for copy default application level meeting type to company / center level at initial stage.
-- Return Bit
-- ====================================================================================================================================
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
				CreatedDttm
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
				@TransactionDttm
		FROM App_Live_Meeting_Type L WITH (NOLOCK)
		WHERE L.MeetingTypeStatus = 1
	END
END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live license by company, center and status
-- Return live license details list
-- ==============================================================================================
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

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live license by id
-- Return live license details list
-- ==============================================================================================
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

-- ======================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live meeting license by company, center and status
-- Return live license meeting details list
-- ======================================================================================================
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
	WHERE (L.Company_Id = @Company_Id OR L.Company_Id = 0) AND
	(L.Center_Id = @Center_Id OR L.Center_Id = 0) AND
	L.MeetingLicenseStatus = @MeetingLicenseStatus

END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get all live meeting license by id
-- Return live license meeting details list
-- ==============================================================================================
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
		'http://localhost:4200/#/center/live/close' [LeaveUrl],
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
-- Description: Create new stored procedure to get live meeting type and details by company and center
-- Return live license meeting type details list
-- ==============================================================================================
--Exec GET_Live_Meeting_Types_By_Company_Center 1046, 1
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
		T.CreatedDttm
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE (T.Company_Id = @Company_Id OR T.Company_Id = 1) AND
	(T.Center_Id = @Center_Id OR T.Center_Id = 1)

END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting type and details by id
-- Return live license meeting type details list
-- ==============================================================================================
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
		T.CreatedDttm
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE T.SysMeetingTypeId = @SysMeetingTypeId

END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meetings list
-- ==============================================================================================
--Exec GET_Meetings_By_Company_Center 1046, 1, 2
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Meetings_By_Company_Center')
BEGIN
    DROP PROC GET_Meetings_By_Company_Center
END
GO
Create PROC GET_Meetings_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL,
	@MeetingsStatus TINYINT = 1
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
	(M.MeetingsStatus = @MeetingsStatus OR M.MeetingsStatus = 0)

END
GO

-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get meetings list by company and center
-- Return meeting details by id
-- ==============================================================================================
--Exec GET_Meeting_By_Id 1
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
	WHERE M.SysMeetingId = @SysMeetingId

END
GO

-- =================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting host's details by company and center
-- Return user details list
-- =================================================================================================
--Exec GET_Live_Meeting_Hosts_Company_Center 1046, 1
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
		U.LastName		
	FROM app_role AR WITH (NOLOCK)
	JOIN company_app_role  CAR WITH (NOLOCK) ON CAR.app_role_id = AR.app_role_id
	JOIN user_role UR WITH (NOLOCK) ON UR.company_app_role_id = CAR.company_app_role_id
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = UR.user_id
	WHERE (CAR.company_id = @Company_Id OR CAR.Company_Id = 1) AND	
	AR.app_role_id IN (1,2,3,4)

END
GO
-- =================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting participant's details by company and center
-- Return parent / user details list
-- =================================================================================================
--Exec GET_Live_Meeting_Participants_Company_Center 1046, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Participants_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Participants_Company_Center
END
GO
Create PROC GET_Live_Meeting_Participants_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = 0
)
AS
BEGIN
	SELECT	DISTINCT
		S.sponsor_id [Parent_Id], 
		U.FirstName [Parent_FirstName],
		U.LastName [Parent_LastName],

		F.Family_Id,
		F.FIRST_NAME [Family_FirstName],
		F.LAST_NAME [Family_LastName],	
		
		F.Family_Account_No,	
		F.Family_Status,
		F.parent2_first_name,	
		F.parent2_last_name,
		'' Parent1Name,	
		'' Parent2Name,	
		F.PARENT1_CELL_PHONE,	
		F.HOME_PHONE,	
		F.PARENT2_CELL_PHONE,	
		F.HOME_PHONE2,	
		F.ledger_type,
		PRIMARY_EMAIL, 
		SECONDARY_EMAIL,

		C.Child_Id [Child_Id],		
		C.FIRST_NAME [Child_FirstName],
		C.LAST_NAME [Child_LastName]
	FROM sponsor_details S WITH (NOLOCK) 
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = S.userId
	JOIN Family_Details F WITH (NOLOCK) ON F.Family_Id = S.Family_id
	JOIN child_details C WITH (NOLOCK) ON C.Family_Id = F.Family_Id
	WHERE (S.Company_id = @Company_Id OR S.Company_Id = 1) AND
	(S.center_id = @Center_id OR S.center_id = 1) AND
	S.PP_status = 1 AND
	S.userId > 0 AND	
	(F.Center_Id = @Center_Id  OR F.Center_Id = 1) AND
	(S.Center_Id = @Center_Id  OR S.Center_Id = 1)
	ORDER BY F.Family_Account_No ASC

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
 @MeetingsStatus TINYINT = 1 ,
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

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (80, 'http://localhost:4200/#/center/live/close', 'Meeting Leave Url')
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (80, 'http://localhost:4200/#/center/live/close', 'Meeting Leave Url')
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

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_Hosts_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["FirstName" ,"LastName"]}]}'
END
GO
IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_Participants_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["Parent_FirstName", "Parent_LastName", "Family_FirstName", "Family_LastName", "Family_Account_No", "parent2_first_name", "parent2_last_name", "PARENT1_CELL_PHONE", "HOME_PHONE", "PARENT2_CELL_PHONE", "HOME_PHONE2", "Child_FirstName", "Child_LastName", "PRIMARY_EMAIL", "SECONDARY_EMAIL"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_By_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meeting_By_Id', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_List_For_Parent', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_LicenseDetails_By_MeetingId', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["DisplayNameFirstName" ,"DisplayNameLastName"]}]}'
END
GO

-- Add Dummy Data

/*

Truncate Table App_Live_Meeting_Type
Truncate Table Live_Meeting_Type
Truncate Table Live_License
Truncate Table Live_Meeting_License

Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Virtual Classroom',
    @MaxParticipants = 20,
    @GraceTime = 5,
    @CallDuration = 125,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 1,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 0,
    @IsPrivateChat = 0,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 1,
    @IsScreenSharingByParticipants = 1,
    @IsWhiteboard = 1,
	@MeetingTypeStatus = 1,
	@SysMeetingTypeId = 1,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'

Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Virtual Tour',
    @MaxParticipants = 10,
    @GraceTime = 5,
    @CallDuration = 60,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 0,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 1,
    @IsPrivateChat = 1,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 0,
    @IsScreenSharingByParticipants = 0,
    @IsWhiteboard = 0,
	@MeetingTypeStatus = 1,
	@SysMeetingTypeId = 2,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'


Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'OneToOne',
    @MaxParticipants = 1,
    @GraceTime = 5,
    @CallDuration = 60,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 1,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 0,
    @IsPrivateChat = 0,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 0,
    @IsScreenSharingByParticipants = 0,
    @IsWhiteboard = 0,
	@MeetingTypeStatus = 1,
	@SysMeetingTypeId = 3,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'

Exec COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type	@Company_Id = 1, @Center_Id = 1, @UserId = 1, @TransactionDttm = '15-Jun-2020'

EXEC SAVE_Live_License
	@Company_Id = 1,
	@Center_Id = 1,
	@LiveApiKey = 'wZT0tluKQ2eV7sZXEkb0GQ',
	@LiveApiSecret = 'c5WxFH1SlTJq7kx19wyUaczijt21n4l5MErW',
	@LicenseStatus = 1,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020',
	@SysLiveLicenseId = 1

Exec SAVE_Live_Meeting_License
	@SysLiveLicenseId = 1,
	@Company_Id = 1,
	@Center_Id = 1,
	@LiveUserId = '129872078',
	@LiveUserName = 'swamivenkat@1coresolution.com',
	@LiveMeetingId = '6361405650',
	@LiveMeetingPassword = '5Jgyqh',
	@MeetingLicenseStatus = 1,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020',
	@SysLiveMeetingLicenseId = 1

Select * from App_Live_Meeting_Type
select * from Live_Meeting_Type
select * from Live_License
select * from Live_Meeting_License
Select * from Live_Meetings
select * from Live_Meeting_Participants
*/