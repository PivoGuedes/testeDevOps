
/*
	Autor: Egler Vieira
	Data Criação: 30/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_RESIDENCIAL_TIPO6_SRG1
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_RESIDENCIAL_TIPO6_SRG1] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESIDENCIAL_TIPO6_SRG_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[RESIDENCIAL_TIPO6_SRG_TMP];
	/*
		RAISERROR   (N'A tabela temporária [RESIDENCIAL_TIPO6_SRG_TMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END

CREATE TABLE [dbo].[RESIDENCIAL_TIPO6_SRG_TMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[NumeroVersao] [varchar](4) NULL,
	[CodigoTipoMoradia] [varchar](4) NULL,
	[CodigoTipoOcupacao] [varchar](4) NULL,
	[CodigoTipoSeguro] [varchar] (2) NULL,
	[TipoSeguro] [varchar](12) NULL,
	[DescontoFidelidade] [decimal](8,4) NULL,
	[DescontoAgrupCobertura] [decimal](8,4) NULL,
	[DescontoExperiencia] [decimal](8,4) NULL,
	[ValorPremioLiquido] [decimal](19,2) NULL,
	[ValorAdicionalFracionamento] [decimal](19,2) NULL,
	[ValorCustoApolice] [varchar](30) NULL,
	[ValorIOF] [decimal](19,2) NULL,
	[ValorPremioTotal] [decimal](19,2) NULL,
	[QuantidadeParcelas] [tinyint] NULL,
	[ValorPrimeiraParcela] [decimal](19,2) NULL,
	[ValorDemaisParcelas] [decimal](19,2) NULL,
	[IndicadorRenovacaoAutomatica] [varchar](1) NULL,
	[NumeroApoliceAnterior] [varchar](20) NULL,
	[DescontoFuncionarioPublico] [decimal](8,4) NULL,
	[NumeroProdutoAVGestao] [varchar](4) NULL
);                         


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_RESIDENCIAL_TIPO6_SRG_TMP_Codigo ON [dbo].[RESIDENCIAL_TIPO6_SRG_TMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_RESIDENCIAL_TIPO6_SRG1'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.RESIDENCIAL_TIPO6_SRG_TMP
        ( [Codigo],                                                     
	        [ControleVersao],                                             
	        [NomeArquivo],                                                
	        [DataArquivo],                                                
	        [NumeroProposta],                                             
	        [NumeroVersao],                                               
	        [CodigoTipoMoradia],                                          
	        [CodigoTipoOcupacao],   
	        [CodigoTipoSeguro],                                      
	        [TipoSeguro],                                                 
	        [DescontoFidelidade],                                         
	        [DescontoAgrupCobertura],                                     
	        [DescontoExperiencia],                                        
	        [ValorPremioLiquido],                                         
	        [ValorAdicionalFracionamento],                                
	        [ValorCustoApolice],                                          
	        [ValorIOF],                                                   
	        [ValorPremioTotal],                                           
	        [QuantidadeParcelas],                                         
	        [ValorPrimeiraParcela],                                       
	        [ValorDemaisParcelas],                                        
	        [IndicadorRenovacaoAutomatica],                               
	        [NumeroApoliceAnterior],                                      
	        [DescontoFuncionarioPublico],                                 
	        [NumeroProdutoAVGestao] )
     SELECT [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],                                             
	          [NumeroVersao],                                               
	          [CodigoTipoMoradia],                                          
	          [CodigoTipoOcupacao], 
	          [CodigoTipoSeguro],                                        
	          [TipoSeguro],                                                 
	          [DescontoFidelidade],                                         
	          [DescontoAgrupCobertura],                                     
	          [DescontoExperiencia],                                        
	          [ValorPremioLiquido],                                         
	          [ValorAdicionalFracionamento],                                
	          [ValorCustoApolice],                                          
	          [ValorIOF],                                                   
	          [ValorPremioTotal],                                           
	          [QuantidadeParcelas],                                         
	          [ValorPrimeiraParcela],                                       
	          [ValorDemaisParcelas],                                        
	          [IndicadorRenovacaoAutomatica],                               
	          [NumeroApoliceAnterior],                                      
	          [DescontoFuncionarioPublico],                                 
	          [NumeroProdutoAVGestao] 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_RESIDENCIAL_TIPO6_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.RESIDENCIAL_TIPO6_SRG_TMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo


  
  /*INSERE TIPOS DE MORADIA NÃO LOCALIZADOS*/
  ;MERGE INTO Dados.TipoMoradia AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.[CodigoTipoMoradia] [IDTipoMoradia]
  FROM [dbo].[RESIDENCIAL_TIPO6_SRG_TMP] RTP6
  WHERE RTP6.[CodigoTipoMoradia] IS NOT NULL
  ) X
  ON T.[ID] = X.[IDTipoMoradia]
  WHEN NOT MATCHED
          THEN INSERT ([ID])
               VALUES (X.[IDTipoMoradia]);  
               
               
  /*INSERE TIPOS DE OCUPAÇÃO NÃO LOCALIZADOS*/
  ;MERGE INTO Dados.TipoOcupacao AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.[CodigoTipoOcupacao] [IDTipoOcupacao]
  FROM [dbo].[RESIDENCIAL_TIPO6_SRG_TMP] RTP6
  WHERE RTP6.[CodigoTipoOcupacao] IS NOT NULL
  ) X
  ON T.[ID] = X.[IDTipoOcupacao]
  WHEN NOT MATCHED
          THEN INSERT ([ID])
               VALUES (X.[IDTipoOcupacao]);                 
  
  
  /*INSERE TIPOS DE OCUPAÇÃO NÃO LOCALIZADOS*/
  ;MERGE INTO Dados.TipoSeguro AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.TipoSeguro [TipoSeguro]
      , RTP6.CodigoTipoSeguro [CodigoTipoSeguro]
  FROM [dbo].[RESIDENCIAL_TIPO6_SRG_TMP] RTP6
  WHERE RTP6.TipoSeguro = ''
  ) X
  ON T.Descricao = X.[CodigoTipoSeguro]
  WHEN NOT MATCHED
          THEN INSERT (Descricao)
               VALUES (X.[CodigoTipoSeguro]); 
   
   
  /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.Proposta AS T
    USING (SELECT RTP6.[NumeroPropostaTratado], 1 [IDSeguradora], MAX(RTP6.[NomeArquivo]) [NomeArquivo], MAX(RTP6.[DataArquivo]) [DataArquivo]
        FROM [dbo].[RESIDENCIAL_TIPO6_SRG_TMP] RTP6
        WHERE RTP6.NumeroPropostaTratado IS NOT NULL
        GROUP BY RTP6.[NumeroPropostaTratado]
          ) X
    ON T.NumeroProposta = X.NumeroPropostaTratado
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, -1, 0, -1, 'PRP-RESIDENCIAL', X.DataArquivo);               
		
		
  /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.PropostaCliente AS T
    USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(RTP6.[NomeArquivo]) [NomeArquivo], MAX(RTP6.[DataArquivo]) [DataArquivo]
        FROM [RESIDENCIAL_TIPO6_SRG_TMP] RTP6
        INNER JOIN Dados.Proposta PRP
        ON PRP.NumeroProposta = RTP6.NumeroProposta
        AND PRP.IDSeguradora = 1
        WHERE RTP6.NumeroProposta IS NOT NULL
        GROUP BY PRP.ID 
          ) X
    ON T.IDProposta = X.IDProposta
   WHEN NOT MATCHED
          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
               VALUES (X.IDProposta, 'PRP-RESIDENCIAL', X.[NomeCliente], X.[DataArquivo]);
		  
		  

	/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 18/10/2013 */
    UPDATE Dados.PropostaResidencial SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaResidencial PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM dbo.[RESIDENCIAL_TIPO6_SRG_TMP] PRP_T
							  INNER JOIN Dados.Proposta PRP
							  ON PRP_T.[NumeroProposta] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1  							   
                            )
          AND PS.LastValue = 1
	
	                            
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaResidencial AS T
		USING (       
            SELECT *
            FROM
            (
            SELECT 
              RTP6.[Codigo],                                                     
              RTP6.[ControleVersao],                                             
              RTP6.[NomeArquivo] [Arquivo],                                                
              RTP6.[DataArquivo],                           
              PRP.ID [IDProposta],                     
              RTP6.[NumeroPropostaTratado] [NumeroProposta],                                             
              RTP6.[NumeroVersao],                                               
              RTP6.[CodigoTipoMoradia] [IDTipoMoradia],                                          
              RTP6.[CodigoTipoOcupacao] [IDTipoOcupacao],                                         
              TS.ID [IDTipoSeguro],
              RTP6.[TipoSeguro],                                                 
              RTP6.[DescontoFidelidade],                                         
              RTP6.[DescontoAgrupCobertura],                                     
              RTP6.[DescontoExperiencia],                                        
              RTP6.[ValorPremioLiquido],                                         
              RTP6.[ValorAdicionalFracionamento],                                
              RTP6.[ValorCustoApolice],                                          
              RTP6.[ValorIOF],                                                   
              RTP6.[ValorPremioTotal],                                           
              RTP6.[QuantidadeParcelas],                                         
              RTP6.[ValorPrimeiraParcela],                                       
              RTP6.[ValorDemaisParcelas],                                        
              CASE RTP6.[IndicadorRenovacaoAutomatica] WHEN 'S' THEN Cast(1 as Bit) ELSE Cast(0 as Bit) END [IndicadorRenovacaoAutomatica],   
              --CNT.ID [IDApoliceAnterior],                            
              RTP6.[NumeroApoliceAnterior],                                      
              RTP6.[DescontoFuncionarioPublico],                                 
              --RTP6.[NumeroProdutoAVGestao]
              ROW_NUMBER() OVER(PARTITION BY PRP.ID, RTP6.[NumeroVersao], RTP6.[DataArquivo], RTP6.ValorPremioTotal ORDER BY RTP6.[Codigo] DESC)  [ORDER]
            FROM [dbo].[RESIDENCIAL_TIPO6_SRG_TMP]  RTP6
              LEFT JOIN Dados.Proposta PRP
              ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
              LEFT JOIN Dados.TipoSeguro TS
              ON TS.Descricao = RTP6.TipoSeguro or TS.Descricao = RTP6.[CodigoTipoSeguro]
			--where prp.id = 4947048
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[NumeroVersao] = T.[NumeroVersao]
    AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[ValorPremioTotal] = T.[ValorPremioTotal]
    WHEN MATCHED
			    THEN UPDATE
				     SET
				  [IDTipoMoradia] = COALESCE(X.[IDTipoMoradia], T.[IDTipoMoradia])
                , [IDTipoOcupacao] = COALESCE(X.[IDTipoOcupacao], T.[IDTipoOcupacao])
				, [IDTipoSeguro] = COALESCE(X.[IDTipoSeguro], T.[IDTipoSeguro])
				, [NumeroApoliceAnterior] = COALESCE(X.[NumeroApoliceAnterior], T.[NumeroApoliceAnterior])
				, [DescontoFidelidade] = COALESCE(X.[DescontoFidelidade], T.[DescontoFidelidade])
				, [DescontoAgrupCobertura] = COALESCE(X.[DescontoAgrupCobertura], T.[DescontoAgrupCobertura])
				, [DescontoExperiencia] = COALESCE(X.[DescontoExperiencia], T.[DescontoExperiencia])
				, [DescontoFuncionarioPublico] = COALESCE(X.[DescontoFuncionarioPublico], T.[DescontoFuncionarioPublico])
				, [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido], T.[ValorPremioLiquido])
				, [ValorPremioTotal] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
				, [ValorAdicionalFracionamento] = COALESCE(X.[ValorAdicionalFracionamento], T.[ValorAdicionalFracionamento])
				, [ValorCustoApolice] = COALESCE(X.[ValorCustoApolice], T.[ValorCustoApolice])
				, [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])  
                , [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas])  				       
                , [ValorPrimeiraParcela] = COALESCE(X.[ValorPrimeiraParcela], T.[ValorPrimeiraParcela])  
                , [ValorDemaisParcelas] = COALESCE(X.[ValorDemaisParcelas], T.[ValorDemaisParcelas])  
                , [IndicadorRenovacaoAutomatica] = COALESCE(X.[IndicadorRenovacaoAutomatica], T.[IndicadorRenovacaoAutomatica])  

    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                  --[NumeroProposta]                     
                , [IDTipoMoradia]  
                , [IDTipoOcupacao]
                , [IDTipoSeguro]
                , NumeroApoliceAnterior
                , [NumeroVersao]                       
                  --[TipoSeguro]                         
                , [DescontoFidelidade]                 
                , [DescontoAgrupCobertura]             
                , [DescontoExperiencia]                
                , [DescontoFuncionarioPublico]         
                
                , [ValorPremioLiquido]                 
                , [ValorPremioTotal]                   
                , [ValorAdicionalFracionamento]        
                , [ValorCustoApolice]                  
                , [ValorIOF]                           
                
                , [QuantidadeParcelas]                 
                , [ValorPrimeiraParcela]               
                , [ValorDemaisParcelas]                
                , [IndicadorRenovacaoAutomatica]       
                
                --, [NumeroProdutoAVGestao]
                , [DataArquivo]
                , [Arquivo])
          VALUES (   
                  X.[IDProposta]                  
          
                , X.[IDTipoMoradia]  
                , X.[IDTipoOcupacao]
                , X.[IDTipoSeguro]
                , X.NumeroApoliceAnterior
                , X.[NumeroVersao]                
               
                , X.[DescontoFidelidade]          
                , X.[DescontoAgrupCobertura]      
                , X.[DescontoExperiencia]         
                , X.[DescontoFuncionarioPublico]  

                , X.[ValorPremioLiquido]          
                , X.[ValorPremioTotal]            
                , X.[ValorAdicionalFracionamento] 
                , X.[ValorCustoApolice]           
                , X.[ValorIOF]                    

                , X.[QuantidadeParcelas]          
                , X.[ValorPrimeiraParcela]        
                , X.[ValorDemaisParcelas]         
                , X.[IndicadorRenovacaoAutomatica]
                    
                --, X.[NumeroProdutoAVGestao]
                , X.[DataArquivo]
                , X.[Arquivo]
                ); 
  /*************************************************************************************/ 

	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 18/10/2013 */		 
    UPDATE Dados.PropostaResidencial SET LastValue = 1
    FROM Dados.PropostaResidencial PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta  ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaResidencial PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM dbo.[RESIDENCIAL_TIPO6_SRG_TMP] PRP_T
										  INNER JOIN Dados.Proposta PRP
										  ON PRP_T.NumeroPropostaTratado = PRP.NumeroProposta
										 AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1;	
	

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_RESIDENCIAL_TIPO6_SRG1'
  /*************************************************************************************/  
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[RESIDENCIAL_TIPO6_SRG_TMP]
  
  /*********************************************************************************************************************/
                
 SET @COMANDO =
    '  INSERT INTO dbo.RESIDENCIAL_TIPO6_SRG_TMP
        ( [Codigo],                                                     
	        [ControleVersao],                                             
	        [NomeArquivo],                                                
	        [DataArquivo],                                                
	        [NumeroProposta],                                             
	        [NumeroVersao],                                               
	        [CodigoTipoMoradia],                                          
	        [CodigoTipoOcupacao], 
	        [CodigoTipoSeguro],                                        
	        [TipoSeguro],                                                 
	        [DescontoFidelidade],                                         
	        [DescontoAgrupCobertura],                                     
	        [DescontoExperiencia],                                        
	        [ValorPremioLiquido],                                         
	        [ValorAdicionalFracionamento],                                
	        [ValorCustoApolice],                                          
	        [ValorIOF],                                                   
	        [ValorPremioTotal],                                           
	        [QuantidadeParcelas],                                         
	        [ValorPrimeiraParcela],                                       
	        [ValorDemaisParcelas],                                        
	        [IndicadorRenovacaoAutomatica],                               
	        [NumeroApoliceAnterior],                                      
	        [DescontoFuncionarioPublico],                                 
	        [NumeroProdutoAVGestao] )
     SELECT [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],                                             
	          [NumeroVersao],                                               
	          [CodigoTipoMoradia],                                          
	          [CodigoTipoOcupacao],
	          [CodigoTipoSeguro],                                         
	          [TipoSeguro],                                                 
	          [DescontoFidelidade],                                         
	          [DescontoAgrupCobertura],                                     
	          [DescontoExperiencia],                                        
	          [ValorPremioLiquido],                                         
	          [ValorAdicionalFracionamento],                                
	          [ValorCustoApolice],                                          
	          [ValorIOF],                                                   
	          [ValorPremioTotal],                                           
	          [QuantidadeParcelas],                                         
	          [ValorPrimeiraParcela],                                       
	          [ValorDemaisParcelas],                                        
	          [IndicadorRenovacaoAutomatica],                               
	          [NumeroApoliceAnterior],                                      
	          [DescontoFuncionarioPublico],                                 
	          [NumeroProdutoAVGestao] 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_RESIDENCIAL_TIPO6_SRG1] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)  

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.RESIDENCIAL_TIPO6_SRG_TMP PRP    
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESIDENCIAL_TIPO6_SRG_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[RESIDENCIAL_TIPO6_SRG_TMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_RESIDENCIAL_TIPO6_SRG1] 

