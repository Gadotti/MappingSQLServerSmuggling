-----------------------------------------------------------------------------
--  TEST QUERIES
-----------------------------------------------------------------------------
 
-- Do any mappings not match conversion?
SELECT * FROM dbo.UnicodeCharacters WHERE DoesConvertedCharacterMatchMapping = 'No';
 
-- Do any unmapped Code Points have a conversion?
SELECT * FROM dbo.UnicodeCharacters WHERE DoesUnmappedCodePointConvertToSomething = 'Yes'; 
 
-- See all Code Points:
SELECT * FROM dbo.UnicodeCharacters;
 
-- See all conversions:
SELECT * FROM dbo.UnicodeCharacters WHERE CodePage1252CodeBIN IS NOT NULL;