IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_License')
BEGIN
    DROP TABLE [Live_License]
END
GO
CREATE TABLE [dbo].[Live_License](
	[SysLiveLicenseId] [int] IDENTITY(1,1) NOT NULL,
	[Company_Id] [int] NOT NULL,
	[Center_Id] [int] NULL,
	[LiveApiKey] [varchar](100) NOT NULL,
	[LiveApiSecret] [varchar](255) NOT NULL,
	[LicenseStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL
) ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_License')
BEGIN
    DROP TABLE [Live_Meeting_License]
END
GO
CREATE TABLE [dbo].[Live_Meeting_License](
	[SysLiveMeetingLicenseId] [int] IDENTITY(1,1) NOT NULL,
	[SysLiveLicenseId] [int] NOT NULL,
	[Company_Id] [int] NOT NULL,
	[Center_Id] [int] NULL,
	[LiveUserId] [nvarchar](100) NOT NULL,
	[LiveUserName] [nvarchar](100) NOT NULL,
	[LiveMeetingId] [nvarchar](100) NOT NULL,
	[LiveMeetingPassword] [nvarchar](100) NOT NULL,
	[MeetingLicenseStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[OneCoreUserId] [int] NULL,
	[MaxMeetingCount] [int] NULL,
	[IsDemoAccount] [bit] NULL
) ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'App_Live_Meeting_Type')
BEGIN
    DROP TABLE [App_Live_Meeting_Type]
END
GO
CREATE TABLE [dbo].[App_Live_Meeting_Type](
	[SysMeetingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MeetingTypeName] [varchar](100) NOT NULL,
	[MaxParticipants] [smallint] NOT NULL,
	[GraceTime] [int] NOT NULL,
	[CallDuration] [int] NOT NULL,
	[IsShowHostVideo] [bit] NOT NULL,
	[IsShowParticipantsVideo] [bit] NOT NULL,
	[IsMuteParticipant] [bit] NOT NULL,
	[IsViewOtherParticipants] [bit] NOT NULL,
	[IsJoinbeforeHost] [bit] NOT NULL,
	[IsChat] [bit] NOT NULL,
	[IsPrivateChat] [bit] NOT NULL,
	[IsFileTransfer] [bit] NOT NULL,
	[IsScreenSharingByHost] [bit] NOT NULL,
	[IsScreenSharingByParticipants] [bit] NOT NULL,
	[IsWhiteboard] [bit] NOT NULL,
	[MeetingTypeStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[IsSendReminderHost] [bit] NULL,
	[IsSendReminderParticipants] [bit] NULL,
	[IsRecordSession] [bit] NULL,
	[MeetingEndBufferTime] [int] NOT NULL
) ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Type')
BEGIN
    DROP TABLE [Live_Meeting_Type]
END
GO
CREATE TABLE [dbo].[Live_Meeting_Type](
	[SysMeetingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MeetingTypeName] [varchar](100) NOT NULL,
	[Company_Id] [int] NOT NULL,
	[Center_Id] [int] NULL,
	[MaxParticipants] [smallint] NOT NULL,
	[GraceTime] [int] NOT NULL,
	[CallDuration] [int] NOT NULL,
	[IsShowHostVideo] [bit] NOT NULL,
	[IsShowParticipantsVideo] [bit] NOT NULL,
	[IsMuteParticipant] [bit] NOT NULL,
	[IsViewOtherParticipants] [bit] NOT NULL,
	[IsJoinbeforeHost] [bit] NOT NULL,
	[IsChat] [bit] NOT NULL,
	[IsPrivateChat] [bit] NOT NULL,
	[IsFileTransfer] [bit] NOT NULL,
	[IsScreenSharingByHost] [bit] NOT NULL,
	[IsScreenSharingByParticipants] [bit] NOT NULL,
	[IsWhiteboard] [bit] NOT NULL,
	[MeetingTypeStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[IsSendReminderHost] [bit] NULL,
	[IsSendReminderParticipants] [bit] NULL,
	[IsRecordSession] [bit] NULL,
	[AppLiveMeetingId] [int] NULL,
	[MeetingEndBufferTime] [int] NOT NULL
) ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meetings')
BEGIN
    DROP TABLE [Live_Meetings]
END
GO
CREATE TABLE [dbo].[Live_Meetings](
	[SysMeetingId] [int] IDENTITY(1,1) NOT NULL,
	[SysLiveLicenseId] [int] NOT NULL,
	[SysLiveMeetingLicenseId] [int] NOT NULL,
	[Company_Id] [int] NOT NULL,
	[Center_Id] [int] NULL,
	[MeetingHostUserId] [int] NOT NULL,
	[MeetingName] [nvarchar](100) NOT NULL,
	[TimeZoneId] [int] NOT NULL,
	[MeetingStartTime] [datetime] NOT NULL,
	[MeetingEndTime] [datetime] NOT NULL,
	[MeetingTypeId] [int] NOT NULL,
	[MeetingDescription] [varchar](1000) NULL,
	[IsSendReminderHost] [bit] NOT NULL,
	[IsSendReminderParticipants] [bit] NOT NULL,
	[IsRecordSession] [bit] NOT NULL,
	[MeetingsStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[MeetingId] [varchar](50) NULL,
	[StartURL] [varchar](4000) NULL,
	[JoinURL] [varchar](1000) NULL,
	[Uuid] [varchar](1000) NULL,
	[ActualMeetingStartTime] [datetime] NULL,
	[ActualMeetingEndTime] [datetime] NULL,
	[MeetingStatus] [tinyint] NULL,
	[ParticipantsCount] [int] NULL,
	[MeetingAttendeesCount] [int] NULL,
	[IsJobExecuted] [bit] NULL,
	[LastJobExecutedOn] [datetime] NULL,
	[SysVirtualClassroomId] [int] NULL,
	[SysVcScheduleId] [int] NULL,
	[HostTimezoneId] [int] NULL,
	[AppJobHistId] [int] NULL,
	[IsSystemCreated] [bit] NOT NULL,
	[MeetingDate] [date] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Live_Meetings] ADD  DEFAULT ((0)) FOR [IsSendReminderHost]
GO

ALTER TABLE [dbo].[Live_Meetings] ADD  DEFAULT ((0)) FOR [IsSendReminderParticipants]
GO

ALTER TABLE [dbo].[Live_Meetings] ADD  DEFAULT ((0)) FOR [IsRecordSession]
GO

ALTER TABLE [dbo].[Live_Meetings] ADD  DEFAULT ((1)) FOR [MeetingsStatus]
GO

ALTER TABLE [dbo].[Live_Meetings] ADD  DEFAULT ((0)) FOR [IsSystemCreated]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Participants')
BEGIN
    DROP TABLE [Live_Meeting_Participants]
END
GO
CREATE TABLE [dbo].[Live_Meeting_Participants](
	[SysParticipantId] [int] IDENTITY(1,1) NOT NULL,
	[SysMeetingId] [int] NOT NULL,
	[Company_Id] [int] NOT NULL,
	[Center_Id] [int] NULL,
	[MeetingParticipantUserId] [int] NOT NULL,
	[Family_Id] [int] NULL,
	[Child_Id] [int] NULL,
	[MeetingParticipantStatus] [tinyint] NOT NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[Eqs] [varchar](4000) NULL,
	[ActualMeetingStartTime] [datetime] NULL,
	[ActualMeetingEndTime] [datetime] NULL,
	[SysVcEnrollmentId] [int] NOT NULL,
	[SysVcEnrollScheduleId] [int] NOT NULL,
	[IsSystemCreated] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Live_Meeting_Participants] ADD  DEFAULT ((1)) FOR [MeetingParticipantStatus]
GO

ALTER TABLE [dbo].[Live_Meeting_Participants] ADD  DEFAULT ((0)) FOR [SysVcEnrollmentId]
GO

ALTER TABLE [dbo].[Live_Meeting_Participants] ADD  DEFAULT ((0)) FOR [SysVcEnrollScheduleId]
GO

ALTER TABLE [dbo].[Live_Meeting_Participants] ADD  DEFAULT ((0)) FOR [IsSystemCreated]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Live_Meeting_Recordings')
BEGIN
    DROP TABLE [Live_Meeting_Recordings]
END
GO
CREATE TABLE [dbo].[Live_Meeting_Recordings](
	[SysRecordingId] [int] IDENTITY(1,1) NOT NULL,
	[Company_Id] [int] NULL,
	[Center_Id] [int] NULL,
	[SysMeetingId] [int] NULL,
	[Account_Id] [varchar](255) NULL,
	[Duration] [int] NULL,
	[Meeting_Host_Id] [varchar](255) NULL,
	[Id] [varchar](255) NULL,
	[Recording_Count] [int] NULL,
	[Share_Url] [varchar](255) NULL,
	[Start_Time] [datetime] NULL,
	[Timezone] [varchar](255) NULL,
	[Topic] [varchar](255) NULL,
	[Total_Size] [int] NULL,
	[MeetingType] [varchar](25) NULL,
	[Uuid] [varchar](255) NULL,
	[Download_Url] [varchar](255) NULL,
	[File_Size] [int] NULL,
	[File_Type] [varchar](25) NULL,
	[Recording_Id] [varchar](255) NULL,
	[Meeting_Id] [varchar](255) NULL,
	[Play_Url] [varchar](255) NULL,
	[Recording_End] [datetime] NULL,
	[Recording_Start] [datetime] NULL,
	[Recording_Type] [varchar](50) NULL,
	[MeetingStatus] [varchar](20) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL,
	[Password] [varchar](10) NULL
) ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Actual_Meeting_Participants')
BEGIN
    DROP TABLE [Actual_Meeting_Participants]
END
GO
CREATE TABLE [dbo].[Actual_Meeting_Participants](
	[SysMeetingParticipantId] [int] IDENTITY(1,1) NOT NULL,
	[SysMeetingId] [int] NULL,
	[Next_Page_Token] [varchar](255) NULL,
	[Page_Count] [int] NULL,
	[Page_Size] [int] NULL,
	[Total_Records] [int] NULL,
	[Participant_Id] [varchar](255) NULL,
	[Participant_Name] [varchar](255) NULL,
	[Participant_Email] [varchar](255) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDttm] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDttm] [datetime] NULL
) ON [PRIMARY]
GO