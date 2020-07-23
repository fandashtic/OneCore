-- ===============================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new scalar function for validate the given string variant has value or not. 
-- Return bit value
-- ===============================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'IsHasValue')
BEGIN
    DROP FUNCTION dbo.IsHasValue
END
GO
CREATE FUNCTION dbo.IsHasValue(@Data nvarchar(4000) = NULL)    
	RETURNS BIT   
AS    
BEGIN    
	DECLARE @IsHasValue BIT
	SET @IsHasValue = 0;
	
	IF(ISNULL(@Data, '') <> '') SET @IsHasValue = 1;

	RETURN @IsHasValue;
END 
GO