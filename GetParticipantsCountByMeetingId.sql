-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for collect all Participants details and return as comma seprated string.
-- Return comma seprated value
-- ==================================================================================================================================
--select dbo.GetParticipantsCountByMeetingId(13)
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
	FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId

	IF EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Participants D WITH (NOLOCK) WHERE D.SysMeetingId = @SysMeetingId)
	BEGIN
		SET @ParticipantsCount = (SELECT COUNT(DISTINCT ComboId) FROM @CountTable)
	END

	RETURN @ParticipantsCount;
END
GO