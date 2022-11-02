-----------------------------------------------------------------------------
--  SETUP 3 (of 3): CREATE UnicodeCharacters TABLE
-----------------------------------------------------------------------------
 
IF (OBJECT_ID(N'dbo.UnicodeCharacters') IS NULL)
BEGIN
  -- DROP TABLE dbo.UnicodeCharacters;
  PRINT 'Creating UnicodeCharacters table...';
  CREATE TABLE dbo.UnicodeCharacters
  (
    UnicodeCodePointBIN BINARY(2) NOT NULL PRIMARY KEY,
    UnicodeCodePointINT AS (CONVERT(INT, [UnicodeCodePointBIN])),
    UnicodeCharacter AS (NCHAR([UnicodeCodePointBIN])),
 
    CodePage1252CodeBIN BINARY(1) NULL, -- NULL if not mapped for Best Fit
    CodePage1252CodeINT AS (CONVERT(INT, [CodePage1252CodeBIN])),
    CodePage1252Character AS (CHAR([CodePage1252CodeBIN])),
 
    ConvertedCharacter AS (CONVERT(VARCHAR(5), NCHAR([UnicodeCodePointBIN]))),
    ConvertedCharacterCodeINT AS (ASCII(CONVERT(VARCHAR(5), NCHAR([UnicodeCodePointBIN])))),
 
    DoesConvertedCharacterMatchMapping AS (
       CASE
         WHEN [CodePage1252CodeBIN] IS NULL -- not mapped
           THEN NULL
         WHEN ((ASCII(CONVERT(VARCHAR(5), NCHAR([UnicodeCodePointBIN]))))
                = (CONVERT(INT, [CodePage1252CodeBIN])))
           THEN 'Yes'
         ELSE 'No'
       END),
    DoesUnmappedCodePointConvertToSomething AS (
       CASE
         WHEN [CodePage1252CodeBIN] IS NOT NULL -- mapped
           THEN NULL
         WHEN [CodePage1252CodeBIN] IS NULL -- not mapped
              AND [UnicodeCodePointBIN] > 0x00FF -- Unicode range
              AND (ASCII(CONVERT(VARCHAR(5), NCHAR([UnicodeCodePointBIN])))) <> 63
           THEN 'Yes'
         ELSE
           'No'
       END)
  );
 
  PRINT 'Populating table with base Unicode characters...';
  INSERT INTO dbo.UnicodeCharacters ([UnicodeCodePointBIN])
    SELECT TOP (65536) CONVERT(BINARY(2), ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) AS [num]
    FROM   [master].[sys].[columns] sc
    CROSS JOIN [master].[sys].[objects] so;
 
  -- SELECT * FROM dbo.UnicodeCharacters;
 
  PRINT 'Updating table with Unicode to Code Page 1252 mappings...';
  UPDATE tmp
  SET    tmp.CodePage1252CodeBIN = map.CodePage1252Code
  FROM   dbo.UnicodeCharacters tmp
  INNER JOIN dbo.Mappings map
          ON map.UnicodeCodePoint = tmp.UnicodeCodePointBIN
  WHERE   tmp.CodePage1252CodeBIN IS NULL;
 
  -- SELECT * FROM dbo.UnicodeCharacters;
 
END;