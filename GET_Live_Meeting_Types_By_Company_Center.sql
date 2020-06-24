-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure to get live meeting type and details by company and center
-- Return live license meeting type details list
-- ==============================================================================================
--Exec GET_Live_Meeting_Types_By_Company_Center 1046, 1
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GET_Live_Meeting_Types_By_Company_Center')
BEGIN
    DROP PROC GET_Live_Meeting_Types_By_Company_Center
END
GO
Create PROC GET_Live_Meeting_Types_By_Company_Center
(	
	@Company_Id INT,
	@Center_Id INT = NULL
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
		T.CreatedDttm
	FROM Live_Meeting_Type T WITH (NOLOCK)
	WHERE (T.Company_Id = @Company_Id OR T.Company_Id = 1) AND
	(T.Center_Id = @Center_Id OR T.Center_Id = 1)

END
GO