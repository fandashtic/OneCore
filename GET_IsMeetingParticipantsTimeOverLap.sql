-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for validate the given participants are already scheduled with any other meeting for the same time.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_IsMeetingParticipantsTimeOverLap')
BEGIN
    DROP PROC GET_IsMeetingParticipantsTimeOverLap
END
GO
Create PROC GET_IsMeetingParticipantsTimeOverLap
(
	@ParentIds NVARCHAR(1000), @FamilyIds NVARCHAR(1000), @ChildIds NVARCHAR(1000), @MeetingStartTime DATETIME, @MeetingEndTime DATETIME, @SysMeetingId INT
)
AS
BEGIN
	SELECT dbo.IsMeetingParticipantsTimeOverLap(@ParentIds, @FamilyIds, @ChildIds, @MeetingStartTime, @MeetingEndTime, @SysMeetingId)
END
GO