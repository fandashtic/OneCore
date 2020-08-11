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