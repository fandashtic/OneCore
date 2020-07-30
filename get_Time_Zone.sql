-- ======================================================================================                     
-- Author :      
-- -------- Change History --------------------------------------------------------------                                                                                        
-- Modfied by         | Modified on       |Change Description                                                                                            
-- --------------------------------------------------------------------------------------                      
-- Arun        17-Sep-2018     Added New Column TimeZoneValue for ClassAPI    
-- ======================================================================================    
-- =================================================================================================
-- Author: Manickam.G
-- Create date: 28th Jul 2020
-- Description: Add AlternateTimeZoneInfoId column
-- Return details list
-- =================================================================================================
--Exec get_Time_Zone 0
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'get_Time_Zone')
BEGIN
    DROP PROC get_Time_Zone
END
GO
CREATE procedure get_Time_Zone           
	@timezone_id int      
AS
SET NOCOUNT ON            
BEGIN        
IF(ISNULL(@timezone_id,0) >0)  
 BEGIN  
	SELECT 
		timezone_id,
		timezone_nm,
		timezone_utc_offset,
		timezone_status,
		abbreviation,  
		offset,TimeZoneInfoId,
		TimeZoneValue,
		AlternateTimeZoneInfoId       
	FROM timezone WITH (NOLOCK) 
	WHERE timezone_id = @timezone_id AND AlternateTimeZoneInfoId IS NOT NULL    
 END  
ELSE  
 BEGIN  
    DECLARE @active_status INT   
	
	SELECT @active_status = dbo.FN_FamilyStatus('ACTIVE')  
	
	SELECT
		timezone_id,
		timezone_nm,
		timezone_utc_offset,
		timezone_status,
		abbreviation,  
		offset,TimeZoneInfoId,
		TimeZoneValue,
		AlternateTimeZoneInfoId
	FROM timezone WITH (NOLOCK)    
	WHERE timezone_status = @active_status  AND AlternateTimeZoneInfoId IS NOT NULL

 END  
END      
GO
