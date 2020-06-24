-- ==========================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the custom center level meeting type and details.
-- Return SysMeetingTypeId  as INT
-- ==========================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Custom_Live_Meeting_Type')
BEGIN
    DROP PROC SAVE_Custom_Live_Meeting_Type
END
GO
Create PROC SAVE_Custom_Live_Meeting_Type
(	
	@MeetingTypeName VARCHAR(100),
	@Company_Id INT,
	@Center_Id INT,
	@MaxParticipants SMALLINT,
	@GraceTime INT,
	@CallDuration INT,
	@IsShowHostVideo BIT,
	@IsShowParticipantsVideo BIT,
	@IsMuteParticipant BIT,
	@IsViewOtherParticipants BIT,
	@IsJoinbeforeHost BIT,
	@IsChat BIT,
	@IsPrivateChat BIT,
	@IsFileTransfer BIT,
	@IsScreenSharingByHost BIT,
	@IsScreenSharingByParticipants BIT,
	@IsWhiteboard BIT,
	@MeetingTypeStatus TINYINT,
	@SysMeetingTypeId INT = 0,
	@UserId INT,
	@TransactionDttm DATETIME
)
AS
BEGIN
	IF(@SysMeetingTypeId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Type WITH (NOLOCK) WHERE SysMeetingTypeId = @SysMeetingTypeId))
	BEGIN
		Update L
		SET 
			L.MeetingTypeName = @MeetingTypeName,
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
			L.MaxParticipants = @MaxParticipants,
			L.GraceTime= @GraceTime,
			L.CallDuration= @CallDuration,
			L.IsShowHostVideo= @IsShowHostVideo,
			L.IsShowParticipantsVideo= @IsShowParticipantsVideo,
			L.IsMuteParticipant= @IsMuteParticipant,
			L.IsViewOtherParticipants= @IsViewOtherParticipants,
			L.IsJoinbeforeHost= @IsJoinbeforeHost,
			L.IsChat= @IsChat,
			L.IsPrivateChat= @IsPrivateChat,
			L.IsFileTransfer= @IsFileTransfer,
			L.IsScreenSharingByHost= @IsScreenSharingByHost,
			L.IsScreenSharingByParticipants= @IsScreenSharingByParticipants,
			L.IsWhiteboard= @IsWhiteboard,
			L.MeetingTypeStatus= @MeetingTypeStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_Type L WITH (NOLOCK)
		WHERE L.SysMeetingTypeId = @SysMeetingTypeId
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 1 FROM Live_Meeting_Type L WITH (NOLOCK) WHERE L.SysMeetingTypeId = @SysMeetingTypeId)
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
				CreatedDttm
			)
			SELECT 
				@MeetingTypeName,
				@Company_Id,
				@Center_Id,
				@MaxParticipants,
				@GraceTime,
				@CallDuration,
				@IsShowHostVideo,
				@IsShowParticipantsVideo,
				@IsMuteParticipant,
				@IsViewOtherParticipants,
				@IsJoinbeforeHost,
				@IsChat,
				@IsPrivateChat,
				@IsFileTransfer,
				@IsScreenSharingByHost,
				@IsScreenSharingByParticipants,
				@IsWhiteboard,
				@MeetingTypeStatus,
				@UserId,
				@TransactionDttm

			SET @SysMeetingTypeId = @@IDENTITY;
		END
	END	

	SELECT @SysMeetingTypeId;
END
GO