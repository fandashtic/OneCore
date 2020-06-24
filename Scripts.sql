IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (80, 'http://localhost:4200/#/center/live/close', 'Meeting Leave Url')
END
GO
IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 80)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (80, 'http://localhost:4200/#/center/live/close', 'Meeting Leave Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config (AppConfigId, Value , Description) values (81, 'http://localhost:4255/#/live/close', 'Meeting Leave PP Url')
END
GO

IF NOT EXISTS(SELECT TOP 1 1 FROM app_config_beta WITH (NOLOCK) WHERE AppConfigId = 81)
BEGIN
	INSERT INTO app_config_beta (AppConfigId, Value , Description) values (81, 'http://localhost:4255/#/live/close', 'Meeting Leave PP Url')
END
GO

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