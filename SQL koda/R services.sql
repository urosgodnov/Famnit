EXEC sp_configure 'show advanced options',1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'external scripts enabled';
GO
EXEC sp_configure 'external scripts enabled', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
--Executing script
EXEC sp_execute_external_script
@language = N'R'
,@script = N'OutputDataSet<- InputDataSet'
,@input_data_1 = N'SELECT 1 AS Numb UNION ALL SELECT 2;'
WITH RESULT SETS
((
Res INT
));
GO
-- Finding the default path
EXECUTE sp_execute_external_script
@language = N'R'
,@script = N'OutputDataSet <- data.frame(.libPaths());'
WITH RESULT SETS (([DefaultLibraryName] VARCHAR(MAX) NOT NULL));
GO
--Which packages are preinstalled
-- You can create a table for libraries and populate all the necessary
CREATE TABLE dbo.Libraries
(
ID INT IDENTITY NOT NULL CONSTRAINT PK_RLibraries PRIMARY
KEY CLUSTERED
,Package NVARCHAR(50)
,LibPath NVARCHAR(200)
,[Version] NVARCHAR(20)
,Depends NVARCHAR(200)
,Imports NVARCHAR(200)
,Suggests NVARCHAR(200)
,Built NVARCHAR(20)
)
GO
INSERT INTO dbo.Libraries
EXECUTE sp_execute_external_script
@language = N'R'
,@script=N'x <- data.frame(installed.packages())
OutputDataSet <- x[,c(1:3,5,6,8,16)]'
GO
SELECT * FROM dbo.Libraries
GO
DROP TABLE IF EXISTS dbo.Libraries
GO