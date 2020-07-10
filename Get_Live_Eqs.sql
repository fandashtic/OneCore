-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 3rd Jul 2020
-- Description: Create new stored procedure to get live meeting eqs data
-- Return eqs data
-- ==============================================================================================
--Exec Get_LIve_Eqs 169
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Live_Eqs')
BEGIN
    DROP PROC Get_Live_Eqs
END
GO
CREATE PROC Get_Live_Eqs      
(  
 @SysParticipantId INT
)      
AS      
BEGIN 
	SELECT TOP 1 Eqs FROM Live_Meeting_Participants WITH (NOLOCK) WHERE SysParticipantId = @SysParticipantId
END
GO
