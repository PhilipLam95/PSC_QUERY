alter PROCEDURE sp_psc_Reg_Sel_DeleteStudyUnitImportExcel            
(            
 @XmlData NTEXT,            
 @RegistStaff VARCHAR(50)            
)            
AS            
BEGIN            
 --> Dữ liệu từ file import excel            
 DECLARE @IDoc INT            
 EXEC sys.sp_xml_preparedocument @IDoc OUTPUT , @XmlData            
    DECLARE @tblStudentUnRegistStudyUnits TABLE            
        (            
          StudentID VARCHAR(30) ,            
          ScheduleStudyUnitID VARCHAR(30),            
          StaffName NVARCHAR(200) ,            
          UNIQUE CLUSTERED ( StudentID, ScheduleStudyUnitID )            
        )            
    INSERT INTO @tblStudentUnRegistStudyUnits            
        (             
   StudentID ,            
            ScheduleStudyUnitID ,            
            StaffName            
        )            


             
 --> Lấy dữ liệu loại bỏ dòng trùng(Loại bỏ những dòng trùng MSSV,MaLHP)            
    SELECT DISTINCT            
           REPLACE(LTRIM(RTRIM(a.StudentID)),'','[-+.^:,]#!') AS StudentID ,            
           REPLACE(LTRIM(RTRIM(a.ScheduleStudyUnitID)),'','[-+.^:,]#!') AS ScheduleStudyUnitID ,            
            ''            
    FROM    OPENXML(@IDoc,'/Root/R') WITH(StudentID VARCHAR(30),ScheduleStudyUnitID VARCHAR(30))            
            AS a            
    ORDER BY StudentID ,ScheduleStudyUnitID            
            
            
 --> Gán thông tin người import            
 DECLARE @StaffName NVARCHAR(200)            
 SELECT @StaffName = a.LastName + ' ' + a.MiddleName + ' ' + a.FirstName            
 FROM dbo.psc_urm_Staffs a            
 WHERE a.StaffID = @RegistStaff            
            
 --> Cập lại cột User đăng ký             
 UPDATE @tblStudentUnRegistStudyUnits            
 SET StaffName = @StaffName            
 FROM @tblStudentUnRegistStudyUnits a  
 

 --> Kiểm tra lỗi import            
 SELECT a.StudentID,            
   b.StudentName,            
   b.ClassStudentName,            
   b.OlogyName,            
   c.CurriculumID,            
   a.ScheduleStudyUnitID,            
   c.CurriculumName,            
   c.Credits            
   ,CASE             
    --WHEN EXISTS(SELECT 1 FROM dbo.psc_StudentScheduleStudyUnits j  WITH(NOLOCK) WHERE a.StudentID = j.StudentID AND a.ScheduleStudyUnitID =  j.ScheduleStudyUnitID) THEN N'Sinh viên đã đăng ký'            
    WHEN NOT EXISTS(SELECT 1 FROM dbo.psc_Students k WITH(NOLOCK) WHERE a.StudentID = k.StudentID) THEN N'MSSV không đúng'        
 WHEN NOT EXISTS (SELECT 1 FROM dbo.psc_ScheduleStudyUnits h with(nolock) where h.ScheduleStudyUnitID = a.ScheduleStudyUnitID) THEN N'Mã LHP không đúng'                
    WHEN NOT EXISTS(SELECT 1 FROM dbo.psc_StudentScheduleStudyUnits l WHERE a.ScheduleStudyUnitID = l.ScheduleStudyUnitID and l.StudentID = a.StudentID) THEN N'Sinh viên '+ ' ' + a.StudentID +' ' + N'chưa đăng ký học phần ' +' ' + a.ScheduleStudyUnitID   
    WHEN EXISTS (SELECT 1 FROM dbo.psc_ScheduleStudyUnits i where i.ScheduleStudyUnitID = a.ScheduleStudyUnitID and i.Status > 5 )  THEN N'Tình trạng LHP này không cho phép hủy'
    WHEN EXISTS            
      (    select 1 from psc_StudentStudyUnits n with(nolock) inner join psc_ScheduleStudyUnits m on n.StudyUnitID = m.StudyUnitID and m.ScheduleStudyUnitID =a.ScheduleStudyUnitID        
   where n.StudentID = a.StudentID and m.ScheduleStudyUnitID = a.ScheduleStudyUnitID and n.IsPass is not null          
      ) THEN N'Học phần sinh viên này đã có điểm không được hủy học phần này'            
    WHEN not EXISTS            
      (            
     select 1 from  AccountsFee_BUH.dbo.tblTransactionDebts ac  with(nolock)      
  INNER join psc_StudentScheduleStudyUnits ps on ps.StudentID = ac.StudentId and ps.ScheduleStudyUnitID = ac.ScheduleStudyUnitID and ps.StudentID = a.StudentID and ps.ScheduleStudyUnitID = a.ScheduleStudyUnitID     
     WHERE SumAmountCurr -(SumAmountEx+SumPaidAmount+SumPaidLeft+SumAmountExDiff) > 0         
     AND Locked <> 1         
     and ac.TransactionID = ps.TransactionID         
     and ac.StudentId = a.StudentID         
     and ac.ScheduleStudyUnitID = a.ScheduleStudyUnitID                  
      ) THEN N'Học phần sinh viên này đã đóng phí không được hủy' 
	WHEN EXISTS( select  1 from psc_ExaminationSchedules where SCheduleStudyUnitID = a.ScheduleStudyUnitID and Isnull(IsUsed, 1) = 1)  THEN N'Sinh viên đã có lịch thi'
	WHEN EXISTS (select 1 from psc_Examinations  v
				 inner join psc_ExaminationStudents b on v.Examination = b.Examination and v.ScheduleStudyUnitID = a.ScheduleStudyUnitID
				where v.ScheduleStudyUnitID = a.ScheduleStudyUnitID and Isnull(IsUsed, 1) = 1
				)   THEN N'Sinh viên này đã có trong danh sách thi'
    ELSE ''            
   END AS 'NoteError' INTO #TmpIsError            
 FROM @tblStudentUnRegistStudyUnits a            
 LEFT JOIN dbo.vw_psc1_Students b WITH(NOLOCK) ON b.StudentID = a.StudentID            
 LEFT JOIN dbo.vw_psc_Sch_ScheduleStudyUnitInfos c WITH(NOLOCK) ON c.ScheduleStudyUnitID = a.ScheduleStudyUnitID            
          
  
 /*            
  Danh sách sinh viên hợp lệ            
   - Sinh viên chưa đăng ký lớp học phần(chính lớp học phần đó hoặc lớp học phần khác nhưng cùng học phần cùng loại học phần)            
   - Mã sinh viên phù hợp            
   - Tình trạng sinh viên phù hợp            
   - Mã lớp học phần phù hợp            
   - Lớp học phần không phải tình trạng hủy            
   - Loại bỏ dòng trùng            
   - Sinh viên chưa có đăng ký bất kỳ lớp học phần nào cùng HP và cùng loại HP            
 */            
 SELECT  a.StudentID,            
            c.StudentName ,            
            c.ClassStudentName ,            
            c.OlogyName ,            
            b.CurriculumID ,            
            a.ScheduleStudyUnitID ,            
            b.CurriculumName ,            
            b.Credits ,
			'' as 'NoteError'            
            --ISNULL(@StaffName, '') AS StaffName ,            
            --CONVERT(VARCHAR(30), GETDATE(), 103) AS RegistDate            
    FROM  @tblStudentUnRegistStudyUnits a            
 INNER JOIN dbo.vw_psc_Sch_ScheduleStudyUnitInfos b ON a.ScheduleStudyUnitID = b.ScheduleStudyUnitID            
 INNER JOIN dbo.vw_psc1_Students c WITH(NOLOCK) ON a.StudentID = c.StudentID            
 WHERE NOT EXISTS            
 (            
  SELECT 1            
  FROM #TmpIsError i            
  WHERE a.StudentID = i.StudentID AND a.ScheduleStudyUnitID = i.ScheduleStudyUnitID AND i.NoteError <> ''            
 )            
 ORDER BY a.StudentID,a.ScheduleStudyUnitID            
            
            
 /*            
  Danh sách những dòng dữ liệu không hợp lệ            
   - Sinh viên đã đăng ký            
   - sinh viên đã đăng ký vào lớp học phần khác nhưng cùng học phần cùng loại học phần            
   - Mã sinh viên không đúng            
   - Mã lớp học phần không đúng            
   - Sinh viên bị thôi học, buộc thôi học, đã tốt nghiệp            
   - Tình trạng lớp học phần bị hủy            
   - Sinh đã đăng ký vào lớp học phần khác ở cùng HP cùng loại học phần            
   - File import sinh viên có nhiều dòng đăng ký cùng mã sinh viên khác lớp học phần nhưng cùng 1 HP và cùng loại HP            
 */            
            
 SELECT             
  StudentID,            
  StudentName,            
  ClassStudentName,            
  OlogyName,            
  CurriculumID,            
  ScheduleStudyUnitID,            
  CurriculumName,            
  Credits,            
  NoteError            
 FROM #TmpIsError a            
 WHERE a.NoteError <> ''            
 ORDER BY a.StudentID,a.ScheduleStudyUnitID            
            
 DROP TABLE #TmpIsError            
 EXEC sys.sp_xml_removedocument @IDoc            
END         



