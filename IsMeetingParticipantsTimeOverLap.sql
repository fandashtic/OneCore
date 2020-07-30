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

		DELETE @TempParticipant_Meetings WHERE SysMeetingId IN(SELECT DISTINCT SysMeetingId FROM Live_Meetings WITH (NOLOCK) WHERE MeetingStatus > 2)

		SET @P_Id = 1;

		WHILE(@P_Id <= (SELECT MAX(P_Id) FROM @TempParticipant_Meetings))
		BEGIN

			SELECT @SysMeetingId = SysMeetingId FROM @TempParticipant_Meetings WHERE P_Id = @P_Id;

			IF EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE L.MeetingStatus <= 2 AND
						@MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND SysMeetingId <> @SysMeetingId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)
			BEGIN
				SET @IsMeetingParticipantsTimeOverLap = 1;
				BREAK; 
			END

			IF EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE L.MeetingStatus <= 2 AND
						@MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND SysMeetingId <> @SysMeetingId AND Company_Id = @Company_Id AND Center_Id = @Center_Id)						
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