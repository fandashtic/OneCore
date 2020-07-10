-- ======================================================================
-- Author: Manickam.G
-- Create date: 3rd Jul 2020
-- Description: Create new stored procedure for update the meeting eqs for the participant id.
-- Return null
-- ======================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Update_Meeting_Eqs')
BEGIN
    DROP PROC Update_Meeting_Eqs
END
GO
Create PROC Update_Meeting_Eqs
(
	@SysParticipantId INT,
	@Eqs VARCHAR(4000)
)
AS
BEGIN	
	IF(@SysParticipantId > 0)
	BEGIN		
		Update L 
		SET L.Eqs = @Eqs
		FROM Live_Meeting_Participants L WITH (NOLOCK)
		WHERE L.SysParticipantId = @SysParticipantId
	END

	SELECT 'Success';
END
GO