
/*
	Autor: Egler Vieira
	Data Criação: 22/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCobertura_COBVIDA
	Descrição: Procedimento que realiza a inserção das Coberturas (COBVIDA) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCobertura_COBVIDA] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COBVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[COBVIDA_TEMP];


CREATE TABLE [dbo].[COBVIDA_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](100) NULL,
	[DataArquivo] [date] NULL,
	[NumeroApolice] [varchar](20) NOT NULL,
	[NumeroCertificado] [varchar](20) NOT NULL,
	NumeroCertificadoTratado  as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as   varchar(20)) PERSISTED,
	[CodigoCobertura] [smallint] NOT NULL,
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	[ImportanciaSegurada] [numeric](15, 5) NULL,
	[LimiteIndenizacao] [numeric](15, 5) NULL,
	[ValorPremioLiquido] [numeric](15, 5) NULL,
	[CodigoProduto] [varchar](5) null
);  


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_COBVIDA_TEMP ON [dbo].[COBVIDA_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Cobertura_COBVIDA'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = '0'
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)
SET @COMANDO = 'INSERT INTO [dbo].[COBVIDA_TEMP] ( 
                      [Codigo],
	                    [ControleVersao],
	                    [NomeArquivo],
	                    [DataArquivo],
	                    [NumeroApolice],
	                    [NumeroCertificado],
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia],
	                    [ImportanciaSegurada],
	                    [LimiteIndenizacao],
	                    [ValorPremioLiquido],
						[CodigoProduto] 	                    
	                    )
                SELECT 
                      [Codigo],
	                    [ControleVersao],
	                    [NomeArquivo],
	                    [DataArquivo],
	                    [NumeroApolice],
	                    [NumeroCertificado],
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia],
	                    [ImportanciaSegurada],
	                    [LimiteIndenizacao],
	                    [ValorPremioLiquido],
						[CodigoProduto]	
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaCoberturaVida_COBVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[COBVIDA_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
            /*
                  INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
		                           */
                  
   
   /***********************************************************************
     Carregar as COBERTURAS
   ***********************************************************************/
     ;MERGE INTO Dados.Cobertura AS T
      USING (SELECT DISTINCT COB.CodigoCobertura, '' [Nome] 
             FROM [COBVIDA_TEMP] COB
             INNER JOIN Dados.Ramo R
             ON R.Codigo = '93' /*93 - RAMO VIDA PARA COBERTURAS DE VIDA*/
             WHERE COB.CodigoCobertura IS NOT NULL
            ) X
       ON T.[Codigo] = X.CodigoCobertura 
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Nome)
	               VALUES (X.[CodigoCobertura], X.[Nome])
   /***********************************************************************/   
		                           

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Contratos não recebidos nosarquivo de emissões (EMISSAO)
    ----------------------------------------------------------------------------------------------------------------------- 	    
      ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT  DISTINCT
               1 [IDSeguradora] /*Caixa Seguros*/               
             , EM.NumeroApolice [NumeroContrato]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[COBVIDA_TEMP] EM
        WHERE EM.NumeroApolice IS NOT NULL
        GROUP BY EM.NumeroApolice 
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);    
                     
    -----------------------------------------------------------------------------------------------------------------------
    
    
        -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Produto
    -----------------------------------------------------------------------------------------------------------------------
	    
		    
      ;MERGE INTO Dados.Produto AS T
      USING	
       (SELECT DISTINCT CodigoProduto, '' Descricao
        FROM [dbo].[COBVIDA_TEMP] EM
        WHERE EM.CodigoProduto IS NOT NULL
       ) X
      ON isnull(T.CodigoComercializado,-1) = isnull(X.CodigoProduto,-1)
     WHEN NOT MATCHED
			THEN INSERT ([CodigoComercializado], Descricao)
		               VALUES (X.CodigoProduto, X.[Descricao]);  
    
    ---====================
    
    
    
    
    /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    ;MERGE INTO Dados.Proposta AS T
      USING (SELECT CNT.ID [IDContrato], EM.NumeroCertificadoTratado, 1 [IDSeguradora],PRD.ID [IDProduto]
                           , 'COBVIDA' [TipoDado], MAX(EM.DataArquivo) [DataArquivo]
             FROM [COBVIDA_TEMP] EM
              INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = EM.NumeroApolice

			  INNER JOIN Dados.Produto PRD
			  ON isnull(PRD.CodigoComercializado,-1) = isnull(EM.CodigoProduto,-1)

             WHERE EM.[NumeroCertificado] IS NOT NULL
              
             GROUP BY EM.NumeroCertificadoTratado, CNT.ID,PRD.ID
            ) X
      ON T.NumeroProposta = X.NumeroCertificadoTratado
     AND T.IDSeguradora = X.IDSeguradora
     WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
                   VALUES (X.NumeroCertificadoTratado, X.[IDSeguradora], -1, X.IDProduto, 0, -1, 0, -1, X.TipoDado, X.DataArquivo)	               
     WHEN MATCHED	               
            THEN UPDATE SET T.IDContrato = X.IDContrato,
			 /*Atualiza o código do Produto & código do Produto Anterior com o código recebido no comissionamento
		   Diego - 24/04/2014*/
		        T.IDProduto = X.IDProduto,
				   T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											   ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											             ELSE T.IDProdutoAnterior
												    END
										 END    ;
                        

     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
        SELECT DISTINCT   
                  PRP.ID [IDProposta]
                 ,NULL [CPFCNPJ]
                 ,'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' Nome              
                 ,NULL DataNascimento 
                 ,'COBVIDA' [TipoDado]           
                 ,MAX(CRT.DataArquivo) DataArquivo
        FROM dbo.[COBVIDA_TEMP] CRT
          INNER JOIN Dados.Proposta PRP
          ON CRT.[NumeroCertificado] = PRP.NumeroProposta
         AND PRP.IDSeguradora = 1
         GROUP BY PRP.ID
          ) AS X
    ON X.IDProposta = T.IDProposta
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, CPFCNPJ, Nome, DataNascimento                                                                 
              , TipoDado, DataArquivo)                                            
          VALUES (
                  X.IDProposta                                                   
                 ,X.CPFCNPJ                                                        
                 ,X.Nome                                                          
                 ,X.DataNascimento
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]  
                 );
                 
                 
                 
                 
                 
                 
                 
                 
    /****************************************************************************************************************/
    /*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
    /****************************************************************************************************************/
    ;MERGE INTO Dados.Certificado AS T
    USING (             
            SELECT DISTINCT
                   CNT.ID [IDContrato], COB.[NumeroCertificadoTratado], 1 [IDSeguradora]
                 , 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' [NomeCliente]
                 , PRP.ID [IDProposta]
                 , MAX(COB.[DataArquivo]) [DataArquivo], MAX(COB.NomeArquivo) [Arquivo]
            FROM COBVIDA_TEMP COB
              INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = COB.NumeroApolice
              LEFT JOIN Dados.Proposta PRP
              ON COB.NumeroCertificadoTratado = PRP.NumeroProposta          
              AND PRP.IDSeguradora = 1
            WHERE COB.NumeroCertificado IS NOT NULL
            GROUP BY PRP.ID, CNT.ID, COB.[NumeroCertificadoTratado]
          ) AS X
    ON  X.[NumeroCertificadoTratado] = T.[NumeroCertificado]
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
            , [IDProposta])
      VALUES (   
              X.[NumeroCertificadoTratado]
            , X.[NomeCliente]
            , X.[IDSeguradora]
            , X.[IDContrato]
            , X.[DataArquivo]
            , X.[Arquivo]
            , X.IDProposta); 
     /****************************************************************************************************************/       
            
            
      /****************************************************************************************************************/      
      /*INSERE CERTIFICADOS NÃO LOCALIZADOS NA TABELA DE CERTIFICADO HISTÓRICO*/	
      /****************************************************************************************************************/
      ;MERGE INTO Dados.CertificadoHistorico AS T
      USING (
              SELECT DISTINCT C.ID [IDCertificado], /*'0000000' +*/ RIGHT(COB.NumeroCertificadoTratado, 8) [NumeroProposta]
                           , 0 [ValorPremioTotal], 0 [ValorPremioLiquido]
                           , COB.[DataArquivo], COB.NomeArquivo [Arquivo]
              FROM Dados.Certificado C
              INNER JOIN COBVIDA_TEMP COB
              ON COB.NumeroCertificadoTratado = C.NumeroCertificado
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
      /****************************************************************************************************************/
    
		
    MERGE INTO Dados.CertificadoCoberturaHistorico AS T
		USING (
			SELECT 
						COB.[NomeArquivo] [Arquivo],
	          COB.[DataArquivo],	          
	          CRT.ID [IDCertificado],
			      C.ID [IDCobertura],
			      COB.DataInicioVigencia,
			      MAX(COB.DataFimVigencia) DataFimVigencia,
			      MAX(COB.ImportanciaSegurada) ImportanciaSegurada,
			      MAX(COB.LimiteIndenizacao) LimiteIndenizacao,
			      MAX(COB.ValorPremioLiquido) ValorPremioLiquido,
            MAX(COB.Codigo) Codigo
       FROM   Dados.Certificado CRT 
        INNER JOIN [COBVIDA_TEMP] COB        
        ON COB.NumeroCertificadoTratado = CRT.NumeroCertificado
        INNER JOIN Dados.Cobertura C
        ON C.Codigo = COB.CodigoCobertura
        INNER JOIN Dados.Ramo R
        ON R.ID = C.IDRamo
        AND R.Codigo = '93' /*93 - RAMO VIDA PARA COBERTURAS DE VIDA*/
       GROUP BY COB.[NomeArquivo],
         COB.[DataArquivo],	       
         CRT.ID,
         C.ID,
         COB.DataInicioVigencia--,
         --COB.DataFimVigencia, 
         --COB.ImportanciaSegurada,
         --COB.LimiteIndenizacao
         --COB.ValorPremioLiquido         
			) AS O
		ON  T.IDCertificado = O.IDCertificado
    AND T.IDCobertura = O.IDCobertura
    AND T.DataArquivo = O.DataArquivo
    AND (T.DataInicioVigencia = O.DataInicioVigencia OR T.DataInicioVigencia IS NULL AND O.DataInicioVigencia IS NULL)
		WHEN MATCHED
			THEN UPDATE 
				SET T.DataInicioVigencia =  COALESCE(O.DataInicioVigencia, T.DataInicioVigencia)
				   ,T.DataFimVigencia =     COALESCE(O.DataFimVigencia, T.DataFimVigencia)
				   ,T.ImportanciaSegurada = COALESCE(O.ImportanciaSegurada, T.ImportanciaSegurada)
           ,T.LimiteIndenizacao =   COALESCE(O.LimiteIndenizacao, T.LimiteIndenizacao)
					 ,T.ValorPremioLiquido =  COALESCE(O.ValorPremioLiquido, T.ValorPremioLiquido)
					 ,T.DataArquivo =  COALESCE(O.DataArquivo, T.DataArquivo)
					 ,T.Arquivo =  COALESCE(O.Arquivo, T.Arquivo)
					
		WHEN NOT MATCHED
			THEN INSERT (IDCertificado, IDCobertura, DataInicioVigencia, DataFimVigencia, ImportanciaSegurada
			           , LimiteIndenizacao, ValorPremioLiquido, DataArquivo, Arquivo)
				VALUES (O.IDCertificado, O.IDCobertura, O.DataInicioVigencia, O.DataFimVigencia, O.ImportanciaSegurada
				      , O.LimiteIndenizacao, O.ValorPremioLiquido, O.DataArquivo, O.Arquivo);			        
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Cobertura_COBVIDA'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[COBVIDA_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

 SET @COMANDO = 'INSERT INTO [dbo].[COBVIDA_TEMP] ( 
                      [Codigo],
	                    [ControleVersao],
	                    [NomeArquivo],
	                    [DataArquivo],
	                    [NumeroApolice],
	                    [NumeroCertificado],
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia],
	                    [ImportanciaSegurada],
	                    [LimiteIndenizacao],
	                    [ValorPremioLiquido],
						[CodigoProduto] 	                    
	                    )
                SELECT 
                      [Codigo],
	                    [ControleVersao],
	                    [NomeArquivo],
	                    [DataArquivo],
	                    [NumeroApolice],
	                    [NumeroCertificado],
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia],
	                    [ImportanciaSegurada],
	                    [LimiteIndenizacao],
	                    [ValorPremioLiquido],
						[CodigoProduto]	
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaCoberturaVida_COBVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[COBVIDA_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COBVIDA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[COBVIDA_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
