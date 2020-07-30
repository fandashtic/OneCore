-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting type and details by id
-- Return live license meeting type details list
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Type_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_Type_By_Id
END
GO
Create PROC GET_Live_Meeting_Type_By_Id
(	
	@SysMeetingTypeId INT
)
AS
BEGIN

	SELECT	DISTINCT 
		T.Company_Id,
		T.Center_Id,
		T.SysMeetingTypeId,
		T.MeetingTypeName,
		T.MaxParticipants,
		T.GraceTime,
		T.CallDuration,
		T.IsShowHostVideo,
		T.IsShowParticipantsVideo,
		T.IsMuteParticipant,
		T.IsViewOtherParticipants,
		T.IsJoinbeforeHost,
		T.IsChat,
		T.IsPrivateChat,
		T.IsFileTransfer,
		T.IsScreenSharingByHost,
		T.IsScreenSharingByParticipants,
		T.IsWhiteboard,
		T.MeetingTypeStatus,
		T.ModifiedDttm,
		T.ModifiedBy,
		T.CreatedBy,
		T.CreatedDttm,
		T.IsSendReminderHost,
		T.IsSendReminderParticipants,
		T.IsRecordSession,
		T.AppLiveMeetingId
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE T.SysMeetingTypeId = @SysMeetingTypeId

END
GO