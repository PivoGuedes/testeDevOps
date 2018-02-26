
CREATE PROCEDURE [Dados].[proc_InsereInformacoesComplementares_PRPFCAP] 
AS
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InfoComplementares_PRPFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[InfoComplementares_PRPFCAP_TEMP];

CREATE TABLE [dbo].[InfoComplementares_PRPFCAP_TEMP]
(
	[Codigo] [int] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[TipoArquivo] [varchar](15) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado] AS CAST(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) AS VARCHAR(20)) PERSISTED,
	[InformacoesComplementares] [varchar](120) NULL
)

 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_InfoComplementares_PRPFCAP_TEMP ON [dbo].[InfoComplementares_PRPFCAP_TEMP] (Codigo ASC)         

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'InfoComplementares_PRPFCAP'

--SELECT @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/

--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max) 
SET @COMANDO = 'INSERT INTO [dbo].[InfoComplementares_PRPFCAP_TEMP] (
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [InformacoesComplementares]
	                    )  
                SELECT  
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [InformacoesComplementares]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaInformacoesComplementares_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[InfoComplementares_PRPFCAP_TEMP] PRP
        
         
/****************************************************************************/
/****************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo

/*Inserção de Propostas não Localizadas - Por Numero de Proposta*/
MERGE INTO Dados.Proposta AS T
USING (
		SELECT distinct EM.[NumeroPropostaTratado], 
		        3 AS [IDSeguradora],
	            MAX(TipoArquivo) [TipoDado], 
				MAX(DataArquivo) [DataArquivo]
        FROM dbo.[InfoComplementares_PRPFCAP_TEMP] EM
        WHERE EM.NumeroPropostaTratado IS NOT NULL
        GROUP BY EM.[NumeroPropostaTratado]
      ) X
ON T.NumeroProposta = X.NumeroPropostaTratado
AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR,IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
    VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               		               
	

/*Insere Propostas de Clientes não Localizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID AS [IDProposta], 
			'Cliente Desconhecido - Proposta não Recebida' AS [NomeCliente], 
			MIN(EM.[TipoArquivo]) AS [TipoDado], 
			MAX(EM.[DataArquivo]) AS [DataArquivo]
	FROM dbo.[InfoComplementares_PRPFCAP_TEMP] EM
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = EM.[NumeroPropostaTratado]
	AND PRP.IDSeguradora = 3
	WHERE EM.NumeroProposta IS NOT NULL
	GROUP BY PRP.ID
) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
    VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
                 	
			 --SELECT *
			 --FROM Dados.PropostaInformacaoComplementar
            
/*Inserção de Informações Complementares PRPFCAP - Capitalização*/
MERGE INTO Dados.PropostaInformacaoComplementar AS T
USING (
		SELECT DISTINCT PROP.ID AS IDProposta,
			   T.InformacoesComplementares AS InformacaoComplementar,
			   T.NomeArquivo AS Arquivo,
			   T.TipoArquivo,
			   T.DataArquivo
        FROM [InfoComplementares_PRPFCAP_TEMP] AS T
		INNER JOIN Dados.Proposta AS PROP
		ON T.NumeroPropostaTratado = PROP.NumeroProposta
      ) X
ON T.IDProposta = X.IDProposta 
and T.DataArquivo = X.DataArquivo

-- SUGESTÃO... AVALIAR NA BASE PRIMÁRIA (FENAE) SE PRPSASSE E PRPFPREV POSSUEM DADOS DE INFORMAÇÃO COMPLEMENTAR.
-- SE POSSUIREM, PENSAR EM UMA MODELAGEM GENÉRICA.
--WHEN MATCHED THEN 
--	UPDATE
--		SET InformacaoComplementar = COALESCE(X.InformacaoComplementar, T.InformacaoComplementar),
--			--DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo),
--			Arquivo = COALESCE(X.Arquivo, T.Arquivo)
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, InformacaoComplementar, DataArquivo, Arquivo)
    VALUES (x.IDProposta, x.InformacaoComplementar, x.DataArquivo, x.Arquivo);
		                   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'InfoComplementares_PRPFCAP'

TRUNCATE TABLE [dbo].[InfoComplementares_PRPFCAP_TEMP]

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[InfoComplementares_PRPFCAP_TEMP] (
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [InformacoesComplementares]
	                    )  
                SELECT  
                        [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [InformacoesComplementares]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaInformacoesComplementares_PRPFCAP] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[InfoComplementares_PRPFCAP_TEMP] PRP
                    
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InfoComplementares_PRPFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[InfoComplementares_PRPFCAP_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
