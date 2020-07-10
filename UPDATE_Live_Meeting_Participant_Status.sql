-- ==================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for update the meeting participant status
-- Return meeting id  as INT
-- ==================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'UPDATE_Live_Meeting_Participant_Status')
BEGIN
    DROP PROC UPDATE_Live_Meeting_Participant_Status
END
GO
Create PROC UPDATE_Live_Meeting_Participant_Status
(
	@SysParticipantId INT = 0,
	@MeetingParticipantStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@Eqs VARCHAR(4000)
)
AS
BEGIN
	IF(@SysParticipantId > 0)
	BEGIN
		UPDATE L
		SET 
			L.MeetingParticipantStatus = @MeetingParticipantStatus,
			L.Eqs = @Eqs,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Participants L WITH (NOLOCK)
			WHERE L.SysParticipantId = @SysParticipantId
	END
END
GO