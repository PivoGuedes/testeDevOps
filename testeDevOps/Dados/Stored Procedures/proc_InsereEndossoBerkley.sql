
/*
	Autor: Pedro Guedes
	Data Criação: 15/09/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereEndosso_Berkley
	Descrição: Procedimento que realiza a inserção de contratos ou apolices no banco de dados.
		
	Parâmetros de entrada:
	
					rollback select top 200 * from Dados.Comissao order by id desc
	Retorno:


*******************************************************************************/
-- Número da Apolice é igual ao Número do Contrato
CREATE PROCEDURE [Dados].[proc_InsereEndossoBerkley]
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENDOSSO_BERKLEY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[ENDOSSO_BERKLEY_TEMP];

CREATE TABLE [dbo].[ENDOSSO_BERKLEY_TEMP](

[ID] int NOT null,
[NumeroProposta] [varchar](20) NULL,
[Apolice] [varchar](15) NULL,
[Endosso] [varchar](15) NULL,
[IDTipoEndosso] smallint null,
[AlteraEndosso] [varchar](15) NULL,
[DataEmissao] [DATE] NULL,
[InicioVigencia] [DATE]  NULL,
[FimVigencia] [DATE] NULL,
[QuantidadeParcelas] [varchar](3) NULL,
[DataVencimentoPrimeiraParcela] [DATE] NULL,
--[ComissaoAntecipada] [varchar](1) NULL,
--[ComissaoInicideSobreAdicional] [varchar](1) NULL,
[PremioLiquido] [decimal] (38,6)NULL,
[Adicional] [decimal] (38,6) NULL,
--[CustoDeApolice] [decimal] (18,6) NULL,
[ValorIOF] [decimal] (38,6) NULL,
[PremioTotal] [decimal] (38,6) NULL,
[PercentualDeComissao] [decimal] (5,2) NULL,
[ValorComissaoEndosso] [decimal] (38,6) NULL,
--[QuantidadeDeVidasInicial] [varchar](5) NULL,
--[NumeroPropostaCorretor] [varchar](7) NULL,
[DataArquivoEndosso] [date] NULL,
[NomeArquivoEndosso] [varchar](20) NULL,
[DataArquivoComissao] [date] NULL,
[NomeArquivoComissao] [varchar](20) NULL,
[NumeroParcela] [varchar](3) NULL,
[PremioLiquidoComissao] [decimal] (38,6) NULL,
[AdicionalComissao] [decimal] (38,6) NULL,
[CustoDeApoliceComissao] [decimal] (38,6) NULL,
[ValorIOFComissao] [decimal] (38,6) NULL,
[PremioTotalComissao] [decimal] (38,6) NULL,
[DataVencimentoPremio] [DATE]  NULL,
[ValorComissao] [decimal] (38,6) NULL,
[DataVencimentoComissao] [DATE] NULL,
[DataPagamentoComissao] [DATE] NULL,
[Endereco] [varchar](50) NULL,
[NumeroEndereco] [varchar](10) NULL,
[Complemento] [varchar](20) NULL,
[CEP] [varchar](8) NULL,
[Cidade] [varchar](30) NULL,
[UF] [varchar](2) NULL,
[EnderecoLocalRisco] [varchar](50) NULL,
[NumeroLocalRisco] [varchar](10) NULL,
[ComplementoLocalRisco] [varchar](20) NULL,
[CEPLocalRisco] [varchar](8) NULL,
[CidadeLocalRisco] [varchar](30) NULL,
[EstadoLocalRisco] [varchar](2) NULL

);

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX IDX_ENDOSSO_BERKLEY_TEMP_ID ON [dbo].[ENDOSSO_BERKLEY_TEMP]
( 
  ID ASC
)   

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX IDX_ENDOSSO_BERKLEY_TEMP_Proposta ON [dbo].[ENDOSSO_BERKLEY_TEMP]
( 
  NumeroProposta ASC
)   

CREATE NONCLUSTERED INDEX IDX_ENDOSSO_BERKLEY_TEMP_Apolice ON [dbo].[ENDOSSO_BERKLEY_TEMP]
( 
  Apolice ASC
)   


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Endosso_Berkley'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
 --DECLARE @COMANDO AS NVARCHAR(MAX) 
 --DECLARE @PontoDeParada AS VARCHAR(400) set @PontoDeParada = 0               
 SET @COMANDO =
	  '  INSERT INTO dbo.[ENDOSSO_BERKLEY_TEMP]
				(    [ID]
					,[NumeroProposta]
					,[Apolice]
					,[Endosso]
					,IDTipoEndosso
					,[AlteraEndosso]
					,[DataEmissao]
					,[InicioVigencia]
					,[FimVigencia]
					,[QuantidadeParcelas]
					,[DataVencimentoPrimeiraParcela]
					--,[ComissaoAntecipada]
					--,[ComissaoInicideSobreAdicional]
					,[PremioLiquido]
					,[Adicional]
					--,[CustoDeApolice]
					,[ValorIOF]
					,[PremioTotal]
					,[PercentualDeComissao]
					,[ValorComissaoEndosso]
					--,[QuantidadeDeVidasInicial]
					--,[NumeroPropostaCorretor]
					,[DataArquivoEndosso]
					,[NomeArquivoEndosso]
					,[DataArquivoComissao]
					,[NomeArquivoComissao]
					,[NumeroParcela]
					,[PremioLiquidoComissao]
					,[AdicionalComissao]
					--,[CustoDeApoliceComissao]
					,[ValorIOFComissao]
					,[PremioTotalComissao]
					,[DataVencimentoPremio]
					,[ValorComissao]
					,[DataVencimentoComissao]
					,[DataPagamentoComissao]
					,[Endereco]
					,[NumeroEndereco]
					,[Complemento]
					,[CEP]
					,[Cidade]
					,[UF]
					,[EnderecoLocalRisco]
					,[NumeroLocalRisco]
					,[ComplementoLocalRisco]
					,[CEPLocalRisco]
					,[CidadeLocalRisco]
					,[EstadoLocalRisco]
				 
				  )
			SELECT 
				    [ID]
					,[NumeroProposta]
					,[Apolice]
					,[Endosso]
					,IDTipoEndosso
					,[AlteraEndosso]
					,[DataEmissao]
					,[InicioVigencia]
					,[FimVigencia]
					,[QuantidadeParcelas]
					,[DataVencimentoPrimeiraParcela]
					--,[ComissaoAntecipada]
					--,[ComissaoInicideSobreAdicional]
					,[PremioLiquido]
					,[Adicional]
					--,[CustoDeApolice]
					,[ValorIOF]
					,[PremioTotal]
					,[PercentualDeComissao]
					,[ValorComissaoEndosso]
					--,[QuantidadeDeVidasInicial]
					--,[NumeroPropostaCorretor]
					,[DataArquivoEndosso]
					,[NomeArquivoEndosso]
					,[DataArquivoComissao]
					,[NomeArquivoComissao]
					,[NumeroParcela]
					,[PremioLiquidoComissao]
					,[AdicionalComissao]
					--,[CustoDeApoliceComissao]
					,[ValorIOFComissao]
					,[PremioTotalComissao]
					,[DataVencimentoPremio]
					,[ValorComissao]
					,[DataVencimentoComissao]
					,[DataPagamentoComissao]
					,[Endereco]
					,[NumeroEndereco]
					,[Complemento]
					,[CEP]
					,[Cidade]
					,[UF]
					,[EnderecoLocalRisco]
					,[NumeroLocalRisco]
					,[ComplementoLocalRisco]
					,[CEPLocalRisco]
					,[CidadeLocalRisco]
					,[EstadoLocalRisco]
					
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoBerkley] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 


SELECT @MaiorCodigo= MAX(PRP.ID)
FROM dbo.[ENDOSSO_BERKLEY_TEMP] PRP  

/**************************************************************************************************/

SET @COMANDO = '' 

;WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**************************************************************************************************
		GRAVA ENDOSSOS select top 200 * from Dados.Endosso order by ID desc       
**************************************************************************************************/
 --begin tran
 --rollback
 --select @@trancount


;MERGE INTO [Dados].[Endosso] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						p.IDContrato,
						p.IDProduto,
						t.Endosso as NumeroEndosso,
						t.DataEmissao,
						t.InicioVigencia as DataInicioVigencia,
						t.FimVigencia as DataFimVigencia,
						t.PremioTotal as ValorPremioTotal,
						t.PremioLiquido as ValorPremioLiquido,
						IDTipoEndosso,
						NomeArquivoEndosso as Arquivo,
						t.DataArquivoEndosso as DataArquivo,
						t.QuantidadeParcelas,
						t.ValorIOF,
						ROW_NUMBER() OVER (PARTITION BY P.ID,t.Endosso ORDER BY t.DataArquivoEndosso desc ) NUMERADOR
					FROM dbo.[ENDOSSO_BERKLEY_TEMP] T
						inner JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158
				) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 7514588
			) X
		ON T.IDProposta = X.IDProposta and t.NumeroEndosso = X.NumeroEndosso
	
	WHEN NOT MATCHED --AND x.DataArquivo >= t.DataArquivo --AND T.IDPROPOSTA IS NULL
			THEN INSERT ([IDContrato],[IDProduto],[IDProposta],[NumeroEndosso],[DataEmissao],[DataInicioVigencia],[DataFimVigencia],[ValorPremioTotal]
      ,[ValorPremioLiquido],[IDTipoEndosso],[QuantidadeParcelas],[DataArquivo],[Arquivo],[ValorIOF])
			VALUES (x.[IDContrato],x.[IDProduto],x.[IDProposta],x.[NumeroEndosso],x.[DataEmissao],x.[DataInicioVigencia],x.[DataFimVigencia],x.[ValorPremioTotal]
      ,x.[ValorPremioLiquido],x.[IDTipoEndosso],x.[QuantidadeParcelas],x.[DataArquivo],x.[Arquivo],x.[ValorIOF]);




--;MERGE INTO [Dados].[Contrato] AS T
--  USING	rollback
--		( SELECT * FROM (
--							SELECT  Apolice as NumeroContrato, DataArquivoEndosso as DataArquivo,NomeArquivoEndosso as NomeArquivo,DataEmissao,InicioVigencia as DataInicioVigencia
--											,FimVigencia as DataFimVigencia,QuantidadeParcelas,PremioLiquido as ValorPremioLiquido,
--											ROW_NUMBER() OVER(PARTITION BY Apolice ORDER BY Apolice, DataArquivo DESC )  [ORDER]

--							FROM dbo.[ENDOSSO_BERKLEY_TEMP]
--							WHERE Apolice IS NOT NULL
--						) A
--				where a.[order] = 1
--		) X
--	 ON T.NumeroContrato = X.NumeroContrato
--		AND T.IDSeguradora = X.IDSeguradora
--  WHEN NOT MATCHED
--          THEN INSERT (NumeroContrato, IDSeguradora, DataArquivo, Arquivo,DataEmissao,DataInicioVigencia,DataFimVigencia,QuantidadeParcelas,ValorPremioLiquido)
--               VALUES (X.NumeroContrato, IDSeguradora, X.DataArquivo, X.Arquivo,X.DataEmissao,X.DataInicioVigencia,X.DataFimVigencia,X.QuantidadeParcelas,X.ValorPremioLiquido );




/*************************************************************************************
	ATUALIZA STATUS DA PROPOSTAS COM ENDOSSO DE CANCELAMENTO select @@trancount
************************************************************************************/

;MERGE INTO Dados.Proposta  as T
	USING (SELECT 
						P.ID AS IDPROPOSTA,
						t.DataEmissao,
						5  AS IDSituacaoProposta, 
						NomeArquivoEndosso as Arquivo,
						t.DataArquivoEndosso as DataArquivo,
						NomeArquivoEndosso as TipoDado,
						ROW_NUMBER() OVER (PARTITION BY P.ID,t.Endosso ORDER BY t.DataArquivoEndosso desc ) NUMERADOR
					FROM dbo.[ENDOSSO_BERKLEY_TEMP] T
						inner JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158
								where t.IDTipoEndosso = 2
) as S
on S.IDProposta = T.ID
WHEN MATCHED THEN UPDATE SET IDSituacaoProposta = s.IDSituacaoProposta,
							DataArquivo = t.DataArquivo,
							TipoDado = t.TipoDado;
							




/**************************************************************************************************
		ATUALIZA DADOS DE APOLICES OU CONTRATOS
**************************************************************************************************/
 --begin tran select top 300 * from Dados.Proposta order by ID desc
 --rollback   select top 300 * from Dados.Contrato order by ID desc
 --select @@trancount 
;MERGE INTO [Dados].[Contrato] AS T
  USING	
		( SELECT * FROM (
							SELECT  Apolice as NumeroContrato, [DataArquivoEndosso] as DataArquivo, NomeArquivoEndosso Arquivo,1158 as IDSeguradora,
								[Endereco],[NumeroEndereco],[Complemento],[CEP],[Cidade],[UF],a.[EnderecoLocalRisco],[NumeroLocalRisco],[ComplementoLocalRisco]
								 ,[CEPLocalRisco],a.[CidadeLocalRisco],[EstadoLocalRisco]
									,ROW_NUMBER() OVER(PARTITION BY Apolice ORDER BY Apolice, DataArquivo DESC )  [ORDER]
							FROM dbo.[ENDOSSO_BERKLEY_TEMP] a
							INNER JOIN Dados.Contrato c  on a.Apolice = c.NumeroContrato and c.IDSeguradora = 1158
							WHERE a.CEP is not null or a.CEPLocalRisco is not null
						) A
				where a.[order] = 1
		) X
	 ON T.NumeroContrato = X.NumeroContrato
		AND T.IDSeguradora = X.IDSeguradora
  WHEN   MATCHED
          THEN UPDATE SET EnderecoLocalRisco = coalesce(X.[EnderecoLocalRisco] + ' ' + [ComplementoLocalRisco] + ' ' +[NumeroLocalRisco] ,X.[Endereco] + ' '+ [Complemento] + ' ' + [NumeroEndereco] ,T.[EnderecoLocalRisco]),
						 --BairroLocalRisco = coalesce(X.[EnderecoLocalRisco],X.[Endereco],T.[EnderecoLocalRisco]),
						 CidadeLocalRisco = coalesce(X.[CidadeLocalRisco],X.[Cidade],T.[CidadeLocalRisco]),
						 [UFLocalRisco] = coalesce(X.[EstadoLocalRisco],X.[UF],T.[UFLocalRisco]) ;





/**************************************************************************************************
		INSERE AS COMISSÕES  
**************************************************************************************************/

;MERGE INTO [Dados].[Comissao] AS T
  USING	
		( SELECT * FROM (
							SELECT  [PercentualDeComissao] as PercentualCorretagem,[ValorComissao] as ValorCorretagem,[PremioTotalComissao] as ValorBase,[ValorComissao] as [ValorComissaoPAR],
									[DataVencimentoComissao] as DataCompetencia,[DataPagamentoComissao] as DataRecibo,cast([Endosso] as int) as NumeroEndosso,									
									[DataVencimentoComissao] as DataCalculo,[DataPagamentoComissao] as DataQuitacaoParcela,cast([NumeroParcela] as smallint) as NumeroParcela,c.ID as IDContrato,
									c.IDProposta,t.NumeroProposta,[DataArquivoComissao] as DataArquivo, [NomeArquivoComissao] as Arquivo,
									15 as IDEmpresa									
									,ROW_NUMBER() OVER(PARTITION BY c.ID,c.IDProposta,t.NumeroParcela ORDER BY Apolice,  t.[DataArquivoComissao] DESC )  [ORDER]

							FROM dbo.[ENDOSSO_BERKLEY_TEMP] t
							INNER JOIN Dados.Contrato c on c.NumeroContrato = t.Apolice						
							WHERE [DataPagamentoComissao] is not null
						) A
				where a.[order] = 1
		) X
		ON T.IDContrato = X.IDContrato
		AND T.NumeroEndosso = X.NumeroEndosso
		AND T.IDProposta = X.IDProposta
		WHEN NOT MATCHED THEN INSERT ([PercentualCorretagem],[ValorCorretagem],ValorBase,[ValorComissaoPAR],DataCompetencia,DataRecibo,NumeroEndosso,									
									 DataCalculo,DataQuitacaoParcela,[NumeroParcela],IDContrato,IDProposta,NumeroProposta,DataArquivo,Arquivo)
		Values (x.[PercentualCorretagem],x.[ValorCorretagem],x.ValorBase,x.[ValorComissaoPAR],x.DataCompetencia,x.DataRecibo,x.NumeroEndosso,									
									 x.DataCalculo,x.DataQuitacaoParcela,x.[NumeroParcela],x.IDContrato,x.IDProposta,x.NumeroProposta,x.DataArquivo,x.Arquivo);
		--WHEN MATCHED
		--	    THEN UPDATE select top 20 * from Dados.Comissao order by ID Desc
		--		     SET IDContrato = COALESCE(T.IDContrato, X.IDContrato) --Carrega o Contrato somento quando este for NULL
		--			   , [SubGrupo] = X.SubGrupo; --Carrega o subgrupo


--/*************************************************************************************
--					rollback		INSERE AS PARCELAS select @@trancount BEGIN TRAN select top 220 * from Dados.Parcela order by ID DESC
--*************************************************************************************/
declare @idparcela bigint
select @idparcela = max(ID) from Dados.Parcela
--SELECT * FROM Dados.Parcela where DataEmissao is null
MERGE INTO Dados.Parcela as T
USING 
( 
SELECT 
						e.ID AS IDEndosso,
						cast([NumeroParcela] as smallint) as NumeroParcela,
						t.DataEmissao,
						t.[DataVencimentoPremio] as DataVencimento,
						t.PremioLiquido as ValorPremioLiquido,
						t.DataArquivoEndosso as DataArquivo,						 
						ROW_NUMBER() OVER (PARTITION BY e.ID,t.NumeroParcela ORDER BY t.DataArquivoEndosso desc ) NUMERADOR,
						ROW_NUMBER() OVER ( ORDER BY e.ID,t.NumeroParcela) + @idparcela as idparcela
				 	FROM dbo.[ENDOSSO_BERKLEY_TEMP] T
						inner JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1158
						inner join [Dados].[Endosso] e on e.IDProposta = p.ID  and e.IDContrato = p.IDContrato and e.NumeroEndosso = t. Endosso
						where NumeroParcela IS NOT NULL
) AS S
ON T.IDEndosso = S.IDEndosso 
	and T.NumeroParcela = S.NumeroParcela

WHEN NOT MATCHED THEN INSERT (ID,IDEndosso,NumeroParcela,DataEmissao,DataVencimento,DataArquivo,ValorPremioLiquido)
		VALUES (S.IDParcela,S.IDEndosso,S.NumeroParcela,S.DataEmissao,S.DataVencimento,S.DataArquivo,S.ValorPremioLiquido);

	

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Endosso_Berkley'

/****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[ENDOSSO_BERKLEY_TEMP]
  
/**************************************************************************************/
   
SET @COMANDO =
	  '  INSERT INTO dbo.[ENDOSSO_BERKLEY_TEMP]
				(    [ID]
					,[NumeroProposta]
					,[Apolice]
					,[Endosso]
					,IDTipoEndosso
					,[AlteraEndosso]
					,[DataEmissao]
					,[InicioVigencia]
					,[FimVigencia]
					,[QuantidadeParcelas]
					,[DataVencimentoPrimeiraParcela]
					--,[ComissaoAntecipada]
					--,[ComissaoInicideSobreAdicional]
					,[PremioLiquido]
					,[Adicional]
					--,[CustoDeApolice]
					,[ValorIOF]
					,[PremioTotal]
					,[PercentualDeComissao]
					,[ValorComissaoEndosso]
					--,[QuantidadeDeVidasInicial]
					--,[NumeroPropostaCorretor]
					,[DataArquivoEndosso]
					,[NomeArquivoEndosso]
					,[DataArquivoComissao]
					,[NomeArquivoComissao]
					,[NumeroParcela]
					,[PremioLiquidoComissao]
					,[AdicionalComissao]
					--,[CustoDeApoliceComissao]
					,[ValorIOFComissao]
					,[PremioTotalComissao]
					,[DataVencimentoPremio]
					,[ValorComissao]
					,[DataVencimentoComissao]
					,[DataPagamentoComissao]
					,[Endereco]
					,[NumeroEndereco]
					,[Complemento]
					,[CEP]
					,[Cidade]
					,[UF]
					,[EnderecoLocalRisco]
					,[NumeroLocalRisco]
					,[ComplementoLocalRisco]
					,[CEPLocalRisco]
					,[CidadeLocalRisco]
					,[EstadoLocalRisco]
				 
				  )
			SELECT 
				    [ID]
					,[NumeroProposta]
					,[Apolice]
					,[Endosso]
					,IDTipoEndosso
					,[AlteraEndosso]
					,[DataEmissao]
					,[InicioVigencia]
					,[FimVigencia]
					,[QuantidadeParcelas]
					,[DataVencimentoPrimeiraParcela]
					--,[ComissaoAntecipada]
					--,[ComissaoInicideSobreAdicional]
					,[PremioLiquido]
					,[Adicional]
					--,[CustoDeApolice]
					,[ValorIOF]
					,[PremioTotal]
					,[PercentualDeComissao]
					,[ValorComissaoEndosso]
					--,[QuantidadeDeVidasInicial]
					--,[NumeroPropostaCorretor]
					,[DataArquivoEndosso]
					,[NomeArquivoEndosso]
					,[DataArquivoComissao]
					,[NomeArquivoComissao]
					,[NumeroParcela]
					,[PremioLiquidoComissao]
					,[AdicionalComissao]
					--,[CustoDeApoliceComissao]
					,[ValorIOFComissao]
					,[PremioTotalComissao]
					,[DataVencimentoPremio]
					,[ValorComissao]
					,[DataVencimentoComissao]
					,[DataPagamentoComissao]
					,[Endereco]
					,[NumeroEndereco]
					,[Complemento]
					,[CEP]
					,[Cidade]
					,[UF]
					,[EnderecoLocalRisco]
					,[NumeroLocalRisco]
					,[ComplementoLocalRisco]
					,[CEPLocalRisco]
					,[CidadeLocalRisco]
					,[EstadoLocalRisco]
					
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoBerkley] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 
SELECT @MaiorCodigo= MAX(PRP.ID)
FROM dbo.[ENDOSSO_BERKLEY_TEMP] PRP  

/*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ENDOSSO_BERKLEY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[ENDOSSO_BERKLEY_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     
