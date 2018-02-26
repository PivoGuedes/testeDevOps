/*
	Autor: Gustavo Moreira
	Data Criação: 09/12/2013

	Descrição: 
	

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_Processa_VENDAS
	Descrição: Procedimento que realiza a atualização de informações de apólices recebidas no arquivo VENDAS.
		
	Parâmetros de entrada:
	
					
	Retorno:


	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_Processa_VENDAS] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRPSASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VENDAS_TEMP];


CREATE TABLE [dbo].[VENDAS_TEMP]
			(
			  [NumeroCertificado] [varchar](20) NULL
			, [NumeroReciboCobranca] [varchar](20) NULL
			, [CodigoFilial] [smallint]
			, [NumeroProposta] [varchar](20) NULL
			, [NumeroBilhete] [varchar](20) NULL
			, [CodigoProduto] [smallint]
			, [CodigoAgencia] [smallint]
			, [DataQuitacao] [date] NOT NULL
			, [ValorPremioTotal] [numeric](15, 2) NULL
			, [DataMovimentacao] [date] NOT NULL
			, [ValorPremioLiquido] [numeric](15, 2) NULL
			, [CodigoOperacao] [smallint]
			, [DataArquivo] [date] NOT NULL
			, [NomeArquivo] [varchar](100) NOT NULL
			, [ControleVersao] [numeric](16, 8) NULL
			, [Codigo] [bigint]
			)



SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Processa_VENDAS'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO =
	'	INSERT INTO dbo.VENDAS_TEMP
		(	  [NumeroCertificado]
			, [NumeroReciboCobranca]
			, [CodigoFilial]
			, [NumeroProposta]
			, [NumeroBilhete]
			, [CodigoProduto]
			, [CodigoAgencia]
			, [DataQuitacao]
			, [ValorPremioTotal]
			, [DataMovimentacao]
			, [ValorPremioLiquido]
			, [CodigoOperacao]
			, [DataArquivo]
			, [NomeArquivo]
			, [ControleVersao]
			, [Codigo]
		)
		SELECT [NumeroCertificado]
			, [NumeroReciboCobranca]
			, [CodigoFilial]
			, [NumeroProposta]
			, [NumeroBilhete]
			, [CodigoProduto]
			, [CodigoAgencia]
			, [DataQuitacao]
			, [ValorPremioTotal]
			, [DataMovimentacao]
			, [ValorPremioLiquido]
			, [CodigoOperacao]
			, [DataArquivo]
			, [NomeArquivo]
			, [ControleVersao]
			, [Codigo]
		FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaVENDAS]''''' + @PontoDeParada + ''''''') RV
	'

exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(RV.Codigo)
FROM dbo.VENDAS_TEMP RV 

/*********************************************************************************************************************/
  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/************************************************************************
		Carrega Produtos Desconhecidos
*************************************************************************/  

; MERGE INTO Dados.Produto T
	USING (
			SELECT DISTINCT VT.CodigoProduto as [CodigoComercializado],
				   '' as [Descricao]
			FROM dbo.VENDAS_TEMP VT
		  )  X
	ON T.CodigoComercializado = X.CodigoComercializado
  WHEN NOT MATCHED
		THEN INSERT (CodigoComercializado, Descricao)
		VALUES (X.[CodigoComercializado], X.[Descricao]);


/************************************************************************
		Carrega Agências Desconhecidas
*************************************************************************/  

/*INSERE PVs NÃO LOCALIZADOS*/
	;INSERT INTO Dados.Unidade(Codigo) 
	SELECT DISTINCT CAD.CodigoAgencia
	FROM dbo.VENDAS_TEMP CAD
	WHERE  CAD.CodigoAgencia IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.CodigoAgencia);
					  
					                                                                          

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'EMISSAO' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					EM.NomeArquivo [Arquivo]

	FROM dbo.VENDAS_TEMP EM
	INNER JOIN Dados.Unidade U
	ON EM.CodigoAgencia = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID ,EM.NomeArquivo


/************************************************************************/
/*					Insere propostas não recebidas						*/
/************************************************************************/  

; MERGE INTO Dados.Proposta T
	USING  (
			SELECT    VT.NumeroCertificado [NumeroProposta]
					, P.ID [IDProduto]
					, 0 [IDSituacaoProposta]
					, U.ID [IDUnidade]
					, VT.ValorPremioTotal
					, VT.DataQuitacao [DataSituacao]
					, 'VENDAS' [TipoDado]
					, VT.DataArquivo
					, 1 [IDSeguradora] /*Caixa Seguros*/  
			FROM dbo.VENDAS_TEMP VT
			INNER JOIN Dados.Produto P
			ON P.CodigoComercializado = VT.CodigoProduto
			INNER JOIN Dados.Unidade U
			ON U.Codigo = VT.CodigoAgencia
		   ) X
  ON T.NumeroProposta = X.NumeroProposta
 AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED
	THEN INSERT ( IDSeguradora
				, NumeroProposta
				, IDProduto
				, DataProposta
				, Valor
				, DataSituacao
				, IDSituacaoProposta
				, TipoDado
				, DataArquivo)
	VALUES		( X.IDSeguradora
				, X.NumeroProposta
				, X.IDProduto
				, X.DataSituacao --DataProposta (alimentado com a data da quitação)
				, X.ValorPremioTotal
				, X.DataSituacao --DataSituacao (alimentado com a data da quitação)
				, X.IDSituacaoProposta
				, X.TipoDado
				, X.DataArquivo)
WHEN MATCHED AND (T.IDProduto IS NULL OR T.IDProduto = -1)
    THEN UPDATE SET IDProduto = X.IDProduto,
	                TipoDado = CASE WHEN CHARINDEX('VENDAS', T.TipoDado) > 0 THEN T.TipoDado ELSE T.TipoDado + ' # ' + X.TipoDado END;
;

/************************************************************************/
/*					Insere PropostaSituacao	fake    					*/
/************************************************************************/ 
 
;  INSERT INTO Dados.PropostaSituacao (IDProposta, IDSituacaoProposta, [IDTipoMotivo], [DataInicioSituacao], DataArquivo, TipoDado, LastValue)
   SELECT IDProposta, IDSituacaoProposta, IDTipoMotivo, DataInicioSituacao, DataArquivo, TipoDado, LastValue
   FROM
   (
	 SELECT PRP.ID [IDProposta] 
	    , PRP.IDSituacaoProposta
		, -1 [IDTipoMotivo]
		, PRP.DataSituacao [DataInicioSituacao]
		, MAX(PRP.DataArquivo) DataArquivo
		, 'VENDAS' TipoDado
		, 1 LastValue
	 FROM Dados.P.VENDAS_TEMP VT  			 
	  INNER JOIN Dados.Proposta PRP
	  on VT.NumeroProposta = PRP.NumeroProposta
	 AND VT.IDSeguradora = PRP.IDSeguradora
	GROUP BY PRP.ID, PRP.IDSituacaoProposta, PRP.DataSituacao
   ) X	
   WHERE NOT EXISTS (SELECT * 							 --Data: 2013-12-17: Aqui filtramos parq que apenas propostas nunca recebidas recembão 
					 FROM Dados.PropostaSituacao PS		 --o registro de situação na tabela PropostaSituacao
					 WHERE PS.IDProposta = X.IDProposta);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Processa_VENDAS'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[VENDAS_TEMP]
  
  /*********************************************************************************************************************/
                
    SET @COMANDO =
    '	INSERT INTO dbo.VENDAS_TEMP
		(	  [NumeroCertificado]
			, [NumeroReciboCobranca]
			, [CodigoFilial]
			, [NumeroProposta]
			, [NumeroBilhete]
			, [CodigoProduto]
			, [CodigoAgencia]
			, [DataQuitacao]
			, [ValorPremioTotal]
			, [DataMovimentacao]
			, [ValorPremioLiquido]
			, [CodigoOperacao]
			, [DataArquivo]
			, [NomeArquivo]
			, [ControleVersao]
			, [Codigo]
		)
		SELECT [NumeroCertificado]
			, [NumeroReciboCobranca]
			, [CodigoFilial]
			, [NumeroProposta]
			, [NumeroBilhete]
			, [CodigoProduto]
			, [CodigoAgencia]
			, [DataQuitacao]
			, [ValorPremioTotal]
			, [DataMovimentacao]
			, [ValorPremioLiquido]
			, [CodigoOperacao]
			, [DataArquivo]
			, [NomeArquivo]
			, [ControleVersao]
			, [Codigo]
		FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaVENDAS]''''' + @PontoDeParada + ''''''') RV
	'
  EXEC (@COMANDO)
                  
  SELECT @MaiorCodigo= MAX(RV.Codigo)
  FROM dbo.VENDAS_TEMP RV    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VENDAS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VENDAS_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     


