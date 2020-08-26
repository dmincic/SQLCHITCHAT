
DROP TABLE IF EXISTS dbo.TestGUIDstore
GO
CREATE TABLE dbo.TestGUIDstore(uid UNIQUEIDENTIFIER
                               ,uid_bin16 BINARY(16)
                               ,uid_char CHAR(36)
                               ,uid_nchar NCHAR(72)
)
GO

DROP PROCEDURE IF EXISTS dbo.TestGUIDinsert
GO

CREATE PROCEDURE dbo.TestGUIDinsert(@guid VARCHAR(36))
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON ;

    INSERT INTO dbo.TestGUIDstore (
            [uid]
           ,uid_bin16
           ,uid_char
           ,uid_nchar)
        SELECT [uid]     = @guid
              ,uid_bin16 = CONVERT(VARBINARY(16),@guid) --Implicit conversion from data type nvarchar to binary is not allowed
            --,uid_bin16 = CONVERT(BINARY(16),REPLACE(@guid ,'-',''),2)
            --,uid_bin16 = CONVERT(UNIQUEIDENTIFIER,@guid)
              ,uid_char  = @guid
              ,udi_nchar = @guid

    RETURN
    
END 