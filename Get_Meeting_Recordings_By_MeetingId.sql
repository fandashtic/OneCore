-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 21st Jul 2020
-- Description: Create new stored procedure to get meeting recording details by meeting id.
-- Return schedule meeting details
-- ==============================================================================================
--Exec Get_Meeting_Recordings_By_MeetingId 137
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Meeting_Recordings_By_MeetingId')
BEGIN
    DROP PROC Get_Meeting_Recordings_By_MeetingId
END
GO
Create PROC Get_Meeting_Recordings_By_MeetingId 
(   
	@SysMeetingId INT
)  
AS  
BEGIN 
	SELECT 
		R.SysMeetingId,
		Duration,
		Recording_Count,
		Share_Url,
		Start_Time,
		(SELECT TOP 1 t.TimeZoneInfoId FROM timezone t WITH (NOLOCK) WHERE timezone_id = M.TimeZoneId) Timezone,
		R.Uuid,
		Download_Url,
		File_Size,
		File_Type,
		Recording_Id,
		Play_Url,
		Recording_End,
		Recording_Start,
		Recording_Type		
	FROM Live_Meeting_Recordings R WITH (NOLOCK)
	JOIN Live_Meetings M ON M.SysMeetingId = R.SysMeetingId
	WHERE R.SysMeetingId = @SysMeetingId
END
GO