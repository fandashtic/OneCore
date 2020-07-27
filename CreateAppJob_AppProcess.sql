-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 23rd Jul 2020
-- Description: Create new stored procedure for add Job and process.
-- Return App Job Id
-- ==============================================================================================
--Exec CreateAppJob_AppProcess 'LiveMeetingEndProcess', 'C:\OCO_TEST\OCOJOBS\LiveMeetingJob\LiveMeetingJob.exe'
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'CreateAppJob_AppProcess')
BEGIN
    DROP PROC CreateAppJob_AppProcess
END
GO
CREATE PROC CreateAppJob_AppProcess (@app_proc_nm VARCHAR(50), @ExePath VARCHAR(1000) = '')
AS  
BEGIN
	DECLARE @app_proc_id INT

	IF NOT EXISTS (SELECT TOP 1 1 FROM app_process WITH (NOLOCK) WHERE app_proc_nm = @app_proc_nm)
	BEGIN
		INSERT INTO app_process(app_proc_nm, app_proc_ver, is_proc_active, created_dttm, updated_dttm, app_proc_exec_nm, category_id)
		SELECT @app_proc_nm , 1 ,1, GETDATE() , GETDATE() , @ExePath, 2

		SET @app_proc_id = SCOPE_IDENTITY();

		INSERT INTO app_job (app_proc_id, app_job_status_id, app_job_start_dttm, app_job_end_dttm, 
		app_job_freq, app_job_last_exec_dttm, app_job_time_interval, created_dttm,updated_dttm)
		SELECT @app_proc_id , 1 ,GETDATE() ,'9999-12-31 00:00:00.000' ,'Hourly' , GETDATE() , 1 ,GETDATE() , GETDATE()	

		SELECT SCOPE_IDENTITY();
	END
	ELSE
	BEGIN
		SELECT J.app_job_id FROM app_process P WITH (NOLOCK) 
		JOIN app_job J WITH (NOLOCK) ON J.app_proc_id = P.app_proc_id
		WHERE P.app_proc_nm = @app_proc_nm
	END
END
GO