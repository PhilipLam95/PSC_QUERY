FIND QUICKLY STORE PROCEDURE
---------------------------------------
select * 
from 
   sys.procedures 
where 
   name like '%psc_Allow%';


FIND QUICKLY FUNCTION
-------------------------------------
SELECT name AS function_name
,SCHEMA_NAME(schema_id) AS schema_name
,type_desc
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%' and name like '%check%';

RETURN TYPE DATA
----------------------------

SELECT COLUMN_NAME,
       DATA_TYPE,
       CHARACTER_MAXIMUM_LENGTH
FROM information_schema.columns
WHERE TABLE_NAME = 'psc_StudentScheduleStudyUnits';


FIND QUICKLY RELATION OF TABLE
---------------------------------------
Select
 object_name(rkeyid) Parent_Table,
 object_name(fkeyid) Child_Table,
 object_name(constid) FKey_Name,
 c1.name FKey_Col,
 c2.name Ref_KeyCol
From
 sys.sysforeignkeys s
 Inner join sys.syscolumns c1
  on ( s.fkeyid = c1.id And s.fkey = c1.colid )
 Inner join syscolumns c2
  on ( s.rkeyid = c2.id And s.rkey = c2.colid )
 where object_name(rkeyid) = 'psc1_StudyPrograms'
Order by Parent_Table,Child_Table




Search Tables:
----------------------------
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%MyName%'
ORDER BY    TableName
            ,ColumnName;


Search Tables & Views:
----------------------------
SELECT      COLUMN_NAME AS 'ColumnName'
            ,TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE '%MyName%'
ORDER BY    TableName
            ,ColumnName;
FIND QUICKLY STORE PROCEDURE
---------------------------------------
select * 
from 
   sys.procedures 
where 
   name like '%psc_Allow%';


FIND QUICKLY FUNCTION
-------------------------------------
SELECT name AS function_name
,SCHEMA_NAME(schema_id) AS schema_name
,type_desc
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%' and name like '%check%';

RETURN TYPE DATA
----------------------------

SELECT COLUMN_NAME,
       DATA_TYPE,
       CHARACTER_MAXIMUM_LENGTH
FROM information_schema.columns
WHERE TABLE_NAME = 'psc_StudentScheduleStudyUnits';


FIND QUICKLY RELATION OF TABLE
---------------------------------------
Select
 object_name(rkeyid) Parent_Table,
 object_name(fkeyid) Child_Table,
 object_name(constid) FKey_Name,
 c1.name FKey_Col,
 c2.name Ref_KeyCol
From
 sys.sysforeignkeys s
 Inner join sys.syscolumns c1
  on ( s.fkeyid = c1.id And s.fkey = c1.colid )
 Inner join syscolumns c2
  on ( s.rkeyid = c2.id And s.rkey = c2.colid )
 where object_name(rkeyid) = 'psc1_StudyPrograms'
Order by Parent_Table,Child_Table




Search Tables:
----------------------------
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%MyName%'
ORDER BY    TableName
            ,ColumnName;


Search Tables & Views:
----------------------------
SELECT      COLUMN_NAME AS 'ColumnName'
            ,TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE '%MyName%'
ORDER BY    TableName
            ,ColumnName;

Find quickly newly create table,sp,view,...
----------------------------------------------
select 
    so.name, su.name, so.crdate 
from 
    sysobjects so 
join 
    sysusers su on so.uid = su.uid  
	where so.name like 'psc%'
order by 
    so.crdate
	desc

Find quickly new update on table,sp,view
----------------------------------------------

SELECT OBJECT_NAME(OBJECT_ID) AS DatabaseName,
last_user_update,*
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID( 'CoreUis')
AND OBJECT_ID=OBJECT_ID('')


Query to find whether a Stored Procedure is used inside some other Stored procedure.
--------------------------------------------------------------------------------------------
SELECT ROUTINE_NAME, ROUTINE_DEFINITION 
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_TYPE='PROCEDURE' and
ROUTINE_DEFINITION LIKE '%YourStoredProcedure%'



Query to find Stored Procedure LIKE .
--------------------------------------------------------------------------------------------
select distinct 'sp_helptext ' + name + CHAR(13)+CHAR(10)+'go' as Name  
  FROM syscomments c 
  JOIN sysobjects o 
    ON c.id = o.id
  JOIN INFORMATION_SCHEMA.Tables t
    ON  c.text LIKE '%psc_Sch_BusyProfessorByTerms%'
order by Name ASC





