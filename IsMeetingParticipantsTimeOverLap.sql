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