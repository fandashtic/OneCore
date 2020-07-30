-- app_config
IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80 
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (80, 'https://360.oncareoffice.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (80, 'https://360.oncareoffice.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (81, 'https://360.oncareoffice.com/live/#/close/', 'PP Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (81, 'https://360.oncareoffice.com/live/#/close/', ' PP Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (82, 'https://api.zoom.us/v2/users/[USERID]/meetings', 'Add Meeting URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (82, 'https://api.zoom.us/v2/users/[USERID]/meetings', 'Add Meeting URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83 
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (83, 'https://360.oncareoffice.com/live/#/live/', 'PP Meeting Start / Join URL ')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (83, 'https://360.oncareoffice.com/live/#/live/', 'PP Meeting Start / Join URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 85
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (85, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings', 'Get Meeting Recordings Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 85
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (85, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings', 'Get Meeting Recordings Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 86
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (86, 'https://api.zoom.us/v2/past_meetings/[UUID]', 'Get Past Meeting Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 86
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (86, 'https://api.zoom.us/v2/past_meetings/[UUID]', 'Get Past Meeting Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 87
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (87, 'https://api.zoom.us/v2/past_meetings/[UUID]/participants', 'Get Past Meeting Participants Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 87
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (87, 'https://api.zoom.us/v2/past_meetings/[UUID]/participants', 'Get Past Meeting Participants Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	DELETE FROM app_config WITH (NOLOCK) WHERE AppConfigId = 88
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (88, 'https://teststaff.1core.com/#', 'Staff Portal Client')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 88
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (88, 'https://teststaff.1core.com/#', 'Staff Portal Client')
END
GO

IF EXISTS(SELECT TOP 1 1  FROM app_config WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	DELETE  FROM app_config WITH (NOLOCK) WHERE AppConfigId = 89
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (89, 'https://teststaff.1core.com/', 'Staff Base URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	DELETE FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 89
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (89, 'https://teststaff.1core.com/', 'Staff Base URL')
END
GO


-- Pii_Elements:

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Hosts_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_Hosts_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["FirstName" ,"LastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_Participants_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_Participants_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["Parent_FirstName", "Parent_LastName", "Family_FirstName", "Family_LastName", "Family_Account_No", "parent2_first_name", "parent2_last_name", "PARENT1_CELL_PHONE", "HOME_PHONE", "PARENT2_CELL_PHONE", "HOME_PHONE2", "Child_FirstName", "Child_LastName", "PRIMARY_EMAIL", "SECONDARY_EMAIL"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Company_Center')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_By_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meeting_By_Id')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meeting_By_Id', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_List_For_Parent')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_List_For_Parent', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName", "Child_First_Name", "Child_Last_Name"]}]}'
END
GO

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Live_Meeting_LicenseDetails_By_MeetingId')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Live_Meeting_LicenseDetails_By_MeetingId', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["DisplayNameFirstName" ,"DisplayNameLastName"]}]}'
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Staff')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_By_Staff', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'OneCoreUserId' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_License'))
BEGIN
	ALTER TABLE Live_Meeting_License ADD OneCoreUserId INT
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MeetingId' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD MeetingId VARCHAR(50) NULL
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'StartURL' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD StartURL VARCHAR(4000) NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'JoinURL' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD JoinURL VARCHAR(1000) NULL
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'AlternateTimeZoneInfoId' AND OBJECT_ID = OBJECT_ID(N'timezone'))
BEGIN
	ALTER TABLE timezone ADD AlternateTimeZoneInfoId VARCHAR(100) NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'Uuid' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD Uuid VARCHAR(1000) NULL
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'Eqs' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Participants'))
BEGIN
	ALTER TABLE Live_Meeting_Participants ADD Eqs VARCHAR(4000) NULL
END
GO

--Add Script on 15-Jul-2020 by Manickam.G

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'ActualMeetingStartTime' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD ActualMeetingStartTime DATETIME
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'ActualMeetingEndTime' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD ActualMeetingEndTime DATETIME
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'ActualMeetingStartTime' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Participants'))
BEGIN
	ALTER TABLE Live_Meeting_Participants ADD ActualMeetingStartTime DATETIME
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'ActualMeetingEndTime' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Participants'))
BEGIN
	ALTER TABLE Live_Meeting_Participants ADD ActualMeetingEndTime DATETIME
END
GO

IF EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MeetingsStatus' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	EXEC sp_rename 'Live_Meetings.MeetingsStatus', 'MeetingStatus', 'COLUMN'; 
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'ParticipantsCount' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD ParticipantsCount INT
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MeetingAttendeesCount' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD MeetingAttendeesCount INT
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MaxMeetingCount' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_License'))
BEGIN
	ALTER TABLE Live_Meeting_License ADD MaxMeetingCount INT
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsJobExecuted' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD IsJobExecuted BIT
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'LastJobExecutedOn' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD LastJobExecutedOn DATETIME NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'AppJobHistId' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD AppJobHistId INT NULL
END
GO

--Changes on 28-Jul-2020

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'HostTimezoneId' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD HostTimezoneId INT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsSendReminderHost' AND OBJECT_ID = OBJECT_ID(N'App_Live_Meeting_Type'))
BEGIN
	ALTER TABLE App_Live_Meeting_Type ADD IsSendReminderHost BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsSendReminderParticipants' AND OBJECT_ID = OBJECT_ID(N'App_Live_Meeting_Type'))
BEGIN
	ALTER TABLE App_Live_Meeting_Type ADD IsSendReminderParticipants BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsRecordSession' AND OBJECT_ID = OBJECT_ID(N'App_Live_Meeting_Type'))
BEGIN
	ALTER TABLE App_Live_Meeting_Type ADD IsRecordSession BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsSendReminderHost' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Type'))
BEGIN
	ALTER TABLE Live_Meeting_Type ADD IsSendReminderHost BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsSendReminderParticipants' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Type'))
BEGIN
	ALTER TABLE Live_Meeting_Type ADD IsSendReminderParticipants BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'IsRecordSession' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Type'))
BEGIN
	ALTER TABLE Live_Meeting_Type ADD IsRecordSession BIT NULL
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'AppLiveMeetingId' AND OBJECT_ID = OBJECT_ID(N'Live_Meeting_Type'))
BEGIN
	ALTER TABLE Live_Meeting_Type ADD AppLiveMeetingId INT NULL
END
GO

Update App_Live_Meeting_Type SET MeetingTypeName = 'Live Meeting' WHERE SysMeetingTypeId = 1
Update App_Live_Meeting_Type SET MeetingTypeName = 'Virtual Preschool' WHERE SysMeetingTypeId = 2
DELETE App_Live_Meeting_Type WHERE SysMeetingTypeId > 2

Update Live_Meeting_Type SET AppLiveMeetingId = 1 WHERE MeetingTypeName = 'Virtual Classroom'
Update Live_Meeting_Type SET AppLiveMeetingId = 2 WHERE MeetingTypeName = 'Virtual Tour'

Update Live_Meeting_Type SET MeetingTypeName = 'Live Meeting' WHERE AppLiveMeetingId = 1
Update Live_Meeting_Type SET MeetingTypeName = 'Virtual Preschool' WHERE AppLiveMeetingId = 2
DELETE Live_Meeting_Type WHERE ISNULL(AppLiveMeetingId, 0) = 0
GO
Exec CreateAppJob_AppProcess 'LiveMeetingEndProcess', 'C:\OCO_TEST\OCOJOBS\LiveMeetingJob\LiveMeetingJob.exe'
GO

--29-Jul-2020 Changes
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MeetingDate' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD MeetingDate DATE NULL
END
GO