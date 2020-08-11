-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 3rd Aug 2020
-- Description: Create new stored procedure to get live meeting type and details by id
-- Return live license meeting type details list
-- ==============================================================================================
--Exec GET_Live_Meeting_By_Id 1183, 4, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_By_Id')
BEGIN
    DROP PROC GET_Live_Meeting_By_Id
END
GO
Create PROC GET_Live_Meeting_By_Id
(	
	@Company_Id INT,
	@Center_Id INT,
	@LiveMeetingType INT
)
AS
BEGIN
	
	DECLARE @TransactionDttm DATETIME
	SET @TransactionDttm = GETDATE();

	IF NOT EXISTS(SELECT TOP 1 1 
		FROM Live_Meeting_Type T WITH (NOLOCK) WHERE 
		T.Company_Id = @Company_Id)
	BEGIN
		EXEC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type @Company_Id, @Center_Id, 0, @TransactionDttm
	END

	IF NOT EXISTS(SELECT TOP 1 1 
		FROM Live_Meeting_Type T WITH (NOLOCK) WHERE 
		T.Company_Id = @Company_Id AND
		T.Center_Id = @Center_Id)
	BEGIN
		EXEC COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type @Company_Id, @Center_Id, 0, @TransactionDttm
	END

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
	WHERE 
		T.Company_Id = @Company_Id AND
		T.Center_Id = @Center_Id AND
		T.AppLiveMeetingId = @LiveMeetingType
END
GO