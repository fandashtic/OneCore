-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 24th Jul 2020
-- Description: Create new stored procedure for update liveMeeting job status
-- ==============================================================================================
--Exec Update_LiveMeeting_Job_Status 1, '2020-07-24 19:00:10.770'
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_LiveMeeting_Job_Status')
BEGIN
    DROP PROC Update_LiveMeeting_Job_Status
END
GO
Create PROC Update_LiveMeeting_Job_Status (@SysMeetingId INT, @LastJobExecutedOn DATETIME)
AS  
BEGIN
	UPDATE L
		SET L.IsJobExecuted = 1, L.LastJobExecutedOn = @LastJobExecutedOn
	FROM Live_Meetings L WITH (NOLOCK)
	WHERE SysMeetingId = @SysMeetingId

END
GO