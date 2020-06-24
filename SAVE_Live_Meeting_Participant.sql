-- ==========================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the meeting participant details.
-- Return SysParticipantId  as INT
-- ==========================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_Meeting_Participant')
BEGIN
    DROP PROC SAVE_Live_Meeting_Participant
END
GO
Create PROC SAVE_Live_Meeting_Participant
(		
	@SysMeetingId INT = 0,
	@Company_Id INT,
	@Center_Id INT,
	@MeetingParticipantUserId INT,
	@Family_Id INT,
	@Child_Id INT,
	@MeetingParticipantStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,	
	@SysParticipantId INT = 0
)
AS
BEGIN
	IF(@SysMeetingId > 0)
	BEGIN
		IF(@SysParticipantId > 0)
		BEGIN
			Update L
			SET 
				L.SysMeetingId = @SysMeetingId,
				L.Company_Id = @Company_Id,
				L.Center_Id = @Center_Id,
				L.MeetingParticipantUserId = @MeetingParticipantUserId,
				L.Family_Id = @Family_Id,
				L.Child_Id = @Child_Id,
				L.MeetingParticipantStatus = @MeetingParticipantStatus,
				L.ModifiedBy = @UserId,
				L.ModifiedDttm = @TransactionDttm
			FROM Live_Meeting_Participants L WITH (NOLOCK)
			WHERE L.SysParticipantId = @SysParticipantId
		END
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Participants L WITH (NOLOCK) WHERE L.SysMeetingId = @SysMeetingId AND L.MeetingParticipantUserId = @MeetingParticipantUserId AND L.Family_Id = @Family_Id AND L.Child_Id = @Child_Id)
			BEGIN
				INSERT INTO Live_Meeting_Participants
				(
					SysMeetingId,
					Company_Id,
					Center_Id,
					MeetingParticipantUserId,
					Family_Id,
					Child_Id,
					MeetingParticipantStatus,
					CreatedBy,
					CreatedDttm
				)
				SELECT 
					@SysMeetingId,
					@Company_Id,
					@Center_Id,
					@MeetingParticipantUserId,
					@Family_Id,
					@Child_Id,
					@MeetingParticipantStatus,
					@UserId,
					@TransactionDttm
			END
		END
	END	
END
GO