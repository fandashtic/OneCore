-- ======================================================================
-- Author: Manickam.G
-- Create date: 5th Aug 2020
-- Description: Create new stored procedure for update the meeting recording play password
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_Meeting_Recording_PassCode')
BEGIN
    DROP PROC Update_Meeting_Recording_PassCode
END
GO
Create PROC Update_Meeting_Recording_PassCode
(
	@MeetingId VARCHAR(100),
	@Password VARCHAR(10)
)
AS
BEGIN
	IF(ISNULL(@MeetingId, '') <> '' AND ISNULL(@Password, '') <> '')
	BEGIN		
		UPDATE Live_Meeting_Recordings SET [Password] = @Password WHERE Id = @MeetingId
	END
END
GO