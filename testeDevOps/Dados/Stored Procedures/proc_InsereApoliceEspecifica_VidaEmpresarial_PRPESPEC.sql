
/*
	Autor: Diego Lima
	Data Criação: 25/10/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereApoliceEspecifica_VidaEmpresarial_PRPESPEC
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereApoliceEspecifica_VidaEmpresarial_PRPESPEC] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP];

CREATE TABLE [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP](

[Codigo] bigint null,
[ControleVersao] decimal(16,8),
[NomeArquivo] varchar(100),
[DataArquivo] date,
[NumeroProposta] varchar(20),
[CodigoTipoCapital] tinyint,
[TipoCapital] varchar(60),
[CapitalContratado] decimal(19,2),
[ValorTotalCapitalSeguradoBasico] decimal(19,2),
[PeriodicidadePagamento] char(2),
[ValorFatura] Decimal(19,2),
[TotalVidaSegurada] int,
[CodigoCNAE] varchar(20),
[CodigoPorteEmpresa] tinyint,
[PorteEmpresa] varchar(60),
[QuantidadeOcorrencia] tinyint,
[NivelCargo1] tinyint,
[Valor1] decimal(19,2),
[QuantidadeVida1] int,
[NivelCargo2] tinyint,
[Valor2] decimal(19,2),
[QuantidadeVida2] int,
[NivelCargo3] tinyint,
[Valor3] decimal(19,2),
[QuantidadeVida3] int,
[NivelCargo4] tinyint,
[Valor4] decimal(19,2),
[QuantidadeVida4] int,
[NivelCargo5] tinyint,
[Valor5] decimal(19,2),
[QuantidadeVida5] int
);

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP_Codigo ON [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_VidaEmpresarial_PRPESPEC'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
 --DECLARE @COMANDO AS NVARCHAR(MAX) 
--DECLARE @PontoDeParada AS VARCHAR(400) set @PontoDeParada = 0               
 SET @COMANDO =
    '  INSERT INTO dbo.APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP
        ( [Codigo]
		  ,[ControleVersao]
		  ,[NomeArquivo]
		  ,[DataArquivo]
		  ,[NumeroProposta]
		  ,[CodigoTipoCapital]
		  ,[TipoCapital]
		  ,[CapitalContratado]
		  ,[ValorTotalCapitalSeguradoBasico]
		  ,[PeriodicidadePagamento]
		  ,[ValorFatura]
		  ,[TotalVidaSegurada]
		  ,[CodigoCNAE]
		  ,[CodigoPorteEmpresa]
		  ,[PorteEmpresa]
		  ,[QuantidadeOcorrencia]
		  ,[NivelCargo1]
		  ,[Valor1]
		  ,[QuantidadeVida1]
		  ,[NivelCargo2]
		  ,[Valor2]
		  ,[QuantidadeVida2]
		  ,[NivelCargo3]
		  ,[Valor3]
		  ,[QuantidadeVida3]
		  ,[NivelCargo4]
		  ,[Valor4]
		  ,[QuantidadeVida4]
		  ,[NivelCargo5]
		  ,[Valor5]
		  ,[QuantidadeVida5]
	       )
     SELECT 
          [Codigo]
		  ,[ControleVersao]
		  ,[NomeArquivo]
		  ,[DataArquivo]
		  ,[NumeroProposta]
		  ,[CodigoTipoCapital]
		  ,[TipoCapital]
		  ,[CapitalContratado]
		  ,[ValorTotalCapitalSeguradoBasico]
		  ,[PeriodicidadePagamento]
		  ,[ValorFatura]
		  ,[TotalVidaSegurada]
		  ,[CodigoCNAE]
		  ,[CodigoPorteEmpresa]
		  ,[PorteEmpresa]
		  ,[QuantidadeOcorrencia]
		  ,[NivelCargo1]
		  ,[Valor1]
		  ,[QuantidadeVida1]
		  ,[NivelCargo2]
		  ,[Valor2]
		  ,[QuantidadeVida2]
		  ,[NivelCargo3]
		  ,[Valor3]
		  ,[QuantidadeVida3]
		  ,[NivelCargo4]
		  ,[Valor4]
		  ,[QuantidadeVida4]
		  ,[NivelCargo5]
		  ,[Valor5]
		  ,[QuantidadeVida5]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceEspecifica_ComplementoProposta_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP PRP 

/**************************************************************************************************/

SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**************************************************************************************************
		INSERE PORTES DE EMPRESA
**************************************************************************************************/

;MERGE INTO Dados.PorteEmpresa AS T
  USING	
		(
			SELECT DISTINCT
				t.CodigoPorteEmpresa, PorteEmpresa
			FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] T
			WHERE t.CodigoPorteEmpresa IS NOT NULL
		) X
	ON T.[ID]= X.CodigoPorteEmpresa
  WHEN NOT MATCHED
          THEN INSERT ([ID], descricao)
               VALUES (X.CodigoPorteEmpresa,x.PorteEmpresa);

/**************************************************************************************************
		INSERE TIPOS DE CAPITAL SEGURADOS
**************************************************************************************************/

;MERGE INTO Dados.TipoCapital AS T
  USING	
		(
			SELECT DISTINCT
				t.CodigoTipoCapital, t.TipoCapital
			FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] T
			WHERE t.CodigoTipoCapital IS NOT NULL
		) X
	ON T.[ID]= X.CodigoTipoCapital
  WHEN NOT MATCHED
          THEN INSERT ([ID],descricao)
               VALUES (X.CodigoTipoCapital,TipoCapital); 

/**************************************************************************************************
		INSERE PERIODICIDADES DE PAGAMENTO
**************************************************************************************************/

 ;MERGE INTO Dados.PeriodoPagamento AS T
  USING	
		(
			SELECT DISTINCT
				t.PeriodicidadePagamento, '' [Descricao]
			FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] T
			WHERE t.PeriodicidadePagamento IS NOT NULL
		) X
	 ON T.[Codigo]= X.PeriodicidadePagamento
  WHEN NOT MATCHED
          THEN INSERT ([Codigo], [Descricao])
               VALUES (X.PeriodicidadePagamento, X.[Descricao]);

/**************************************************************************************************
		INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA
**************************************************************************************************/

;MERGE INTO Dados.Proposta AS T
    USING (
			SELECT DISTINCT t.[NumeroProposta], 
							1 [IDSeguradora], 
							t.nomeArquivo [TipoDado], 
							t.[DataArquivo]
			FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] T
			WHERE t.NumeroProposta IS NOT NULL 
			
          ) X
    ON T.NumeroProposta = X.NumeroProposta
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, 
						[IDSeguradora], 
						IDAgenciaVenda, 
						IDProduto,
						IDProdutoSIGPF, 
						IDCanalVendaPAR, 
						IDSituacaoProposta, 
						IDTipoMotivo, 
						TipoDado, 
						DataArquivo)
               VALUES (X.[NumeroProposta], X.[IDSeguradora],-1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);               

/**************************************************************************************************
		INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA
**************************************************************************************************/

;MERGE INTO Dados.PropostaCliente AS T
    USING (
			SELECT PRP.ID [IDProposta],
					t.numeroproposta,
					'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 
					t.NomeArquivo [TipoDado],  
					MAX(t.[DataArquivo]) [DataArquivo]

			FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] T
			inner JOIN Dados.Proposta PRP
				ON PRP.NumeroProposta = t.NumeroProposta
					AND PRP.IDSeguradora = 1
			WHERE t.NumeroProposta IS NOT NULL
			GROUP BY PRP.ID,t.numeroproposta,t.NomeArquivo
          ) X
    ON T.IDProposta = X.IDProposta
   WHEN NOT MATCHED
          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);


---------------------------------------------------------------------------------------------------------

    UPDATE Dados.PropostaVidaEmpresarial SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaVidaEmpresarial PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP.ID
                            FROM  [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] t
								LEFT JOIN Dados.Proposta PRP
									ON PRP.NumeroProposta = t.NumeroProposta
								LEFT JOIN Dados.PeriodoPagamento PP
									ON PP.Codigo = t.PeriodicidadePagamento
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1

/*************************************************************************************
  Chama a PROC que roda a importação dos registros apolice especifica de complemento das propostas
*************************************************************************************/ 

;MERGE INTO Dados.PropostaVidaEmpresarial AS T
		USING (      
				SELECT DISTINCT  a.[Codigo]
								,prp.ID as IDProposta
								,a.[NumeroProposta]
								,A.[CodigoTipoCapital] as IDTipoCapital
								,A.[CapitalContratado] as [CapitalSeguradoBasicoTotal]
								,pp.ID as [IDPeriodicidadePagamento]
								,a.[PeriodicidadePagamento]
								,A.[ValorFatura]
								,A.[TotalDeVidas]
								,A.[CodigoCNAE]
								,A.[CodigoPorteEmpresa] as IDPorteEmpresa
								,A.[QuantidadeOcorrencias] 
								,a.TipoDado
								,a.[DataArquivo]  
								,0 LastValue
				FROM (SELECT DISTINCT * 
						FROM (
								SELECT [Codigo]
										,[NumeroProposta]
										,[CodigoTipoCapital]
										,[CapitalContratado]
										,[PeriodicidadePagamento]
										,[ValorFatura]
										,[TotalDeVidas]
										,[CodigoCNAE]
										,[CodigoPorteEmpresa]
										,[QuantidadeOcorrencias]
										,[NivelCargo]
										--,CASE WHEN [ValorSeguradoCargo] = -99999999999999999.99 THEN NULL ELSE [ValorSeguradoCargo] END [ValorSeguradoCargo]
										, CASE WHEN SUBSTRING(Valores, 1, 21) = '-99999999999999999.99' THEN NULL ELSE Cast( SUBSTRING(Valores, 1, 21) as decimal(19,2)) END [ValorSeguradoCargo] 
										, CASE WHEN SUBSTRING(Valores, 23, 6) = '000000' THEN NULL ELSE Cast(SUBSTRING(Valores, 23, 6) as int) END [QuantidadeDeVidas] 
										--,[QuantidadeVidasCargo]
										,NomeArquivo as TipoDado
										,[DataArquivo]
										,ROW_NUMBER() OVER(PARTITION BY [NumeroProposta],[CodigoTipoCapital],[CapitalContratado],[PeriodicidadePagamento],
											[ValorFatura],TotalDeVidas, [CodigoPorteEmpresa],CodigoCNAE ORDER BY DataArquivo DESC )  [ORDER]

								FROM (
										SELECT DISTINCT [Codigo]
														,[ControleVersao]
														,[NomeArquivo]
														,[DataArquivo]
														,[NumeroProposta]
														,[CodigoTipoCapital] 
														,[TipoCapital]
														,[CapitalContratado]
														,[ValorTotalCapitalSeguradoBasico]
														,[PeriodicidadePagamento]
														,[ValorFatura]
														,[TotalVidaSegurada] as [TotalDeVidas]
														,[CodigoCNAE]
														,[CodigoPorteEmpresa]
														,[PorteEmpresa]
														,[QuantidadeOcorrencia] as [QuantidadeOcorrencias]
														,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor1],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida1,'0') as VARchar(6)),6) [1]
														,[Valor1]
														,[QuantidadeVida1]
														,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor2],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida2,'0') as VARchar(6)),6) [2]
														,[Valor2]
														,[QuantidadeVida2]
														,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor3],-99999999999999999.99)  as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida3,'0') as VARchar(6)),6) [3]
														,[Valor3]
														,[QuantidadeVida3]
														,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor4],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida4,'0') as VARchar(6)),6) [4]
														,[QuantidadeVida4]
														,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor5],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida5,'0') as VARchar(6)),6) [5]
														,[Valor5]
														,[QuantidadeVida5]
											FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]) p
												UNPIVOT ([Valores] FOR  NivelCargo IN ([1], [2], [3], [4], [5])
														)AS ptr
							  )as Y
						WHERE Y.[ORDER] = 1 
					 )A

				LEFT JOIN Dados.Proposta PRP
					ON PRP.NumeroProposta = a.NumeroProposta
						AND prp.IDSeguradora = 1
				LEFT JOIN Dados.PeriodoPagamento PP
					ON PP.Codigo = a.PeriodicidadePagamento
					--where prp.ID = 975
			)X

				 ON  X.[IDProposta] = T.[IDProposta]
					AND X.IDTipoCapital = T.IDTipoCapital
					AND X.CapitalSeguradoBasicoTotal = T.CapitalSeguradoBasicoTotal
					AND X.[IDPeriodicidadePagamento] = T.[IDPeriodicidadePagamento]
					AND isnull(X.[ValorFatura],0) = isnull(T.[ValorFatura],0)
					AND isnull(X.TotalDeVidas,0) = isnull(T.TotalDeVidas,0)
					AND X.IDPorteEmpresa = T.IDPorteEmpresa
					AND isnull(X.CodigoCNAE,'') = isnull(T.CodigoCNAE,'')

			 WHEN MATCHED  AND X.[DataArquivo] >= T.[DataArquivo]
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
						 ,dataArquivo = X.[DataArquivo]
						 , LastValue = X.LastValue
			
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
							   ,X.IDTipoCapital
							   ,X.CapitalSeguradoBasicoTotal
							   ,X.IDPeriodicidadePagamento
							   ,X.ValorFatura
							   ,X.TotalDeVidas
							   ,X.CodigoCNAE
							   ,X.IDPorteEmpresa
							   ,X.QuantidadeOcorrencias
							   --,NivelCargo
							  -- ,ValorSeguradoCargo
							  -- ,QuantidadeVidasCargo
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
										FROM [dbo].APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP  t
											LEFT JOIN Dados.Proposta PRP
												ON PRP.NumeroProposta = t.NumeroProposta
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
                            FROM  [dbo].APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP  t
								LEFT JOIN Dados.Proposta PRP
									ON PRP.NumeroProposta = t.NumeroProposta
								LEFT JOIN Dados.PeriodoPagamento PP
									ON PP.Codigo = t.PeriodicidadePagamento
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
   
   /*************************************************************************************
  Chama a PROC que roda a importação dos registros apolice especifica de complemento das proposta apenas o cargo
*************************************************************************************/ 

;MERGE INTO Dados.PropostaVidaEmpresarialCargo AS T
		USING (  
				SELECT  DISTINCT a.[Codigo]
								,prp.ID as IDProposta
								,a.[NumeroProposta]
								,a.NivelCargo
								,a.ValorSeguradoCargo
								,a.QuantidadeDeVidas as [QuantidadeVidasCargo]
								,a.TipoDado
								,a.[DataArquivo]
								,0 LastValue 
					FROM (
							SELECT DISTINCT *
	  
							FROM (
	  
									SELECT     [Codigo]
											  ,[NumeroProposta]
											  ,[CodigoTipoCapital]
											  ,[CapitalContratado]
											  ,[PeriodicidadePagamento]
											  ,[ValorFatura]
											  ,[TotalDeVidas]
											  ,[CodigoCNAE]
											  ,[CodigoPorteEmpresa]
											  ,[QuantidadeOcorrencias]
											  ,[NivelCargo]
											 --,CASE WHEN [ValorSeguradoCargo] = -99999999999999999.99 THEN NULL ELSE [ValorSeguradoCargo] END [ValorSeguradoCargo]
											 , CASE WHEN SUBSTRING(Valores, 1, 21) = '-99999999999999999.99' THEN NULL ELSE Cast( SUBSTRING(Valores, 1, 21) as decimal(19,2)) END [ValorSeguradoCargo] 
											 , CASE WHEN SUBSTRING(Valores, 23, 6) = '000000' THEN NULL ELSE Cast(SUBSTRING(Valores, 23, 6) as int) END [QuantidadeDeVidas] 
											  --,[QuantidadeVidasCargo]
											  ,NomeArquivo as TipoDado
											  ,[DataArquivo] 
											  ,ROW_NUMBER() OVER(PARTITION BY [NumeroProposta],NivelCargo,
											  CASE WHEN SUBSTRING(Valores, 23, 6) = '000000' THEN NULL ELSE Cast(SUBSTRING(Valores, 23, 6) as int) END ORDER BY DataArquivo DESC  )  [ORDER]

									FROM (
											SELECT 
													[Codigo]
												  ,[ControleVersao]
												  ,[NomeArquivo]
												  ,[DataArquivo]
												  ,[NumeroProposta]
												  ,[CodigoTipoCapital] 
												  ,[TipoCapital]
												  ,[CapitalContratado]
												  ,[ValorTotalCapitalSeguradoBasico]
												  ,[PeriodicidadePagamento]
												  ,[ValorFatura]
												  ,[TotalVidaSegurada] as [TotalDeVidas]
												  ,[CodigoCNAE]
												  ,[CodigoPorteEmpresa]
												  ,[PorteEmpresa]
												  ,[QuantidadeOcorrencia] as [QuantidadeOcorrencias]
												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor1],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida1,'0') as VARchar(6)),6) [1]
												  ,[Valor1]
												  ,[QuantidadeVida1]
												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor2],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida2,'0') as VARchar(6)),6) [2]
												  ,[Valor2]
												  ,[QuantidadeVida2]
												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor3],-99999999999999999.99)  as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida3,'0') as VARchar(6)),6) [3]
												  ,[Valor3]
												  ,[QuantidadeVida3]
												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor4],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida4,'0') as VARchar(6)),6) [4]
												  ,[QuantidadeVida4]
												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor5],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida5,'0') as VARchar(6)),6) [5]
												  ,[Valor5]
												  ,[QuantidadeVida5]
											  FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]) p
											  UNPIVOT ([Valores] FOR  NivelCargo IN ([1], [2], [3], [4], [5])
														)AS ptr
								 )as Y
							WHERE Y.[ORDER] = 1
						 )A

				 LEFT JOIN Dados.Proposta PRP
					 ON PRP.NumeroProposta = a.NumeroProposta
					 AND prp.IDSeguradora = 1
				 LEFT JOIN Dados.PeriodoPagamento PP
					 ON PP.Codigo = a.PeriodicidadePagamento
				 WHERE NOT (A.[ValorSeguradoCargo] IS NULL AND A.QuantidadeDeVidas IS NULL)
			) X

		ON X.[IDProposta] = T.[IDProposta]
			 AND X.[NivelCargo] = T.[NivelCargo]
			 AND isnull(X.[QuantidadeVidasCargo],0) = isnull(T.[QuantidadeVidasCargo],0)
			 AND isnull(X.[ValorSeguradoCargo],'0.00') = isnull(T.[ValorSeguradoCargo],'0.00')
				--AND X.[DataArquivo] = T.[DataArquivo]

	WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] 
		THEN UPDATE
				     SET 
						--[IDProposta]= COALESCE(X.[IDProposta], T.[IDProposta])
						[NivelCargo]= COALESCE(X.[NivelCargo], T.[NivelCargo])
					    ,[ValorSeguradoCargo]= COALESCE(X.[ValorSeguradoCargo], T.[ValorSeguradoCargo])
					    ,[QuantidadeVidasCargo]= COALESCE(X.[QuantidadeVidasCargo], T.[QuantidadeVidasCargo])
					    ,[TipoDado]= COALESCE(X.[TipoDado], T.[TipoDado])
					    ,[DataArquivo]= X.[DataArquivo]
						,LastValue = X.LastValue

	WHEN NOT MATCHED  
			    THEN INSERT  (
							   [IDProposta]
							  ,[NivelCargo]
							  ,[ValorSeguradoCargo]
							  ,[QuantidadeVidasCargo]
							  ,[TipoDado]
							  ,[DataArquivo]
							  ,LastValue
							 )
					VALUES (

							X.[IDProposta]
							,X.[NivelCargo]
							,X.[ValorSeguradoCargo]
							,X.[QuantidadeVidasCargo]
							,X.[TipoDado]
							,X.[DataArquivo]
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
										FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]  t
											LEFT JOIN Dados.Proposta PRP
												ON PRP.NumeroProposta = t.NumeroProposta
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1

/*Apaga a marcação LastValue das propostas com total de vidas recebidas para atualizar a última posição -> 
logo depois da inserção das Situações (abaixo)*/
	/*Diego Lima - Data: 18/11/2013 */

 --UPDATE [Dados].[PropostaVidaEmpresarialHistorico] SET LastValue = 0
 --  --SELECT *
 --   FROM [Dados].[PropostaVidaEmpresarialHistorico] PS
	--INNER JOIN Dados.Proposta PRP
	--	ON PS.idproposta = prp.ID
	--INNER JOIN [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] temp
	--	ON temp.NumeroProposta = prp.numeroproposta
	--where PS.LastValue = 1
   
/*************************************************************************************
  Insere apolice especificas total de vidas no historico
*************************************************************************************/

--;MERGE INTO [Dados].[PropostaVidaEmpresarialHistorico] AS T
--		USING ( 
--					SELECT  DISTINCT 
--								prp.ID as IDProposta
--								,a.[NumeroProposta]
--								,a.[CodigoTipoCapital] AS IDTipoCapital
--								,a.[PeriodicidadePagamento] AS IDPeriodicidadePagamento
--								,a.[TotalDeVidas]
--								,a.[CodigoPorteEmpresa] AS IDPorteEmpresa
--								,a.TipoDado
--								,a.[DataArquivo] 
--								,0 AS LastValue
--								--,ROW_NUMBER() OVER (PARTITION BY
--										--		a.[NumeroProposta],a.[TotalDeVidas] ORDER BY a.DataArquivo DESC) NUMERADOR

--					FROM  (
	  
--									SELECT     [Codigo]
--											  ,[NumeroProposta]
--											  ,[CodigoTipoCapital]
--											  ,[CapitalContratado]
--											  ,[PeriodicidadePagamento]
--											  ,[ValorFatura]
--											  ,[TotalDeVidas]
--											  ,[CodigoCNAE]
--											  ,[CodigoPorteEmpresa]
--											  ,[QuantidadeOcorrencias]
--											  ,[NivelCargo]
--											 --,CASE WHEN [ValorSeguradoCargo] = -99999999999999999.99 THEN NULL ELSE [ValorSeguradoCargo] END [ValorSeguradoCargo]
--											 , CASE WHEN SUBSTRING(Valores, 1, 21) = '-99999999999999999.99' THEN NULL ELSE Cast( SUBSTRING(Valores, 1, 21) as decimal(19,2)) END [ValorSeguradoCargo] 
--											 , CASE WHEN SUBSTRING(Valores, 23, 6) = '000000' THEN NULL ELSE Cast(SUBSTRING(Valores, 23, 6) as int) END [QuantidadeDeVidas] 
--											  --,[QuantidadeVidasCargo]
--											  ,NomeArquivo as TipoDado
--											  ,[DataArquivo] 
--											 -- ,0 LastValue
--											  ,ROW_NUMBER() OVER (PARTITION BY
--												[NumeroProposta],[TotalDeVidas] ORDER BY DataArquivo DESC) NUMERADOR

--									FROM (
--											SELECT 
--													[Codigo]
--												  ,[ControleVersao]
--												  ,[NomeArquivo]
--												  ,[DataArquivo]
--												  ,[NumeroProposta]
--												  ,[CodigoTipoCapital] 
--												  ,[TipoCapital]
--												  ,[CapitalContratado]
--												  ,[ValorTotalCapitalSeguradoBasico]
--												  ,[PeriodicidadePagamento]
--												  ,[ValorFatura]
--												  ,[TotalVidaSegurada] as [TotalDeVidas]
--												  ,[CodigoCNAE]
--												  ,[CodigoPorteEmpresa]
--												  ,[PorteEmpresa]
--												  ,[QuantidadeOcorrencia] as [QuantidadeOcorrencias]
--												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor1],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida1,'0') as VARchar(6)),6) [1]
--												  ,[Valor1]
--												  ,[QuantidadeVida1]
--												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor2],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida2,'0') as VARchar(6)),6) [2]
--												  ,[Valor2]
--												  ,[QuantidadeVida2]
--												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor3],-99999999999999999.99)  as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida3,'0') as VARchar(6)),6) [3]
--												  ,[Valor3]
--												  ,[QuantidadeVida3]
--												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor4],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida4,'0') as VARchar(6)),6) [4]
--												  ,[QuantidadeVida4]
--												  ,RIGHT(REPLICATE('0',17) +Cast(isnull([Valor5],-99999999999999999.99 ) as VARchar(21)),21) + ';' + RIGHT(REPLICATE('0',6) + Cast(isnull(QuantidadeVida5,'0') as VARchar(6)),6) [5]
--												  ,[Valor5]
--												  ,[QuantidadeVida5]
--											  FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]) p
--											  UNPIVOT ([Valores] FOR  NivelCargo IN ([1], [2], [3], [4], [5])
--														)AS ptr
								
							
--						 )A

--				 LEFT JOIN Dados.Proposta PRP
--					 ON PRP.NumeroProposta = a.NumeroProposta
--				 LEFT JOIN Dados.PeriodoPagamento PP
--					 ON PP.Codigo = a.PeriodicidadePagamento
--				WHERE A.numerador = '1'
--			)X

--				ON ISNULL(X.IDProposta,-1) = ISNULL(T.IDProposta,-1)
--					AND ISNULL(X.[TotalDeVidas],'') = ISNULL(T.[TotalDeVidas],'')
					

--			WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
--					UPDATE
--							SET
--								 [IDProposta] =  COALESCE(X.IDProposta, T.IDProposta)
--								,[TotalDeVidas] =  COALESCE(X.[TotalDeVidas], T.[TotalDeVidas])
--								,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
--								,[DataArquivo] = X.DataArquivo
--								,[LastValue] = X.LastValue

--			WHEN NOT MATCHED
--					THEN INSERT ([IDProposta]
--								  ,[IDTipoCapital]
--								  ,[IDPeriodicidadePagamento]
--								  ,[TotalDeVidas]
--								  ,[IDPorteEmpresa]
--								  ,[TipoDado]
--								  ,[DataArquivo]
--								  ,[LastValue])
--						VALUES (X.IDProposta, X.[IDTipoCapital], X.[IDPeriodicidadePagamento], X.[TotalDeVidas],
--								X.[IDPorteEmpresa], X.[TipoDado], X.[DataArquivo], X.[LastValue]);

--/*Atualiza a marcação LastValue das propostas e total de vidas recebidas para atualizar a última posição*/
--	/*Diego Lima - Data: 18/11/2013 */	
		 
--    UPDATE [Dados].[PropostaVidaEmpresarialHistorico] SET LastValue = 1
--	--select *
--    FROM [Dados].[PropostaVidaEmpresarialHistorico] PE
--	INNER JOIN (
--				SELECT ID, ROW_NUMBER() OVER (PARTITION BY  FH.IDProposta
--											    ORDER BY FH.DataArquivo DESC) [ORDEM]
--				FROM  [Dados].[PropostaVidaEmpresarialHistorico] FH
--				WHERE FH.IDProposta in (SELECT F.ID
--										   FROM [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP] A
--											inner join Dados.Proposta F
--												on F.NumeroProposta = A.NumeroProposta
--												AND F.IDSeguradora = 1
--											) 
--											--AND IDFUNCIONARIO = 5007
--											--ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC
--				) A
--	 ON A.ID = PE.ID 
--	 AND A.ORDEM = 1

	
					

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_VidaEmpresarial_PRPESPEC'
                  
/*********************************************************************************************************************/
  
  TRUNCATE TABLE [dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]   
       
/*********************************************************************************************************************/
                
  SET @COMANDO =
    ' INSERT INTO dbo.APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP
        ( [Codigo]
		  ,[ControleVersao]
		  ,[NomeArquivo]
		  ,[DataArquivo]
		  ,[NumeroProposta]
		  ,[CodigoTipoCapital]
		  ,[TipoCapital]
		  ,[CapitalContratado]
		  ,[ValorTotalCapitalSeguradoBasico]
		  ,[PeriodicidadePagamento]
		  ,[ValorFatura]
		  ,[TotalVidaSegurada]
		  ,[CodigoCNAE]
		  ,[CodigoPorteEmpresa]
		  ,[PorteEmpresa]
		  ,[QuantidadeOcorrencia]
		  ,[NivelCargo1]
		  ,[Valor1]
		  ,[QuantidadeVida1]
		  ,[NivelCargo2]
		  ,[Valor2]
		  ,[QuantidadeVida2]
		  ,[NivelCargo3]
		  ,[Valor3]
		  ,[QuantidadeVida3]
		  ,[NivelCargo4]
		  ,[Valor4]
		  ,[QuantidadeVida4]
		  ,[NivelCargo5]
		  ,[Valor5]
		  ,[QuantidadeVida5]
	       )
     SELECT 
          [Codigo]
		  ,[ControleVersao]
		  ,[NomeArquivo]
		  ,[DataArquivo]
		  ,[NumeroProposta]
		  ,[CodigoTipoCapital]
		  ,[TipoCapital]
		  ,[CapitalContratado]
		  ,[ValorTotalCapitalSeguradoBasico]
		  ,[PeriodicidadePagamento]
		  ,[ValorFatura]
		  ,[TotalVidaSegurada]
		  ,[CodigoCNAE]
		  ,[CodigoPorteEmpresa]
		  ,[PorteEmpresa]
		  ,[QuantidadeOcorrencia]
		  ,[NivelCargo1]
		  ,[Valor1]
		  ,[QuantidadeVida1]
		  ,[NivelCargo2]
		  ,[Valor2]
		  ,[QuantidadeVida2]
		  ,[NivelCargo3]
		  ,[Valor3]
		  ,[QuantidadeVida3]
		  ,[NivelCargo4]
		  ,[Valor4]
		  ,[QuantidadeVida4]
		  ,[NivelCargo5]
		  ,[Valor5]
		  ,[QuantidadeVida5]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceEspecifica_ComplementoProposta_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP PRP    
              
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].APOLICE_ESPECIFICA_VIDAEMPRESARIAL_PRPESPEC_TEMP;

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_VIDAEMPRESARIAL_TIPO6_SRG1] 

