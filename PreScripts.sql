-- app_config 
IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 80 
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (80, 'https://app.1core.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 80
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (80, 'https://app.1core.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 81
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (81, 'https://app.1core.com/live/#/close/', 'PP Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 81
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (81, 'https://app.1core.com/live/#/close/', ' PP Meeting Leave Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 82
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (82, 'https://api.zoom.us/v2/users/[USERID]/meetings', 'Add Meeting URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 82
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (82, 'https://api.zoom.us/v2/users/[USERID]/meetings', 'Add Meeting URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 83 
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (83, 'https://app.1core.com/live/#/live/', 'PP Meeting Start / Join URL ')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 83
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (83, 'https://app.1core.com/live/#/live/', 'PP Meeting Start / Join URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 85
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (85, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings', 'Get Meeting Recordings Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 85
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 85)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (85, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings', 'Get Meeting Recordings Url')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 86
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (86, 'https://api.zoom.us/v2/past_meetings/[UUID]', 'Get Past Meeting Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 86
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 86)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (86, 'https://api.zoom.us/v2/past_meetings/[UUID]', 'Get Past Meeting Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 87
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (87, 'https://api.zoom.us/v2/past_meetings/[UUID]/participants', 'Get Past Meeting Participants Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 87
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 87)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (87, 'https://api.zoom.us/v2/past_meetings/[UUID]/participants', 'Get Past Meeting Participants Deails')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 88
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (88, 'https://staff.1core.com/#', 'Staff Portal Client')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 88
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 88)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (88, 'https://staff.1core.com/#', 'Staff Portal Client')
END
GO

IF EXISTS(SELECT TOP 1 1  FROM app_config WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	DELETE  FROM app_config WHERE AppConfigId = 89
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (89, 'https://staff.1core.com/', 'Staff Base URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 89
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 89)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (89, 'https://staff.1core.com/', 'Staff Base URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 92)
BEGIN
	DELETE FROM app_config WHERE AppConfigId = 92
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 92)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (92, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings/settings', 'Meeting Recording Settings URL')
END
GO

IF EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 92)
BEGIN
	DELETE FROM app_config_beta WHERE AppConfigId = 92
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (82, 'https://api.zoom.us/v2/meetings/[MEETINGID]/recordings/settings', 'Meeting Recording Settings URL')
END
GO

--**********************************************************************************************************************************

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
	SELECT 'GET_Live_Meeting_Participants_Company_Center', '{"InputColumnNames":null,"OutputParamaters":[{"TableIndex":0,"OutputColumnNames":["Parent_FirstName", "Parent_LastName", "Family_FirstName", "Family_LastName", "Family_Account_No", "parent2_first_name", "parent2_last_name", "PARENT1_CELL_PHONE", "HOME_PHONE", "PARENT2_CELL_PHONE", "HOME_PHONE2", "Child_FirstName", "Child_LastName", "PRIMARY_EMAIL", "SECONDARY_EMAIL"]},{"TableIndex":1,"OutputColumnNames":["Child_FirstName", "Child_LastName"]}]}'
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
	SELECT 'GET_Meetings_By_Company_Center', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName", "MeetingHostLastName", "StaffFirstName", "StaffLastName", "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
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
	SELECT 'GET_Meeting_By_Id', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName", "MeetingHostLastName", "StaffFirstName", "StaffLastName", "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
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
	SELECT 'GET_Meetings_List_For_Parent', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName", "MeetingHostLastName", "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName", "Child_First_Name", "Child_Last_Name"]},{"TableIndex":2,"OutputColumnNames":["Child_FirstName", "Child_LastName"]}]}'
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

IF EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Staff')
BEGIN
	DELETE FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Staff'
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM Pii_Elements WHERE ElementName = 'GET_Meetings_By_Staff')
BEGIN
	INSERT INTO Pii_Elements (ElementName, Parameters)
	SELECT 'GET_Meetings_By_Staff', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName", "MeetingHostLastName", "StaffFirstName", "StaffLastName", "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
END
GO

--**********************************************************************************************************************************

IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'AlternateTimeZoneInfoId' AND OBJECT_ID = OBJECT_ID(N'timezone'))
BEGIN
	ALTER TABLE timezone ADD AlternateTimeZoneInfoId VARCHAR(100) NULL
END
GO

--**********************************************************************************************************************************

Truncate Table App_Live_Meeting_Type
Truncate Table Live_Meeting_Type
Truncate Table Live_License
Truncate Table Live_Meeting_License
GO

Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Live Meeting',
    @MaxParticipants = 20,
    @GraceTime = 5,
    @CallDuration = 125,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 1,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 0,
    @IsPrivateChat = 0,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 1,
    @IsScreenSharingByParticipants = 1,
    @IsWhiteboard = 1,
	@MeetingTypeStatus = 1,
	@IsSendReminderHost = 1,
	@IsSendReminderParticipants  = 1,
	@IsRecordSession  = 1,
	@MeetingEndBufferTime = 30,
	@SysMeetingTypeId = 0,
	@UserId = 1
GO
Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Virtual Preschool',
    @MaxParticipants = 10,
    @GraceTime = 5,
    @CallDuration = 60,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 0,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 1,
    @IsPrivateChat = 1,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 0,
    @IsScreenSharingByParticipants = 0,
    @IsWhiteboard = 0,
	@MeetingTypeStatus = 1,
	@IsSendReminderHost = 1,
	@IsSendReminderParticipants  = 1,
	@IsRecordSession  = 1,
	@MeetingEndBufferTime = 30,
	@SysMeetingTypeId = 0,
	@UserId = 1
GO
EXEC SAVE_Live_License
	@Company_Id = 1,
	@Center_Id = 1,
	@LiveApiKey = 'wZT0tluKQ2eV7sZXEkb0GQ',
	@LiveApiSecret = 'c5WxFH1SlTJq7kx19wyUaczijt21n4l5MErW',
	@LicenseStatus = 1,
	@UserId = 1,
	@SysLiveLicenseId = 1
GO
Exec SAVE_Live_Meeting_License
	@SysLiveLicenseId = 1,
	@Company_Id = 1,
	@Center_Id = 1,
	@LiveUserId = '129872078',
	@LiveUserName = 'swamivenkat@1coresolution.com',
	@LiveMeetingId = '6361405650',
	@LiveMeetingPassword = '5Jgyqh',
	@MeetingLicenseStatus = 1,
	@UserId = 1,
	@SysLiveMeetingLicenseId = 1
GO

--**********************************************************************************************************************************

Exec CreateAppJob_AppProcess 'LiveMeetingEndProcess', 'C:\OCO_TEST\OCOJOBS\LiveMeetingJob\LiveMeetingJob.exe', 1, 'Hourly', 30
GO

--**********************************************************************************************************************************

IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'timezone_bak_08082020')
BEGIN
    DROP TABLE timezone_bak_08082020
END
GO
SELECT * INTO timezone_bak_08082020 from timezone WITH (NOLOCK)
GO

Update timezone Set AlternateTimeZoneInfoId = 'Etc/GMT+12' WHERE timezone_nm = '(UTC-12:00) International Date Line West'
Update timezone Set AlternateTimeZoneInfoId = 'Etc/GMT+11' WHERE timezone_nm = '(UTC-11:00) Coordinated Universal Time-11'
Update timezone Set AlternateTimeZoneInfoId = 'Etc/GMT+10' WHERE timezone_nm = '(UTC-10:00) Hawaii'
Update timezone Set AlternateTimeZoneInfoId = 'America/Anchorage' WHERE timezone_nm = '(UTC-09:00) Alaska'
Update timezone Set AlternateTimeZoneInfoId = 'America/Santa_Isabel' WHERE timezone_nm = '(UTC-08:00) Baja California'
Update timezone Set AlternateTimeZoneInfoId = 'America/Dawson' WHERE timezone_nm = '(UTC-08:00) Pacific Time (US & Canada)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Creston' WHERE timezone_nm = '(UTC-07:00) Arizona'
Update timezone Set AlternateTimeZoneInfoId = 'America/Chihuahua' WHERE timezone_nm = '(UTC-07:00) Chihuahua, La Paz, Mazatlan'
Update timezone Set AlternateTimeZoneInfoId = 'America/Boise' WHERE timezone_nm = '(UTC-07:00) Mountain Time (US & Canada)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Belize' WHERE timezone_nm = '(UTC-06:00) Central America'
Update timezone Set AlternateTimeZoneInfoId = 'America/Chicago' WHERE timezone_nm = '(UTC-06:00) Central Time (US & Canada)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Bahia_Banderas' WHERE timezone_nm = '(UTC-06:00) Guadalajara, Mexico City, Monterrey'
Update timezone Set AlternateTimeZoneInfoId = 'America/Regina' WHERE timezone_nm = '(UTC-06:00) Saskatchewan'
Update timezone Set AlternateTimeZoneInfoId = 'America/Detroit' WHERE timezone_nm = '(UTC-05:00) Eastern Time (US & Canada)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Indiana/Marengo' WHERE timezone_nm = '(UTC-05:00) Indiana (East)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Caracas' WHERE timezone_nm = '(UTC-04:30) Caracas'
Update timezone Set AlternateTimeZoneInfoId = 'America/Asuncion' WHERE timezone_nm = '(UTC-04:00) Asuncion'
Update timezone Set AlternateTimeZoneInfoId = 'America/Glace_Bay' WHERE timezone_nm = '(UTC-04:00) Atlantic Time (Canada)'
Update timezone Set AlternateTimeZoneInfoId = 'America/Santiago' WHERE timezone_nm = '(UTC-04:00) Santiago'
Update timezone Set AlternateTimeZoneInfoId = 'America/Sao_Paulo' WHERE timezone_nm = '(UTC-03:00) Brasilia'
Update timezone Set AlternateTimeZoneInfoId = 'America/Argentina/La_Rioja' WHERE timezone_nm = '(UTC-03:00) Buenos Aires'
Update timezone Set AlternateTimeZoneInfoId = 'America/Araguaina' WHERE timezone_nm = '(UTC-03:00) Cayenne, Fortaleza'
Update timezone Set AlternateTimeZoneInfoId = 'America/Godthab' WHERE timezone_nm = '(UTC-03:00) Greenland'
Update timezone Set AlternateTimeZoneInfoId = 'America/Montevideo' WHERE timezone_nm = '(UTC-03:00) Montevideo'
Update timezone Set AlternateTimeZoneInfoId = 'America/Bahia' WHERE timezone_nm = '(UTC-03:00) Salvador'
Update timezone Set AlternateTimeZoneInfoId = 'America/Noronha' WHERE timezone_nm = '(UTC-02:00) Coordinated Universal Time-02'
Update timezone Set AlternateTimeZoneInfoId = 'America/Scoresbysund' WHERE timezone_nm = '(UTC-01:00) Azores'
Update timezone Set AlternateTimeZoneInfoId = 'Atlantic/Cape_Verde' WHERE timezone_nm = '(UTC-01:00) Cape Verde Is.'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Casablanca' WHERE timezone_nm = '(UTC) Casablanca'
Update timezone Set AlternateTimeZoneInfoId = 'America/Danmarkshavn' WHERE timezone_nm = '(UTC) Coordinated Universal Time'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Abidjan' WHERE timezone_nm = '(UTC) Monrovia, Reykjavik'
Update timezone Set AlternateTimeZoneInfoId = 'Arctic/Longyearbyen' WHERE timezone_nm = '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'
Update timezone Set AlternateTimeZoneInfoId = 'Europe/Belgrade' WHERE timezone_nm = '(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Ceuta' WHERE timezone_nm = '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris'
Update timezone Set AlternateTimeZoneInfoId = 'Europe/Sarajevo' WHERE timezone_nm = '(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Algiers' WHERE timezone_nm = '(UTC+01:00) West Central Africa'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Windhoek' WHERE timezone_nm = '(UTC+01:00) Windhoek'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Nicosia' WHERE timezone_nm = '(UTC+02:00) Athens, Bucharest'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Beirut' WHERE timezone_nm = '(UTC+02:00) Beirut'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Cairo' WHERE timezone_nm = '(UTC+02:00) Cairo'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Damascus' WHERE timezone_nm = '(UTC+02:00) Damascus'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Nicosia' WHERE timezone_nm = '(UTC+02:00) E. Europe'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Blantyre' WHERE timezone_nm = '(UTC+02:00) Harare, Pretoria'
Update timezone Set AlternateTimeZoneInfoId = 'Europe/Helsinki' WHERE timezone_nm = '(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Jerusalem' WHERE timezone_nm = '(UTC+02:00) Jerusalem'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Tripoli' WHERE timezone_nm = '(UTC+02:00) Tripoli'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Baghdad' WHERE timezone_nm = '(UTC+03:00) Baghdad'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Aden' WHERE timezone_nm = '(UTC+03:00) Kuwait, Riyadh'
Update timezone Set AlternateTimeZoneInfoId = 'Africa/Addis_Ababa' WHERE timezone_nm = '(UTC+03:00) Nairobi'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Tehran' WHERE timezone_nm = '(UTC+03:30) Tehran'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Dubai' WHERE timezone_nm = '(UTC+04:00) Abu Dhabi, Muscat'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Baku' WHERE timezone_nm = '(UTC+04:00) Baku'
Update timezone Set AlternateTimeZoneInfoId = 'Indian/Mahe' WHERE timezone_nm = '(UTC+04:00) Port Louis'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Tbilisi' WHERE timezone_nm = '(UTC+04:00) Tbilisi'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Yerevan' WHERE timezone_nm = '(UTC+04:00) Yerevan'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Kabul' WHERE timezone_nm = '(UTC+04:30) Kabul'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/Mawson' WHERE timezone_nm = '(UTC+05:00) Ashgabat, Tashkent'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Karachi' WHERE timezone_nm = '(UTC+05:00) Islamabad, Karachi'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Kolkata' WHERE timezone_nm = '(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Colombo' WHERE timezone_nm = '(UTC+05:30) Sri Jayawardenepura'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Kathmandu' WHERE timezone_nm = '(UTC+05:45) Kathmandu'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/Davis' WHERE timezone_nm = '(UTC+07:00) Bangkok, Hanoi, Jakarta'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Novokuznetsk' WHERE timezone_nm = '(UTC+07:00) Novosibirsk'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Hong_Kong' WHERE timezone_nm = '(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Krasnoyarsk' WHERE timezone_nm = '(UTC+08:00) Krasnoyarsk'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Brunei' WHERE timezone_nm = '(UTC+08:00) Kuala Lumpur, Singapore'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/Casey' WHERE timezone_nm = '(UTC+08:00) Perth'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Taipei' WHERE timezone_nm = '(UTC+08:00) Taipei'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Choibalsan' WHERE timezone_nm = '(UTC+08:00) Ulaanbaatar'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Dili' WHERE timezone_nm = '(UTC+09:00) Osaka, Sapporo, Tokyo'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Pyongyang' WHERE timezone_nm = '(UTC+09:00) Seoul'
Update timezone Set AlternateTimeZoneInfoId = 'Australia/Adelaide' WHERE timezone_nm = '(UTC+09:30) Adelaide'
Update timezone Set AlternateTimeZoneInfoId = 'Australia/Darwin' WHERE timezone_nm = '(UTC+09:30) Darwin'
Update timezone Set AlternateTimeZoneInfoId = 'Australia/Brisbane' WHERE timezone_nm = '(UTC+10:00) Brisbane'
Update timezone Set AlternateTimeZoneInfoId = 'Australia/Melbourne' WHERE timezone_nm = '(UTC+10:00) Canberra, Melbourne, Sydney'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/DumontDUrville' WHERE timezone_nm = '(UTC+10:00) Guam, Port Moresby'
Update timezone Set AlternateTimeZoneInfoId = 'Australia/Currie' WHERE timezone_nm = '(UTC+10:00) Hobart'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/Macquarie' WHERE timezone_nm = '(UTC+11:00) Solomon Is., New Caledonia'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Sakhalin' WHERE timezone_nm = '(UTC+11:00) Vladivostok'
Update timezone Set AlternateTimeZoneInfoId = 'Antarctica/McMurdo' WHERE timezone_nm = '(UTC+12:00) Auckland, Wellington'
Update timezone Set AlternateTimeZoneInfoId = 'Etc/GMT-12' WHERE timezone_nm = '(UTC+12:00) Coordinated Universal Time+12'
Update timezone Set AlternateTimeZoneInfoId = 'Pacific/Fiji' WHERE timezone_nm = '(UTC+12:00) Fiji'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Anadyr' WHERE timezone_nm = '(UTC+12:00) Magadan'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Kamchatka' WHERE timezone_nm = '(UTC+12:00) Petropavlovsk-Kamchatsky - Old'
Update timezone Set AlternateTimeZoneInfoId = 'Asia/Dhaka' WHERE timezone_nm = '(UTC+06:00) Dhaka'
GO

Truncate Table Live_Meeting_License
GO
INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1455,	1, '129872078', 'swamivenkat@1coresolution.com', '6361405650', '5Jgyqh', 1, 1, Getdate()
GO
INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1154,	1, '129872078', 'kartheesan.j@busofttech.com', '9745155513 ', '5Jgyqh', 1, 1, Getdate()
GO