
SELECT * FROM psc_WrongRegistStudent a 

DECLARE @yearstudy VARCHAR(20) = '2017-2018'
DECLARE @termid VARCHAR(20) = 'HK01'

DECLARE @studentid NVARCHAR(50)
DECLARE @ScheduleStudyUnitID VARCHAR(100)
	
	
DECLARE @StudentRegistTYpe TABLE  
 (   
	studentID NVARCHAR(255),  
	schedulestudyunitid VARCHAR(100),
	registtype VARCHAR(50)
 ) 
DECLARE cs_HTDK CURSOR FOR (
SELECT a.StudentID,
									a.ScheduleStudyUnitID
									FROM psc_StudentScheduleStudyUnits a WITH(NOLOCK)
									INNER JOIN psc_ScheduleStudyUnits b ON b.ScheduleStudyUnitID = a.ScheduleStudyUnitID
									INNER JOIN psc_StudyUnits c ON c.StudyUnitID = b.StudyUnitID
									WHERE c.YearStudy = @yearstudy AND c.TermID = @termid AND a.RegistType = 'KH'
							)
OPEN cs_HTDK --(3)`
 FETCH NEXT FROM  cs_HTDK INTO @studentid, @ScheduleStudyUnitID --(4)
  WHILE @@FETCH_STATUS = 0
	BEGIN
		 INSERT INTO @StudentRegistTYpe(
		 	studentID,
		 	schedulestudyunitid,
		 	registtype)
			SELECT distinct
		 			@studentid,
		 			@ScheduleStudyUnitID,
		 			dbo.fn_psc_REG_GetRegistType_ChayLaiHTDK
		 			(
		 				@studentid,
		 				(SELECT a.ClassStudentID FROM psc_StudentClassStudent a WITH(NOLOCK) WHERE a.StudentID = @studentid),
		 				@ScheduleStudyUnitID ,
		 				(SELECT b.CurriculumID
		 					FROM psc_ScheduleStudyUnits a INNER JOIN psc_StudyUnits b WITH(NOLOCK) ON b.StudyUnitID = a.StudyUnitID
		 					WHERE a.ScheduleStudyUnitID = @ScheduleStudyUnitID),
		 				(SELECT b.YearStudy 
		 					FROM psc_ScheduleStudyUnits a INNER JOIN psc_StudyUnits b WITH (nolock) ON b.StudyUnitID = a.StudyUnitID
		 				 WHERE a.ScheduleStudyUnitID = @ScheduleStudyUnitID),
		 				(SELECT b.TermID
		 				   FROM  psc_ScheduleStudyUnits a INNER JOIN psc_StudyUnits b WITH (nolock)  ON b.StudyUnitID = a.StudyUnitID
		 				 WHERE a.ScheduleStudyUnitID = @ScheduleStudyUnitID)
		 			)
	

		 FETCH NEXT FROM cs_HTDK INTO  @studentid, @ScheduleStudyUnitID --(6)
		
	END
 CLOSE cs_HTDK --(7)
 
 
 SELECT a.studentID,a.schedulestudyunitid,a.registtype AS 'HTDK LAI' ,b.RegistType AS 'HTDK TRUOC DO'
   FROM @StudentRegistTYpe a 
 INNER JOIN psc_StudentScheduleStudyUnits b WITH(NOLOCK) ON b.studentID = a.studentID AND b.schedulestudyunitid = a.schedulestudyunitid
 WHERE A.registtype <> b.RegistType
 DEALLOCATE cs_HTDK
 
 
 
 SELECT * FROM psc_
 
