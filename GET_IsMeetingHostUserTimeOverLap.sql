-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for validate the given host is already scheduled with any other meeting for the same time.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_IsMeetingHostUserTimeOverLap')
BEGIN
    DROP PROC GET_IsMeetingHostUserTimeOverLap
END
GO
Create PROC GET_IsMeetingHostUserTimeOverLap
(
	@MeetingHostUserId INT, @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT
)
AS
BEGIN
	SELECT dbo.IsMeetingHostUserTimeOverLap(@MeetingHostUserId, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
END
GO