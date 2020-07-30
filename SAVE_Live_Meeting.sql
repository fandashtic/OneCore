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
					--L.SysLiveLicenseId = @SysLiveLicenseId,
					--L.SysLiveMeetingLicenseId = @SysLiveMeetingLicenseId,
					--L.Company_Id = @Company_Id,
					--L.Center_Id = @Center_Id,				
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