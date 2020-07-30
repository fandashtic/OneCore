-- ==================================================================================================================================
-- Author: Manickam.G
-- Create date: 15th Jun 2020
-- Description: Create new scalar function for get available meeting licence id.
-- Return live meeting license id
-- ==================================================================================================================================
--select dbo.Get_Availalbe_Live_Meeting_License(0, '7/28/2020 10:42:00 PM', '7/28/2020 10:43:00 PM')
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'Get_Availalbe_Live_Meeting_License')
BEGIN
    DROP FUNCTION dbo.Get_Availalbe_Live_Meeting_License
END
GO
Create FUNCTION dbo.Get_Availalbe_Live_Meeting_License(@SysLiveLicenseId INT, @MeetingStartTime DATETIME, @MeetingEndTime DATETIME)
Returns INT
AS  
BEGIN 
	DECLARE @SysLiveMeetingLicenseId INT;
	SET @SysLiveMeetingLicenseId = 0;

	IF EXISTS (SELECT TOP 1 1 FROM Live_License D WITH (NOLOCK) WHERE D.SysLiveLicenseId = @SysLiveLicenseId)
	BEGIN
		DECLARE @TempLiveMeetingLicenses AS TABLE(Id INT Identity(1,1), SysLiveMeetingLicenseId INT)
		
		INSERT INTO @TempLiveMeetingLicenses(SysLiveMeetingLicenseId)
		SELECT DISTINCT SysLiveMeetingLicenseId
		FROM Live_Meeting_License D WITH (NOLOCK) 
		WHERE D.SysLiveLicenseId = @SysLiveLicenseId AND
		D.MeetingLicenseStatus = 1

		Declare @Id AS INT
		SET @Id = 1
		WHILE(@Id <= (SELECT Max(Id) From @TempLiveMeetingLicenses))
		BEGIN			
			SET @SysLiveMeetingLicenseId = (SELECT TOP 1 SysLiveMeetingLicenseId From @TempLiveMeetingLicenses WHERE Id = @Id)
			
			IF NOT EXISTS (SELECT TOP 1 1 
						FROM Live_Meetings L WITH (NOLOCK) 
						WHERE @MeetingStartTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
						AND L.SysLiveLicenseId = @SysLiveLicenseId)
			BEGIN
				IF NOT EXISTS (SELECT TOP 1 1 
							FROM Live_Meetings L WITH (NOLOCK)
							WHERE @MeetingEndTime BETWEEN L.MeetingStartTime AND L.MeetingEndTime 
							AND L.SysLiveLicenseId = @SysLiveLicenseId)						
				BEGIN
					BREAK; 
				END
			END

			SET @Id = @Id + 1
		END

	END

	RETURN @SysLiveMeetingLicenseId;
END
GO