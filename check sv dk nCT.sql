DECLARE @svdk TABLE (studentid VARCHAR(20),curriculumid VARCHAR(20))
 INSERT INTO @svdk
 --SELECT a.StudentID,d.CurriculumID,a.RegistType
 -- FROM psc_StudentScheduleStudyUnits AS a WITH(NOLOCK)
 --INNER JOIN psc_ScheduleStudyUnits b ON b.ScheduleStudyUnitID = a.ScheduleStudyUnitID
 --INNER JOIN psc_StudyUnits c ON c.StudyUnitID = b.StudyUnitID
 --INNER JOIN psc_Curriculums d WITH(NOLOCK) ON d.CurriculumID = c.CurriculumID
 SELECT  a.StudentID,C.CurriculumID from psc_studentstudyunits a 
 inner join psc_StudyUnits b on a.StudyUnitID = b.studyunitid
 INNER JOIN psc_Curriculums c ON C.CurriculumID = b.curriculumid
 where b.YearStudy = '2017-2018' AND b.TermID = 'HK02'

 



 DECLARE @svctdt table(studentid VARCHAR(20),StudyProgramID VARCHAR(20),StudyProgramName NVARCHAR(100),
      CurriculumID VARCHAR(15),CurriculumName NVARCHAR(100),EquipCurriculumIDs VARCHAR(100))
 Insert INTO @svctdt
 select         
     h.StudentID  
    ,a.StudyProgramID
    ,a.StudyProgramName         
    ,d.CurriculumID
    ,d.CurriculumName
    ,j.CurriculumIDs         
    from psc1_StudyPrograms a  WITH(NOLOCK)  
    inner join psc1_CurriculumStudyPrograms b on b.StudyProgramID = a.StudyProgramID       
    INNER JOIN psc_Curriculums d WITH(NOLOCK) ON b.CurriculumID = d.CurriculumID
    INNER JOIN psc1_StudentStudyPrograms h ON h.StudyProgramID = a.StudyProgramID
    INNER JOIN @svdk i ON i.studentid = h.StudentID   
    LEFT JOIN ws_vw_psc1_EquivalentCurriculums j ON 
						j.CurriculumID = d.CurriculumID  
						AND J.OriStudyProgramID = h.StudyProgramID 
						AND j.curriculumid = i.curriculumid
						AND J.CurriculumID <> j.CurriculumIDs
 order by a.StudyProgramID
 
 
 SELECT a.studentid, a.curriculumid FROM @svdk a WHERE 
 a.curriculumid NOT IN 
 (
	SELECT b.CurriculumID FROM @svctdt b WHERE b.studentid = a.studentid 
 )
 and
 a.curriculumid NOT IN 
 (
 	SELECT c.EquipCurriculumIDs
 	  FROM @svctdt c WHERE c.studentid = a.studentid  AND c.EquipCurriculumIDs IS NOT null
 )


 
 
 

	--SELECT a.StudentID,d.CurriculumID,a.RegistType
 -- FROM psc_StudentScheduleStudyUnits AS a WITH(NOLOCK)
 --INNER JOIN psc_ScheduleStudyUnits b ON b.ScheduleStudyUnitID = a.ScheduleStudyUnitID
 --INNER JOIN psc_StudyUnits c ON c.StudyUnitID = b.StudyUnitID
 --INNER JOIN psc_Curriculums d WITH(NOLOCK) ON d.CurriculumID = c.CurriculumID
 --where a.StudentID = '1171010086' and d.CurriculumID = '227089'
 
 
 --SELECT * FROM ws_vw_psc1_EquivalentCurriculums  a WHERE a.CurriculumID <> a.CurriculumIDs


