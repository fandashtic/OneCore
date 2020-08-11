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
	
	IF(ISNULL(@Data, '') <> '') SET @IsHasValue = 1;

	RETURN @IsHasValue;
END 
GO
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
		SELECT DISTINCT 
			CAST(D.MeetingParticipantUserId AS VARCHAR) + ';' 
		  + CAST(D.Family_Id AS VARCHAR) + ';' 
		  + CAST(D.Child_Id AS VARCHAR) + ';' 
		  + CAST(D.SysParticipantId AS VARCHAR) + ';' 
		  + CAST(D.MeetingParticipantStatus AS VARCHAR) + ';' 
		  + CASE WHEN D.ActualMeetingStartTime IS NULL THEN '' ELSE CAST(D.ActualMeetingStartTime AS VARCHAR) END + ';' 
		  + CASE WHEN D.ActualMeetingEndTime IS NULL THEN '' ELSE CAST(D.ActualMeetingEndTime AS VARCHAR) END
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId --AND
		--D.MeetingParticipantStatus IN (1, 2, 3, 6)

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
	Declare @CountTable As Table(ComboId VARCHAR(255))
	INSERT INTO @CountTable(ComboId)
	SELECT DISTINCT CAST(Family_Id AS VARCHAR) + CAST(Child_Id AS VARCHAR) + CAST(MeetingParticipantUserId AS VARCHAR)
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	WHERE D.SysMeetingId = @SysMeetingId
	AND D.MeetingParticipantStatus <= 3

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		SET @ParticipantsCount = (SELECT COUNT(DISTINCT ComboId) FROM @CountTable)
	END

	RETURN @ParticipantsCount;
END
GO
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
	DECLARE	@Company_Id INT
	DECLARE @Center_Id INT
	SET @IsMeetingHostUserTimeOverLap = 0;

	SELECT @Company_Id = Company_Id, @Center_Id = Center_Id FROM Live_Meetings WITH (NOLOCK) WHERE SysMeetingId = @SysMeetingId

	IF EXISTS (SELECT TOP 1 1 
				FROM Live_Meetings L WITH (NOLOCK) 
				WHERE L.MeetingHostUserId = @MeetingHostUserId AND 
				L.MeetingStatus <= 2 AND
				@MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND SysMeetingId <> @SysMeetingId)
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	IF EXISTS (SELECT TOP 1 1 
				FROM Live_Meetings L WITH (NOLOCK) 
				WHERE L.MeetingHostUserId = @MeetingHostUserId AND 
				L.MeetingStatus <= 2 AND
				@MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND SysMeetingId <> @SysMeetingId)
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	RETURN @IsMeetingHostUserTimeOverLap;
END
GO
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
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GetMeetingAttendeesCount')
BEGIN
    DROP FUNCTION dbo.GetMeetingAttendeesCount
END
GO
Create FUNCTION dbo.GetMeetingAttendeesCount(@SysMeetingId INT)
Returns INT
AS  
BEGIN 
	DECLARE @MeetingAttendeesCount INT;
	SET @MeetingAttendeesCount = 0;

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		
		SELECT @MeetingAttendeesCount =  
			COUNT(SysParticipantId)
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId AND
		D.MeetingParticipantStatus IN (2, 3) AND
		D.ActualMeetingStartTime IS NOT NULL
	END

	RETURN @MeetingAttendeesCount;
END
GO
