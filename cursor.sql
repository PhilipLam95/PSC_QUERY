 SELECT a.StudentID,d.CurriculumID,a.RegistType
  FROM psc_StudentScheduleStudyUnits AS a WITH(NOLOCK)
 INNER JOIN psc_ScheduleStudyUnits b ON b.ScheduleStudyUnitID = a.ScheduleStudyUnitID
 INNER JOIN psc_StudyUnits c ON c.StudyUnitID = b.StudyUnitID
 INNER JOIN psc_Curriculums d WITH(NOLOCK) ON d.CurriculumID = c.CurriculumID
 WHERE  c.TermID = 'HK01' AND C.YearStudy = '2018-2019' AND a.StudentID = '142107056'
 
 
 SELECT  * from psc_studentstudyunits a WITH(NOLOCK)
 inner join psc_StudyUnits b on a.StudyUnitID = b.studyunitid
 INNER JOIN psc_Curriculums c with(nolock) ON C.CurriculumID = b.curriculumid
 WHERE   a.StudentID = '142107056' AND b.CurriculumID = '040178'


SELECT * FROM psc1_StudentStudyPrograms a 
  inner join psc1_CurriculumStudyPrograms b on b.StudyProgramID = a.StudyProgramID  
WHERE  a.StudentID = '142107056' AND b.CurriculumID = '040178'

 
142107056	040178
142107056	040176
142107056	040174
142107056	040177
142107056	040175

DECLARE @svdk TABLE (studentid VARCHAR(20),curriculumid VARCHAR(20))
 INSERT INTO @svdk
 SELECT DISTINCT a.StudentID,C.CurriculumID from psc_studentstudyunits a WITH(NOLOCK)
 inner join psc_StudyUnits b on a.StudyUnitID = b.studyunitid
 INNER JOIN psc_Curriculums c with(nolock) ON C.CurriculumID = b.curriculumid
 where b.YearStudy = '2010-2011' AND b.TermID = 'HK02'

 SELECT* FROM  @svdk
 
 0912140140	ENM1004
0912140140	FIN1243
0912140140	LAW1203
0912140140	ECO1201
0912140140	POL1002
0912140140	TIN1202
0912140140	MKT0430