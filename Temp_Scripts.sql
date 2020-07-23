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

Update Live_Meetings 
Set MeetingHostUserId = 55478, SysVcEnrollmentId = 1
Where Company_Id = 1154 AND MeetingHostUserId = 30215

select Company_Id, MeetingHostUserId, count(1) from Live_Meetings Where Company_Id = 1154 Group By Company_Id, MeetingHostUserId
