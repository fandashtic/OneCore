/*

Truncate Table App_Live_Meeting_Type
Truncate Table Live_Meeting_Type
Truncate Table Live_License
Truncate Table Live_Meeting_License

Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Virtual Classroom',
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
	@SysMeetingTypeId = 1,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'

Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'Virtual Tour',
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
	@SysMeetingTypeId = 2,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'


Exec SAVE_App_Live_Meeting_Type @MeetingTypeName = 'OneToOne',
    @MaxParticipants = 1,
    @GraceTime = 5,
    @CallDuration = 60,
    @IsShowHostVideo = 1,
    @IsShowParticipantsVideo = 1,
    @IsMuteParticipant = 1,
    @IsViewOtherParticipants = 0,
    @IsJoinbeforeHost  = 0,
    @IsChat = 0,
    @IsPrivateChat = 0,
    @IsFileTransfer = 0,
    @IsScreenSharingByHost = 0,
    @IsScreenSharingByParticipants = 0,
    @IsWhiteboard = 0,
	@MeetingTypeStatus = 1,
	@SysMeetingTypeId = 3,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020'

Exec COPY_App_Live_Meeting_Type_To_Custom_Live_Meeting_Type	@Company_Id = 1, @Center_Id = 1, @UserId = 1, @TransactionDttm = '15-Jun-2020'

EXEC SAVE_Live_License
	@Company_Id = 1,
	@Center_Id = 1,
	@LiveApiKey = 'wZT0tluKQ2eV7sZXEkb0GQ',
	@LiveApiSecret = 'c5WxFH1SlTJq7kx19wyUaczijt21n4l5MErW',
	@LicenseStatus = 1,
	@UserId = 1,
	@TransactionDttm = '15-Jun-2020',
	@SysLiveLicenseId = 1

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
	@TransactionDttm = '15-Jun-2020',
	@SysLiveMeetingLicenseId = 1

Select * from App_Live_Meeting_Type
select * from Live_Meeting_Type
select * from Live_License
select * from Live_Meeting_License
Select * from Live_Meetings
select * from Live_Meeting_Participants

*/


select * from Live_Meeting_License
--Truncate Table Live_Meeting_License

INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1,	1, '129872078', 'swamivenkat@1coresolution.com', '6361405650', '5Jgyqh', 1, 1, Getdate()

INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1822,	1, '129872078', 'kartheesan.j@busofttech.com', '9745155513 ', '5Jgyqh', 1, 1, Getdate()

INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1825,	1, '129872078', 'kartheesan.j@busofttech.com', '9745155513 ', '5Jgyqh', 1, 1, Getdate()

INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
SELECT 1, 1154,	1, '129872078', 'kartheesan.j@busofttech.com', '9745155513 ', '5Jgyqh', 1, 1, Getdate()

