-- ==============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the live integration details.
-- Return SysLiveLicenseId as INT
-- ==============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_License')
BEGIN
    DROP PROC SAVE_Live_License
END
GO
Create PROC SAVE_Live_License
(
	@Company_Id INT,
	@Center_Id INT,
	@LiveApiKey VARCHAR(100),
	@LiveApiSecret  VARCHAR(255),
	@LicenseStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@SysLiveLicenseId INT = 0
)
AS
BEGIN
	IF(@SysLiveLicenseId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_License WITH (NOLOCK) WHERE [SysLiveLicenseId] = @SysLiveLicenseId))
	BEGIN
		UPDATE L
		SET 
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
			L.LiveApiKey = @LiveApiKey,
			L.LiveApiSecret = @LiveApiSecret,
			L.LicenseStatus = @LicenseStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_License L WITH (NOLOCK)
		WHERE [SysLiveLicenseId] = @SysLiveLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_License([Company_Id],	[Center_Id], [LiveApiKey], [LiveApiSecret], [LicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @Company_Id,	@Center_Id, @LiveApiKey, @LiveApiSecret, @LicenseStatus, @UserId, @TransactionDttm

		SET @SysLiveLicenseId = @@IDENTITY
	END
	
	RETURN @SysLiveLicenseId;
END
GO