-- ======================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for update the meeting status
-- Return meeting id  as INT
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'UPDATE_Live_Meeting_Status')
BEGIN
    DROP PROC UPDATE_Live_Meeting_Status
END
GO
Create PROC UPDATE_Live_Meeting_Status
(
	@SysMeetingId INT = 0, 
	@MeetingStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN
		UPDATE L
		SET 
			L.MeetingsStatus = @MeetingStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meetings L WITH (NOLOCK)
		WHERE L.SysMeetingId = @SysMeetingId
		
		-- Update Meeting Participants Status

		UPDATE D 
		SET D.MeetingParticipantStatus = @MeetingStatus,
			D.ModifiedBy = @UserId,
			D.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Participants D WITH (NOLOCK) 
		WHERE D.SysMeetingId = @SysMeetingId

	END
END
GO