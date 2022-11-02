-----------------------------------------------------------------------------
--  SETUP 1 (of 3): CREATE DATABASE
-----------------------------------------------------------------------------
 
IF (DB_ID(N'MappingTestCodePage1252') IS NULL)
BEGIN
  CREATE DATABASE [MappingTestCodePage1252]
    COLLATE Latin1_General_CI_AS;
END;
GO
 
USE [MappingTestCodePage1252];
SELECT CONVERT(INT,
               COLLATIONPROPERTY(CONVERT(NVARCHAR(128),
                                         DATABASEPROPERTYEX(DB_NAME(), 'Collation')
                                        ),
                                 'CodePage'
                                )
              ) AS [DatabaseCodePage];