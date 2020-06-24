-- =======================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new stored procedure for add / update the live meeting integration details.
-- Return SysLiveMeetingLicenseId as INT
-- =======================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SAVE_Live_Meeting_License')
BEGIN
    DROP PROC SAVE_Live_Meeting_License
END
GO
Create PROC SAVE_Live_Meeting_License
(
	@SysLiveLicenseId INT,
	@Company_Id INT,
	@Center_Id INT,
	@LiveUserId NVARCHAR(100),
	@LiveUserName  NVARCHAR(100),
	@LiveMeetingId NVARCHAR(100),
	@LiveMeetingPassword NVARCHAR(100),	
	@MeetingLicenseStatus TINYINT,
	@UserId INT,
	@TransactionDttm DATETIME,
	@SysLiveMeetingLicenseId INT = 0
)
AS
BEGIN
	IF(@SysLiveMeetingLicenseId > 0 AND EXISTS(SELECT TOP 1 1 FROM Live_Meeting_License WITH (NOLOCK) WHERE [SysLiveMeetingLicenseId] = @SysLiveMeetingLicenseId))
	BEGIN
		UPDATE L
		SET 
			L.SysLiveLicenseId = @SysLiveLicenseId,
			L.Company_Id = @Company_Id,
			L.Center_Id = @Center_Id,
			L.LiveUserId = @LiveUserId,
			L.LiveUserName = @LiveUserName,
			L.LiveMeetingId = @LiveMeetingId,
			L.LiveMeetingPassword = @LiveMeetingPassword,
			L.MeetingLicenseStatus = @MeetingLicenseStatus,
			L.ModifiedBy = @UserId,
			L.ModifiedDttm = @TransactionDttm
		FROM Live_Meeting_License L WITH (NOLOCK)
		WHERE [SysLiveMeetingLicenseId] = @SysLiveMeetingLicenseId
	END
	ELSE
	BEGIN
		INSERT INTO Live_Meeting_License([SysLiveLicenseId], [Company_Id],	[Center_Id], [LiveUserId], [LiveUserName], [LiveMeetingId], [LiveMeetingPassword], [MeetingLicenseStatus], [CreatedBy], [CreatedDttm])
		SELECT @SysLiveLicenseId, @Company_Id,	@Center_Id, @LiveUserId, @LiveUserName, @LiveMeetingId, @LiveMeetingPassword, @MeetingLicenseStatus, @UserId, @TransactionDttm

		SET @SysLiveMeetingLicenseId = @@IDENTITY
	END

	RETURN @SysLiveMeetingLicenseId;
END
GO