-- =================================================================================
-- Author: Manickam.G
-- Create date: 8th Jun 2020
-- Description: Create new table-valued function for split string to int rows by separator.
-- Return table object with "ItemValue" column as int.
-- =================================================================================
IF EXISTS(SELECT * FROM sys.objects WHERE Name = N'SplitIn2Rows_Int')
BEGIN
    DROP FUNCTION dbo.SplitIn2Rows_Int
END
GO
CREATE FUNCTION dbo.SplitIn2Rows_Int(@Source nvarchar(4000) = NULL, @Separator char(1) = ',')    
	RETURNS @ARRAY TABLE (ItemValue Int )    
AS    
BEGIN    
	DECLARE @CurrentStr nvarchar(2000)    
	DECLARE @ItemStr Int
     
	SET @CurrentStr = @Source    
      
	WHILE Datalength(@CurrentStr) > 0    
	BEGIN    
		IF CHARINDEX(@Separator, @CurrentStr,1) > 0     
		BEGIN    
			SET @ItemStr = cast(SUBSTRING (@CurrentStr, 1, CHARINDEX(@Separator, @CurrentStr,1) - 1)    as Int)
			SET @CurrentStr = SUBSTRING (@CurrentStr, CHARINDEX(@Separator, @CurrentStr,1) + 1, (Datalength(@CurrentStr) - CHARINDEX(@Separator, @CurrentStr,1) + 1))    
			INSERT @ARRAY (ItemValue) VALUES (@ItemStr)    
		END    
		ELSE    
		BEGIN                    
			INSERT @ARRAY (ItemValue) VALUES (cast(@CurrentStr as Int))        
			BREAK;    
		END     
	END    
	RETURN;
END 
GO