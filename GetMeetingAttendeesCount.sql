-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 17th Jul 2020
-- Description: Create new scalar function for collect all attent Participants count and return
-- Return int value
-- ==================================================================================================================================
--select dbo.GetMeetingAttendeesCount(67)
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
