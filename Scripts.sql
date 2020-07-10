-- app_config
Delete FROM app_config WHERE AppConfigId IN (80,81,82,83)
Delete FROM app_config_beta WHERE AppConfigId IN (80,81,82,83)
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (80, 'https://360.oncareoffice.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (80, 'https://360.oncareoffice.com/live/#/close/', 'Meeting Leave Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (81, 'https://360.oncareoffice.com/live/#/close/', 'PP Meeting Leave Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (81, 'https://360.oncareoffice.com/live/#/close/', ' PP Meeting Leave Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (82, 'https://360.oncareoffice.com/live/#/live/', 'Meeting Start / Join URL')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 82)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (82, 'https://360.oncareoffice.com/live/#/live/', 'Meeting Start / Join URL')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (83, 'https://360.oncareoffice.com/live/#/live/', 'PP Meeting Start / Join URL ')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 83)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (83, 'https://360.oncareoffice.com/live/#/live/', 'PP Meeting Start / Join URL')
END
GO

SELECT *  FROM app_config WHERE AppConfigId IN (80,81,82,83) ORDER By AppConfigId
SELECT *  FROM app_config_beta WHERE AppConfigId IN (80,81,82,83) ORDER By AppConfigId
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
	SELECT 'GET_Meetings_List_For_Parent', '{"InputColumnNames":null,"OutputParamaters":   [{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]}]}'
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
ALTER TABLE Live_Meeting_License ADD OneCoreUserId INT
GO
ALTER TABLE Live_Meetings ADD MeetingId VARCHAR(50) NULL
GO
ALTER TABLE Live_Meetings ADD StartURL VARCHAR(4000) NULL
GO
ALTER TABLE Live_Meetings ADD JoinURL VARCHAR(1000) NULL
GO
UPDATE App_config SET [Value] = 'https://api.zoom.us/v2/users/[]/meetings' WHERE AppConfigId = 82
GO
UPDATE app_config_beta SET [Value] = 'https://api.zoom.us/v2/users/[]/meetings' WHERE AppConfigId = 82
GO
ALTER TABLE timezone ADD AlternateTimeZoneInfoId VARCHAR(100) NULL
GO
ALTER TABLE Live_Meetings ADD Uuid VARCHAR(1000) NULL
GO
ALTER TABLE Live_Meeting_Participants ADD Eqs VARCHAR(4000) NULL
GO