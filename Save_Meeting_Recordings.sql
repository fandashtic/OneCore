-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 20th Jul 2020
-- Description: Create new stored procedure to save meeting recordings
-- No Return
-- ==============================================================================================
--Exec Save_Meeting_Recordings 69, 'WZv0wFOVT6akB2kWnf3jRA', 0, 'z06tt8WbQdqb-PE2_Rexkw', '89096004702', 6, 
--'https://us02web.zoom.us/rec/share/osMoE6r-7V1LZquSzUzdRvQaJdnZaaa80CBIrqYPzUrUtFSz5VuI96Y-AgqgI0kZ',
--'2020-07-21T07:10:53Z', 'UTC','XYZ', 3369181, '2', '/g5TsfsVQLO7Mejt2SS5Tw==', 
--'https://us02web.zoom.us/rec/download/tJcvdOqo_Gk3T9OQ5ASDUPd8W466J6qsg3MdrKEMyx7jACNSNgL3MLERYudQjdDIW7wDvEhA2uVNsgX2',
--'892312', 'MP4', '932330bb-e75d-4b15-b791-ab3fb17afcca', '/g5TsfsVQLO7Mejt2SS5Tw==', 
--'https://us02web.zoom.us/rec/play/tJcvdOqo_Gk3T9OQ5ASDUPd8W466J6qsg3MdrKEMyx7jACNSNgL3MLERYudQjdDIW7wDvEhA2uVNsgX2',
--'2020-07-21T07:11:52Z', '2020-07-21T07:11:37Z', 'active_speaker', 'completed', 0

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Save_Meeting_Recordings')
BEGIN
    DROP PROC Save_Meeting_Recordings
END
GO
Create PROC Save_Meeting_Recordings 
(   
	@SysMeetingId INT,
	@Account_Id VARCHAR(255),
	@Duration INT,
	@Meeting_Host_Id VARCHAR(255),
	@Id VARCHAR(255),
	@Recording_Count INT,
	@Share_Url VARCHAR(255),
	@Start_Time DATETIME,
	@Timezone VARCHAR(255),
	@Topic VARCHAR(255),
	@Total_Size INT,
	@Type VARCHAR(25),
	@Uuid VARCHAR(255),
	@Download_Url VARCHAR(255),
	@File_Size INT,
	@File_Type VARCHAR(25),
	@Recording_Id VARCHAR(255),
	@Meeting_Id VARCHAR(255),
	@Play_Url VARCHAR(255),
	@Recording_End DATETIME,
	@Recording_Start DATETIME,
	@Recording_Type VARCHAR(50),
	@Status VARCHAR(20),
	@Index INT = 0
)  
AS  
BEGIN 

	DECLARE	@Company_Id AS INT
	DECLARE	@Center_Id AS INT
		
	IF(@Index = 0)
	BEGIN
		DELETE Live_Meeting_Recordings WHERE SysMeetingId = @SysMeetingId
		UPDATE Live_Meetings SET IsRecordSession = 1 WHERE SysMeetingId = @SysMeetingId
	END

	SELECT @Company_Id = Company_Id, @Center_Id = Center_Id FROM Live_Meetings L WITH (NOLOCK) WHERE SysMeetingId = @SysMeetingId

	INSERT Live_Meeting_Recordings 
	(
		SysMeetingId,
		Company_Id,
		Center_Id,
		Account_Id,
		Duration,
		Meeting_Host_Id,
		Id,
		Recording_Count,
		Share_Url,
		Start_Time,
		Timezone,
		Topic,
		Total_Size,
		MeetingType,
		Uuid,
		Download_Url,
		File_Size,
		File_Type,
		Recording_Id,
		Meeting_Id,
		Play_Url,
		Recording_End,
		Recording_Start,
		Recording_Type,
		MeetingStatus,
		CreatedBy,
		CreatedDttm
	)

	SELECT 
		@SysMeetingId,
		@Company_Id,
		@Center_Id,
		@Account_Id,
		@Duration,
		@Meeting_Host_Id,
		@Id,
		@Recording_Count,
		@Share_Url,
		@Start_Time,
		@Timezone,
		@Topic,
		@Total_Size,
		@Type,
		@Uuid,
		@Download_Url,
		@File_Size,
		@File_Type,
		@Recording_Id,
		@Meeting_Id,
		@Play_Url,
		@Recording_End,
		@Recording_Start,
		@Recording_Type,
		@Status,
		0,
		GETDATE()
END
GO