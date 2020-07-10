--Select dbo.GetDayOn('2020-06-07 13:33:47', '2020-07-07 13:33:47');
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'GetDayOn')
BEGIN
    DROP FUNCTION dbo.GetDayOn
END
GO
CREATE FUNCTION dbo.GetDayOn(@CurrentDate datetime, @TransactionDate DateTime)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @DayOn AS VARCHAR(100)

	SET @CurrentDate = dbo.StripDateFromTime(@CurrentDate)
	SET @TransactionDate = dbo.StripDateFromTime(@TransactionDate)

	DECLARE @WeekStartDate   DATETIME, 
			@WeekEndDate     DATETIME 
	SELECT  @WeekStartDate = dbo.StripDateFromTime(DATEADD(d,   - DATEPART(dw, GETDATE()) + 2, GETDATE())),
			@WeekEndDate   = dbo.StripDateFromTime(DATEADD(d, 8 - DATEPART(dw, GETDATE())    , GETDATE()))


	IF(MONTH(@TransactionDate) > MONTH(GETDATE()) - 2 AND (YEAR(@TransactionDate) = YEAR(GETDATE()) - 1)) 
	BEGIN
		SET @DayOn = 'Last Year'
	END
	ELSE IF(MONTH(@TransactionDate) = MONTH(GETDATE()) - 1 AND (YEAR(@TransactionDate) = YEAR(GETDATE()))) 
	BEGIN
		SET @DayOn = 'Last Month'
	END
	ELSE IF((dbo.StripDateFromTime(DATEADD(d, -1, GETDATE())) <> dbo.StripDateFromTime(@TransactionDate)) AND 
		@TransactionDate BETWEEN DATEADD(d, -7, @WeekStartDate) AND DATEADD(d, -1, @WeekStartDate)) 
	BEGIN
		SET @DayOn = 'Last Week'
	END
	ELSE IF(dbo.StripDateFromTime(DATEADD(d, -1, GETDATE())) = dbo.StripDateFromTime(@TransactionDate))
	BEGIN
		SET @DayOn = 'Yesterday'
	END
	ELSE IF(dbo.StripDateFromTime(@TransactionDate) = dbo.StripDateFromTime(GETDATE()) AND @TransactionDate BETWEEN @WeekStartDate AND @WeekEndDate) 
	BEGIN
		SET @DayOn = 'Today'
	END
	ELSE IF((dbo.StripDateFromTime(@TransactionDate) <> dbo.StripDateFromTime(GETDATE())) AND 
	(dbo.StripDateFromTime(DATEADD(d, +1, GETDATE())) = dbo.StripDateFromTime(@TransactionDate)) AND 
	(@TransactionDate BETWEEN @WeekStartDate AND @WeekEndDate))
	BEGIN
		SET @DayOn = 'Tomorrow'
	END
	ELSE IF(dbo.StripDateFromTime(@TransactionDate) <> dbo.StripDateFromTime(GETDATE()) AND @TransactionDate BETWEEN @WeekStartDate AND @WeekEndDate) 
	BEGIN
		SET @DayOn = 'This Week'
	END
	ELSE IF(@TransactionDate BETWEEN DATEADD(d, +1, @WeekEndDate) AND DATEADD(d, +7, @WeekEndDate))
	BEGIN
		SET @DayOn = 'Next Week'
	END
	ELSE IF(@TransactionDate > DATEADD(d, +7, @WeekEndDate) AND (MONTH(@TransactionDate) = MONTH(GETDATE()))) 
	BEGIN
		SET @DayOn = 'This Month'
	END
	ELSE IF(MONTH(@TransactionDate) = MONTH(GETDATE()) + 1 AND (YEAR(@TransactionDate) = YEAR(GETDATE()))) 
	BEGIN
		SET @DayOn = 'Next Month'
	END
	ELSE IF(MONTH(@TransactionDate) = MONTH(GETDATE()) + 1 AND (YEAR(@TransactionDate) = YEAR(GETDATE())))
	BEGIN
		SET @DayOn = 'UpComing Month'
	END
	ELSE IF(MONTH(@TransactionDate) > MONTH(GETDATE()) + 2 AND (YEAR(@TransactionDate) = YEAR(GETDATE()))) 
	BEGIN
		SET @DayOn = 'Current Year'
	END
	ELSE IF(MONTH(@TransactionDate) > MONTH(GETDATE()) + 2 AND (YEAR(@TransactionDate) = YEAR(GETDATE()) + 1)) 
	BEGIN
		SET @DayOn = 'Next Year'
	END
	RETURN @DayOn
END
GO
