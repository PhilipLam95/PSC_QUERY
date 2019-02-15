 
 drop table #tmp1
drop table #tmp2
 SELECT A.MaNhomDanhGia,A.TenNhom,A.Loai,A.Active,b.TenDanhGia,b.STT,b.DiemToiDa,b.IdDanhGia,b.ParentID,c.Flag1,c.DanhGiaDinhNghiaId,c.LoaiDanhGia,c.MaKhoa,Isnull(flag1, 0) FLAG 
 into #tmp1 
 FROM(SELECT manhomdanhgia,tennhom,loai,active FROM   dmdanhgia_nhom nolock WHERE  active = 1 AND loai = 10)AS A 
 INNER JOIN (SELECT manhomdanhgia,tendanhgia,stt,diemtoida,id IdDanhGia,parentid FROM   dmdanhgia_chung nolock WHERE active = 1 AND manhomdanhgia = 'PTCCQTI' and ParentID = 0) AS B ON B.manhomdanhgia = A.manhomdanhgia 
 INNER JOIN (SELECT CASE WHEN(id > 0) THEN 1 ELSE 0 END Flag1, danhgiadinhnghiaid,loaidanhgia,makhoa 
 FROM  dmdanhgia_luachon nolock WHERE  makhoa = 'KBND' AND loaidanhgia = 10) AS C ON C.danhgiadinhnghiaid = B.iddanhgia 

 SELECT A.MaNhomDanhGia,A.TenNhom,A.Loai,A.Active,b.TenDanhGia,b.STT,b.DiemToiDa,b.IdDanhGia,b.ParentID,c.Flag1,c.DanhGiaDinhNghiaId,c.LoaiDanhGia,c.MaKhoa,Isnull(flag1, 0) FLAG 
 into #tmp2 
 FROM(SELECT manhomdanhgia,tennhom,loai,active FROM   dmdanhgia_nhom nolock WHERE  active = 1 AND loai = 10)AS A 
 INNER JOIN (SELECT manhomdanhgia,tendanhgia,stt,diemtoida,id IdDanhGia,parentid FROM   dmdanhgia_chung nolock WHERE active = 1 AND manhomdanhgia = 'PTCCQTI') AS B ON B.manhomdanhgia = A.manhomdanhgia 
 LEFT JOIN  (SELECT CASE WHEN(id > 0) THEN 1 ELSE 0 END Flag1, danhgiadinhnghiaid,loaidanhgia,makhoa 
 FROM  dmdanhgia_luachon nolock WHERE  makhoa = 'KBND' AND loaidanhgia = 10) AS C ON C.danhgiadinhnghiaid = B.iddanhgia 

--SELECT * FROM #tmp2
--SELECT * FROM #tmp1
 ;WITH CTE_DMDanhGia_Chung(MaNhomDanhGia, TenNhom, Loai, Active, TenDanhGia, STT, DiemToiDa, IdDanhGia, ParentID, Flag1, DanhGiaDinhNghiaId, LoaiDanhGia, MaKhoa, Flag, LEVEL, TreePath) AS 
 ( 
	  SELECT A.MaNhomDanhGia, A.TenNhom, A.Loai, A.Active, A.TenDanhGia, A.STT, A.DiemToiDa, A.IdDanhGia, A.ParentID, A.Flag1, A.DanhGiaDinhNghiaId, A.LoaiDanhGia, A.MaKhoa, Isnull(flag1, 0),   
	  0 AS LEVEL,   
	  CAST(FORMAT(A.STT,'d5') AS VARCHAR(1024)) AS TreePath
	  --CAST(a.TenDanhGia AS NVARCHAR(1024)) AS TreePath
	  FROM   #tmp1 A 
	  UNION ALL 
	  SELECT BB.MaNhomDanhGia, BB.TenNhom, BB.Loai, BB.Active, BB.TenDanhGia, BB.STT, BB.DiemToiDa, BB.IdDanhGia, BB.ParentID, BB.Flag1, BB.DanhGiaDinhNghiaId, BB.LoaiDanhGia, BB.MaKhoa, Isnull(BB.flag1, 0), 
	  cted.LEVEL + 1 AS LEVEL, 
	  CAST(CAST(cted.TreePath AS VARCHAR(1024)) + '-' + CAST(FORMAT(BB.STT,'d5') AS VARCHAR(1024)) AS VARCHAR(1024)) AS TreePath
	  --CAST(cted.TreePath + ' -> ' + CAST(BB.TenDanhGia AS NVARCHAR(1024)) AS NVARCHAR(1024)) AS TreePath
	  FROM   #tmp2 BB 
	  INNER JOIN CTE_DMDanhGia_Chung cted ON cted.IdDanhGia = BB.ParentID 
	  WHERE cted.LEVEL <= 9 
	  
 )  

SELECT MaNhomDanhGia,TenNhom,Loai,Active,TenDanhGia,STT,DiemToiDa,IdDanhGia,ParentID,Flag1,DanhGiaDinhNghiaId,LoaiDanhGia,MaKhoa,Flag ,TreePath
FROM CTE_DMDanhGia_Chung ORDER BY MaNhomDanhGia, TreePath; 



