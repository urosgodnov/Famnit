IF OBJECT_ID('Department_Source', 'U') IS NOT NULL
   DROP TABLE dbo.Department_Source;
IF OBJECT_ID('Department_Target', 'U') IS NOT NULL
   DROP TABLE dbo.Department_Target;

CREATE TABLE [dbo].[Department_Source]
(
   [DepartmentID] [SMALLINT] NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   [GroupName] VARCHAR(50) NOT NULL,
   [ModifiedDate] [DATETIME] NOT NULL
) ON [PRIMARY];
GO
CREATE TABLE [dbo].[Department_Target]
(
   [DepartmentID] [SMALLINT] NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   [GroupName] VARCHAR(50) NOT NULL,
   [ModifiedDate] [DATETIME] NOT NULL
) ON [PRIMARY];
GO
---Insert some test values
INSERT INTO [dbo].[Department_Source]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
(
   1, 'Engineering', 'Research and Development', GETDATE()
);

---Checking the Source Table Data
SELECT  * FROM  [Department_Source];














---For excercise number 5
--Inserting records into target table
INSERT INTO [dbo].[Department_Target]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
( 3, 'Sales', 'Sales & Marketing', GETDATE()),
( 1, 'Engineering', 'IT', GETDATE());

--Inserting  records into target table
INSERT INTO [dbo].[Department_Source]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
(   2, 'Marketing', 'Sales & Marketing', GETDATE()),
(   1, 'Engineering', 'IT', GETDATE());

---Checking the Source Table
SELECT  * FROM  [Department_Source];

---Checking the Target Table
SELECT  * FROM  [Department_Target];