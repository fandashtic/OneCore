-- ======================================================================
-- Author: Manickam.G
-- Create date: 07th Jul 2020
-- Description: Create new stored procedure for update the meeting status from zoom web hooks.
-- Return null
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_End_Meeting_Status')
BEGIN
    DROP PROC Update_End_Meeting_Status
END
GO
Create PROC Update_End_Meeting_Status
(
	@Uuid VARCHAR(1000),
	@MeetingStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@ActualMeetingStartTime DATETIME = null,
	@ActualMeetingEndTime DATETIME = null
)
AS
BEGIN
	DECLARE @SysMeetingId INT = 0
	SELECT @SysMeetingId = SysMeetingId FROM Live_Meetings L WITH (NOLOCK) WHERE L.Uuid = @Uuid

	IF(@SysMeetingId > 0)
	BEGIN		
		EXEC UPDATE_Live_Meeting_Status @SysMeetingId, @MeetingStatus, @UserId, @TransactionDttm, @ActualMeetingStartTime, @ActualMeetingEndTime
	END

	SELECT 'Success' [Status], SysMeetingId, MeetingHostUserId, TimeZoneId FROM Live_Meetings L WITH (NOLOCK) WHERE L.Uuid = @Uuid
END
GO