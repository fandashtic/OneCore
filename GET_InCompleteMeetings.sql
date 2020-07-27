-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 7th Jul 2020
-- Description: Create new stored procedure to get schedule meeting details by onecore user id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec GET_InCompleteMeetings 0, 0
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_InCompleteMeetings')
BEGIN
    DROP PROC GET_InCompleteMeetings
END
GO
Create PROC GET_InCompleteMeetings (@Company_Id INT = 0, @Center_Id INT = 0)
AS  
BEGIN
	SELECT DISTINCT TOP 10
		M.SysMeetingId, 
		M.MeetingId, 
		M.Uuid, 
		M.Company_Id, 
		M.Center_Id,
		M.MeetingHostUserId,
		M.TimeZoneId
	FROM Live_Meetings M WITH (NOLOCK)
	WHERE M.MeetingStatus In(2,3) AND
	ISNULL(M.IsJobExecuted, 0) = 0 AND
	M.MeetingId IS NOT NULL AND
	M.Uuid IS NOT NULL
END
GO