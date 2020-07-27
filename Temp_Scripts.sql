--SELECT TOP 10 * FROM SYS.TABLES WHERE NAME like '%tpd%log%'
--SELECT TOP 10 * FROM OCO_TPD_LOG WITH (NOLOCK) WHERE request_method_nm like '%meeting%' order by request_end_dttm desc

SELECT * FROM OCO_TPD_LOG WITH (NOLOCK) WHERE request_method_nm like '%meeting%' and request_text like '%83945897272%' order by request_start_dttm desc

--83945897272
{"Event":"meeting.ended","Payload":{"Account_Id":"WZv0wFOVT6akB2kWnf3jRA","Object":{"Id":"83945897272","Uuid":"1l0mQqGKSqukWapGEztlRQ==","Host_id":"z06tt8WbQdqb-PE2_Rexkw","Topic":"VC-Live Integration 7/20","Type":2,"Start_time":"2020-07-20T04:51:15Z","Timezone":"America/Chicago","Duration":60}}}
{"Event":"meeting.ended","Payload":{"Account_Id":"WZv0wFOVT6akB2kWnf3jRA","Object":{"Id":"83945897272","Uuid":"hv6VtYf0QGq7C/nv3lCIOw==","Host_id":"z06tt8WbQdqb-PE2_Rexkw","Topic":"VC-Live Integration 7/20","Type":2,"Start_time":"2020-07-20T05:37:18Z","Timezone":"America/Chicago","Duration":60}}}

--select * from vc_enrollment
--select * from vc_enrollment_details
select top 10 * from Live_Meeting_Recordings
select * from App_Config where AppConfigId = 85

select top 10 * from app_error_log order by created_dttm desc

select top 10 * from user_details order by user_id desc

select * from Live_Meeting_Participants order by SysMeetingId desc

select * from Live_Meetings order by SysMeetingId desc

--select * from 
Use TEST_ONCARE_SESSION

select * from Active_User_Session Where user_session_id = '887b2326-b3ac-4e12-8bd3-8f7a5dd419be'

OU: 37382
C: 1154,
U: 55478

select * from User_Details Where User_id = 55478
select * from User_Details Where User_id = 43272

select * from Live_Meetings Where Company_Id = 1154
select * from Live_Meetings Where SysMeetingId = 137

--Update Live_Meetings 
--Set MeetingHostUserId = 55478, SysVcEnrollmentId = 1
--Where Company_Id = 1154 AND MeetingHostUserId = 30215

select Company_Id, MeetingHostUserId, count(1) from Live_Meetings Where Company_Id = 1154 Group By Company_Id, MeetingHostUserId

	SELECT	DISTINCT 
		U.User_Id,
		U.FirstName,
		U.LastName,
		AR.app_role_id
	FROM app_role AR WITH (NOLOCK)
	JOIN company_app_role  CAR WITH (NOLOCK) ON CAR.app_role_id = AR.app_role_id
	JOIN user_role UR WITH (NOLOCK) ON UR.company_app_role_id = CAR.company_app_role_id
	JOIN User_Details U WITH (NOLOCK) ON U.User_Id = UR.user_id
	WHERE (CAR.company_id = 1154 OR CAR.Company_Id = 1) AND	
	U.User_Id = 55478


	kidsu_demo  /  welcome@123

Company ID	1825
Location ID	1

Select * from Live_License
Select * from Live_Meeting_License

Exec GET_Live_Meeting_License_By_Company_Center 1825, 1

--sp_depends Live_Meeting_License

Exec SAVE_Live_Meeting_License 
 @SysLiveLicenseId = 1,  
 @Company_Id = 1825,  
 @Center_Id = 1,  
 @LiveUserId  = '129872078',  
 @LiveUserName  = 'kartheesan.j@busofttech.com',  
 @LiveMeetingId  = '9745155513 ',  
 @LiveMeetingPassword  = '5Jgyqh',  
 @MeetingLicenseStatus = 1,    
 @UserId = 1,    
 @TransactionDttm = '2020-07-24 00:38:23.953',
 @SysLiveMeetingLicenseId = 0  

Select  dbo.GetMeetingAttendeesCount(137)

SELECT *  FROM app_config WHERE AppConfigId IN (80,81,82,83, 85, 86, 87, 88, 89) ORDER By AppConfigId
SELECT *  FROM app_config_beta WHERE AppConfigId IN (80,81,82,83, 85, 86, 87, 88, 89) ORDER By AppConfigId
GO

use OCO_DEV_LOG
select top 10 * from OCO_TPD_LOG order by request_start_dttm desc

Exec CreateAppJob_AppProcess 'LiveMeetingEndProcess', 'C:\OCO_TEST\OCOJOBS\LiveMeetingJob\LiveMeetingJob.exe'

--Exec GET_InCompleteMeetings

select * from Live_Meeting_Recordings
select * from Actual_Meeting_Participants
--select * from Live_Meetings