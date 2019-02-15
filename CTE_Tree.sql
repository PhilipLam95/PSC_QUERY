WITH CTE_DMDanhGia_Chung(DepartmentID,DepartmentName,ParentID,STT,LEVEL,TreePath) AS
(
SELECT d.Id,d.TenDanhGia,d.ParentID,d.STT,
    0 AS LEVEL,
    --CAST(d.TenDanhGia AS NVARCHAR(1024)) AS TreePath
	--2012
	CAST(FORMAT(d.STT,'d5') AS VARCHAR(1024)) AS TreePath
	--2008
	--CAST(right('00000' + cast(d.STT as varchar(5)), 5) AS VARCHAR(1024)) AS TreePath
FROM DMDanhGia_Chung d
WHERE d.ParentID = 0 


UNION ALL

SELECT d.Id,d.TenDanhGia,d.ParentID,d.STT,
    cted.LEVEL + 1 AS LEVEL,
    --CAST(cted.TreePath + ' -> ' + CAST(d.TenDanhGia AS NVARCHAR(1024)) AS NVARCHAR(1024)) AS TreePath
	--2012
	CAST(CAST(FORMAT(cted.STT,'d5') AS VARCHAR(1024)) + '-' + CAST(FORMAT(d.STT,'d5') AS VARCHAR(1024)) AS VARCHAR(1024)) AS TreePath
	--2008
	--CAST(CAST(right('00000' + cast(cted.STT as varchar(5)), 5) AS VARCHAR(1024)) + '-' + CAST(right('00000' + cast(d.STT as varchar(5)), 5) AS VARCHAR(1024)) AS VARCHAR(1024)) AS TreePath
	FROM DMDanhGia_Chung d
	INNER JOIN CTE_DMDanhGia_Chung cted ON cted.DepartmentID = d.ParentID
	--LEVEL <= 9 tranh vong lap
	WHERE cted.LEVEL <= 9
)

SELECT *
FROM CTE_DMDanhGia_Chung
ORDER BY TreePath;