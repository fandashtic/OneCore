-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 24th Jul 2020
-- Description: Create new stored procedure to save Actual Meeting Participants
-- No Return
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Save_Actual_Meeting_Participants')
BEGIN
    DROP PROC Save_Actual_Meeting_Participants
END
GO
Create PROC Save_Actual_Meeting_Participants 
(   
	@SysMeetingId INT,
	@Next_Page_Token VARCHAR(255),
	@Page_Count INT,
	@Page_Size INT,
	@Total_Records  INT,
	@Participant_Id VARCHAR(255),
	@Participant_Name VARCHAR(255),
	@Participant_Email VARCHAR(255),
	@Index INT = 0
)  
AS  
BEGIN 
	IF(@Index = 0)
	BEGIN
		DELETE Actual_Meeting_Participants WHERE @SysMeetingId = @SysMeetingId
	END

	INSERT Actual_Meeting_Participants 
	(
		SysMeetingId,
		Next_Page_Token,
		Page_Count,
		Page_Size,
		Total_Records,
		Participant_Id,
		Participant_Name,
		Participant_Email,
		CreatedBy,
		CreatedDttm
	)

	SELECT 
		@SysMeetingId,
		@Next_Page_Token,
		@Page_Count,
		@Page_Size,
		@Total_Records,
		@Participant_Id,
		@Participant_Name,
		@Participant_Email,
		0,
		GETDATE()
END
GO