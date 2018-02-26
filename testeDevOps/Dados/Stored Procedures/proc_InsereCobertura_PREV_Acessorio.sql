
/*
	Autor: Egler Vieira
	Data Criação: 17/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCobertura_PREV_Acessorio
	Descrição: Procedimento que realiza a inserção das Coberturas (PREV_Acessorio) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCobertura_PREV_Acessorio] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREV_Acessorio_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREV_Acessorio_TEMP];

CREATE TABLE [dbo].[PREV_Acessorio_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](100) NULL,
	[TipoArquivo] [varchar](30) NULL,
	[DataArquivo] [date] NULL,
	[NumeroProposta] [numeric](14, 0) NULL,
	[NumeroPropostaTratado] AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as VARCHAR(20)) PERSISTED,
	[CodigoAcessorio] [smallint] NULL,
	[Acessorio] [varchar](27) NULL,
	[IndicadorPerc_ValorContribuicao] [varchar](1) NULL,
	[PrazoPercepcao] [tinyint] NULL,
	[PeriodicidadePagamentoProtecao] [char](1) NULL,
	[ValorBeneficio] [decimal](19, 2) NULL,
	[ValorContribuicao] [decimal](19, 2) NULL
) 
      


 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PREV_Acessorio_CodigoAcessorio_TEMP ON [dbo].[PREV_Acessorio_TEMP]
( 
  [CodigoAcessorio] ASC
)        

CREATE CLUSTERED INDEX idx_PREV_Acessorio_TEMP ON [dbo].[PREV_Acessorio_TEMP]
( 
  NumeroPropostaTratado ASC,
  CodigoAcessorio ASC,
  DataArquivo ASC
)     


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Cobertura_PREV_Acessorio'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[PREV_Acessorio_TEMP] ( 
                      [Codigo],                           
	                    [ControleVersao],                   
	                    [NomeArquivo],                      
	                    [TipoArquivo],                      
	                    [DataArquivo],                      
	                    [NumeroProposta],                   
	                    [CodigoAcessorio],                  
	                    [Acessorio],                        
	                    [IndicadorPerc_ValorContribuicao],  
	                    [PrazoPercepcao],                   
	                    [PeriodicidadePagamentoProtecao],   
	                    [ValorBeneficio],                   
	                    [ValorContribuicao])
                SELECT 
                      [Codigo],                           
	                    [ControleVersao],                   
	                    [NomeArquivo],                      
	                    [TipoArquivo],                      
	                    [DataArquivo],                      
	                    [NumeroProposta],                   
	                    [CodigoAcessorio],                  
	                    [Acessorio],                        
	                    [IndicadorPerc_ValorContribuicao],  
	                    [PrazoPercepcao],                   
	                    [PeriodicidadePagamentoProtecao],   
	                    [ValorBeneficio],                   
	                    [ValorContribuicao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaAcessorio_PRPFPREV] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[PREV_Acessorio_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
            /*
                  INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
		                           */

   /***********************************************************************/                         
   
   /***********************************************************************
     Carregar as Acessorio
   ***********************************************************************/
     ;MERGE INTO Dados.Acessorio AS T
      USING (SELECT DISTINCT COB.CodigoAcessorio, Acessorio [Descricao] 
             FROM [PREV_Acessorio_TEMP] COB
             WHERE COB.CodigoAcessorio IS NOT NULL
            ) X
       ON T.[ID] = X.CodigoAcessorio 
     WHEN NOT MATCHED
	          THEN INSERT ( ID, Descricao)
	               VALUES ( X.[CodigoAcessorio], X.[Descricao]);
   /***********************************************************************/                         


-----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------

      MERGE INTO Dados.Proposta AS T
	      USING (SELECT COB.NumeroPropostaTratado, 4 [IDSeguradora], MAX(COB.[TipoArquivo]) [TipoDado], MAX(COB.DataArquivo) DataArquivo
            FROM [dbo].[PREV_Acessorio_TEMP] COB
            WHERE COB.NumeroPropostaTratado IS NOT NULL
            GROUP BY COB.NumeroPropostaTratado
              ) X
        ON T.NumeroProposta= X.NumeroPropostaTratado
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
              THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
                   VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               		               

		-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(COB.[TipoArquivo]) [TipoDado], MAX(COB.[DataArquivo]) [DataArquivo]
          FROM [PREV_Acessorio_TEMP] COB
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = COB.NumeroPropostaTratado
          AND PRP.IDSeguradora = 4
          WHERE COB.NumeroPropostaTratado IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);  

				 
 /***********************************************************************

/*Apaga a marcação LastValue da tabela Previdencia Cobertura para atualizar a última posição das propostas 
recebidas. */
/* Diego Lima - Data: 22/10/2013 */

     ***********************************************************************/	  

	UPDATE [Dados].[PrevidenciaCobertura] SET LastValue = 0
--select top 100 * 
	FROM [Dados].[PrevidenciaCobertura] PC
		INNER JOIN Dados.Proposta PRP
		ON  PRP.ID = PC.IDProposta
			AND PRP.IDSeguradora = 4
	WHERE EXISTS (SELECT * 
				    FROM [PREV_Acessorio_TEMP] COB
					WHERE  COB.CodigoAcessorio = PC.IDAcessorio
					AND  PRP.NumeroProposta = COB.NumeroPropostaTratado)   		
		  AND PC.LastValue = 1	 
           		
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as Coberturas recebidas no arquivo PREV_Acessorio
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.PrevidenciaCobertura AS T
		USING (
			SELECT *
			FROM
			(
			SELECT 
				COB.[TipoArquivo] [TipoDado],
				COB.[DataArquivo] [DataArquivo],
	          
				COB.[Codigo] [CodigoNaFonte],
	          		       
			    PRP.ID [IDProposta],
			    
			    COB.CodigoAcessorio [IDAcessorio], 
			    0 as LastValue,
			    COB.[IndicadorPerc_ValorContribuicao] [IndicadorPercContr],  
				
				COB.[PrazoPercepcao],                   
				COB.[PeriodicidadePagamentoProtecao],   
				COB.[ValorBeneficio],                   
				COB.[ValorContribuicao],
				ROW_NUMBER() OVER(PARTITION BY PRP.ID, COB.CodigoAcessorio, COB.[DataArquivo], COB.ValorContribuicao, COB.ValorBeneficio ORDER BY COB.[TipoArquivo] ASC, COB.[Codigo] DESC) [ORDEM]
			FROM 
				[PREV_Acessorio_TEMP] COB
				INNER JOIN Dados.Proposta PRP
				ON  PRP.NumeroProposta = COB.NumeroPropostaTratado
				AND PRP.IDSeguradora = 4
				/*INNER JOIN Dados.Acessorio A
				ON A.ID = COB.CodigoAcessorio*/   
			WHERE COB.[ValorBeneficio] <> 0.00 AND COB.[ValorContribuicao] <> 0.00
			--and prp.id = 12973865
			/*GROUP BY PRP.ID ,			      
					COB.CodigoAcessorio ,     			      
					COB.[IndicadorPerc_ValorContribuicao] ,  
					COB.[PrazoPercepcao],                   
					COB.[PeriodicidadePagamentoProtecao],   
					COB.[ValorBeneficio],                   
					COB.[ValorContribuicao]
					--COB.[Codigo]*/
			) A
			WHERE A.ORDEM = 1
    ) AS O
	ON  T.IDProposta  = O.IDProposta
    AND T.IDAcessorio = O.IDAcessorio
    AND T.DataArquivo = O.DataArquivo
	AND T.ValorContribuicao = O.ValorContribuicao
	AND T.ValorBeneficio = O.ValorBeneficio
    
    --AND T.CodigoNaFonte = O.CodigoNaFonte
		WHEN MATCHED
			THEN UPDATE 
				SET 
                      T.[IndicadorPercContr] =    COALESCE(O.[IndicadorPercContr], T.[IndicadorPercContr])
					 ,T.[PrazoPercepcao]     =    COALESCE(O.[PrazoPercepcao], T.[PrazoPercepcao])
					 ,T.[PeriodicidadePagamentoProtecao]    =    COALESCE(O.[PeriodicidadePagamentoProtecao], T.[PeriodicidadePagamentoProtecao])
					 ,T.[ValorBeneficio]     =    COALESCE(O.[ValorBeneficio], T.[ValorBeneficio])
					 ,T.[ValorContribuicao]  =    COALESCE(O.[ValorContribuicao], T.[ValorContribuicao])
					 ,T.[LastValue]			 =	  O.LastValue
					 ,T.[TipoDado]           =    COALESCE(O.[TipoDado], T.[TipoDado])
		WHEN NOT MATCHED
			THEN INSERT (
			       [TipoDado]
                 , [DataArquivo] 
                 , [CodigoNaFonte]         			     
                 , [IDProposta]			      
                 , [IDAcessorio]
                 , [IndicadorPercContr]  
                 , [PrazoPercepcao]                 
                 , [PeriodicidadePagamentoProtecao] 
                 , [ValorBeneficio]                 
                 , [ValorContribuicao]
				 , [LastValue])
				VALUES (  O.[TipoDado]
				        , O.[DataArquivo]    
				        , O.[CodigoNaFonte]      			       
				        , O.[IDProposta]			      
				        , O.[IDAcessorio]
				        , O.[IndicadorPercContr]  
				        , O.[PrazoPercepcao]                   
				        , O.[PeriodicidadePagamentoProtecao]   
				        , O.[ValorBeneficio]                   
				        , O.[ValorContribuicao]
				        , O.LastValue);
              
    -----------------------------------------------------------------------------------------------------------------------				
	
/*************************************************************************************/ 

/*Atualiza a marcação LastValue das Previdencia Cobertura recebidas para atualizar a última posição*/
/*Diego Lima - Data: 22/10/2013 */

/*************************************************************************************/ 	 
    UPDATE [Dados].[PrevidenciaCobertura] SET LastValue = 1
    FROM [Dados].[PrevidenciaCobertura] PE
	INNER JOIN (
				SELECT PC.ID, /*  PS.IDProposta, PS.IDCobertura*/ 
					   ROW_NUMBER() OVER(PARTITION BY PC.IDProposta, PC.IDAcessorio ORDER BY PC.DataArquivo DESC, PC.ID DESC) [ORDEM]
				--SELECT *
				FROM [Dados].[PrevidenciaCobertura] PC
				INNER JOIN Dados.Proposta PRP
				ON PC.IDProposta = PRP.ID
				AND PRP.IDSeguradora = 4
				WHERE EXISTS (SELECT * 
				              FROM [PREV_Acessorio_TEMP] COB
							  WHERE  COB.CodigoAcessorio = PC.IDAcessorio
								AND  PRP.NumeroProposta = COB.NumeroPropostaTratado)   													
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	

    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Cobertura_PREV_Acessorio'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PREV_Acessorio_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[PREV_Acessorio_TEMP] ( 
                        [Codigo],                           
                        [ControleVersao],                   
                        [NomeArquivo],                      
                        [TipoArquivo],                      
                        [DataArquivo],                      
                        [NumeroProposta],                   
                        [CodigoAcessorio],                  
                        [Acessorio],                        
                        [IndicadorPerc_ValorContribuicao],  
                        [PrazoPercepcao],                   
                        [PeriodicidadePagamentoProtecao],   
                        [ValorBeneficio],                   
                        [ValorContribuicao])
                  SELECT 
                        [Codigo],                           
                        [ControleVersao],                   
                        [NomeArquivo],                      
                        [TipoArquivo],                      
                        [DataArquivo],                      
                        [NumeroProposta],                   
                        [CodigoAcessorio],                  
                        [Acessorio],                        
                        [IndicadorPerc_ValorContribuicao],  
                        [PrazoPercepcao],                   
                        [PeriodicidadePagamentoProtecao],   
                        [ValorBeneficio],                   
                        [ValorContribuicao]
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaAcessorio_PRPFPREV] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)            

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[PREV_Acessorio_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREV_Acessorio_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
--	DROP TABLE [dbo].[PREV_Acessorio_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
