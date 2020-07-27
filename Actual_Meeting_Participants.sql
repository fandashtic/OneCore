IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Actual_Meeting_Participants')
BEGIN
    DROP TABLE Actual_Meeting_Participants
END
GO
CREATE TABLE Actual_Meeting_Participants
(
	SysMeetingParticipantId INT IDENTITY(1,1),
	SysMeetingId INT,
	Next_Page_Token VARCHAR(255),
	Page_Count INT,
	Page_Size INT,
	Total_Records INT,
	Participant_Id VARCHAR(255),
	Participant_Name VARCHAR(255),
	Participant_Email VARCHAR(255),
	CreatedBy INT NULL,
	CreatedDttm DATETIME,
	ModifiedBy INT NULL,
	ModifiedDttm DATETIME NULL
)
GO