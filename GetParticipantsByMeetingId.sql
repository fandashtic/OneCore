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