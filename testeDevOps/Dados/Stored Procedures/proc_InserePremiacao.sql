

/*******************************************************************************
	Nome: Corporativo.Dados.proc_InserePremiacao   -> 
	
	Descrição: Proc escrita para coordenar os processos de carga de premiação de indicadores (incluindo gerente e SR)
		
	Parâmetros de entrada: @TipoAcordo ('I', 'GI', 'SR')
		
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePremiacao] @TipoAcordo VARCHAR(2)
AS

--DECLARE @TipoAcordo VARCHAR(2) = 'SR'
--DECLARE @NomeEntidadeAnalitico VARCHAR(50)
--DECLARE @NomeEntidadeSintetico VARCHAR(50)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @NomeEntidade VARCHAR(50) -- = 'Premiacao_SUPERINTENDENTE_INDICADORES' ;
DECLARE @PontoDeParada AS DATE	= '2015-08-23'
DECLARE @COMANDO AS NVARCHAR(max) 
DECLARE @MaiorCodigo AS DATE

IF  @TipoAcordo ='GI'  
	BEGIN
	  SET @NomeEntidade = 'Premiacao_GERENTE_INDICADORES_Odonto' ;
	  --SET @NomeEntidadeSintetico ='PremiacaoSintetico_GERENTE_INDICADORES' ;
	  --SET @NomeEntidadeAnalitico = 'PremiacaoAnalitico_GERENTE_INDICADORES'
	END
	ELSE
	  IF @TipoAcordo = 'I' 
	  BEGIN
		SET @NomeEntidade = 'Premiacao_INDICADORES_Odonto'
		--SET @NomeEntidadeSintetico = 'PremiacaoSintetico_INDICADORES'; 
		--SET @NomeEntidadeAnalitico = 'PremiacaoAnalitico_INDICADORES'
	  END
	  ELSE
		IF	 @TipoAcordo = 'SR' 
		BEGIN
		  SET @NomeEntidade = 'Premiacao_SUPERINTENDENTE_INDICADORES_Odonto' ;
		 -- SET @NomeEntidadeSintetico = 'PremiacaoSintetico_SUPERINTENDENTE_INDICADORES' ;
		 -- SET @NomeEntidadeAnalitico = 'PremiacaoAnalitico_SUPERINTENDENTE_INDICADORES'  ;
		END
		ELSE
			THROW 60000, N'Daily - Indicadores - Carga Corporativo. Tipo de premiação não permitida', 1;



--SELECT @@TRANCOUNT	
SELECT @PontoDeParada = LEFT(PontoParada,10)
FROM ControleDados.PontoParada
WHERE NomeEntidade = @NomeEntidade
 	/*********************************************************************************************************************/               
	/*Recupeara maior Código do retorno*/
	/*********************************************************************************************************************/
SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
            FROM OPENQUERY ([OBERON], 
            '' SELECT MAX(DataArquivo) [MaiorData]
                FROM FENAE.dbo.FundaoAnaliticoIndicadores
                WHERE DataArquivo >= ''''' + Cast(@PontoDeParada as varchar(10)) + '''''
				AND TipoAcordo = ''''' + Cast(@TipoAcordo as varchar(10)) + ''''''') EM';

  --        print @COMANDO      
exec sp_executesql @COMANDO
                ,@ParmDefinition
                ,@MaiorCodigo = @MaiorCodigo OUTPUT;

--*********************************************************************************************************
--TODO: Avaliar se é necessário verificar o maior ponto de parada tanto no sintético quanto no analítico
--Egler -> 2015-08-11
--*********************************************************************************************************
--SELECT  @PontoDeParada = cast(CAST(PontoParada AS VARCHAR(10))as date)-- , Convert(date,LEFT(PontoParada,8),101)
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = @NomeEntidade

--	/*********************************************************************************************************************/               
--	/*Recupeara maior Código do retorno*/
--	/*********************************************************************************************************************/
--SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

--SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
--            FROM OPENQUERY ([OBERON], 
--            '' SELECT MAX(DataArquivo) [MaiorData]
--                FROM FENAE.dbo.PremiacaoSinteticoIndicadores
--                WHERE DataArquivo >= ''''' + Cast(@PontoDeParada as varchar(10)) + '''''
--				AND TipoAcordo = ''''' + Cast(@TipoAcordo as varchar(10)) + ''''''') EM';


--exec sp_executesql @COMANDO
--                ,@ParmDefinition
--                ,@MaiorCodigo = @MaiorCodigo OUTPUT;
--*********************************************************************************************************

                  
WHILE @PontoDeParada < @MaiorCodigo
BEGIN

	BEGIN TRAN

	SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada) --Avança o ponto de parada

    EXEC [Dados].[proc_InserePremiacaoAnalitico_INDICADORES] @PontoDeParada, @TipoAcordo;

    EXEC [Dados].[proc_InserePremiacaoSintetico_INDICADORES] @PontoDeParada, @TipoAcordo;


	IF EXISTS (SELECT * FROM TEMPDB.SYS.objects WHERE NAME LIKE'#LoteProtheusCriado%')
		DROP TABLE #LoteProtheusCriado;

	IF EXISTS (SELECT * FROM TEMPDB.SYS.objects WHERE NAME LIKE '#ControlePremiacaoOrfa%')
		DROP TABLE #ControlePremiacaoOrfa;

    CREATE TABLE #LoteProtheusCriado (acao varchar(20), ID INT, DataArquivo DATE, Tipo VARCHAR(2))
	
	CREATE TABLE #ControlePremiacaoOrfa (DataArquivo DATE, Tipo VARCHAR(2), Contagem TINYINT)

	INSERT INTO #ControlePremiacaoOrfa (Tipo, DataArquivo, Contagem)
	SELECT Tipo, DataArquivo, Count(*) Contagem
	FROM
	(

	SELECT @TipoAcordo Tipo, DATEADD(DD,1,Cast(PP.PontoParada as Date)) DataArquivo
	FROM ControleDados.Pontoparada PP
	WHERE EXISTS (SELECT * -- ANALÍTICO
					FROM Dados.PremiacaoIndicadores PC
					WHERE PC.DataArquivo = DATEADD(DD,1,Cast(PP.PontoParada as Date))					  
				--  AND PC.IDLote IS NUL
					AND
					 PC.Gerente  = CASE WHEN @TipoAcordo = 'I' THEN 0 ELSE 1 END --TODO: Substituir para adaptar o campo Gerente para aceitar o SR
					)
		AND PP.NomeEntidade = @NomeEntidade 
	UNION ALL

	SELECT @TipoAcordo Tipo, DATEADD(DD,1,Cast(PP.PontoParada as Date)) DataArquivo
	FROM ControleDados.Pontoparada PP 
	WHERE EXISTS (SELECT * -- SINTÉTICO
					FROM Dados.RePremiacaoIndicadores RPC
					WHERE RPC.DataArquivo = DATEADD(DD,1,Cast(PP.PontoParada as Date))						
				--	AND RPC.IDLote IS NULL
					AND RPC.Gerente  = CASE WHEN @TipoAcordo = 'I' THEN 0 ELSE 1 END --TODO: Substituir para adaptar o campo Gerente para aceitar o SR
					)
		AND PP.NomeEntidade = @NomeEntidade
	) A
	GROUP BY Tipo, DataArquivo

	
	IF NOT EXISTS (SELECT * FROM #ControlePremiacaoOrfa WHERE Contagem <> 2) 
	BEGIN

	    INSERT INTO #LoteProtheusCriado
		SELECT acao, ID, DataArquivo, Tipo
		FROM
		(
		MERGE INTO ControleDados.LoteProtheus AS T
		USING (
				SELECT Tipo, DataArquivo
				FROM #ControlePremiacaoOrfa			
			 ) S
		ON S.Tipo = T.Tipo COLLATE SQL_Latin1_General_CP1_CI_AS
		AND S.DataArquivo = T.DataArquivo
		WHEN NOT MATCHED 
		THEN 
		  INSERT (Tipo, Ano, Mes, Processado, DataArquivo)
		  VALUES (S.Tipo, YEAR(S.DataArquivo), RIGHT('00' + Cast(MONTH(S.DataArquivo) -1 as varchar(2)),2), 0, DataArquivo)
		WHEN MATCHED THEN  
		  UPDATE SET DataArquivo = S.DataArquivo
		 OUTPUT  $action, inserted.ID, inserted.DataArquivo, inserted.Tipo
		) AS INSERTS (acao, ID, DataArquivo, Tipo)

		--Atualiza o lote da premiação analítica
		UPDATE Dados.PremiacaoIndicadores SET IDLote = l.ID 
		FROM Dados.PremiacaoIndicadores P
		INNER JOIN #LoteProtheusCriado L
		ON L.DataArquivo = P.DataArquivo
		AND P.Gerente = CASE WHEN @TipoAcordo = 'I' THEN 0 ELSE 1 END --TODO: Substituir para adaptar o campo Gerente para aceitar o SR
		WHERE 1 = CASE WHEN @TipoAcordo = 'SR' AND P.NomeArquivo LIKE '%SUPERINTENDENTE%' THEN 1 WHEN @TipoAcordo <> 'SR' AND P.NomeArquivo NOT LIKE '%SUPERINTENDENTE%' THEN 1 ELSE 0 END

		--Atualiza o lote da premiação sintética
		UPDATE Dados.RePremiacaoIndicadores SET IDLote = l.ID
		FROM Dados.RePremiacaoIndicadores P
		INNER JOIN #LoteProtheusCriado L
		ON L.DataArquivo = P.DataArquivo
		AND P.Gerente = CASE WHEN @TipoAcordo = 'I' THEN 0 ELSE 1 END --TODO: Substituir para adaptar o campo Gerente para aceitar o SR
		WHERE 1 = CASE WHEN @TipoAcordo = 'SR' AND P.NomeArquivo LIKE '%SUPERINTENDENTE%' THEN 1 WHEN @TipoAcordo <> 'SR' AND P.NomeArquivo NOT LIKE '%SUPERINTENDENTE%' THEN 1 ELSE 0 END
	END
	ELSE
	BEGIN
		ROLLBACK;
		THROW 60000, N'Daily - Indicadores - Carga Corporativo. Premiação ou Repremiação não encontrada! Verifique registros órfãos', 1;
	END

	/*************************************************************************************/
    /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
    /*************************************************************************************/

    UPDATE ControleDados.PontoParada 
    SET PontoParada = @PontoDeParada
    WHERE NomeEntidade = @NomeEntidade
	/*************************************************************************************/

	COMMIT
END


--SELECT * FROM CONTROLEDADOS.LOTEPROTHEUS
--SELECT * FROM DADOS.PREMIACAOINDICADORES WHERE IDLOTE = 109
--SELECT * FROM DADOS.REPREMIACAOINDICADORES WHERE IDLOTE = 109
--SELECT *
--FROM [ControleDados].[LoteProtheus] 
--WHERE Codigo IS NULL

--SELECT *
--FROM Dados.RepremiacaoIndicadores ri WHERE NOMEARQUIVO = 'D150805.CO3381B.GERENTE.SINTETICO.TXT'
--where ri.idlote = 104

--update 
--Dados.RepremiacaoIndicadores set idlote = 104
-- WHERE NOMEARQUIVO = 'D150805.CO3381B.GERENTE.SINTETICO.TXT'


--SELECT *
--FROM [ControleDados].[LoteProtheus] 

--SELECT TOP 1 *
--FROM Dados.premiacaoIndicadores ri
--where ri.idlote = 95

--SELECT  TOP 1 *
--FROM Dados.REpremiacaoIndicadores ri
--where ri.idlote = 95

--SELECT TOP 1 *
--FROM Dados.premiacaoIndicadores ri
--where ri.idlote = 99

--SELECT  TOP 1 *
--FROM Dados.REpremiacaoIndicadores ri
--where ri.idlote = 99

