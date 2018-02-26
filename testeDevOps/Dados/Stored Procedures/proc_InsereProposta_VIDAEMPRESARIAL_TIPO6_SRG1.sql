
/*
	Autor: Egler Vieira
	Data Criação: 22/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_VIDAEMPRESARIAL_TIPO6_SRG1
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_VIDAEMPRESARIAL_TIPO6_SRG1] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP];
	/*
		RAISERROR   (N'A tabela temporária [VIDAEMPRESARIAL_TIPO6_SRG1_TMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END

CREATE TABLE [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP](

	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[DataArquivo] [date] NOT NULL,
	
	[TipoArquivo] [varchar](30) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	
	[IDTipoCapital] [tinyint] NULL,
	--[DescricaoTipoCapital] [varchar](12) NULL,
	[CapitalSeguradoBasicoTotal] [decimal](19,2) NULL,
	[PeriodicidadeEscolhida] [varchar](2) NULL,
	[ValorFatura] [decimal] (19,2) NULL,
	[TotalDeVidas] [int] NULL,
	[CodigoCNAE] [varchar](10) NULL,
	[IDPorteEmpresa] [tinyint] NULL,
	--[DescricaoPorteEmpresa] [varchar](19) NULL,
	[QuantidadeOcorrencias] [int] NULL,
	[NivelCargo] [tinyint] NULL,
	[ValorSegurado] [decimal](19,2) NULL,
	[QuantidadeDeVidas] [int] NULL
);	

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_VIDAEMPRESARIAL_TIPO6_SRG1_TMP_Codigo ON [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_VIDAEMPRESARIAL_TIPO6_SRG1'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
      
--DECLARE @PontoDeParada AS VARCHAR(400) = '0'
--DECLARE @COMANDO AS NVARCHAR(MAX)    
      
    SET @COMANDO =
    '  INSERT INTO dbo.VIDAEMPRESARIAL_TIPO6_SRG1_TMP
        ( [Codigo],                                               
	        [ControleVersao],                                       
	        [DataArquivo],  
	        [TipoArquivo],                                          
	        [NumeroProposta], 
	        [IDTipoCapital], 
	        [CapitalSeguradoBasicoTotal],                           
	        [PeriodicidadeEscolhida],                               
	        [ValorFatura],                                          
	        [TotalDeVidas],                                         
	        [CodigoCNAE],                                           
	        [IDPorteEmpresa], 
	        [QuantidadeOcorrencias],                                
	        [NivelCargo],                                           
	        [ValorSegurado],                                        
	        [QuantidadeDeVidas] 
	       )
     SELECT 
          [Codigo],                                               
	        [Versao],                                       
	        [DataArquivo],  
	        [TipoArquivo],                                          
	        [NumeroProposta], 
	        [IDTipoCapital], 
	        [CapitalSeguradoBasicoTotal],                           
	        [PeriodicidadeEscolhida],                               
	        [ValorFatura],                                          
	        [TotalDeVidas],                                         
	        [CodigoCNAE],                                           
	        [IDPorteEmpresa], 
	        [QuantidadeOcorrencias],                                
	        [NivelCargo],                                           
	        [ValorSegurado],                                        
	        [QuantidadeDeVidas]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_VIDAEMPRESARIAL_TIPO6_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.VIDAEMPRESARIAL_TIPO6_SRG1_TMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

  
  /*INSERE PORTES DE EMPRESA*/
  ;MERGE INTO Dados.PorteEmpresa AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.[IDPorteEmpresa]
  FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP] RTP6
  WHERE RTP6.[IDPorteEmpresa] IS NOT NULL
  ) X
  ON T.[ID]= X.[IDPorteEmpresa]
  WHEN NOT MATCHED
          THEN INSERT ([ID])
               VALUES (X.[IDPorteEmpresa]);  
          
               
  /*INSERE TIPOS DE CAPIUTAL SEGURADOS*/
  ;MERGE INTO Dados.TipoCapital AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.IDTipoCapital
  FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP] RTP6
  WHERE RTP6.IDTipoCapital IS NOT NULL
  ) X
  ON T.[ID]= X.IDTipoCapital
  WHEN NOT MATCHED
          THEN INSERT ([ID])
               VALUES (X.IDTipoCapital); 
                   
                 
  /*INSERE PERIODICIDADES DE PAGAMENTO*/
  ;MERGE INTO Dados.PeriodoPagamento AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.PeriodicidadeEscolhida, '' [Descricao]
  FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP] RTP6
  WHERE RTP6.IDTipoCapital IS NOT NULL
  ) X
  ON T.[Codigo]= X.PeriodicidadeEscolhida
  WHEN NOT MATCHED
          THEN INSERT ([Codigo], [Descricao])
               VALUES (X.PeriodicidadeEscolhida, X.[Descricao]);  
               
               
  /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.Proposta AS T
    USING (SELECT DISTINCT RTP6.[NumeroPropostaTratado], 1 [IDSeguradora], RTP6.[TipoArquivo] [TipoDado], RTP6.[DataArquivo]
        FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP] RTP6
        WHERE RTP6.NumeroPropostaTratado IS NOT NULL
          ) X
    ON T.NumeroProposta = X.NumeroPropostaTratado
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);               
               
               
  /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.PropostaCliente AS T
    USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(TipoArquivo) [TipoDado], MAX(RTP6.[DataArquivo]) [DataArquivo]
        FROM [VIDAEMPRESARIAL_TIPO6_SRG1_TMP] RTP6
        INNER JOIN Dados.Proposta PRP
        ON PRP.NumeroProposta = RTP6.NumeroProposta
        AND PRP.IDSeguradora = 1
        WHERE RTP6.NumeroProposta IS NOT NULL
        GROUP BY PRP.ID 
          ) X
    ON T.IDProposta = X.IDProposta
   WHEN NOT MATCHED
          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]) ;  
			               
		               
 /*Apaga a marcação LastValue das propostas vida empresarial recebidas para atualizar a última posição */
	/*Diego Lima - Data: 02/12/2013 */

    UPDATE Dados.PropostaVidaEmpresarial SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaVidaEmpresarial PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM  [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
								LEFT JOIN Dados.Proposta PRP
									ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
								LEFT JOIN Dados.PeriodoPagamento PP
									ON PP.Codigo = RTP6.PeriodicidadeEscolhida
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1

  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
   
 ;MERGE INTO Dados.PropostaVidaEmpresarial AS T
		USING (       
				SELECT *
						 FROM
							(
							SELECT 
							  --RTP6.[Codigo],                                                     
							  --RTP6.[ControleVersao],                                             
							  RTP6.[TipoArquivo] [TipoDado],                                                
							  RTP6.[DataArquivo],                           
							  PRP.ID [IDProposta],                    
							  RTP6.CapitalSeguradoBasicoTotal,                                         
							  RTP6.[ValorFatura],  
							  RTP6.TotalDeVidas,                                           
							  PP.ID [IDPeriodicidadePagamento],
							  RTP6.CodigoCNAE,
							  RTP6.IDPorteEmpresa,
							  RTP6.IDTipoCapital,
							  RTP6.QuantidadeOcorrencias,
							  0 as LastValue,
							  --RTP6.NivelCargo,
							  --RTP6.QuantidadeDeVidas [QuantidadeVidasCargo],
							 -- RTP6.ValorSegurado [ValorSeguradoCargo],
							  ROW_NUMBER() OVER(PARTITION BY PRP.ID, RTP6.IDTipoCapital,RTP6.CapitalSeguradoBasicoTotal,PP.ID,
					RTP6.[ValorFatura],	RTP6.TotalDeVidas, RTP6.IDPorteEmpresa,RTP6.CodigoCNAE ORDER BY  RTP6.DataArquivo DESC )  [ORDER]
							FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
							  LEFT JOIN Dados.Proposta PRP
							  ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
							  LEFT JOIN Dados.PeriodoPagamento PP
							  ON PP.Codigo = RTP6.PeriodicidadeEscolhida
							) A
							WHERE A.[ORDER] = 1 --and IDProposta = 2825704
							/*LEFT JOIN Dados.Contrato CNT
							ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
						  ) AS X
			ON X.[IDProposta] = T.[IDProposta]
			AND X.IDTipoCapital = T.IDTipoCapital
			AND X.CapitalSeguradoBasicoTotal = T.CapitalSeguradoBasicoTotal
			AND X.[IDPeriodicidadePagamento] = T.[IDPeriodicidadePagamento]
			AND isnull(X.[ValorFatura],0) = isnull(T.[ValorFatura],0)
			AND isnull(X.TotalDeVidas,0) = isnull(T.TotalDeVidas,0)
			AND X.IDPorteEmpresa = T.IDPorteEmpresa
			AND X.CodigoCNAE = T.CodigoCNAE
		
    --AND X.[NivelCargo] = T.[NivelCargo]
    --AND X.[DataArquivo] = T.[DataArquivo]

    WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo]
			    THEN UPDATE
				     SET
				         
                [IDTipoCapital] = COALESCE(X.[IDTipoCapital], T.[IDTipoCapital])
               ,[CapitalSeguradoBasicoTotal] = COALESCE(X.[CapitalSeguradoBasicoTotal], T.[CapitalSeguradoBasicoTotal])
               ,[IDPeriodicidadePagamento] = COALESCE(X.[IDPeriodicidadePagamento], T.[IDPeriodicidadePagamento])
               ,[ValorFatura] = COALESCE(X.[ValorFatura], T.[ValorFatura])
               ,[TotalDeVidas] = COALESCE(X.[TotalDeVidas], T.[TotalDeVidas])
               ,[CodigoCNAE] = COALESCE(X.[CodigoCNAE], T.[CodigoCNAE])
               ,[IDPorteEmpresa] = COALESCE(X.[IDPorteEmpresa], T.[IDPorteEmpresa])
               ,[QuantidadeOcorrencias] = COALESCE(X.[QuantidadeOcorrencias], T.[QuantidadeOcorrencias])
               --,[ValorSeguradoCargo] = COALESCE(X.[ValorSeguradoCargo], T.[ValorSeguradoCargo])
               --,[QuantidadeVidasCargo] = COALESCE(X.[QuantidadeVidasCargo], T.[QuantidadeVidasCargo])
               ,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
			   ,DataArquivo = X.DataArquivo
			   ,LastValue = X.LastValue

    WHEN NOT MATCHED  
			    THEN INSERT          
              (
                [IDProposta]
               ,[IDTipoCapital]
               ,[CapitalSeguradoBasicoTotal]
               ,[IDPeriodicidadePagamento]
               ,[ValorFatura]
               ,[TotalDeVidas]
               ,[CodigoCNAE]
               ,[IDPorteEmpresa]
               ,[QuantidadeOcorrencias]
               --,[NivelCargo]
               --,[ValorSeguradoCargo]
              -- ,[QuantidadeVidasCargo]
               ,[TipoDado]
               ,[DataArquivo]
			   ,LastValue
              )
         VALUES
               (
                X.IDProposta
               ,x.IDTipoCapital
               ,x.CapitalSeguradoBasicoTotal
               ,x.IDPeriodicidadePagamento
               ,x.ValorFatura
               ,x.TotalDeVidas
               ,x.CodigoCNAE
               ,x.IDPorteEmpresa
               ,x.QuantidadeOcorrencias
              -- ,NivelCargo
             --  ,ValorSeguradoCargo
               --,QuantidadeVidasCargo
               ,X.TipoDado
               ,X.DataArquivo
			   ,X.LastValue
              ); 


	/*Atualiza a marcação LastValue das propostas vida empresarial recebidas para atualizar a última posição*/
	/*Diego Lima - Data: 02/12/2013 */	
		 
    UPDATE Dados.PropostaVidaEmpresarial SET LastValue = 1
	--select *
    FROM Dados.PropostaVidaEmpresarial PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM Dados.PropostaVidaEmpresarial PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
											LEFT JOIN Dados.Proposta PRP
												ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1 --and IDProposta = 2825704

  /*************************************************************************************/ 

    /*Apaga a marcação LastValue das propostas vida empresarial recebidas para atualizar a última posição */
	/*Diego Lima - Data: 02/12/2013 */

    UPDATE Dados.PropostaVidaEmpresarialCargo SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaVidaEmpresarialCargo PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM  [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
								LEFT JOIN Dados.Proposta PRP
									ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
								LEFT JOIN Dados.PeriodoPagamento PP
									ON PP.Codigo = RTP6.PeriodicidadeEscolhida
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1

   /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 

 ;MERGE INTO Dados.PropostaVidaEmpresarialCargo AS T
	USING (       
            SELECT Distinct *
					FROM
						(
							SELECT distinct
							  --RTP6.[Codigo],                                                     
							  --RTP6.[ControleVersao],                                             
							  RTP6.[TipoArquivo] [TipoDado],                                                
							  RTP6.[DataArquivo],                           
							  PRP.ID [IDProposta],                    
							  --RTP6.CapitalSeguradoBasicoTotal,                                         
							  --RTP6.[ValorFatura],  
							  --RTP6.TotalDeVidas,                                           
							  --PP.ID [IDPeriodicidadePagamento],
							  --RTP6.CodigoCNAE,
							  --RTP6.IDPorteEmpresa,
							  --RTP6.IDTipoCapital,
							  --RTP6.QuantidadeOcorrencias,
							  0 LastValue,
							  RTP6.NivelCargo,
							  RTP6.QuantidadeDeVidas [QuantidadeVidasCargo],
							  RTP6.ValorSegurado [ValorSeguradoCargo],
							  ROW_NUMBER() OVER(PARTITION BY PRP.ID, RTP6.NivelCargo,RTP6.QuantidadeDeVidas ORDER BY RTP6.DataArquivo DESC )  [ORDER]
							FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
							  LEFT JOIN Dados.Proposta PRP
							  ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
							  LEFT JOIN Dados.PeriodoPagamento PP
							  ON PP.Codigo = RTP6.PeriodicidadeEscolhida
							) A
							WHERE A.[ORDER] = 1 --and IDProposta = 5502437
							/*LEFT JOIN Dados.Contrato CNT
							ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
						  ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[NivelCargo] = T.[NivelCargo]
	AND X.[QuantidadeVidasCargo] = T.[QuantidadeVidasCargo]
	AND X.[ValorSeguradoCargo] = T.[ValorSeguradoCargo]

    WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo]
			    THEN UPDATE
				     SET
				         
               [NivelCargo]= COALESCE(X.[NivelCargo], T.[NivelCargo])
               ,[ValorSeguradoCargo] = COALESCE(X.[ValorSeguradoCargo], T.[ValorSeguradoCargo])
               ,[QuantidadeVidasCargo] = COALESCE(X.[QuantidadeVidasCargo], T.[QuantidadeVidasCargo])
               ,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
			   ,DataArquivo = X.DataArquivo
			   ,LastValue = X.LastValue

    WHEN NOT MATCHED  
			    THEN INSERT          
              (
                [IDProposta]
               ,[NivelCargo]
               ,[ValorSeguradoCargo]
               ,[QuantidadeVidasCargo]
               ,[TipoDado]
               ,[DataArquivo]
			   ,LastValue
              )
         VALUES
               (
                X.IDProposta
               ,X.NivelCargo
               ,X.ValorSeguradoCargo
               ,X.QuantidadeVidasCargo
               ,X.TipoDado
               ,X.DataArquivo
			   ,X.LastValue
              ); 

------------------------------------------------------------------------

	/*Atualiza a marcação LastValue das propostas vida empresarial cargo recebidas para atualizar a última posição*/
	/*Diego Lima - Data: 02/12/2013 */		
	 
    UPDATE Dados.PropostaVidaEmpresarialCargo SET LastValue = 1
	--select *
    FROM Dados.PropostaVidaEmpresarialCargo PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.NivelCargo,PS.ValorSeguradoCargo,
												PS.QuantidadeVidasCargo 
												ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaVidaEmpresarialCargo PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]  RTP6
											LEFT JOIN Dados.Proposta PRP
												ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_VIDAEMPRESARIAL_TIPO6_SRG1'
  /*************************************************************************************/
  
    
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]        
  /*********************************************************************************************************************/
                
  SET @COMANDO =
    '  INSERT INTO dbo.VIDAEMPRESARIAL_TIPO6_SRG1_TMP
        ( [Codigo],                                               
	        [ControleVersao],                                       
	        [DataArquivo],  
	        [TipoArquivo],                                          
	        [NumeroProposta], 
	        [IDTipoCapital], 
	        [CapitalSeguradoBasicoTotal],                           
	        [PeriodicidadeEscolhida],                               
	        [ValorFatura],                                          
	        [TotalDeVidas],                                         
	        [CodigoCNAE],                                           
	        [IDPorteEmpresa], 
	        [QuantidadeOcorrencias],                                
	        [NivelCargo],                                           
	        [ValorSegurado],                                        
	        [QuantidadeDeVidas] 
	       )
     SELECT 
          [Codigo],                                               
	        [Versao],                                       
	        [DataArquivo],  
	        [TipoArquivo],                                          
	        [NumeroProposta], 
	        [IDTipoCapital], 
	        [CapitalSeguradoBasicoTotal],                           
	        [PeriodicidadeEscolhida],                               
	        [ValorFatura],                                          
	        [TotalDeVidas],                                         
	        [CodigoCNAE],                                           
	        [IDPorteEmpresa], 
	        [QuantidadeOcorrencias],                                
	        [NivelCargo],                                           
	        [ValorSegurado],                                        
	        [QuantidadeDeVidas]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_VIDAEMPRESARIAL_TIPO6_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.VIDAEMPRESARIAL_TIPO6_SRG1_TMP PRP    

  
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[VIDAEMPRESARIAL_TIPO6_SRG1_TMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_VIDAEMPRESARIAL_TIPO6_SRG1] 

