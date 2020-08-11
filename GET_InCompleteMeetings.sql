-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_InCompleteMeetings 0, 0, 1333
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_InCompleteMeetings')
BEGIN
    DROP PROC GET_InCompleteMeetings
END
GO
Create PROC GET_InCompleteMeetings (@Company_Id INT = 0, @Center_Id INT = 0, @AppJobHistId INT = 0)
AS  
BEGIN
	
	--#region : Start Update Meeting & Participants Status

	--TODO: If any meeting is there with SCHEDULED status and end time is cross the current time then it updated as expired.
	IF EXISTS(SELECT TOP 1 1 FROM Live_Meetings M WITH (NOLOCK) WHERE M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE())
	BEGIN		
		UPDATE P SET P.MeetingParticipantStatus = 6 
		FROM Live_Meeting_Participants P WITH (NOLOCK) 
		JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = P.SysMeetingId AND M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE()
		WHERE P.MeetingParticipantStatus = 1 

		UPDATE M SET M.MeetingStatus = 6 FROM Live_Meetings M WITH (NOLOCK) WHERE M.MeetingStatus = 1 AND M.MeetingEndTime < GETUTCDATE()
	END

	UPDATE D 
	SET D.MeetingParticipantStatus = 3,
		D.ActualMeetingEndTime = ISNULL(D.ActualMeetingEndTime, M.ActualMeetingEndTime)
	FROM Live_Meeting_Participants D WITH (NOLOCK)
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus = 3
	AND D.MeetingParticipantStatus = 2

	UPDATE D 
	SET D.MeetingParticipantStatus = M.MeetingStatus -- Not Attended Meetings are updated as Meeting Status like Deleted.
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus > 3
	AND D.MeetingParticipantStatus = 1

	UPDATE D 
	SET D.MeetingParticipantStatus = 6 -- Not Attended Meetings are updated as Expired
	FROM Live_Meeting_Participants D WITH (NOLOCK) 
	JOIN Live_Meetings M WITH (NOLOCK) ON M.SysMeetingId = D.SysMeetingId
	WHERE M.MeetingStatus = 3
	AND D.MeetingParticipantStatus = 1

	--#endregion : End Update Meeting & Participants Status

	--#region : Start Fecth Meetings list for JOB

	DECLARE @MeetingEndBufferTime INT

	IF(ISNULL(@MeetingEndBufferTime, 0) = 0) SET @MeetingEndBufferTime = 30; -- Default Meeting End buffer time is 30 Minuite.


	DECLARE @Meetings AS TABLE(SysMeetingId INT)

	INSERT INTO @Meetings(SysMeetingId)
	SELECT DISTINCT SysMeetingId 
	FROM Live_Meetings M WITH (NOLOCK)
	WHERE M.MeetingStatus In(3) AND
	ISNULL(M.AppJobHistId, 0) = 0 AND
	ISNULL(M.IsJobExecuted, 0) = 0 AND
	DATEADD(MINUTE, +(@MeetingEndBufferTime), M.ModifiedDttm) <= GETUTCDATE() AND
	M.MeetingId IS NOT NULL AND
	M.Uuid IS NOT NULL
	
	UPDATE M
	SET M.AppJobHistId = @AppJobHistId
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @Meetings T ON T.SysMeetingId = M.SysMeetingId

	SELECT
		M.SysMeetingId, 
		M.MeetingId, 
		M.Uuid, 
		M.Company_Id, 
		M.Center_Id,
		M.MeetingHostUserId,
		M.TimeZoneId
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN @Meetings T ON T.SysMeetingId = M.SysMeetingId

	--#endregion : END Fecth Meetings list for JOB
END
GO