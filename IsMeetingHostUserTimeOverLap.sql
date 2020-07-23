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
				L.MeetingStatus <= 2 AND
				@MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	IF EXISTS (SELECT TOP 1 1 
				FROM Live_Meetings L WITH (NOLOCK) 
				WHERE L.MeetingHostUserId = @MeetingHostUserId AND 
				L.MeetingStatus <= 2 AND
				@MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
				AND (L.SysMeetingId <> @SysMeetingId OR L.SysMeetingId = 0))
	BEGIN
		SET @IsMeetingHostUserTimeOverLap = 1;
	END

	RETURN @IsMeetingHostUserTimeOverLap;
END
GO