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
	@ActualMeetingStartTime DATETIME = null,
	@ActualMeetingEndTime DATETIME = null,
	@Eqs VARCHAR(4000) = null
)
AS
BEGIN
	IF(@SysParticipantId > 0)
	BEGIN
		IF(@MeetingParticipantStatus = 2) -- Update InProgress Status.
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.ActualMeetingStartTime = ISNULL(D.ActualMeetingStartTime, @ActualMeetingStartTime),
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
		ELSE IF(@MeetingParticipantStatus = 3) -- Update End Status.
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.ActualMeetingStartTime = ISNULL(D.ActualMeetingStartTime, @ActualMeetingStartTime),
				D.ActualMeetingEndTime = @ActualMeetingEndTime,
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
		ELSE
		BEGIN
			UPDATE D 
			SET D.MeetingParticipantStatus = @MeetingParticipantStatus,
				D.Eqs = @Eqs,
				D.ModifiedBy = @UserId,
				D.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants D WITH (NOLOCK) 
			WHERE D.SysParticipantId = @SysParticipantId
		END
	END

	Update M 
	SET M.ParticipantsCount = dbo.GetParticipantsCountByMeetingId(M.SysMeetingId),
	M.MeetingAttendeesCount = dbo.GetMeetingAttendeesCount(M.SysMeetingId)
	FROM Live_Meetings M WITH (NOLOCK)
	JOIN Live_Meeting_Participants LP WITH (NOLOCK) ON LP.SysMeetingId = M.SysMeetingId
	WHERE LP.SysParticipantId = @SysParticipantId

END
GO