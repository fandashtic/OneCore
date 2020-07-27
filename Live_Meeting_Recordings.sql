IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Recordings')
BEGIN
    DROP TABLE Live_Meeting_Recordings
END
GO
CREATE TABLE Live_Meeting_Recordings
(
	SysRecordingId INT IDENTITY(1,1),
	SysMeetingId INT,
	Account_Id VARCHAR(255),
	Duration INT,
	Meeting_Host_Id VARCHAR(255),
	Id VARCHAR(255),
	Recording_Count INT,
	Share_Url VARCHAR(255),
	Start_Time DATETIME,
	Timezone VARCHAR(255),
	Topic VARCHAR(255),
	Total_Size INT,
	MeetingType VARCHAR(25),
	Uuid VARCHAR(255),
	Download_Url VARCHAR(255),
	File_Size INT,
	File_Type VARCHAR(25),
	Recording_Id VARCHAR(255),
	Meeting_Id VARCHAR(255),
	Play_Url VARCHAR(255),
	Recording_End DATETIME,
	Recording_Start DATETIME,
	Recording_Type VARCHAR(50),
	MeetingStatus VARCHAR(20),
	CreatedBy INT NULL,
	CreatedDttm DATETIME,
	ModifiedBy INT NULL,
	ModifiedDttm DATETIME NULL
)
GO