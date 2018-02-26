
CREATE PROCEDURE [ControleDados].[proc_AtualizaPontoParadaAVGestaoDW] @Step VARCHAR(400)
AS

DECLARE @Parametro NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 
DECLARE @parmOUT INT = 0

SET @COMANDO =
    'select @parmOUT = count(*) 
	 from OBERON.msdb.dbo.sysjobactivity A
	 join OBERON.msdb.dbo.sysjobs B on A.job_id = B.job_id
	JOIN msdb.dbo.syssessions sess ON sess.session_id = A.session_id
	JOIN
(
    SELECT
        MAX( agent_start_date ) AS max_agent_start_date
    FROM
        msdb.dbo.syssessions
) sess_max
ON    sess.agent_start_date = sess_max.max_agent_start_date	
	 where name = ''ETL - ExecucaoMestre'' AND start_Execution_Date is not null and stop_execution_date is null       
    '
--	''EXEC @Count = MSDB.dbo.proc_CheckJobActivity ''''ETL - ExecucaoMestre'''''') A
--print @COMANDO

SET @Parametro=N'@parmOUT INT OUTPUT'

EXECUTE sp_executesql
@COMANDO,
@Parametro,
@parmOUT=@parmOUT OUTPUT
--print @parmOUT
IF @parmOUT = 0 --JOB DE CARGA FENAE NÃO EXECUTANDO
BEGIN 
--print 1

	IF (SELECT MAX(ID) Maximo 
	   FROM Dados.AVGestaoBloco
	   WHERE CHARINDEX(@Step,Arquivo) > 1) > (SELECT Cast(PontoParada as bigint)
									FROM ControleDados.PontoParadaDW PPD
									WHERE PPD.Step = @Step) 
	BEGIN
	  UPDATE ControleDados.PontoParadaDW SET PontoParada = (SELECT MAX(ID) Maximo 
														    FROM Dados.AVGestaoBloco
														    WHERE CHARINDEX(@Step,Arquivo) > 1)
	  WHERE Step = @Step
	 -- print '1';
	 --SELECT MAX(ID) Maximo 
	 --FROM Dados.AVGestaoBloco
	END
END