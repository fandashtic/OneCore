-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 24th Jul 2020
-- Description: Create new stored procedure for update liveMeeting job status
-- ==============================================================================================
--Exec Update_LiveMeeting_Job_Status 4191, '2020-08-04 05:20:04.577'
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_LiveMeeting_Job_Status')
BEGIN
    DROP PROC Update_LiveMeeting_Job_Status
END
GO
Create PROC Update_LiveMeeting_Job_Status (@SysMeetingId INT, @LastJobExecutedOn DATETIME)
AS  
BEGIN

	--DECLARE @MeetingEndBufferTime INT
	
	--SELECT @MeetingEndBufferTime = T.MeetingEndBufferTime FROM Live_Meeting_Type T WITH (NOLOCK) 
	--JOIN Live_Meetings L WITH (NOLOCK) ON L.MeetingTypeId = T.SysMeetingTypeId
	--WHERE L.SysMeetingId = @SysMeetingId

	--IF(ISNULL(@MeetingEndBufferTime, 0) = 0) SET @MeetingEndBufferTime = 30; -- Default Meeting End buffer time is 30 Minuite.
	
	--IF EXISTS(
	--	SELECT TOP 1 1 
	--	FROM Live_Meetings L WITH (NOLOCK)
	--	WHERE SysMeetingId = @SysMeetingId AND
	--	L.MeetingStatus = 3 AND 
	--	DATEADD(MINUTE, +(@MeetingEndBufferTime), L.ActualMeetingEndTime) <= @LastJobExecutedOn
	--)
	--BEGIN
		UPDATE L
			SET L.IsJobExecuted = 1, L.LastJobExecutedOn = @LastJobExecutedOn
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE SysMeetingId = @SysMeetingId
	--END
	--ELSE
	--BEGIN
	--	UPDATE L
	--		SET L.IsJobExecuted = 0, L.AppJobHistId = 0
	--	FROM Live_Meetings L WITH (NOLOCK)
	--	WHERE SysMeetingId = @SysMeetingId
	--END
END
GO