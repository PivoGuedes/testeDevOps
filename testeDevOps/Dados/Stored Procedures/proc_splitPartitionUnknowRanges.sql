
--Autor: Egler Vieira
--Criado em: 2014-02-18
--Objetivo: Particionar a tabela de comissão em algum range ainda não particionada
CREATE PROCEDURE [Dados].[proc_splitPartitionUnknowRanges]
as

DECLARE @SchemaName NVARCHAR(200) = N'Dados';
DECLARE @TableName NVARCHAR(200) = N'Comissao_Partitioned';
DECLARE @Range DATE = NULL;

WITH CTE 
AS
(
SELECT
    --SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
    -- , p.partition_number AS [p#]
    -- , fg.name AS [filegroup]
    -- , p.rows
    -- , au.total_pages AS pages
    -- , CASE boundary_value_on_right
    --   WHEN 1 THEN 'less than'
    --   ELSE 'less than or equal to' END as comparison
    Cast(Cast(rv.value as varchar(30))as Date) [Range] 
    -- , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
    --  SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
    --   CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
    --   SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
    --   SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE object_name(p.object_id) = @TableName
AND OBJECT_SCHEMA_NAME(p.object_id) = @SchemaName
AND ISDATE(Cast(rv.value as varchar(30))) = 1
GROUP BY Cast(Cast(rv.value as varchar(30))as Date)
)
--SELECT a.datacompetencia, cte.[range]--* from cte order by [range]	 --a.datacompetencia, cte.[range] --
SELECT   MIN(DataCompetencia)	 
FROM
(
SELECT DataCompetencia
FROM Dados.Comissao_Partitioned CP
group by  CP.DataCompetencia
--ORDER BY DataCompetencia
) A
--left join cte
--on cte.[Range] = a.datacompetencia
WHERE A.DataCompetencia NOT IN (SELECT [Range] FROM CTE)	AND DataCompetencia  IS NOT NULL
;
IF @Range IS NOT NULL
BEGIN
ALTER PARTITION FUNCTION [PF_Dados_DataCompetencia] ()
  SPLIT RANGE (@Range)
;
ALTER PARTITION SCHEME [PS_DADOS_DataCompetencia]
  NEXT USED [Dados]
;
END

