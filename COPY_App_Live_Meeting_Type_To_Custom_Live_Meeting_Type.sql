-- ====================================================================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for copy default application level meeting type to company / center level at initial stage.
-- Return Bit
-- ====================================================================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type')
BEGIN
    DROP PROC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type
END
GO
Create PROC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type
(	
	@Company_Id INT = 0,
	@Center_Id INT = 0,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@Company_Id > 0)
	BEGIN

		SET @Center_Id = 0

		--IF(@Center_Id > 0)
		--BEGIN
		--	Delete C From Live_Meeting_Type C WITH (NOLOCK) WHERE Company_Id = @Company_Id AND Center_Id = @Center_Id AND MeetingTypeName IN (SELECT DISTINCT MeetingTypeName FROM App_Live_Meeting_Type WITH (NOLOCK) WHERE MeetingTypeStatus = 1)
		--END
		--ELSE
		--BEGIN
		--	Delete C From Live_Meeting_Type C WITH (NOLOCK) WHERE Company_Id = @Company_Id AND MeetingTypeName IN (SELECT DISTINCT MeetingTypeName FROM App_Live_Meeting_Type WITH (NOLOCK) WHERE MeetingTypeStatus = 1)
		--END

		IF NOT EXISTS (SELECT TOP 1 1 FROM Live_Meeting_Type C WITH (NOLOCK) WHERE Company_Id = @Company_Id)
		BEGIN
			INSERT INTO Live_Meeting_Type
				(
					MeetingTypeName,
					Company_Id,
					Center_Id,
					MaxParticipants,
					GraceTime,
					CallDuration,
					IsShowHostVideo,
					IsShowParticipantsVideo,
					IsMuteParticipant,
					IsViewOtherParticipants,
					IsJoinbeforeHost,
					IsChat,
					IsPrivateChat,
					IsFileTransfer,
					IsScreenSharingByHost,
					IsScreenSharingByParticipants,
					IsWhiteboard,
					MeetingTypeStatus,
					CreatedBy,
					CreatedDttm,
					IsSendReminderHost,
					IsSendReminderParticipants,
					IsRecordSession,
					AppLiveMeetingId,
					MeetingEndBufferTime
				)
				SELECT 
					MeetingTypeName,
					@Company_Id,
					@Center_Id,
					MaxParticipants,
					GraceTime,
					CallDuration,
					IsShowHostVideo,
					IsShowParticipantsVideo,
					IsMuteParticipant,
					IsViewOtherParticipants,
					IsJoinbeforeHost,
					IsChat,
					IsPrivateChat,
					IsFileTransfer,
					IsScreenSharingByHost,
					IsScreenSharingByParticipants,
					IsWhiteboard,
					MeetingTypeStatus,
					@UserId,
					@TransactionDttm,
					IsSendReminderHost,
					IsSendReminderParticipants,
					IsRecordSession,
					SysMeetingTypeId,
					MeetingEndBufferTime
			FROM App_Live_Meeting_Type L WITH (NOLOCK)
			WHERE L.MeetingTypeStatus = 1
		END
	END
END
GO