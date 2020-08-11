
https://app.1core.com/api/MeetingHooks/UpdateEndMeetingStatus
https://app.1core.com/api/MeetingHooks/UpdateMeetingParticipantJoinedStatus
https://app.1core.com/api/MeetingHooks/UpdateMeetingParticipantLeaveStatus


https://360.oncareoffice.com/api/MeetingHooks/UpdateEndMeetingStatus
https://360.oncareoffice.com/api/UpdateMeetingParticipantJoinedStatus
https://360.oncareoffice.com/api/UpdateMeetingParticipantLeaveStatus


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

select top 1 * from Live_Meeting_Recordings where SysMeetingId = 286
select * from app_job


select * from app_job_history where app_job_id = 17

select * from app_error_log where app_job_hist_id = 1301
select * from app_process Where app_proc_id = 69

Update app_process SET is_proc_active = 2 Where app_proc_id = 69

select * from app_job

select * from Live_Meetings where SysMeetingId = 286 Order By SysMeetingId desc

select * from sys.objects where object_id in (select id from syscomments where text like '%Uuid%')
select * from timezone

select * from Live_Meetings  Where SysMeetingId > 107


--Update Live_Meetings Set MeetingStartTime = '2020-07-01 23:30:00', MeetingEndTime = '2020-07-01 23:30:00' Where SysMeetingId <> 102


Tools.GetTimeZoneDateTime("Alaskan Standard Time", 

select top 10 * from Center_Details where Center_Name like '%Live%'
select * from sys.tables where name like '%meeting%'
select top 10 * from app_module where app_mod_nm like '%live%'
select top 10 * from App_Module_Functions where FunctionName like '%like%'
select * from Live_Meeting_Recordings
select * from Actual_Meeting_Participants

sp_depends Live_Meeting_Recordings

--Exec CreateAppJob_AppProcess 'LiveMeetingEndProcess', 'C:\OCO_TEST\OCOJOBS\LiveMeetingJob\LiveMeetingJob.exe', 1, 'Hourly', 30

select * from Live_Meetings Order By SysMeetingId desc
--Update Live_Meetings Set IsRecordSession = 1, IsJobExecuted = 0,AppJobHistId = null
select * from Live_License
select * from Live_Meeting_License

https://us02web.zoom.us/j/6361405650?pwd=QU1PZ1dXajFMbkNCajlsZnZsZHRMdz09

select top 10 * from app_job_history where app_job_id = 74
select top 10 * from app_error_log  where app_err_method_nm like '%Live%' Order by app_err_log_id desc
--Delete from app_error_log  where app_err_method_nm like '%Live%' 
select * from app_process where app_proc_id = 69
select * from app_job where app_proc_id = 69
--Update app_job Set app_job_time_interval = 30 where app_proc_id = 69

Tools.GetTimeZoneDateTime("Alaskan Standard Time", 
Tools.GetTimeZoneDateTime("UTC",

select * from timezone


meetingStartTime.ToUniversalTime()
TimeZoneInfo.ConvertTimeToUtc(meetingStartTime)

TimeZoneInfo tz = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
TimeZoneInfo.ConvertTimeToUtc(date1, tz);


                    TimeZoneInfo tz = TimeZoneInfo.FindSystemTimeZoneById(timeZone);
                    meetingStartTime = TimeZoneInfo.ConvertTimeToUtc(meetingStartTime, tz);
                    meetingEndTime = TimeZoneInfo.ConvertTimeToUtc(meetingEndTime, tz);

select len('asdfsdfsdafdsfdsafdsfdsafdafdsafdsfasfasdfadsfsdfadsfdsfdasfasdfdsfdsfdsafdsafsdafsdfdsfdsafdsasdfsdfdsfsadsdfsdasdfdassdfsdfasdadfdsafdsafdsfdsfdsfsadfsdafsdfdsafsdfsdafsdfsdasdafdsaffsadfsdafsdsadfdsafsdafsdfdsfsdfsdfdasfdsafdsfsdasdafsdafdsafdsafsasdsd')

  select * FROM Live_Meetings M WITH (NOLOCK) order by SysMeetingId desc
   select * from Live_Meeting_Participants Where SysMeetingId = 217

   Update Live_Meetings set IsRecordSession = 1 Where SysMeetingId = 217

select * from Live_Meeting_Recordings
sp_helptext GET_Meetings_List_For_Parent


select * from OCO_TPD_LOG where --request_id > 5633 
--ANd 
request_method_nm like '%/Meeting%'
--and request_text like '%Meeting on 30-07 - 1%'
order by request_start_dttm desc

select * from Live_Meetings Order by SysMeetingId Desc

--29-Jul-2020 Changes
IF NOT EXISTS(SELECT TOP 1 1 FROM sys.columns WHERE Name = N'MeetingDate' AND OBJECT_ID = OBJECT_ID(N'Live_Meetings'))
BEGIN
	ALTER TABLE Live_Meetings ADD MeetingDate DATE NULL
END
GO

ALTER TABLE Live_Meetings DROP COLUMN MeetingDate;

--update Live_Meetings set MeetingDate = MeetingStartTime

select top 10 * from User_Details where  'fitz_vc@beyonduniverse.in'
select * from vc_enrollment_schedule_details
select * from virtual_classroom_details
select * from vc_schedule_details
select * from Live_Meeting_Participants Where SysParticipantId = 1754
select * from Live_Meetings Where SysMeetingId = 227 -- 1822	1
--Update Live_Meeting_Participants Set SysMeetingId = 227, Company_Id = 1822, Center_Id = 1 Where SysParticipantId = 1754

select * from sys.objects where object_id in (select id from Syscomments where text like '%SysVcEnrollmentId%Live_Meetings%')

select * from TEST_ONCARE_LOG.dbo.OCO_TPD_LOG where --request_id > 5633 
--ANd 
request_method_nm like '%/Meeting%'
--and request_text like '%85914161912%'
order by request_start_dttm desc

--Truncate table OCO_TPD_LOG


--select * from App_Live_Meeting_TYpe
--Delete from Live_Meeting_Recordings WHERE SysMeetingId = 4191
--Delete from Actual_Meeting_Participants WHERE SysMeetingId = 4191
select distinct Recording_Type from Live_Meeting_Recordings

select * from Live_Meeting_Recordings WHERE SysMeetingId = 276
select * from Actual_Meeting_Participants WHERE SysMeetingId = 4110

--SELECT TOP 1 1, DATEADD(MINUTE, +(30), L.ActualMeetingEndTime)
--		FROM Live_Meetings L WITH (NOLOCK)
--		WHERE SysMeetingId = 4191 AND
--		L.MeetingStatus = 3 AND 
--		DATEADD(MINUTE, +(30), L.ActualMeetingEndTime) <= '2020-08-04 05:20:04.577'

select IsJobExecuted,AppJobHistId, MeetingStatus, * from Live_Meetings 
Where MeetingName = 'Record meet' 
Order By SysMeetingID DEsc --4712845

--Update app_job Set app_job_time_interval = 30 where app_proc_id = 69
--UPDATE Live_Meetings SET IsRecordSession = 1 WHERE SysMeetingId = 563

--Update Live_Meetings Set IsJobExecuted = 0, AppJobHistId = null Where MeetingName = 'Meeting Recording 1' 
--select top 10 * from app_job_history where app_job_id = 74
--Delete from app_job_history where app_job_id = 74
--select * from app_process where app_proc_id = 69
--select * from app_job where app_proc_id = 69

--Delete from TEST_ONCARE_LOG.dbo.OCO_TPD_LOG where request_method_nm like '%/Meeting%'
select * from TEST_ONCARE_LOG.dbo.OCO_TPD_LOG where request_method_nm like '%/Meeting%'
--and request_text like '%85914161912%'
order by request_start_dttm desc


select * from app_error_log where app_err_method_nm like '%Meeting%'
--Delete from app_error_log where app_err_method_nm like '%Meeting%'
--truncate table app_error_log

select * from Live_Meeting_Participants Where MeetingParticipantUserId = 398980
--Delete from Live_Meeting_Participants Where MeetingParticipantUserId = 398980



select * from Center_Details where Center_ID = 47 and	Company_Id = 1154
select * from CenterConfig where Center_ID = 47 and	Company_Id = 1154
select * from sys.tables where name like '%center%'



Go
update pii_elements set Parameters='{"InputColumnNames":null,"OutputParamaters":[{"TableIndex":0,"OutputColumnNames":["MeetingHostFirstName" ,"MeetingHostLastName" , "CreatedByFirstName", "CreatedByLastName", "ModifiedByFirstName", "ModifiedByLastName"]},{"TableIndex":2,"OutputColumnNames":["Child_FirstName", "Child_LastName"]}]}'
where ElementName='GET_Meetings_List_For_Parent'
Go