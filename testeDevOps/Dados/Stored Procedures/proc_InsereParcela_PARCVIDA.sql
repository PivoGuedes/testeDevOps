

/*
	Autor: Diego Lima
	Data Criação: 30/04/2014

	Descrição: 

	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereParcela_PARCVIDA
	Descrição: Procedimento que realiza a inserção dos PARCELAS (PARCVIDA) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereParcela_PARCVIDA] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARCELA_PARCVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PARCELA_PARCVIDA_TEMP];

CREATE TABLE [dbo].[PARCELA_PARCVIDA_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NOT NULL,
	[DataArquivo] [date] NULL,
	[NumeroContrato] [varchar](20) NULL,
	[SubGrupo] [int] NULL,
	[NumeroCertificado] [varchar](20) NULL,
	[NumeroParcela] [smallint] NULL,
	[OpcaoPagamento] [Varchar](20) NULL,
	[AgenciaCobranca] [varchar](10) NULL,
	[Operacao] [varchar](20) NULL,
	[Conta] [Varchar](20) NULL,
	[DigitoConta] [varchar](5) NULL,
	[DataVencimento] [date]  NULL,
	[DataCobranca] [date]  NULL,
	[DataPagamento] [date]  NULL,
	[ValorPremio] [decimal](15,2) NULL,
	[CodigoRetornoFebraban] [varchar](20) NULL,
	[SituacaoSeguro] [smallint] NULL,
	[SituacaoLancamentoConta] [smallint] NULL,
	[SituacaoCobranca] [char](3) NULL,
	[IDSituacaoCobrança] [tinyint] NULL,
	[IDContrato] [bigint] NULL,
	[IDCertificado] [int] NULL
	
) 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PARCELA_PARCVIDA_TEMP ON [dbo].[PARCELA_PARCVIDA_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PARCVIDA'


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)
--set @pontodeparada = 0
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max) 
SET @COMANDO = 'INSERT INTO [dbo].[PARCELA_PARCVIDA_TEMP]
				(
				 [Codigo]
					  ,[ControleVersao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[NumeroContrato]
					  ,[SubGrupo]
					  ,[NumeroCertificado]
					  ,[NumeroParcela]
					  ,[OpcaoPagamento]
					  ,[AgenciaCobranca]
					  ,[Operacao]
					  ,[Conta]
					  ,[DigitoConta]
					  ,[DataVencimento]
					  ,[DataCobranca]
					  ,[DataPagamento]
					  ,[ValorPremio]
					  ,[CodigoRetornoFebraban]
					  ,[SituacaoSeguro]
					  ,[SituacaoLancamentoConta]
					  ,[SituacaoCobranca]
				)
                SELECT [Codigo]
					  ,[ControleVersao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[NumeroContrato]
					  ,[SubGrupo]
					  ,[NumeroCertificado]
					  ,[NumeroParcela]
					  ,[OpcaoPagamento]
					  ,[AgenciaCobranca]
					  ,[Operacao]
					  ,[Conta]
					  ,[DigitoConta]
					  ,[DataVencimento]
					  ,[DataCobranca]
					  ,[DataPagamento]
					  ,[ValorPremio]
					  ,[CodigoRetornoFebraban]
					  ,[SituacaoSeguro]
					  ,[SituacaoLancamentoConta]
					  ,[SituacaoCobranca]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPARCVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[PARCELA_PARCVIDA_TEMP] PRP

/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo

 /***********************************************************************
       Carregar as SITUAÇÕES de cobrança desconhecidas
 ***********************************************************************/

 ;MERGE INTO [Dados].[SituacaoCobranca] AS T
	  USING (
			   SELECT DISTINCT PRP.SituacaoCobranca [Sigla], '' [Descricao]
               FROM dbo.[PARCELA_PARCVIDA_TEMP] PRP
               WHERE PRP.SituacaoCobranca IS NOT NULL
              ) X
         ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.[Descricao]);

 -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Apólices  - Que referenciam apólices dos CERTIFICADOS" não recebidas nos arquivos de EMISSAO
    -----------------------------------------------------------------------------------------------------------------------
	    
;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT 
              1 [IDSeguradora], /*Caixa Seguros*/               
              EM.[NumeroContrato]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[PARCELA_PARCVIDA_TEMP] EM
        WHERE EM.NumeroContrato IS NOT NULL
        GROUP BY EM.[NumeroContrato]--, EM.[IDSeguradora] 
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);    
                     
    -----------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************************/
    /*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
/****************************************************************************************************************/
;MERGE INTO Dados.Certificado AS T
    USING (             
            SELECT DISTINCT
                   CNT.ID [IDContrato], COB.[NumeroCertificado], 1 [IDSeguradora]
                 , 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' [NomeCliente]
                 , MAX(COB.[DataArquivo]) [DataArquivo], MAX(COB.NomeArquivo) [Arquivo]
            FROM [PARCELA_PARCVIDA_TEMP] COB
              inner JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = COB.NumeroContrato        
            WHERE COB.NumeroCertificado IS NOT NULL
            GROUP BY CNT.ID, COB.[NumeroCertificado]
          ) AS X
    ON  X.[NumeroCertificado] = T.[NumeroCertificado]
    AND X.[IDSeguradora] = T.[IDSeguradora]
    WHEN NOT MATCHED  
      THEN INSERT          
          (   
              [NumeroCertificado]
            , [NomeCliente]  
            , [IDSeguradora]
            , [IDContrato]
            , [DataArquivo]
            , [Arquivo]
           )
      VALUES (   
              X.[NumeroCertificado]
            , X.[NomeCliente]
            , X.[IDSeguradora]
            , X.[IDContrato]
            , X.[DataArquivo]
            , X.[Arquivo]
            /*, X.IDProposta*/); 
     /****************************************************************************************************************/       
            
            
/****************************************************************************************************************/      
      /*INSERE CERTIFICADOS NÃO LOCALIZADOS NA TABELA DE CERTIFICADO HISTÓRICO*/	
/****************************************************************************************************************/
      ;MERGE INTO Dados.CertificadoHistorico AS T
      USING (
              SELECT DISTINCT C.ID [IDCertificado], /*'0000000' +*/ RIGHT(COB.NumeroCertificado, 8) [NumeroProposta]
                           , 0 [ValorPremioTotal], 0 [ValorPremioLiquido]
                           , COB.[DataArquivo], COB.NomeArquivo [Arquivo]
              FROM Dados.Certificado C
              INNER JOIN [PARCELA_PARCVIDA_TEMP] COB
              ON COB.NumeroCertificado = C.NumeroCertificado
              WHERE NOT EXISTS (SELECT * 
                                FROM Dados.CertificadoHistorico CH            
                                WHERE CH.IDCertificado = C.ID)
            ) AS X
      ON  X.[IDCertificado] = T.[IDCertificado]
      AND X.[NumeroProposta] = T.[NumeroProposta]
      AND X.[DataArquivo] = T.[DataArquivo]
      WHEN NOT MATCHED  
        THEN INSERT          
            (   
                [IDCertificado]
              , [NumeroProposta]
              , [ValorPremioTotal]
              , [ValorPremioLiquido]
              , [DataArquivo]
              , [Arquivo])
        VALUES (   
                X.[IDCertificado]
              , X.[NumeroProposta]
              , X.[ValorPremioTotal]
              , X.[ValorPremioLiquido]
              , X.[DataArquivo]
              , X.[Arquivo]
              );
			  
---============================================================
-- Atualizando o subgrupo na tabela proposta

update dados.proposta
set subgrupo = t.subgrupo
--Select top 1000 T.NumeroCertificado, c.idproposta, t.subgrupo, p.subgrupo
from [PARCELA_PARCVIDA_TEMP] t
inner join  Dados.Certificado c
on t.Numerocertificado = c.numerocertificado

inner join Dados.Proposta p
on isnull(p.ID,-1) = isnull(c.IDProposta,-1)

where c.idproposta is not null

/****************************************************************************************************************/      
      /*INSERE AS PARCELAS VIDAS NA TABELA*/	
/****************************************************************************************************************/
 ;MERGE INTO [Dados].[ParcelaVida] AS T
      USING (
			 SELECT * FROM (

							SELECT 
								   CO.ID AS [IDContrato]
								  ,T.[NumeroContrato]
								  --,[SubGrupo]
								  ,CE.ID AS [IDCertificado]
								  ,T.[NumeroCertificado]
								  ,SC.ID AS [IDSituacaoCobranca]
								  ,[SituacaoCobranca]
								  ,[SituacaoSeguro]
								  ,[SituacaoLancamentoConta]
								  ,[NumeroParcela]
								  ,[OpcaoPagamento]
								  ,[AgenciaCobranca]
								  ,[Operacao]
								  ,[Conta]
								  ,[DigitoConta]
								  ,[DataVencimento]
								  ,[DataCobranca]
								  ,[DataPagamento]
								  ,[ValorPremio]
								  ,[CodigoRetornoFebraban]      
								  ,[NomeArquivo]
								  ,T.[DataArquivo]
								  ,ROW_NUMBER() OVER (PARTITION BY T.NUMEROCONTRATO, T.NUMEROCERTIFICADO,T.SITUACAOCOBRANCA,T.SITUACAOSEGURO,T.SITUACAOLANCAMENTOCONTA,T.NUMEROPARCELA ORDER BY t.DataArquivo DESC) NUMERADOR
	  
							FROM [PARCELA_PARCVIDA_TEMP]  T
							LEFT JOIN Dados.Contrato CO
							ON T.NumeroContrato = CO.NumeroContrato

							LEFT JOIN Dados.Certificado CE
							ON T.NumeroCertificado = CE.NumeroCertificado

							LEFT JOIN Dados.SituacaoCobranca SC
							ON T.SituacaoCobranca = SC.Sigla

							--ORDER BY T.NUMEROCONTRATO, T.NUMEROCERTIFICADO,T.SITUACAOCOBRANCA,T.SITUACAOSEGURO,T.SITUACAOLANCAMENTOCONTA,T.NUMEROPARCELA 
						) A

				 WHERE A.NUMERADOR = 1

		) X
		 ON  isnull(X.[IDContrato],-1)		= isnull(T.[IDContrato],-1)	
			AND isnull(X.[IDCertificado],-1)			= isnull(T.[IDCertificado],-1)	
			AND isnull(X.[IDSituacaoCobranca],0)			= isnull(T.[IDSituacaoCobranca],0)	
			AND isnull(X.[SituacaoSeguro],-1)				= isnull(T.[SituacaoSeguro],-1)	
			AND isnull(X.[SituacaoLancamentoConta],-1)	 = isnull(T.[SituacaoLancamentoConta],-1)	
			AND isnull(X.[NumeroParcela],-1)				= isnull(T.[NumeroParcela],-1)	
WHEN MATCHED THEN 
		UPDATE
			 SET
				[OpcaoPagamento] = COALESCE(X.[OpcaoPagamento],T.[OpcaoPagamento]),
				[AgenciaCobranca]= COALESCE(X.[AgenciaCobranca],T.[AgenciaCobranca]),
				[Operacao]= COALESCE(X.[Operacao],T.[Operacao]),
				[Conta]= COALESCE(X.[Conta],T.[Conta]),
				[DigitoConta]= COALESCE(X.[DigitoConta],T.[DigitoConta]),
				[DataVencimento]= COALESCE(X.[DataVencimento],T.[DataVencimento]),
				[DataCobranca]= COALESCE(X.[DataCobranca],T.[DataCobranca]),
				[DataPagamento]= COALESCE(X.[DataPagamento],T.[DataPagamento]),
				[ValorPremio]= COALESCE(X.[ValorPremio],T.[ValorPremio]),
				[CodigoRetornoFebraban]= COALESCE(X.[CodigoRetornoFebraban],T.[CodigoRetornoFebraban]),
				NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo),
				DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)

	WHEN NOT MATCHED THEN 
	INSERT ([IDContrato],[IDCertificado],[IDSituacaoCobranca],[SituacaoSeguro],[SituacaoLancamentoConta],[NumeroParcela]
			,[OpcaoPagamento],[AgenciaCobranca],[Operacao],[Conta],[DigitoConta],[DataVencimento],[DataCobranca],[DataPagamento]
			,[ValorPremio],[CodigoRetornoFebraban],[NomeArquivo],[DataArquivo] )

	values (X.[IDContrato],X.[IDCertificado],X.[IDSituacaoCobranca],X.[SituacaoSeguro],X.[SituacaoLancamentoConta]
			,X.[NumeroParcela],X.[OpcaoPagamento],X.[AgenciaCobranca],X.[Operacao],X.[Conta],X.[DigitoConta],X.[DataVencimento]
			,X.[DataCobranca],X.[DataPagamento],X.[ValorPremio],X.[CodigoRetornoFebraban],X.[NomeArquivo],X.[DataArquivo]);

 
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'PARCVIDA'

TRUNCATE TABLE [dbo].PARCELA_PARCVIDA_TEMP

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[PARCELA_PARCVIDA_TEMP]
				(
				 [Codigo]
					  ,[ControleVersao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[NumeroContrato]
					  ,[SubGrupo]
					  ,[NumeroCertificado]
					  ,[NumeroParcela]
					  ,[OpcaoPagamento]
					  ,[AgenciaCobranca]
					  ,[Operacao]
					  ,[Conta]
					  ,[DigitoConta]
					  ,[DataVencimento]
					  ,[DataCobranca]
					  ,[DataPagamento]
					  ,[ValorPremio]
					  ,[CodigoRetornoFebraban]
					  ,[SituacaoSeguro]
					  ,[SituacaoLancamentoConta]
					  ,[SituacaoCobranca]
				)
                SELECT [Codigo]
					  ,[ControleVersao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  ,[NumeroContrato]
					  ,[SubGrupo]
					  ,[NumeroCertificado]
					  ,[NumeroParcela]
					  ,[OpcaoPagamento]
					  ,[AgenciaCobranca]
					  ,[Operacao]
					  ,[Conta]
					  ,[DigitoConta]
					  ,[DataVencimento]
					  ,[DataCobranca]
					  ,[DataPagamento]
					  ,[ValorPremio]
					  ,[CodigoRetornoFebraban]
					  ,[SituacaoSeguro]
					  ,[SituacaoLancamentoConta]
					  ,[SituacaoCobranca]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPARCVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)    
--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM [dbo].PARCELA_PARCVIDA_TEMP PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PARCELA_PARCVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PARCELA_PARCVIDA_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

